#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
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

void define_dataset(char data_set_identifier, int *nq, int *nr, int *np)
{
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

/* Main computational kernel. The whole function will be timed,
   including the call and return. */
void kernel_doitgen(int nr, int nq, int np)
{
    int r, q, p, s;
    DATA_TYPE sum[np];

    for (r = 0; r < nr; r++){
        
        for (q = 0; q < nq; q++){

            for (p = 0; p < np; p++){
                sum[p] = SCALAR_VAL(0.0);
                for (s = 0; s < np; s++){
                    sum[p] += A[r][q][s] * C4[s][p];
                }
            }

            for (p = 0; p < np; p++){
                A[r][q][p] = sum[p];
            }
        }
    }
}

int main(int argc, char **argv){
    int opt;
    int seed = 0;
    char data_set_identifier=' ';

    /* Retrieve problem size. */
    int nr = 0;
    int nq = 0;
    int np = 0;

    /* Start timer. */
    polybench_start_instruments;

    if ( argc < 2 ) show_help(argv[0]);

    while( (opt = getopt(argc, argv, "ht:d:s:")) > 0 ) {
        switch ( opt ) {
            case 'h': /* help */
                show_help(argv[0]);
                break ;
            case 's': /* opção -t */
                seed = atoi(optarg);
                break;
            case 'd': /* opção -d */
                data_set_identifier = optarg[0];
                break;
            default:
                fprintf(stderr, "Opcao invalida ou faltando argumento: `%c'\n", optopt) ;
                return -1 ;
        }
    }

    /* Defines data_set to run */
    define_dataset(data_set_identifier, &nq, &nr, &np);

    /* Variable declaration/allocation. */
    alocate_data(nr, nq, np);

    /* Initialize array(s). */
    init_arrays(nr, nq, np, seed);

    /* Run kernel. */
    kernel_doitgen(nr, nq, np);

    /* Prevent dead-code elimination. All live-out data must be printed
       by the function call in argument. */
    polybench_prevent_dce(print_array(nr, nq, np));

    /* Be clean. */
    libera_matriz(nr, nq, np);

    /* Stop and print timer. */
    polybench_stop_instruments;
    polybench_print_instruments;

    return 0;
}