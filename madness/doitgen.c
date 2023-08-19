#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

/* Include polybench common header. */
#include <polybench.h>

/* Include benchmark-specific header. */
#include "doitgen.h"

void define_arguments(int argc, char **argv, char *data_set_identifier, int *seed, int *threads)
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
            *threads = atoi(command2);
            break;

        default:
            break;
        }
    }
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
        break;
    }
}
/* Array initialization. */
void init_arrays(int nr, int nq, int np, DATA_TYPE POLYBENCH_3D(A, nr, nq, np, nr, nq, np), DATA_TYPE POLYBENCH_2D(C4, np, np, np, np), int seed)
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
static void print_array(int nr, int nq, int np, DATA_TYPE POLYBENCH_3D(A, nr, nq, np, nr, nq, np))
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
void kernel_doitgen(int nr, int nq, int np, DATA_TYPE POLYBENCH_3D(A, nr, nq, np, nr, nq, np), DATA_TYPE POLYBENCH_2D(C4, np, np, np, np), DATA_TYPE POLYBENCH_1D(sum, np, np))
{
    int r, q, p, s;

    for (r = 0; r < _PB_NR; r++){
        
        for (q = 0; q < _PB_NQ; q++){

            for (p = 0; p < _PB_NP; p++){
                sum[p] = SCALAR_VAL(0.0);
                for (s = 0; s < _PB_NP; s++){
                    sum[p] += A[r][q][s] * C4[s][p];
                }
            }

            for (p = 0; p < _PB_NP; p++){
                A[r][q][p] = sum[p];
            }
        }
    }
}

int main(int argc, char **argv){

    int threads = 1;
    int seed = 0;
    char data_set_identifier = ' ';

    /* Retrieve problem size. */
    int nr = 0;
    int nq = 0;
    int np = 0;

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
        define_arguments(argc, argv, &data_set_identifier, &seed, &threads);
    }

    if (data_set_identifier == ' '){
        printf("Invalid dataset identifier\n");
        printf("Usage: %s -d[test|small|medium|large]\n", argv[0]);
        return 1;
    }

    /* Defines data_set to run */
    define_dataset(data_set_identifier, &nq, &nr, &np);

    /* Variable declaration/allocation. */
    POLYBENCH_3D_ARRAY_DECL(A, DATA_TYPE, nr, nq, np, nr, nq, np);
    POLYBENCH_1D_ARRAY_DECL(sum, DATA_TYPE, np, np);
    POLYBENCH_2D_ARRAY_DECL(C4, DATA_TYPE, np, np, np, np);

    /* Initialize array(s). */
    init_arrays(nr, nq, np, POLYBENCH_ARRAY(A), POLYBENCH_ARRAY(C4), seed);

    /* Start timer. */
    polybench_start_instruments;

    /* Run kernel. */
    kernel_doitgen(nr, nq, np, POLYBENCH_ARRAY(A), POLYBENCH_ARRAY(C4), POLYBENCH_ARRAY(sum));

    /* Stop and print timer. */
    polybench_stop_instruments;
    polybench_print_instruments;

    /* Prevent dead-code elimination. All live-out data must be printed
       by the function call in argument. */
    polybench_prevent_dce(print_array(nr, nq, np, POLYBENCH_ARRAY(A)));

    /* Be clean. */
    POLYBENCH_FREE_ARRAY(A);
    POLYBENCH_FREE_ARRAY(sum);
    POLYBENCH_FREE_ARRAY(C4);

    return 0;
}