#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: ./auto_run_mpi_threads.sh <binary_name>";
    echo "Example: ./auto_run_mpi_threads.sh \"./a.out\"";
    echo "Note: the file must be a Polybench program compiled with -DPOLYBENCH_TIME";
    exit 1;
fi;

# Get the program path from the first argument
PROGRAM_PATH_MPI="$1"
# Get the number of executions from the second argument
EXECS=10
SEED=58

echo "----------------------------------------SMALL [2 THREADS FIXO]----------------------------------------"
DATA_SET="small"
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 2 threads & 1 worker = total 2
# -----------------------------------------------------------------------------------------------
THREADS=2
WORKERS=1
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS SMALL [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 2 threads & 2 workers = total 4
# -----------------------------------------------------------------------------------------------
THREADS=2
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS SMALL [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 2 threads & 4 workers = total 8
# -----------------------------------------------------------------------------------------------
THREADS=2
WORKERS=4
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS SMALL [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 2 threads & 8 workers = total 16
# -----------------------------------------------------------------------------------------------
THREADS=2
WORKERS=8
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS SMALL [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt

# ###############################################################################################################
# ###############################################################################################################

echo "----------------------------------------MEDIUM [2 THREADS FIXO]----------------------------------------"
DATA_SET="medium"
# -----------------------------------------------------------------------------------------------
# RUNNING MEDIUM DATASET 2 threads & 1 worker = total 2
# -----------------------------------------------------------------------------------------------
THREADS=2
WORKERS=1
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS MEDIUM [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING MEDIUM DATASET 2 threads & 2 workers = total 4
# -----------------------------------------------------------------------------------------------
THREADS=2
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS MEDIUM [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING MEDIUM DATASET 2 threads & 4 workers = total 8
# -----------------------------------------------------------------------------------------------
THREADS=2
WORKERS=4
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS MEDIUM [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING MEDIUM DATASET 2 threads & 8 workers = total 16
# -----------------------------------------------------------------------------------------------
THREADS=2
WORKERS=8
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS MEDIUM [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt

# ###############################################################################################################
# ###############################################################################################################

echo "----------------------------------------LARGE [2 THREADS FIXO]----------------------------------------"
DATA_SET="large"
# -----------------------------------------------------------------------------------------------
# RUNNING LARGE DATASET 2 threads & 1 worker = total 2
# -----------------------------------------------------------------------------------------------
THREADS=2
WORKERS=1
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS LARGE [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING LARGE DATASET 2 threads & 2 workers = total 4
# -----------------------------------------------------------------------------------------------
THREADS=2
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS LARGE [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING LARGE DATASET 2 threads & 4 workers = total 8
# -----------------------------------------------------------------------------------------------
THREADS=2
WORKERS=4
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS LARGE [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING LARGE DATASET 2 threads & 8 workers = total 16
# -----------------------------------------------------------------------------------------------
THREADS=2
WORKERS=8
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS LARGE [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt

# ###############################################################################################################
# ###############################################################################################################
# ###############################################################################################################
# ###############################################################################################################
# ###############################################################################################################
# ###############################################################################################################
# ###############################################################################################################
# ###############################################################################################################

echo "----------------------------------------SMALL [2 WORKERS FIXO]----------------------------------------"
DATA_SET="small"
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 1 threads & 2 workers = total 2
# -----------------------------------------------------------------------------------------------
THREADS=1
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS SMALL [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 2 threads & 2 workers = total 4
# -----------------------------------------------------------------------------------------------
THREADS=2
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS SMALL [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 4 threads & 2 workers = total 8
# -----------------------------------------------------------------------------------------------
THREADS=4
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS SMALL [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 8 threads & 2 workers = total 16
# -----------------------------------------------------------------------------------------------
THREADS=8
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS SMALL [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt

# ###############################################################################################################
# ###############################################################################################################

echo "----------------------------------------MEDIUM [2 WORKERS FIXO]----------------------------------------"
DATA_SET="medium"
# -----------------------------------------------------------------------------------------------
# RUNNING MEDIUM DATASET 1 threads & 2 worker = total 2
# -----------------------------------------------------------------------------------------------
THREADS=1
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS MEDIUM [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING MEDIUM DATASET 2 threads & 2 workers = total 4
# -----------------------------------------------------------------------------------------------
THREADS=2
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS MEDIUM [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING MEDIUM DATASET 4 threads & 2 workers = total 8
# -----------------------------------------------------------------------------------------------
THREADS=4
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS MEDIUM [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING MEDIUM DATASET 8 threads & 2 workers = total 16
# -----------------------------------------------------------------------------------------------
THREADS=8
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS MEDIUM [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt

# ###############################################################################################################
# ###############################################################################################################

echo "----------------------------------------LARGE [2 WORKERS FIXO]----------------------------------------"
DATA_SET="large"
# -----------------------------------------------------------------------------------------------
# RUNNING LARGE DATASET 1 threads & 2 worker = total 2
# -----------------------------------------------------------------------------------------------
THREADS=1
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS LARGE [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING LARGE DATASET 2 threads & 2 workers = total 4
# -----------------------------------------------------------------------------------------------
THREADS=2
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS LARGE [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING LARGE DATASET 4 threads & 2 workers = total 8
# -----------------------------------------------------------------------------------------------
THREADS=4
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS LARGE [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING LARGE DATASET 2 threads & 8 workers = total 16
# -----------------------------------------------------------------------------------------------
THREADS=8
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED -t $THREADS| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI_THREADS results with $DATA_SET data_set and ($WORKERS workers + $THREADS threads):"
echo "Average time for $EXECS executions: $mean_runtime seconds"
# echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI_THREADS LARGE [$WORKERS WORKERS + $THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt