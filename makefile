PROG = madness/doitgen
DATASET = MINI_DATASET
OUTPUT_NAME = doitgen_build

build: 
	gcc -O3 -I utilities -I $(PROG) utilities/polybench.c $(PROG).c -DPOLYBENCH_TIME -D$(DATASET) -o builds/$(OUTPUT_NAME)

run:
	./builds/$(OUTPUT_NAME)

build_papi:
	gcc -O3 -I utilities -I $(PROG) utilities/polybench.c $(PROG).c -DPOLYBENCH_PAPI -D$(DATASET) -lpapi -o builds/$(OUTPUT_NAME)

run_benchmark:
	./test_files/auto_run.sh ./builds/$(OUTPUT_NAME) 10
