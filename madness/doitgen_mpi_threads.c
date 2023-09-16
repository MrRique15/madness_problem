#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <getopt.h>
#include <time.h>
#include <string.h>
#include <pthread.h>

/* Include polybench common header. */
#include <polybench.h>

/* Include benchmark-specific header. */
#include "doitgen.h"

// Declaração de funções para previnir warnings
int pthread_setconcurrency(int new_level);
int pthread_getconcurrency(void);

MPI_Status status;

int nq, nr, np;

DATA_TYPE *vetorized_A;
DATA_TYPE *vetorized_C4;

pthread_barrier_t barrier; // Barreira global

void show_help(char *name) {
    fprintf(stderr, "\
            [uso] %s <opcoes>\n\
            -h         mostra essa tela e sai.\n\
            -t THREADS    seta quantidade de threads.\n\
            -d DATA_SET   seta o data_set utilizado.\n\
            -s SSED  seta seed de numeros random.\n", name) ;
    exit(-1) ;
}

void define_dataset(char data_set_identifier){
    switch (data_set_identifier)
    {
    case 't':
        nq = 150;
        nr = 170;
        np = 220;
        break;

    case 's':
        nq = 420;
        nr = 470;
        np = 520;
        break;

    case 'm':
        nq = 520;
        nr = 570;
        np = 620;
        break;

    case 'l':
        nq = 620;
        nr = 670;
        np = 720;
        break;

    default:
        printf("Wrong data_set inserted, assuming TEST\n");
        nq = 150;
        nr = 170;
        np = 220;
        break;
    }
}

int a_array_index(int i, int j, int k){
    return ((i * nq * np) + (j * np) + k);
}

int c4_array_index(int i, int j){
    return ((i * np) + j);
}

void libera_matriz() {
    free(vetorized_A);
    free(vetorized_C4);
}

void alocate_data(){
    vetorized_A = (DATA_TYPE *)malloc(nr * nq * np * sizeof(DATA_TYPE));
    vetorized_C4 = (DATA_TYPE *)malloc(np * np * sizeof(DATA_TYPE));
}

/* Array initialization and vetorization. */
void init_arrays(int seed) {
    srand(seed);
    int i, j, k;
    for (i = 0; i < nr; i++){
        for (j = 0; j < nq; j++){
            for (k = 0; k < np; k++){
                vetorized_A[a_array_index(i, j, k)] = (DATA_TYPE)rand() / RAND_MAX;
            }
        }
    }

    for (i = 0; i < np; i++){
        for (j = 0; j < np; j++){
            vetorized_C4[c4_array_index(i, j)] = (DATA_TYPE)rand() / RAND_MAX;
        }
    }
}

/* DCE code. Must scan the entire live-out data.
   Can be used also to check the correctness of the output. */
static void print_array(){
    POLYBENCH_DUMP_START;
    POLYBENCH_DUMP_BEGIN("A");
    for (int i = 0; i < nr; i++) {
        for (int j = 0; j < nq; j++) {
            for (int k = 0; k < np; k++) {
                if ((i * nq * np + j * np + k) % 20 == 0) {
                    fprintf(POLYBENCH_DUMP_TARGET, "\n");
                }
                fprintf(POLYBENCH_DUMP_TARGET, DATA_PRINTF_MODIFIER, vetorized_A[a_array_index(i, j, k)]);
            }
        }
    }
    POLYBENCH_DUMP_END("A");
    POLYBENCH_DUMP_FINISH;
}

/* Main computational kernel. */
void *kernel_worker(void *arg) {
    int tid = *((int *)arg);
    int max_threads = (int)pthread_getconcurrency();
    int start = tid * (nr / max_threads);
    int end = (tid + 1) * (nr / max_threads);
    if (tid == max_threads - 1) {
        end = nr;
    }
    int r, q, p, s;
    DATA_TYPE sum_aux[np];
    for (r = start; r < end; r++) {
        for (q = 0; q < nq; q++) {
            for (p = 0; p < np; p++) {
                sum_aux[p] = 0.0;
                for (s = 0; s < np; s++) {
                    sum_aux[p] += vetorized_A[a_array_index(r, q, s)] * vetorized_C4[c4_array_index(s, p)];
                }
            }

            for (p = 0; p < np; p++) {
                vetorized_A[a_array_index(r, q, p)] = sum_aux[p];
            }
        }
    }
    pthread_barrier_wait(&barrier);
}


int main(int argc, char **argv) {  
    int processCount, processId, workersCount, source, cont_threads = 1;
    int offset, rows;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &processId);
    MPI_Comm_size(MPI_COMM_WORLD, &processCount);

    workersCount = processCount - 1;

    if (processId == 0) {
        polybench_start_instruments;
    }

    if (argc < 3) {
        if (processId == 0)
            printf("Usage: %s -t threads -d data_set -s seed\n", argv[0]);
        MPI_Finalize();
        return -1;
    }

    if (processId == 0) {
        int seed = 0;
        char data_set_identifier = ' ';
        int i = 0;

        while ((i = getopt(argc, argv, "ht:d:s:")) != -1) {
            switch (i) {
                case 'h':
                    show_help(argv[0]);
                    break;
                case 's':
                    seed = atoi(optarg);
                    break;
                case 't': /* opção -t */
                    cont_threads = atoi(optarg);
                    break;
                case 'd':
                    data_set_identifier = optarg[0];
                    break;
                default:
                    if (processId == 0)
                        fprintf(stderr, "Invalid option: `%c'\n", optopt);
                    MPI_Finalize();
                    return -1;
            }
        }

        define_dataset(data_set_identifier);
        rows = nr / processCount;
        offset = 0;

        // alocate and intialyze all data in root
        alocate_data();
        init_arrays(seed);

        // sending data to workers
        for (int dest = 1; dest <= workersCount; dest++) {
            offset = offset + rows;
            if(dest == workersCount){
                rows = nr - offset;
            }
            MPI_Send(&rows, 1, MPI_INT, dest, 1, MPI_COMM_WORLD);
            MPI_Send(&nq, 1, MPI_INT, dest, 1, MPI_COMM_WORLD);
            MPI_Send(&np, 1, MPI_INT, dest, 1, MPI_COMM_WORLD);
            MPI_Send(&cont_threads, 1, MPI_INT, dest, 1, MPI_COMM_WORLD);
            MPI_Send(&offset, 1, MPI_INT, dest, 1, MPI_COMM_WORLD);

            MPI_Send(vetorized_A + (offset * nq * np), rows * nq * np, MPI_DOUBLE, dest, 1, MPI_COMM_WORLD);
            MPI_Send(vetorized_C4, np * np, MPI_DOUBLE, dest, 1, MPI_COMM_WORLD);
        }
        
        i = nr;
        nr = rows;
        rows = i;

        pthread_t threads[cont_threads];
        pthread_setconcurrency(cont_threads);
        pthread_barrier_init(&barrier, NULL, cont_threads);
        
        int j;
        // call kernel to multiply matrixes
        for (j = 0; j < cont_threads; ++j){
            int *tid;
            tid = (int *)malloc(sizeof(int));
            *tid = j;
            pthread_create(&threads[j], NULL, &kernel_worker, (void *)tid);
        }

        for (j = 0; j < cont_threads; ++j){
            pthread_join(threads[j], NULL);
        }
        pthread_barrier_destroy(&barrier);

        MPI_Barrier(MPI_COMM_WORLD);

        i = nr;
        nr = rows;
        rows = i;

        // receiving data from workers and updating vetorized_A
        for (int i = 1; i <= workersCount; i++) {
            source = i;
            MPI_Recv(&offset, 1, MPI_INT, source, 2, MPI_COMM_WORLD, &status);
            MPI_Recv(vetorized_A + (offset * nq * np), rows * nq * np, MPI_DOUBLE, source, 2, MPI_COMM_WORLD, &status);
        }

        polybench_prevent_dce(print_array());

        // free data
        libera_matriz();

        // stop timer and print
        polybench_stop_instruments;
        polybench_print_instruments;
    }

    if (processId > 0) {
        source = 0;
        int j;
        // receive data from root
        MPI_Recv(&rows, 1, MPI_INT, source, 1, MPI_COMM_WORLD, &status);
        MPI_Recv(&nq, 1, MPI_INT, source, 1, MPI_COMM_WORLD, &status);
        MPI_Recv(&np, 1, MPI_INT, source, 1, MPI_COMM_WORLD, &status);
        MPI_Recv(&cont_threads, 1, MPI_INT, source, 1, MPI_COMM_WORLD, &status);
        nr = rows;

        MPI_Recv(&offset, 1, MPI_INT, source, 1, MPI_COMM_WORLD, &status);

        //alocate data in worker
        alocate_data();

        // receive matrixes from root
        MPI_Recv(vetorized_A, nr * nq * np, MPI_DOUBLE, source, 1, MPI_COMM_WORLD, &status);
        MPI_Recv(vetorized_C4, np * np, MPI_DOUBLE, source, 1, MPI_COMM_WORLD, &status);

        pthread_t threads[cont_threads];
        pthread_setconcurrency(cont_threads);
        pthread_barrier_init(&barrier, NULL, cont_threads);

        // call kernel to multiply matrixes
        for (j = 0; j < cont_threads; ++j){
            int *tid;
            tid = (int *)malloc(sizeof(int));
            *tid = j;
            pthread_create(&threads[j], NULL, &kernel_worker, (void *)tid);
        }

        for (j = 0; j < cont_threads; ++j){
            pthread_join(threads[j], NULL);
        }
        pthread_barrier_destroy(&barrier);

        MPI_Barrier(MPI_COMM_WORLD);

        // send data back to root
        MPI_Send(&offset, 1, MPI_INT, 0, 2, MPI_COMM_WORLD);
        MPI_Send(vetorized_A, nr * nq * np, MPI_DOUBLE, 0, 2, MPI_COMM_WORLD);

        libera_matriz();
    }

    MPI_Finalize();
}
