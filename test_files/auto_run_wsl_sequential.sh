#!/bin/bash

# Initialize a variable to store the total runtime
total_time=0

if [ $# -ne 4 ]; then
    echo "Usage: ./auto_run.sh <binary_name> <executions> <data_set (-d[test/small/medium/large])> <threads (-t[value])> <seed (-s[seed])>";
    echo "Example: ./auto_run.sh \"./a.out\" 10";
    echo "Note: the file must be a Polybench program compiled with -DPOLYBENCH_TIME";
    exit 1;
fi;

# Get the program path from the first argument
PRORGAM_PATH="$1"
# Get the number of executions from the second argument
EXECS="$2"
DATA_SET="$3"
SEED="$4"
echo $DATA_SET $THREADS $SEED
# Run the program 10 times
for ((i=1; i<=$EXECS; i++)); do
    echo "Running iteration $i..."
    
    #./$PRORGAM_PATH "$@"
    
    # Capture the runtime from the program's console output
    runtime=$(./$PRORGAM_PATH -s $SEED -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')
    
    # Append the runtime to a temporary file
    echo "$runtime" >> ./test_files/____tempfile.data.polybench
    
    
    # Add the runtime to the total_time
    total_time=$(echo "$total_time + $runtime" | bc)
done

echo "total_time: $total_time"
# Calculate the mean runtime
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

# Print the mean runtime
echo "Average time for $EXECS executions: $mean_runtime seconds"

# Delete the temporary file
rm -f ./test_files/____tempfile.data.polybench;
