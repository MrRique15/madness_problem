# C Program Path to compile
PROG = madness/doitgen
# Dataset to use
DATASET = MINI_DATASET
# Output name
OUTPUT_NAME = doitgen_build
# Number of executions to run in tests
EXECUTIONS=10

build: 
	gcc -O3 -I utilities -I $(PROG) utilities/polybench.c $(PROG).c -DPOLYBENCH_TIME -D$(DATASET) -o builds/$(OUTPUT_NAME)

run:
	./builds/$(OUTPUT_NAME)

build_papi:
	gcc -O3 -I utilities -I $(PROG) utilities/polybench.c $(PROG).c -DPOLYBENCH_PAPI -D$(DATASET) -lpapi -o builds/$(OUTPUT_NAME)

run_tests:
	./test_files/auto_run.sh ./builds/$(OUTPUT_NAME) $(EXECUTIONS)

# github actions build to check if it compiles (DON'T CHANGE)
build_git_actions:
	gcc -O3 -I utilities -I $(PROG) utilities/polybench.c $(PROG).c -DPOLYBENCH_TIME -DMINI_DATASET -o builds/$(OUTPUT_NAME)
