#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: ./auto_run_all_parallel.sh <binary_name>";
    echo "Example: ./auto_run_all_parallel.sh \"./a.out\"";
    echo "Note: the file must be a Polybench program compiled with -DPOLYBENCH_TIME";
    exit 1;
fi;

# Get the program path from the first argument
PRORGAM_PATH="$1"
# Get the number of executions from the second argument
EXECS=10
SEED=58

echo "----------------------------------------SMALL----------------------------------------"
DATA_SET="small"
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 2 threads
# -----------------------------------------------------------------------------------------------
THREADS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PRORGAM_PATH -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')
 
    echo "$runtime" >> ./test_files/____tempfile.data.polybench

    total_time=$(echo "$total_time + $runtime" | bc)
done

# echo "total_time: $total_time" 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"
rm -f ./test_files/____tempfile.data.polybench;
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 4 threads
# -----------------------------------------------------------------------------------------------
THREADS=4
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PRORGAM_PATH -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    echo "$runtime" >> ./test_files/____tempfile.data.polybench

    total_time=$(echo "$total_time + $runtime" | bc)
done

# echo "total_time: $total_time"
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"
rm -f ./test_files/____tempfile.data.polybench;
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 8 threads
# -----------------------------------------------------------------------------------------------
THREADS=8
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PRORGAM_PATH -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    echo "$runtime" >> ./test_files/____tempfile.data.polybench

    total_time=$(echo "$total_time + $runtime" | bc)
done

# echo "total_time: $total_time"
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"

rm -f ./test_files/____tempfile.data.polybench;
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 16 threads
# -----------------------------------------------------------------------------------------------
THREADS=16
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PRORGAM_PATH -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    echo "$runtime" >> ./test_files/____tempfile.data.polybench

    total_time=$(echo "$total_time + $runtime" | bc)
done

# echo "total_time: $total_time"
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"

rm -f ./test_files/____tempfile.data.polybench;



echo "----------------------------------------MEDIUM----------------------------------------"
DATA_SET="medium"
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 2 threads
# -----------------------------------------------------------------------------------------------
THREADS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PRORGAM_PATH -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')
 
    echo "$runtime" >> ./test_files/____tempfile.data.polybench

    total_time=$(echo "$total_time + $runtime" | bc)
done

# echo "total_time: $total_time" 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"
rm -f ./test_files/____tempfile.data.polybench;
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 4 threads
# -----------------------------------------------------------------------------------------------
THREADS=4
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PRORGAM_PATH -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    echo "$runtime" >> ./test_files/____tempfile.data.polybench

    total_time=$(echo "$total_time + $runtime" | bc)
done

# echo "total_time: $total_time"
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"
rm -f ./test_files/____tempfile.data.polybench;
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 8 threads
# -----------------------------------------------------------------------------------------------
THREADS=8
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PRORGAM_PATH -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    echo "$runtime" >> ./test_files/____tempfile.data.polybench

    total_time=$(echo "$total_time + $runtime" | bc)
done

# echo "total_time: $total_time"
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"

rm -f ./test_files/____tempfile.data.polybench;
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 16 threads
# -----------------------------------------------------------------------------------------------
THREADS=16
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PRORGAM_PATH -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    echo "$runtime" >> ./test_files/____tempfile.data.polybench

    total_time=$(echo "$total_time + $runtime" | bc)
done

# echo "total_time: $total_time"
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"

rm -f ./test_files/____tempfile.data.polybench;





echo "----------------------------------------LARGE----------------------------------------"
DATA_SET="large"
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 2 threads
# -----------------------------------------------------------------------------------------------
THREADS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PRORGAM_PATH -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')
 
    echo "$runtime" >> ./test_files/____tempfile.data.polybench

    total_time=$(echo "$total_time + $runtime" | bc)
done

# echo "total_time: $total_time" 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"
rm -f ./test_files/____tempfile.data.polybench;
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 4 threads
# -----------------------------------------------------------------------------------------------
THREADS=4
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PRORGAM_PATH -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    echo "$runtime" >> ./test_files/____tempfile.data.polybench

    total_time=$(echo "$total_time + $runtime" | bc)
done

# echo "total_time: $total_time"
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"
rm -f ./test_files/____tempfile.data.polybench;
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 8 threads
# -----------------------------------------------------------------------------------------------
THREADS=8
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PRORGAM_PATH -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    echo "$runtime" >> ./test_files/____tempfile.data.polybench

    total_time=$(echo "$total_time + $runtime" | bc)
done

# echo "total_time: $total_time"
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"

rm -f ./test_files/____tempfile.data.polybench;
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 16 threads
# -----------------------------------------------------------------------------------------------
THREADS=16
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PRORGAM_PATH -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    echo "$runtime" >> ./test_files/____tempfile.data.polybench

    total_time=$(echo "$total_time + $runtime" | bc)
done

# echo "total_time: $total_time"
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"

rm -f ./test_files/____tempfile.data.polybench;