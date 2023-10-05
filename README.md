# madness_problem
Parallel MADNESS problem implementation, using doitgen kernel from Prolybench, a simplified version of the MADNESS problem for benchmarking purposes.


# --- Executing the program ---
This proggram has different ways to be executed, depending on the objective.
The parameters to be passed to the program are defined into the Makefile, so change them before running, or, they can be passed using the command line.

-> To execute sequential version:
```
    $ make build_sequential
    $ make run_sequential
```

-> To execute Threads version:
```
    $ make build_threads
    $ make run_threads
```

-> To execute MPI version:
```
    $ make build_mpi
    $ make run_mpi
```

-> To execute MPI + Threads version:
```
    $ make build_mpi_threads
    $ make run_mpi_threads
```