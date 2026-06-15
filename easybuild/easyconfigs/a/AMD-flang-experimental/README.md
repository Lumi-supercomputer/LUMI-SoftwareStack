# Technical documentation for AMD-flang-experimental

This module provides access to a pre-release of the new-generation AMD flang compiler. 
These may be built on top of ROCm versions that are also not fully supported.

The module basically makes other modules available, including the compiler module which
is confusingly called `therock`. It also contains an MPI module that is layered on top
of Cray MPICH but provides Fortran interfaces compatible with the new compiler, and 
some other libraries with Fortran interfaces.

This compiler is mostly targeted at GPU development which is why some popular libraries
for CPU work (such as an optimised BLAS library) are currently not included.

The EasyBuild EasyConfig is only a wrapper downloading the necessary files and then 
calling install scripts developed by AMD and HLRS engineers for Hunter, and adapted
by AMD to LUMI. Some further adaptations have been made in the 
[GitHub repository AMD-flang-exsperimental](https://github.com/klust/AMD-flang-experimental)
for LUMI and integration with EasyBuild.

-   [Repository with pre-releases on the new flang compiler](https://repo.radeon.com/rocm/misc/flang/)


## EasyBuild

### 23.2.1

-   This pre-release version was recommended by AMD for first experiments and also comes with
    some experimental ROCm libraries.

-   Note that the `lapack` option of the install script does not install optimised libraries but
    just the vanilla NetLib BLAS and Lapack. So it is not used on LUMI.

    The `rocmlibs` option installs some custom ROCm libraries that were needed for a specific
    project at HLRS and should also not be installed at LUMI (and require specific sources that
    cannot be directly downloaded).

-   Apart from this, the EasyConfig uses a `Binary` EasyBlock.
  
    -   First all sources are downloaded
  
    -   The install step then install the install scripts in the required directory, the source
        files also where expected by the install script, and then runs the install script.

        That install script actually does depend on Cray MPICH 8.1.33 at the moment.
