#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <mpi.h>
#include <getopt.h>

/* Include polybench common header. */
#include <polybench.h>

/* Include benchmark-specific header. */
#include "doitgen.h"

DATA_TYPE ***A;
DATA_TYPE **C4;

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

void libera_matriz(int nr, int nq, int np){
    int line;

    for(line = 0; line < nr; line++){
        free(A[line]);
    }
    for(line = 0; line < np; line++){
        free(C4[line]);
    }

    free(A);
    free(C4);
}

void alocate_data(int nr, int nq, int np){
    A = (DATA_TYPE ***)malloc(nr * sizeof(DATA_TYPE **));
    C4 = (DATA_TYPE **)malloc(np * sizeof(DATA_TYPE *));
    for (int i = 0; i < nr; i++){
        A[i] = (DATA_TYPE **)malloc(nq * sizeof(DATA_TYPE *));
        for (int j = 0; j < nq; j++){
            A[i][j] = (DATA_TYPE *)malloc(np * sizeof(DATA_TYPE));
        }
    }
    for (int i = 0; i < np; i++){
        C4[i] = (DATA_TYPE *)malloc(np * sizeof(DATA_TYPE));
    }
}

/* Array initialization. */
void init_arrays(int nr, int nq, int np, int seed)
{
    int i, j, k;
    srand(seed);
    for (i = 0; i < nr; i++){
        for (j = 0; j < nq; j++){
            for (k = 0; k < np; k++){
                A[i][j][k] = (DATA_TYPE)rand() / RAND_MAX;
            }       
        }
    }
        
    for (i = 0; i < np; i++){
        for (j = 0; j < np; j++){
            C4[i][j] = (DATA_TYPE)rand() / RAND_MAX;
        }
    }
}

/* DCE code. Must scan the entire live-out data.
   Can be used also to check the correctness of the output. */
static void print_array(int nr, int nq, int np)
{
    int i, j, k;

    POLYBENCH_DUMP_START;
    POLYBENCH_DUMP_BEGIN("A");
    for (i = 0; i < nr; i++)
        for (j = 0; j < nq; j++)
            for (k = 0; k < np; k++)
            {
                if ((i * nq * np + j * np + k) % 20 == 0)
                    fprintf(POLYBENCH_DUMP_TARGET, "\n");
                fprintf(POLYBENCH_DUMP_TARGET, DATA_PRINTF_MODIFIER, A[i][j][k]);
            }
    POLYBENCH_DUMP_END("A");
    POLYBENCH_DUMP_FINISH;
}

/* Main computational kernel. */
void kernel_worker(int rank, int size, int nr, int nq, int np){
    int start = rank * (nr / size);
    int end = (rank + 1) * (nr / size);
    int r, q, p, s;
    DATA_TYPE sum_aux[np];
    for (r = start; r < end; r++)
    {
        for (q = 0; q < nq; q++)
        {
            for (p = 0; p < np; p++)
            {
                sum_aux[p] = 0.0;
                for (s = 0; s < np; s++)
                {
                    sum_aux[p] += A[r][q][s] * C4[s][p];
                }
            }

            for (p = 0; p < np; p++)
            {
                A[r][q][p] = sum_aux[p];
            }
        }
    }
}

int main(int argc, char **argv){
    /* Initialize MPI */
    MPI_Init(&argc, &argv);

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int seed = 0;
    char data_set_identifier = ' ';
    int i = 0;
    int nq, nr, np;

    printf("RANK of Process: %d with SIZE: %d\n", rank, size);
    if (rank ==0){
        polybench_start_instruments;
    }

    if (argc < 2){
        if (rank == 0)
            printf("Usage: %s -d data_set -s seed\n", argv[0]);
        MPI_Finalize();
        return -1;
    }

    if (rank == 0){
        while ((i = getopt(argc, argv, "hd:s:")) != -1){
            switch (i){
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
                    if (rank == 0)
                        fprintf(stderr, "Invalid option: `%c'\n", optopt);
                    MPI_Finalize();
                    return -1;
            }
        }
    }
    
    /* Variable declaration/allocation on rank 0 */
    if (rank == 0){
        /* Defines data_set to run */
        define_dataset(data_set_identifier, &nq, &nr, &np);
        /* Variable declaration/allocation. */
        alocate_data(nr, nq, np);
        /* Initialize array(s). */
        init_arrays(nr, nq, np, seed);
    }

    /* Broadcast dataset information to all processes */
    MPI_Bcast(&nq, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(&nr, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(&np, 1, MPI_INT, 0, MPI_COMM_WORLD);

    /* Distribute data to worker processes */
    if (rank == 0){
        for (int dest = 1; dest < size; dest++){
            MPI_Send(&(A[(dest - 1) * (nr / (size - 1))][0][0]), (nr / (size - 1)) * nq * np, MPI_DATA_TYPE, dest, 0, MPI_COMM_WORLD);
        }
    }else{
        /* Receive data from rank 0 */
        MPI_Recv(&(A[0][0][0]), (nr / (size - 1)) * nq * np, MPI_DATA_TYPE, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }

    /* Run kernel on each worker process */
    if (rank != 0){
        kernel_worker(rank, size - 1, nr, nq, np);
    }

    /* Gather data from worker processes to rank 0 */
    if (rank == 0){
        for (int source = 1; source < size; source++){
            MPI_Recv(&(A[(source - 1) * (nr / (size - 1))][0][0]), (nr / (size - 1)) * nq * np, MPI_DATA_TYPE, source, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }
    }else{
        /* Send data to rank 0 */
        MPI_Send(&(A[0][0][0]), (nr / (size - 1)) * nq * np, MPI_DATA_TYPE, 0, 0, MPI_COMM_WORLD);
    }

    /* Clean up on rank 0 */
    if (rank == 0)
    {
        /* Prevent dead-code elimination. All live-out data must be printed
        by the function call in argument. */
        polybench_prevent_dce(print_array(nr, nq, np));

        /* Be clean. */
        libera_matriz(nr, nq, np);

        /* Stop and print timer. */
        polybench_stop_instruments;
        polybench_print_instruments;
    }

    /* Finalize MPI */
    MPI_Finalize();

    return 0;
}