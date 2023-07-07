# lumi-CPEtools user documentation

## Getting help

The tools in `lumi-CPETtools` are documented through manual pages that can be viewed on LUMI
after loading the module. Start with `man lumi-CPEtools`.

Commands provided:

-   `xldd`: An ldd-like program to show which versions of Cray PE libraries are used by an executable.

-   `serial_check`: Serial program can print core and host allocation and affinity information.

-   `omp_check`: OpenMP program can print core and host allocation and affinity information.

-   `mpi_check`: MPI program can print core and host allocation and affinity information.  It is also suitable to test heterogeneous jobs.

-   `hybrid_check`: Hybrid MPI/OpenMP program can print core and host allocation and affinity information.  It is also suitable to test
    heterogeneous jobs.  It encompasses the full functionality of serial_check, omp_check and mpi_check.

-   `gpu_check` (from version 1.1 on): A  hybrid MPI/OpenMP program that prints information about thread and GPU binding/mapping on Cray EX Bardpeak nodes as in
    LUMI-G, based on the ORNL hello_jobstep program.  (AMD GPU nodes only)

The various `*_check` programs are designed to test CPU and GPU binding in Slurm and 
are the LUST recommended way to experiment with those bindings.


## Acknowledgements

The code for `hybrid_check` and its offsprings `serial_check`, `omp_check` and `mpi_check` is inspired
by the [`xthi` program used in the 4-day LUMI comprehensive courses](https://support.hpe.com/hpesc/public/docDisplay?docId=a00114008en_us&docLocale=en_US&page=Run_an_OpenMP_Application.html).
The `hybrid_check` program has been used succesfully on other clusters also, also non-Cray 
or non-HPE clusters.

The `gpu_check` program (lumi-CPEtools 1.1 and later) builds upon the
[`hello_jobstep` code from ORNL](https://code.ornl.gov/olcf/hello_jobstep/-/tree/master).
The program is specifically for the HPE Cray EX Bard Peak nodes and will not work correctly
without reworking on other AMD GPU systems or on NVIDIA GPU systems.

The `lumi-CPEtools` code is developed by LUST in the 
[lumi-CPEtools repository on the LUMI supercomputer GitHub](https://github.com/Lumi-supercomputer/lumi-CPEtools).
