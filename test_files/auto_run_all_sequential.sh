#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: ./auto_run.sh <binary_name>";
    echo "Example: ./auto_run.sh \"./a.out\"";
    echo "Note: the file must be a Polybench program compiled with -DPOLYBENCH_TIME";
    exit 1;
fi;

# Get the program path from the first argument
PRORGAM_PATH="$1"
# Get the number of executions from the second argument
EXECS=10
SEED=58

# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET
# -----------------------------------------------------------------------------------------------
DATA_SET="small"
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PRORGAM_PATH -s $SEED -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')
 
    echo "$runtime" >> ./test_files/____tempfile.data.polybench

    total_time=$(echo "$total_time + $runtime" | bc)
done

# echo "total_time: $total_time" 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "SEQUENTIAL results with $DATA_SET data_set:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"
rm -f ./test_files/____tempfile.data.polybench;
# -----------------------------------------------------------------------------------------------
# RUNNING MEDIUM DATASET
# -----------------------------------------------------------------------------------------------
DATA_SET="medium"
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PRORGAM_PATH -s $SEED -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    echo "$runtime" >> ./test_files/____tempfile.data.polybench

    total_time=$(echo "$total_time + $runtime" | bc)
done

# echo "total_time: $total_time"
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "SEQUENTIAL results with $DATA_SET data_set:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"
rm -f ./test_files/____tempfile.data.polybench;
# -----------------------------------------------------------------------------------------------
# RUNNING LARGE DATASET
# -----------------------------------------------------------------------------------------------
DATA_SET="large"
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PRORGAM_PATH -s $SEED -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    echo "$runtime" >> ./test_files/____tempfile.data.polybench

    total_time=$(echo "$total_time + $runtime" | bc)
done

# echo "total_time: $total_time"
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "SEQUENTIAL results with $DATA_SET data_set:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"

rm -f ./test_files/____tempfile.data.polybench;