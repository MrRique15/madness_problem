#!/bin/bash

# Initialize a variable to store the total runtime
total_time=0

if [ $# -ne 2 ]; then
    echo "Usage: ./time_benchmarh.sh <binary_name> <executions>";
    echo "Example: ./time_benchmarh.sh \"./a.out\" 10";
    echo "Note: the file must be a Polybench program compiled with -DPOLYBENCH_TIME";
    exit 1;
fi;

# Get the program path from the first argument
PRORGAM_PATH="$1"
# Get the number of executions from the second argument
EXECS="$2"

# Run the program 10 times
for ((i=1; i<=$EXECS; i++)); do
    echo "Running iteration $i..."
    
    # Capture the runtime from the program's console output
    runtime=$(./$PRORGAM_PATH | grep -oP '\K[0-9]+\.[0-9]+')
    
    # Append the runtime to a temporary file
    echo "$runtime" >> ./test_files/____tempfile.data.polybench
    
    # Add the runtime to the total_time
    total_time=$(echo "$total_time + $runtime" | bc)
done

# Calculate the mean runtime
mean_runtime=$(echo "scale=6; $total_time / 10" | bc)

# Print the mean runtime
echo "Average time for $EXECS executions: $mean_runtime seconds"

# Delete the temporary file
rm -f ./test_files/____tempfile.data.polybench;