# C Program Path to compile
PROG = madness/doitgen
# Runtime parameters
DATASET = test
THREADS = 1
SEED = 58

# Output name
OUTPUT_NAME = doitgen_build
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
