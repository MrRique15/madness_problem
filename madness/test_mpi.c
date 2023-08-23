#include <stdio.h>
#include <mpi.h>

int main(int argc, char** argv) {
    int process_Rank, size_Of_Cluster, message_Item;
    int i;
    int start, end, arr_size = 12;
    int shared_memory[12];

    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size_Of_Cluster);
    MPI_Comm_rank(MPI_COMM_WORLD, &process_Rank);

    if(process_Rank == 0){
        int shared_memory_master[12] = {1,1,1,1,1,1,1,1,1,1,1,1};

        for(i=0; i<12; i++){
            shared_memory[i] = shared_memory_master[i];
        }

        int total_sum = 0;
        int sum_parcial = 0;

        start = process_Rank * (arr_size/4);
        end = (process_Rank+1) * (arr_size/4);

        for(i=start; i < end; i++){
            total_sum += shared_memory[i];
        }
        MPI_Send(&shared_memory, 12, MPI_INT, 1, 1, MPI_COMM_WORLD);
        MPI_Send(&shared_memory, 12, MPI_INT, 2, 1, MPI_COMM_WORLD);
        MPI_Send(&shared_memory, 12, MPI_INT, 3, 1, MPI_COMM_WORLD);

        MPI_Recv(&sum_parcial, arr_size, MPI_INT, 1, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        total_sum += sum_parcial;
        MPI_Recv(&sum_parcial, arr_size, MPI_INT, 2, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        total_sum += sum_parcial;
        MPI_Recv(&sum_parcial, arr_size, MPI_INT, 3, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        total_sum += sum_parcial;

        printf("Total Sum = %d\n", total_sum);
    }

    else if(process_Rank != 0){
        int shared_memory_worker[12];
        int local_sum = 0;
        MPI_Recv(&shared_memory, 12, MPI_INT, 0, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

        start = process_Rank * (arr_size/4);
        end = (process_Rank+1) * (arr_size/4);

        printf("%d start with %d end in procces %d\n", start, end, process_Rank);
        for(i=start; i<end; i++){
            local_sum += shared_memory[i];
        }

        MPI_Send(&local_sum, 1, MPI_INT, 0, 1, MPI_COMM_WORLD);
    }

    MPI_Finalize();
    return 0;
}
