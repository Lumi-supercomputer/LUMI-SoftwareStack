# User information for AMD-flang-experimental

!!! warning "Pre-release software and unsupported"
    This is pre-release software set up with help from AMD but not software that
    we can fully support. The software may rely on ROCm(tm) version that are not 
    compatible with the current drivers on LUMI and hence may cause errors when
    running software compiled with these compilers. 

    They do offer a way of starting to test compilation of software with the
    new generation Flang compiler so that code is ready when an equivalent version
    of the compiler is officially released.

    AMD is interested in hearing about all issues that we run into, but some may
    not be due to bugs in the software but to lack of support by the current
    driver on LUMI. We did note that not all of AMD's own training examples work
    properly and are discussing with them.


## What is it?

These modules offer [pre-release versions of the new generation AMD Flang compiler](https://repo.radeon.com/rocm/misc/flang/).
The module itself only makes other modules available that should then be used to run 
the compiler. The Cray wrappers are not used.

Depending on the version of this module, the following modules may be provided:

-   `therock`: This is the actual compiler module and needs to be loaded for any of the
    other modules to work.

-   `mpich`: A module that wraps around Cray MPICH but provides a Fortran interface that
    is suitable for the compilers.

-   `fftw`: A CPU-based FFTW library. Also needs `mpich` as it also provides MPI-based
    libraries.

-   `hdf5-parallel`: HDF5 library in parallel configuration. Needs `therock` and `mpich`.

-   `pnetcdf`: PnetCDF library, uses `therock`, `mpich` and `hdf5-parallel`

-   `netcdf_c`: NetCDF libraries with the C interface. Builds upon `hdf5-parallel` and 
    according to the install script also on top of `pnetcdf`

-   `netcdf_fortran` Fortran interfaces for NetCDF, needs `netcdf_c`,

Each module will take care of loading the necessary dependencies so that you cannot make 
mistakes with that.

Compiler names:

-   `amdclang` for C

-   `amdclang++` for C++

-   `amdflang` for Fortran

These compilers don't work with the Cray wrappers. To compile MPI programs, you can use
`mpicc`, etc.


## How can I use these modules?

-   `AMD-flang-experimental/24.3.0-MPI` is pre-installed in CrayEnv only, so
  
    ``` bash
    module load CrayEnv
    module load AMD-flang-experimental/24.3.0-MPI
    ```

    This version is based on ROCm(tm) 10.1.0 and LLVM 24, which was not officially released
    on LLVM.org. MPI is compiled from regular MPICH 4.3.1 sources, after which libmpi was
    replaced with a version from Cray MPICH 9.1.0, installed in the module as it was only
    available in a container at the time of development of this module.

    It currently only provides the `therock` compiler module and `mpich` MPI module.


-   `AMD-flang-experimental/23.2.1-cray-mpich-8.1.33` is pre-installed in CrayEnv only, so
  
    ``` bash
    module load CrayEnv
    module load AMD-flang-experimental/23.2.1-cray-mpich-8.1.33
    ```

    This version is based on an unreleased ROCm(tm) 7.13 version. There is a Frankenstein
    MPI module that combines parts from Cray MPICH from 25.09 with regular MPICH code.

The `AMD-flang-experimental` modules don't make the compiler available, but only the modules
to activate the compiler and other components described above, so you then need to proceed 
with loading the compiler etc.
