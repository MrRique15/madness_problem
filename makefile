# C Program Path to compile
# or -> madness/doitgen_parallel
PROG = madness/doitgen
# Runtime parameters
DATASET = test
THREADS = 2
SEED = 58

# Output name
OUTPUT_NAME = doitgen_build
# Number of executions to run in tests
EXECUTIONS = 10
# ###############################################################################################
# sequential commands
build_sequential: 
	gcc -O3 -I utilities -I $(PROG)_sequential utilities/polybench.c $(PROG)_sequential.c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME)_sequential

run_sequential:
	./builds/$(OUTPUT_NAME)_sequential -d $(DATASET) -s $(SEED)
# ###############################################################################################
# parallel commands
build_parallel: 
	gcc -O3 -I utilities -I $(PROG)_parallel utilities/polybench.c $(PROG)_parallel.c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME)_parallel

run_parallel:
	./builds/$(OUTPUT_NAME)_parallel -d $(DATASET) -t $(THREADS) -s $(SEED)
# ###############################################################################################
# mpi commands
build_mpi: 
	mpicc -O3 -I utilities -I $(PROG)_mpi utilities/polybench.c $(PROG)_mpi.c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME)_mpi -g

run_mpi:
	mpirun -np 3 ./builds/$(OUTPUT_NAME)_mpi -d $(DATASET) -s $(SEED)
# ###############################################################################################
# ###############################################################################################
# auxiliar commands
gdb_mpi:
	mpirun -np 3 gdb -ex run --args ./builds/$(OUTPUT_NAME) -d $(DATASET) -s $(SEED)

build_papi:
	gcc -O3 -I utilities -I $(PROG) utilities/polybench.c $(PROG).c -DPOLYBENCH_PAPI -lpapi -o builds/$(OUTPUT_NAME)

run_tests:
	./test_files/auto_run.sh ./builds/$(OUTPUT_NAME) $(EXECUTIONS) -d$(DATASET) -t$(THREADS) -s$(SEED)

# github actions build to check if it compiles (DON'T CHANGE)
build_git_actions:
	gcc -O3 -I utilities -I $(PROG)_sequential utilities/polybench.c $(PROG)_sequential.c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME)_sequential
# ###############################################################################################
# ###############################################################################################
run_all_sequential:
	./test_files/auto_run_all_sequential.sh ./builds/$(OUTPUT_NAME) 

run_all_parallel:
	./test_files/auto_run_all_parallel.sh ./builds/$(OUTPUT_NAME) 

