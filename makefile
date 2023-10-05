# C Program Path to compile and output
# (DONT CHANGE UNLESS YOU KNOW WHAT YOU ARE DOING)
PROG = madness/doitgen
OUTPUT_NAME = doitgen_build
# ###############################################################################################
# ###############################################################################################
# ###############################################################################################
# Runtime parameters
# datasets = test / small / medium / large
DATASET=test       
# threads = 2 / 4 / 8 / 16 ...
THREADS=16
# seed = any integer > 0
SEED=58
# mpi_workers = 2 / 4 / 8 / 16 ...
MPI_WORKERS=8
# print_result = 0 - don't print results / 1 - print results
PRINT_RESULTS=0  
# verify_output = 0 - don't verify results / 1 - verify results
VERIFY_OUTPUT=1
# ###############################################################################################
# ###############################################################################################
# ###############################################################################################
# sequential commands
build_sequential:
	gcc -O3 -I utilities -I $(PROG)_sequential utilities/polybench.c $(PROG)_sequential.c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME)_sequential

run_sequential:
	./builds/$(OUTPUT_NAME)_sequential -d $(DATASET) -s $(SEED) -p $(PRINT_RESULTS) -v $(VERIFY_OUTPUT)
# ###############################################################################################
# ###############################################################################################
# ###############################################################################################
# parallel commands
build_threads: 
	gcc -O3 -I utilities -I $(PROG)_threads utilities/polybench.c $(PROG)_threads.c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME)_threads

run_threads:
	./builds/$(OUTPUT_NAME)_threads -d $(DATASET) -t $(THREADS) -s $(SEED) -p $(PRINT_RESULTS) -v $(VERIFY_OUTPUT)
# ###############################################################################################
# ###############################################################################################
# ###############################################################################################
# mpi commands
build_mpi: 
	mpicc -O3 -I utilities -I $(PROG)_mpi utilities/polybench.c $(PROG)_mpi.c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME)_mpi -g

run_mpi:
	mpirun -np $(MPI_WORKERS) ./builds/$(OUTPUT_NAME)_mpi -d $(DATASET) -s $(SEED) -p $(PRINT_RESULTS) -v $(VERIFY_OUTPUT)
# ###############################################################################################
# ###############################################################################################
# ###############################################################################################
# mpi+threads commands
build_mpi_threads: 
	mpicc -O3 -I utilities -I $(PROG)_mpi_threads utilities/polybench.c $(PROG)_mpi_threads.c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME)_mpi_threads -g

run_mpi_threads:
	mpirun -np $(MPI_WORKERS) ./builds/$(OUTPUT_NAME)_mpi_threads -t $(THREADS) -d $(DATASET) -s $(SEED) -p $(PRINT_RESULTS) -v $(VERIFY_OUTPUT)
# ###############################################################################################
# ###############################################################################################
# github actions build to check if it compiles (DON'T CHANGE)
build_git_actions:
	gcc -O3 -I utilities -I $(PROG)_sequential utilities/polybench.c $(PROG)_sequential.c -DPOLYBENCH_TIME -o builds/$(OUTPUT_NAME)_sequential