# C Program Path to compile and output
PROG = madness/doitgen
OUTPUT_NAME = doitgen_build

# Runtime parameters
DATASET=large
THREADS=16
SEED=58
MPI_WORKERS=8
PRINT_RESULTS=0  # 0 - don't print results; 1 - print results
VERIFY_OUTPUT=1  # 0 - don't verify results; 1 - verify results

# Number of executions to run in tests
EXECUTIONS=10
# ###############################################################################################
# sequential commands
build_sequential:
	gcc -O3 -I utilities -I $(PROG)_sequential utilities/polybench.c $(PROG)_sequential.c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME)_sequential

run_sequential:
	./builds/$(OUTPUT_NAME)_sequential -d $(DATASET) -s $(SEED) -p $(PRINT_RESULTS) -v $(VERIFY_OUTPUT)
# ###############################################################################################
# parallel commands
build_parallel: 
	gcc -O3 -I utilities -I $(PROG)_parallel utilities/polybench.c $(PROG)_parallel.c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME)_parallel

run_parallel:
	./builds/$(OUTPUT_NAME)_parallel -d $(DATASET) -t $(THREADS) -s $(SEED) -p $(PRINT_RESULTS) -v $(VERIFY_OUTPUT)
# ###############################################################################################
# mpi commands
build_mpi: 
	mpicc -O3 -I utilities -I $(PROG)_mpi utilities/polybench.c $(PROG)_mpi.c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME)_mpi -g

run_mpi:
	mpirun -np $(MPI_WORKERS) ./builds/$(OUTPUT_NAME)_mpi -d $(DATASET) -s $(SEED) -p $(PRINT_RESULTS) -v $(VERIFY_OUTPUT)
# ###############################################################################################
# mpi+threads commands
build_mpi_threads: 
	mpicc -O3 -I utilities -I $(PROG)_mpi_threads utilities/polybench.c $(PROG)_mpi_threads.c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME)_mpi_threads -g

run_mpi_threads:
	mpirun -np $(MPI_WORKERS) ./builds/$(OUTPUT_NAME)_mpi_threads -t $(THREADS) -d $(DATASET) -s $(SEED) -p $(PRINT_RESULTS) -v $(VERIFY_OUTPUT)
# ###############################################################################################
# ###############################################################################################
# auxiliar commands
gdb_mpi:
	mpirun -np $(MPI_WORKERS) gdb -ex run --args ./builds/$(OUTPUT_NAME) -d $(DATASET) -s $(SEED)

build_papi:
	gcc -O3 -I utilities -I $(PROG) utilities/polybench.c $(PROG).c -DPOLYBENCH_PAPI -lpapi -o builds/$(OUTPUT_NAME)
# ###############################################################################################
# ###############################################################################################
# test commands for WSL and LINUX
run_tests_sequential_wsl:
	./test_files/auto_run_wsl_sequential.sh ./builds/$(OUTPUT_NAME)_sequential $(EXECUTIONS) $(DATASET) $(SEED)

run_tests_parallel_wsl:
	./test_files/auto_run_wsl_parallel.sh ./builds/$(OUTPUT_NAME)_parallel $(EXECUTIONS) $(DATASET) $(THREADS) $(SEED)

run_tests_sequential_linux:
	./test_files/auto_run_sequential.sh ./builds/$(OUTPUT_NAME)_sequential $(EXECUTIONS) $(DATASET) $(SEED)

run_tests_parallel_linux:
	./test_files/auto_run_parallel.sh ./builds/$(OUTPUT_NAME)_parallel $(EXECUTIONS) $(DATASET) $(THREADS) $(SEED)
# ###############################################################################################
# ###############################################################################################
# github actions build to check if it compiles (DON'T CHANGE)
build_git_actions:
	gcc -O3 -I utilities -I $(PROG)_sequential utilities/polybench.c $(PROG)_sequential.c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME)_sequential
# ###############################################################################################
# ###############################################################################################
# run all tests with 10 executions and all variations LINUX only
run_all_sequential:
	./test_files/auto_run_all_sequential.sh ./builds/$(OUTPUT_NAME)_sequential

run_all_parallel:
	./test_files/auto_run_all_parallel.sh ./builds/$(OUTPUT_NAME)_parallel

run_all_mpi_threads:
	./test_files/auto_run_all_mpi_threads.sh ./builds/$(OUTPUT_NAME)_mpi_threads

run_complete:
	./test_files/auto_run_complete.sh