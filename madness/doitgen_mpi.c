#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <getopt.h>
#include <time.h>
#include <string.h>

/* Include polybench common header. */
#include <polybench.h>

/* Include benchmark-specific header. */
#include "doitgen.h"

MPI_Status status;

DATA_TYPE *vetorized_A;
DATA_TYPE *vetorized_C4;

void show_help(char *name) {
    fprintf(stderr, "\
            [uso] %s <opcoes>\n\
            -h         mostra essa tela e sai.\n\
            -t THREADS    seta quantidade de threads.\n\
            -d DATA_SET   seta o data_set utilizado.\n\
            -s SSED  seta seed de numeros random.\n", name) ;
    exit(-1) ;
}

void define_dataset(char data_set_identifier, int *nq, int *nr, int *np){
    switch (data_set_identifier)
    {
    case 't':
        *nq = 150;
        *nr = 170;
        *np = 220;
        break;

    case 's':
        *nq = 600;
        *nr = 640;
        *np = 680;
        break;

    case 'm':
        *nq = 700;
        *nr = 750;
        *np = 800;
        break;

    case 'l':
        *nq = 800;
        *nr = 850;
        *np = 900;
        break;

    default:
        printf("Wrong data_set inserted, assuming TEST\n");
        *nq = 150;
        *nr = 170;
        *np = 220;
        break;
    }
}

int a_array_index(int i, int j, int k, int nq, int np){
    return ((i * nq * np) + (j * np) + k);
}

int c4_array_index(int i, int j, int np){
    return ((i * np) + j);
}

void libera_matriz() {
    free(vetorized_A);
    free(vetorized_C4);
}

void alocate_data(int nr, int nq, int np){
    vetorized_A = (DATA_TYPE *)malloc(nr * nq * np * sizeof(DATA_TYPE));
    vetorized_C4 = (DATA_TYPE *)malloc(np * np * sizeof(DATA_TYPE));
}

/* Array initialization and vetorization. */
void init_arrays(int nr, int nq, int np, int seed) {
    srand(seed);
    int i, j, k;
    for (i = 0; i < nr; i++){
        for (j = 0; j < nq; j++){
            for (k = 0; k < np; k++){
                vetorized_A[a_array_index(i, j, k, nq, np)] = (DATA_TYPE)rand() / RAND_MAX;
            }
        }
    }

    for (i = 0; i < np; i++){
        for (j = 0; j < np; j++){
            vetorized_C4[c4_array_index(i, j, np)] = (DATA_TYPE)rand() / RAND_MAX;
        }
    }
}

/* DCE code. Must scan the entire live-out data.
   Can be used also to check the correctness of the output. */
static void print_array(int nr, int nq, int np){
    POLYBENCH_DUMP_START;
    POLYBENCH_DUMP_BEGIN("A");
    for (int i = 0; i < nr; i++) {
        for (int j = 0; j < nq; j++) {
            for (int k = 0; k < np; k++) {
                if ((i * nq * np + j * np + k) % 20 == 0) {
                    fprintf(POLYBENCH_DUMP_TARGET, "\n");
                }
                fprintf(POLYBENCH_DUMP_TARGET, DATA_PRINTF_MODIFIER, vetorized_A[a_array_index(i, j, k, nq, np)]);
            }
        }
    }
    POLYBENCH_DUMP_END("A");
    POLYBENCH_DUMP_FINISH;
}

/* Main computational kernel. */
void kernel_worker(int rows, int nq, int np) {
    DATA_TYPE *sum_aux = (DATA_TYPE *)malloc(np * sizeof(DATA_TYPE));

    for (int r = 0; r < rows; r++) {
        for (int q = 0; q < nq; q++) {
            for (int p = 0; p < np; p++) {
                sum_aux[p] = 0.0;
                for (int s = 0; s < np; s++) {
                    sum_aux[p] += vetorized_A[a_array_index(r, q, s, nq, np)] * vetorized_C4[c4_array_index(s, p, np)];
                }
            }

            for (int p = 0; p < np; p++) {
                vetorized_A[a_array_index(r, q, p, nq, np)] = sum_aux[p];
            }
        }
    }

    free(sum_aux);
}

int main(int argc, char **argv) {  
    int processCount, processId, workersCount, source;
    int nr, nq, np;
    int offset, rows;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &processId);
    MPI_Comm_size(MPI_COMM_WORLD, &processCount);

    workersCount = processCount - 1;

    if (processId == 0) {
        polybench_start_instruments;
    }

    if (argc < 2) {
        if (processId == 0)
            printf("Usage: %s -d data_set -s seed\n", argv[0]);
        MPI_Finalize();
        return -1;
    }

    if (processId == 0) {
        printf("Root Process started ID: %d\n", processId);
        int seed = 0;
        char data_set_identifier = ' ';
        int i = 0;

        while ((i = getopt(argc, argv, "hd:s:")) != -1) {
            switch (i) {
                case 'h':
                    show_help(argv[0]);
                    break;
                case 's':
                    seed = atoi(optarg);
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

        define_dataset(data_set_identifier, &nq, &nr, &np);

        rows = nr / processCount;
        offset = 0;

        // alocate and intialyze all data in root
        alocate_data(nr, nq, np);
        init_arrays(nr, nq, np, seed);

        // sending data to workers
        for (int dest = 1; dest <= workersCount; dest++) {
            offset = offset + rows;
            if(dest == workersCount){
                rows = nr - offset;
            }
            MPI_Send(&rows, 1, MPI_INT, dest, 1, MPI_COMM_WORLD);
            MPI_Send(&nq, 1, MPI_INT, dest, 1, MPI_COMM_WORLD);
            MPI_Send(&np, 1, MPI_INT, dest, 1, MPI_COMM_WORLD);
            MPI_Send(&offset, 1, MPI_INT, dest, 1, MPI_COMM_WORLD);

            MPI_Send(vetorized_A + (offset * nq * np), rows * nq * np, MPI_DOUBLE, dest, 1, MPI_COMM_WORLD);
            MPI_Send(vetorized_C4, np * np, MPI_DOUBLE, dest, 1, MPI_COMM_WORLD);
        }
        
        // call kernel to multiply matrixes
        kernel_worker(rows, nq, np);

        MPI_Barrier(MPI_COMM_WORLD);

        // receiving data from workers and updating vetorized_A
        for (int i = 1; i <= workersCount; i++) {
            source = i;
            MPI_Recv(&offset, 1, MPI_INT, source, 2, MPI_COMM_WORLD, &status);
            MPI_Recv(vetorized_A + (offset * nq * np), rows * nq * np, MPI_DOUBLE, source, 2, MPI_COMM_WORLD, &status);
        }

        polybench_prevent_dce(print_array(nr, nq, np));

        // free data
        libera_matriz();

        // stop timer and print
        polybench_stop_instruments;
        polybench_print_instruments;
    }

    if (processId > 0) {
        // nr = rows (in workers)
        printf("Worker Process started ID: %d\n", processId);
        source = 0;

        // receive data from root
        MPI_Recv(&rows, 1, MPI_INT, source, 1, MPI_COMM_WORLD, &status);
        MPI_Recv(&nq, 1, MPI_INT, source, 1, MPI_COMM_WORLD, &status);
        MPI_Recv(&np, 1, MPI_INT, source, 1, MPI_COMM_WORLD, &status);

        MPI_Recv(&offset, 1, MPI_INT, source, 1, MPI_COMM_WORLD, &status);

        //alocate data in worker
        alocate_data(rows, nq, np);

        // receive matrixes from root
        MPI_Recv(vetorized_A, rows * nq * np, MPI_DOUBLE, source, 1, MPI_COMM_WORLD, &status);
        MPI_Recv(vetorized_C4, np * np, MPI_DOUBLE, source, 1, MPI_COMM_WORLD, &status);

        // call kernel to multiply matrixes
        kernel_worker(rows, nq, np);

        MPI_Barrier(MPI_COMM_WORLD);
        // send data back to root
        MPI_Send(&offset, 1, MPI_INT, 0, 2, MPI_COMM_WORLD);
        MPI_Send(vetorized_A, rows * nq * np, MPI_DOUBLE, 0, 2, MPI_COMM_WORLD);

        libera_matriz();
    }

    MPI_Finalize();
}
