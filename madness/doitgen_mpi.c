#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <math.h>
#include <mpi.h>
#include <stdlib.h>

/* Include polybench common header. */
#include <polybench.h>

/* Include benchmark-specific header. */
#include "doitgen.h"


int nq, nr, np;

DATA_TYPE ***A;
DATA_TYPE **C4;

void define_arguments(int argc, char **argv, char *data_set_identifier, int *seed, int *count_threads)
{
    for (int i = 1; i < argc; i++)
    {
        char arg_name = argv[i][1];
        switch (arg_name)
        {

        case 'd':
            *data_set_identifier = argv[i][2];
            break;

        case 's':
            char *command = argv[i];
            command[0] = '0';
            command[1] = '0';
            *seed = atoi(command);
            break;

        case 't':
            char *command2 = argv[i];
            command2[0] = '0';
            command2[1] = '0';
            *count_threads = atoi(command2);
            break;

        default:
            break;
        }
    }
}

void define_dataset(char data_set_identifier)
{
    switch (data_set_identifier)
    {
    case 't':
        nq = 150;
        nr = 170;
        np = 220;
        break;

    case 's':
        nq = 600;
        nr = 640;
        np = 680;
        break;

    case 'm':
        nq = 700;
        nr = 750;
        np = 800;
        break;

    case 'l':
        nq = 800;
        nr = 850;
        np = 900;
        break;

    default:
        break;
    }
}

void libera_matriz(){
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

void alocate_data(){
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
void init_arrays(int seed){
    int i, j, k;

    srand (seed);
    for (i = 0; i < nr; i++)
        for (j = 0; j < nq; j++)
            for (k = 0; k < np; k++)
                A[i][j][k] = (DATA_TYPE)rand() / RAND_MAX;
    for (i = 0; i < np; i++)
        for (j = 0; j < np; j++)
            C4[i][j] = (DATA_TYPE)rand() / RAND_MAX;
}

/* DCE code. Must scan the entire live-out data.
   Can be used also to check the correctness of the output. */
static void print_array()
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

/* Main computational kernel. The whole function will be timed,
   including the call and return. */
// void *kernel_worker(void *arg) {
//     int tid = *((int *)arg);
//     int max_threads = (int)pthread_getconcurrency();
//     int start = tid * (nr / max_threads);
//     int end = (tid + 1) * (nr / max_threads);
//     int r, q, p, s;
//     DATA_TYPE sum_aux[np];
//     for (r = start; r < end; r++) {
//         for (q = 0; q < nq; q++) {
//             for (p = 0; p < np; p++) {
//                 sum_aux[p] = 0.0;
//                 for (s = 0; s < np; s++) {
//                     sum_aux[p] += A[r][q][s] * C4[s][p];
//                 }
//             }
// 
//             for (p = 0; p < np; p++) {
//                 A[r][q][p] = sum_aux[p];
//             }
//         }
//         // Aguarde todas as threads concluírem antes de prosseguir
//         pthread_barrier_wait(&barrier);
//     }
//     
// }

int main(int argc, char **argv){

    int seed = 0;
    char data_set_identifier = ' ';
    int i = 0;

    if (argc < 2)
    {
        printf("Use help command: %s -h\n", argv[0]);
        return 1;
    }
    else if (argc == 2 && strcmp(argv[1], "-h") == 0){
        printf("Usage: %s -d[test|small|medium|large] -t[threads] -s[seed]\n", argv[0]);
        return 1;
    }
    else{
        define_arguments(argc, argv, &data_set_identifier, &seed, &cont_threads);
    }

    if (data_set_identifier == ' '){
        printf("Invalid dataset identifier\n");
        printf("Usage: %s -d[test|small|medium|large]\n", argv[0]);
        return 1;
    }

    /* Defines data_set to run */
    define_dataset(data_set_identifier);
    // pthread_t threads[cont_threads];
    // pthread_setconcurrency(cont_threads);
    // pthread_barrier_init(&barrier, NULL, cont_threads);

    /* Variable declaration/allocation. */
    alocate_data();

    /* Initialize array(s). */
    init_arrays(seed);

    /* Start timer. */
    polybench_start_instruments;

    /* Run kernel. */
    // for (i = 0; i < cont_threads; ++i){
    //     int *tid;
    //     tid = (int *)malloc(sizeof(int));
    //     *tid = i;
    //     pthread_create(&threads[i], NULL, &kernel_worker, (void *)tid);
    // }

    // for (i = 0; i < cont_threads; ++i){
    //     pthread_join(threads[i], NULL);
    // }
    // pthread_barrier_destroy(&barrier);

    /* Stop and print timer. */
    polybench_stop_instruments;
    polybench_print_instruments;

    /* Prevent dead-code elimination. All live-out data must be printed
       by the function call in argument. */
    polybench_prevent_dce(print_array());

    /* Be clean. */
    libera_matriz();

    return 0;
}