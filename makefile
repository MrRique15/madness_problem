PROG = madness/doitgen
DATASET = MINI_DATASET
OUTPUT_NAME = doitgen_build

build: 
	gcc -O3 -I utilities -I $(PROG) utilities/polybench.c $(PROG).c -DPOLYBENCH_TIME -D$(DATASET) -o builds/$(OUTPUT_NAME)

run:
	./builds/$(OUTPUT_NAME)
