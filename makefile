# C Program Path to compile
# or -> madness/doitgen_parallel
PROG = madness/test_mpi
# Runtime parameters
DATASET = test
THREADS = 2
SEED = 58

# Output name
OUTPUT_NAME = mpi_build
# Number of executions to run in tests
EXECUTIONS = 10

build: 
	gcc -O3 -I utilities -I $(PROG) utilities/polybench.c $(PROG).c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME)

run:
	./builds/$(OUTPUT_NAME) -d$(DATASET) -t$(THREADS) -s$(SEED)

build_papi:
	gcc -O3 -I utilities -I $(PROG) utilities/polybench.c $(PROG).c -DPOLYBENCH_PAPI -lpapi -o builds/$(OUTPUT_NAME)

run_tests:
	./test_files/auto_run.sh ./builds/$(OUTPUT_NAME) $(EXECUTIONS) -d$(DATASET) -t$(THREADS) -s$(SEED)

# github actions build to check if it compiles (DON'T CHANGE)
build_git_actions:
	gcc -O3 -I utilities -I $(PROG) utilities/polybench.c $(PROG).c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME)

run_all_sequential:
	./test_files/auto_run_all_sequential.sh ./builds/$(OUTPUT_NAME) 

run_all_parallel:
	./test_files/auto_run_all_parallel.sh ./builds/$(OUTPUT_NAME) 



build_mpi: 
	mpicc -O3 -I utilities -I $(PROG) utilities/polybench.c $(PROG).c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME) -g

run_mpi:
	mpirun -np 3 ./builds/$(OUTPUT_NAME) -d $(DATASET) -s $(SEED)

gdb_mpi:
	mpirun -np 3 gdb -ex run --args ./builds/$(OUTPUT_NAME) -d $(DATASET) -s $(SEED)