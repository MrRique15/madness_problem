#ifndef _DOITGEN_H
# define _DOITGEN_H

/* Default to SMALL_DATASET. */
# if !defined(MINI_DATASET) && !defined(SMALL_DATASET) && !defined(MEDIUM_DATASET) && !defined(LARGE_DATASET) && !defined(EXTRALARGE_DATASET)
#  define SMALL_DATASET
# endif

# if !defined(NQ) && !defined(NR) && !defined(NP)
/* Define sample dataset sizes. */
#  ifdef MINI_DATASET     // used for small tests and quick verifications
#   define NQ 150
#   define NR 170
#   define NP 220
#  endif

#  ifdef SMALL_DATASET     // Initial values for larger tests
#   define NQ 600
#   define NR 640
#   define NP 680
#  endif

#  ifdef MEDIUM_DATASET    // 100 units bigger than SMALL_DATASET
#   define NQ 700
#   define NR 750
#   define NP 800
#  endif

#  ifdef LARGE_DATASET     // 200 units bigger than SMALL_DATASET
#   define NQ 800
#   define NR 850
#   define NP 900
#  endif

#endif /* !(NQ NR NP) */

# define _PB_NQ POLYBENCH_LOOP_BOUND(NQ,nq)
# define _PB_NR POLYBENCH_LOOP_BOUND(NR,nr)
# define _PB_NP POLYBENCH_LOOP_BOUND(NP,np)


/* Default data type */
# if !defined(DATA_TYPE_IS_INT) && !defined(DATA_TYPE_IS_FLOAT) && !defined(DATA_TYPE_IS_DOUBLE)
#  define DATA_TYPE_IS_FLOAT
# endif

#ifdef DATA_TYPE_IS_INT
#  define DATA_TYPE int
#  define DATA_PRINTF_MODIFIER "%d "
#endif

#ifdef DATA_TYPE_IS_FLOAT
#  define DATA_TYPE float
#  define DATA_PRINTF_MODIFIER "%0.2f "
#  define SCALAR_VAL(x) x##f
#  define SQRT_FUN(x) sqrtf(x)
#  define EXP_FUN(x) expf(x)
#  define POW_FUN(x,y) powf(x,y)
# endif

#ifdef DATA_TYPE_IS_DOUBLE
#  define DATA_TYPE double
#  define DATA_PRINTF_MODIFIER "%0.2lf "
#  define SCALAR_VAL(x) x
#  define SQRT_FUN(x) sqrt(x)
#  define EXP_FUN(x) exp(x)
#  define POW_FUN(x,y) pow(x,y)
# endif

#endif /* !_DOITGEN_H */
