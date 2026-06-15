# User information for AMD-flang-experimental

!!! warning "Pre-release software and unsupported"
    This is pre-release software set up with help from AMD but not software that
    we can support. The software may rely on ROCm(tm) version that are not 
    compatible with the current drivers on LUMI and hence may cause errors when
    running software compiled with these compilers. 

    They do offer a way of starting to test compilation of software with the
    new generation Flang compiler so that code is ready when an equivalent version
    of the compiler is officially released.

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
`mpicc` etc.


## How can I use these modules?

-   `AMD-flang-experimental/23.2.1` is pre-installed in CrayEnv only, so
  
    ``` bash
    module load CrayEnv
    module load AMD-flang-experimental/23.2.1
    ```

The `AMD-flang-experimental` modules don't make the compiler available, but only the modules
to activate the compiler and other components described above, so you then need to proceed 
with loading the compiler etc.
