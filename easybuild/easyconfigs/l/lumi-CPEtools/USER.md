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
    
-   `hpcat` (from version 1.2 on): Another HPC Affinity Tracker program. This program 
    is [developed by HPE](https://github.com/HewlettPackard/hpcat) and shows for 
    each MPI rank the core(s) that will be used (and per thread if `OMP_NUM_THREADS`
    is set), which GPU(s) are accessible to the task and which network adapter will be
    used, indicating the NUMA domain for each so that one can easily check if the resource
    mapping is ideal.

The various `*_check` programs are designed to test CPU and GPU binding in Slurm and 
are the LUST recommended way to experiment with those bindings.


## Some interactive examples

The examples assume the appropriate software stack modules and `lumi-CPEtools` module
are loaded. The examples show one version of modules, but can work with others too.
You'll also need to add the appropriate `-A` flag to the `salloc` commands.


### `gpu_check`

```
salloc -N2 -pstandard-g -G 16 -t 10:00
module load LUMI/24.03 partition/G lumi-CPEtools/1.2-cpeGNU-24.03
srun -n16 -c7 bash -c 'ROCR_VISIBLE_DEVICES=$SLURM_LOCALID gpu_check -l'
srun -n16 -c7 \
    --cpu-bind=mask_cpu:0xfe000000000000,0xfe00000000000000,0xfe0000,0xfe000000,0xfe,0xfe00,0xfe00000000,0xfe0000000000 \
    bash -c 'ROCR_VISIBLE_DEVICES=$SLURM_LOCALID gpu_check -l'
```

Note that in the first `srun` command, the mapping of GPU binding is not optimal while 
in the second `srunz` command it is.


### `hpcat` on a GPU node

```
salloc -N2 -pstandard-g -G 16 -t 10:00
module load LUMI/24.03 partition/G lumi-CPEtools/1.2-cpeGNU-24.03
srun -n16 -c7 bash -c 'ROCR_VISIBLE_DEVICES=$SLURM_LOCALID OMP_NUM_THREADS=7 hpcat'
srun -n16 -c7 \
    --cpu-bind=mask_cpu:0xfe000000000000,0xfe00000000000000,0xfe0000,0xfe000000,0xfe,0xfe00,0xfe00000000,0xfe0000000000 \
    bash -c 'ROCR_VISIBLE_DEVICES=$SLURM_LOCALID OMP_NUM_THREADS=7 hpcat'
srun -n16 -c7 \
    --cpu-bind=mask_cpu:0xfe000000000000,0xfe00000000000000,0xfe0000,0xfe000000,0xfe,0xfe00,0xfe00000000,0xfe0000000000 \
    bash -c 'ROCR_VISIBLE_DEVICES=$SLURM_LOCALID OMP_NUM_THREADS=7 OMP_PLACES=cores hpcat'
```

Note that in the first `srun` command, the mapping of resources is not very good. GPUs 
don't map to their closest chiplet, and the network adapters are also linked based 
on the CPU NUMA domain. In the second case, the mapping is optimal, but except for the
Cray compilers, the OpenMP threads can still move in the chiplet. In the last case, these 
are also fixed with all compilers.


### `serial_check`, `omp_check`, `mpi_cehck` and `hybrid_check`

```
salloc -N1 -pstandard -t 10:00
module load LUMI/24.03 partition/C lumi-CPEtools/1.2-cpeGNU-24.03
srun -n1 -c1 serial_check
srun -n1 -c4 omp_check
srun -n4 -c1 mpi_check
srun -n4 -c4 hybrid_check
```

One big difference between these tools and `hpcat` is that this tool shows on which 
core a thread is running at the moment that this is measured, while `hpcat` actually 
shows the affinity mask, i.e., all cores that can be used by that thread. `gpu_check`
has the same limitation as `omp_check` etc.


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

The `hpcat` program (lumi-CPEtools 1.2 and later) is
[developed by HPE](https://github.com/HewlettPackard/hpcat) and provided
unmodified.
