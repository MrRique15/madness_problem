# madness_problem
Parallel MADNESS problem implementation


# --- SEQUENTIAL IMPLEMENTATION ---
## How to run
1. Clone the repository
2. Go to `makefile`, change `PROG` variable to the path of your C program to compile
3. Still in `makefile`, change `DATASET` to the dataset you want to run and `OUTPUT_NAME` to the path of the output file
4. Run `make build` in the root directory to build the program
5. Run `make run` in the root directory to run the program

## How to use PAPI
1. Run `make build_papi` in the root directory to build the program
2. Run `make run` in the root directory to run the program

## How to run tests
1. In `makefile`, change `EXECUTIONS` to the number of times you want to run the program
2. Run `make run_tests` in the root directory, it will run the program `EXECUTIONS` times and show the average execution time
