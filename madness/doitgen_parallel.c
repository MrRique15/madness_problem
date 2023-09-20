#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <math.h>
#include <pthread.h>
#include <stdlib.h>
#include <getopt.h>

/* Include polybench common header. */
#include <polybench.h>

/* Include benchmark-specific header. */
#include "doitgen.h"

// Declaração de funções para previnir warnings
int pthread_setconcurrency(int new_level);
int pthread_getconcurrency(void);

int nq, nr, np;

DATA_TYPE ***A;
DATA_TYPE **C4;

pthread_barrier_t barrier; // Barreira global

void show_help(char *name) {
    fprintf(stderr, "\
            [uso] %s <opcoes>\n\
            -h            mostra essa tela e sai.\n\
            -t THREADS    seta quantidade de threads.\n\
            -d DATA_SET   seta o data_set utilizado.\n\
            -s SEED       seta seed de numeros random.\n\
            -p (1 or 0)   print result or not.\n\
            -v (1 or 0)   verify output or not.\n", name) ;
    exit(-1) ;
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
                    sum_aux[p] += A[r][q][s] * C4[s][p];
                }
            }

            for (p = 0; p < np; p++) {
                A[r][q][p] = sum_aux[p];
            }
        }
    }

    pthread_barrier_wait(&barrier);
    
}

int main(int argc, char **argv){
    /* Start timer. */
    polybench_start_instruments;

    int cont_threads = 1;
    int seed = 0;
    char data_set_identifier = ' ';
    int i = 0;
    int opt = 0;
    int print_result = 0;
    int verify_output = 0;

    if ( argc < 4 ){
        show_help(argv[0]);
    }

    while( (opt = getopt(argc, argv, "ht:d:s:p:v:")) > 0 ) {
        switch ( opt ) {
            case 'h': /* help */
                show_help(argv[0]);
                break ;
            case 's': /* opção -t */
                seed = atoi(optarg);
                break;
            case 't': /* opção -t */
                cont_threads = atoi(optarg);
                break;
            case 'd': /* opção -d */
                data_set_identifier = optarg[0];
                break;
            case 'p':
                print_result = atoi(optarg);
                break;
            case 'v':
                verify_output = atoi(optarg);
                break;
            default:
                fprintf(stderr, "Opcao invalida ou faltando argumento: `%c'\n", optopt) ;
                return -1 ;
        }
    }

    /* Defines data_set to run */
    define_dataset(data_set_identifier);
    pthread_t threads[cont_threads];
    pthread_setconcurrency(cont_threads);
    pthread_barrier_init(&barrier, NULL, cont_threads);

    /* Variable declaration/allocation. */
    alocate_data();

    /* Initialize array(s). */
    init_arrays(seed);

    /* Run kernel. */
    for (i = 0; i < cont_threads; ++i){
        int *tid;
        tid = (int *)malloc(sizeof(int));
        *tid = i;
        pthread_create(&threads[i], NULL, &kernel_worker, (void *)tid);
    }

    for (i = 0; i < cont_threads; ++i){
        pthread_join(threads[i], NULL);
    }
    pthread_barrier_destroy(&barrier);

    /* Prevent dead-code elimination. All live-out data must be printed
       by the function call in argument. */
    if(verify_output == 1){
        polybench_prevent_dce(print_array());
    }

    if(print_result == 1){
        /* Stop and print timer. */
        polybench_stop_instruments;

        print_array();

        /* Be clean. */
        libera_matriz();
        polybench_print_instruments;
    }else{
        libera_matriz();
        /* Stop and print timer. */
        polybench_stop_instruments;
        polybench_print_instruments;
    }

    return 0;
}