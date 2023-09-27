# -----------------------------------------------------------------------------------------------
# RUNNING LARGE DATASET 2 threads & 1 worker = total 2
# -----------------------------------------------------------------------------------------------
PROGRAM_PATH_MPI='builds/doitgen_build_mpi'
DATA_SET='medium'
SEED=58

echo "--------------------2 WORKERS--------------------"
WORKERS=2
sudo perf stat -o perfLog2.txt mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED >> ./test_files/perf_log.txt
echo "-------------------------------------------------"
echo "--------------------4 WORKERS--------------------"
WORKERS=4
sudo perf stat -o perfLog4.txt mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED
echo "-------------------------------------------------"
echo "--------------------8 WORKERS--------------------"
WORKERS=8
sudo perf stat -o perfLog8.txt mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED
echo "-------------------------------------------------"
echo "--------------------16 WORKERS--------------------"
WORKERS=16
sudo perf stat -o perfLog16.txt mpirun -np $WORKERS ./$PROGRAM_PATH_MPI -d $DATA_SET -s $SEED
echo "-------------------------------------------------"