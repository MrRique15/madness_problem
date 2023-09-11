#!/bin/bash

# program paths to be used
PROGRAM_PATH_SEQUENTIAL="builds/doitgen_build_sequential"
PROGRAM_PATH_PARALLEL="builds/doitgen_build_parallel"
PROGRAM_PATH_MPI="builds/doitgen_build_mpi"

SEED=58
# Get the number of executions from the second argument
EXECS=10

SEQUENTIAL_SMALL_MEAN=0
SEQUENTIAL_MEDIUM_MEAN=0
SEQUENTIAL_LARGE_MEAN=0
# -----------------------------------------------------------------------------------------------
# RUNNING SEQUENTIAL SMALL DATASET
# -----------------------------------------------------------------------------------------------
DATA_SET="small"
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PROGRAM_PATH_SEQUENTIAL -s $SEED -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "SEQUENTIAL results with $DATA_SET data_set:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"
echo "SEQUENTIAL SMALL - $mean_runtime" >> ./test_files/timers_results.txt
SEQUENTIAL_SMALL_MEAN=$mean_runtime
# -----------------------------------------------------------------------------------------------
# RUNNING SEQUENTIAL MEDIUM DATASET
# -----------------------------------------------------------------------------------------------
DATA_SET="medium"
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PROGRAM_PATH_SEQUENTIAL -s $SEED -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "SEQUENTIAL results with $DATA_SET data_set:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"
echo "SEQUENTIAL MEDIUM - $mean_runtime" >> ./test_files/timers_results.txt
SEQUENTIAL_MEDIUM_MEAN=$mean_runtime
# -----------------------------------------------------------------------------------------------
# RUNNING SEQUENTIAL LARGE DATASET
# -----------------------------------------------------------------------------------------------
DATA_SET="large"
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PROGRAM_PATH_SEQUENTIAL -s $SEED -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "SEQUENTIAL results with $DATA_SET data_set:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "----------------------------------------"
echo "SEQUENTIAL LARGE - $mean_runtime" >> ./test_files/timers_results.txt
SEQUENTIAL_LARGE_MEAN=$mean_runtime
# -----------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------------
# RUNNING PARALLEL SMALL DATASET
# -----------------------------------------------------------------------------------------------

echo "----------------------------------------PARALLEL----------------------------------------"
echo "----------------------------------------[SMALL]----------------------------------------"
DATA_SET="small"
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 2 threads
# -----------------------------------------------------------------------------------------------
THREADS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PROGRAM_PATH_PARALLEL -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')
 
    total_time=$(echo "$total_time + $runtime" | bc)
done
 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_SMALL_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "PARALLEL SMALL [$THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 4 threads
# -----------------------------------------------------------------------------------------------
THREADS=4
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PROGRAM_PATH_PARALLEL -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_SMALL_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "PARALLEL SMALL [$THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 8 threads
# -----------------------------------------------------------------------------------------------
THREADS=8
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PROGRAM_PATH_PARALLEL -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_SMALL_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "PARALLEL SMALL [$THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt

# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 16 threads
# -----------------------------------------------------------------------------------------------
THREADS=16
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PROGRAM_PATH_PARALLEL -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_SMALL_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "PARALLEL SMALL [$THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt




echo "----------------------------------------[MEDIUM]----------------------------------------"
DATA_SET="medium"
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 2 threads
# -----------------------------------------------------------------------------------------------
THREADS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PROGRAM_PATH_PARALLEL -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')
 
    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_MEDIUM_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "PARALLEL MEDIUM [$THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 4 threads
# -----------------------------------------------------------------------------------------------
THREADS=4
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PROGRAM_PATH_PARALLEL -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_MEDIUM_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "PARALLEL MEDIUM [$THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 8 threads
# -----------------------------------------------------------------------------------------------
THREADS=8
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PROGRAM_PATH_PARALLEL -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_MEDIUM_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "PARALLEL MEDIUM [$THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 16 threads
# -----------------------------------------------------------------------------------------------
THREADS=16
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PROGRAM_PATH_PARALLEL -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_MEDIUM_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "PARALLEL MEDIUM [$THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt




echo "----------------------------------------[LARGE]----------------------------------------"
DATA_SET="large"
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 2 threads
# -----------------------------------------------------------------------------------------------
THREADS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PROGRAM_PATH_PARALLEL -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')
 
    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "PARALLEL LARGE [$THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 4 threads
# -----------------------------------------------------------------------------------------------
THREADS=4
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PROGRAM_PATH_PARALLEL -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "PARALLEL LARGE [$THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 8 threads
# -----------------------------------------------------------------------------------------------
THREADS=8
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PROGRAM_PATH_PARALLEL -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "PARALLEL LARGE [$THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 16 threads
# -----------------------------------------------------------------------------------------------
THREADS=16
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(./$PROGRAM_PATH_PARALLEL -s $SEED -t $THREADS -d $DATA_SET| grep -oP '\K[0-9]+\.[0-9]+')

    total_time=$(echo "$total_time + $runtime" | bc)
done

mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "PARALLEL results with $DATA_SET data_set and $THREADS threads:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "PARALLEL LARGE [$THREADS THREADS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------------
# RUNNING MPI SMALL DATASET
# -----------------------------------------------------------------------------------------------

echo "----------------------------------------MPI----------------------------------------"
echo "----------------------------------------[SMALL]----------------------------------------"
DATA_SET="small"
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 2 workers
# -----------------------------------------------------------------------------------------------
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED| grep -oP '\K[0-9]+\.[0-9]+')
 
    total_time=$(echo "$total_time + $runtime" | bc)
done
 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI results with $DATA_SET data_set and $WORKERS workers:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_SMALL_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI SMALL [$WORKERS WORKERS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 4 workers
# -----------------------------------------------------------------------------------------------
WORKERS=4
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED| grep -oP '\K[0-9]+\.[0-9]+')
 
    total_time=$(echo "$total_time + $runtime" | bc)
done
 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI results with $DATA_SET data_set and $WORKERS workers:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_SMALL_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI SMALL [$WORKERS WORKERS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 8 workers
# -----------------------------------------------------------------------------------------------
WORKERS=8
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED| grep -oP '\K[0-9]+\.[0-9]+')
 
    total_time=$(echo "$total_time + $runtime" | bc)
done
 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI results with $DATA_SET data_set and $WORKERS workers:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_SMALL_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI SMALL [$WORKERS WORKERS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 16 workers
# -----------------------------------------------------------------------------------------------
WORKERS=16
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED| grep -oP '\K[0-9]+\.[0-9]+')
 
    total_time=$(echo "$total_time + $runtime" | bc)
done
 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI results with $DATA_SET data_set and $WORKERS workers:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_SMALL_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI SMALL [$WORKERS WORKERS] - $mean_runtime" >> ./test_files/timers_results.txt




echo "----------------------------------------[MEDIUM]----------------------------------------"
DATA_SET="medium"
# -----------------------------------------------------------------------------------------------
# RUNNING MEDIUM DATASET 2 workers
# -----------------------------------------------------------------------------------------------
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED| grep -oP '\K[0-9]+\.[0-9]+')
 
    total_time=$(echo "$total_time + $runtime" | bc)
done
 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI results with $DATA_SET data_set and $WORKERS workers:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_MEDIUM_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI MEDIUM [$WORKERS WORKERS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING MEDIUM DATASET 4 workers
# -----------------------------------------------------------------------------------------------
WORKERS=4
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED| grep -oP '\K[0-9]+\.[0-9]+')
 
    total_time=$(echo "$total_time + $runtime" | bc)
done
 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI results with $DATA_SET data_set and $WORKERS workers:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_MEDIUM_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI MEDIUM [$WORKERS WORKERS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING MEDIUM DATASET 8 workers
# -----------------------------------------------------------------------------------------------
WORKERS=8
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED| grep -oP '\K[0-9]+\.[0-9]+')
 
    total_time=$(echo "$total_time + $runtime" | bc)
done
 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI results with $DATA_SET data_set and $WORKERS workers:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_MEDIUM_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI MEDIUM [$WORKERS WORKERS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING MEDIUM DATASET 16 workers
# -----------------------------------------------------------------------------------------------
WORKERS=16
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED| grep -oP '\K[0-9]+\.[0-9]+')
 
    total_time=$(echo "$total_time + $runtime" | bc)
done
 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI results with $DATA_SET data_set and $WORKERS workers:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_MEDIUM_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI MEDIUM [$WORKERS WORKERS] - $mean_runtime" >> ./test_files/timers_results.txt




echo "----------------------------------------[LARGE]----------------------------------------"
DATA_SET="large"
# -----------------------------------------------------------------------------------------------
# RUNNING LERGE DATASET 2 workers
# -----------------------------------------------------------------------------------------------
WORKERS=2
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED| grep -oP '\K[0-9]+\.[0-9]+')
 
    total_time=$(echo "$total_time + $runtime" | bc)
done
 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI results with $DATA_SET data_set and $WORKERS workers:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI LARGE [$WORKERS WORKERS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING LARGE DATASET 4 workers
# -----------------------------------------------------------------------------------------------
WORKERS=4
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED| grep -oP '\K[0-9]+\.[0-9]+')
 
    total_time=$(echo "$total_time + $runtime" | bc)
done
 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI results with $DATA_SET data_set and $WORKERS workers:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI LARGE [$WORKERS WORKERS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING LARGE DATASET 8 workers
# -----------------------------------------------------------------------------------------------
WORKERS=8
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED| grep -oP '\K[0-9]+\.[0-9]+')
 
    total_time=$(echo "$total_time + $runtime" | bc)
done
 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI results with $DATA_SET data_set and $WORKERS workers:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI LARGE [$WORKERS WORKERS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# RUNNING LARGE DATASET 16 workers
# -----------------------------------------------------------------------------------------------
WORKERS=16
total_time=0
mean_runtime=0
for ((i=1; i<=$EXECS; i++)); do
    runtime=$(mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED| grep -oP '\K[0-9]+\.[0-9]+')
 
    total_time=$(echo "$total_time + $runtime" | bc)
done
 
mean_runtime=$(echo "scale=6; $total_time / $EXECS" | bc)

echo "----------------------------------------"
echo "MPI results with $DATA_SET data_set and $WORKERS workers:"
echo "Average time for $EXECS executions: $mean_runtime seconds"
echo "Speed UP = $(echo "scale=6; $SEQUENTIAL_LARGE_MEAN / $mean_runtime" | bc)"
echo "----------------------------------------"
echo "MPI LARGE [$WORKERS WORKERS] - $mean_runtime" >> ./test_files/timers_results.txt
# -----------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------------
# RUNNING MPI PARALLEL SMALL DATASET
# -----------------------------------------------------------------------------------------------

# echo "----------------------------------------MPI PARALLEL----------------------------------------"
# echo "----------------------------------------[SMALL]----------------------------------------"
# DATA_SET="small"
# -----------------------------------------------------------------------------------------------
# RUNNING SMALL DATASET 2 workers 2 THREADS
# -----------------------------------------------------------------------------------------------