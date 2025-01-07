# lumi-CPEtools instructions

lumi-CPEtools is developed by the LUST team.

-   [lumi-CPEtools on GitHub](https://github.com/Lumi-supercomputer/lumi-CPEtools)


## EasyBuild

The EasyConfig is our own development as this is also our own tool. We provide full
versions for each Cray PE, and a restricted version using the S?YSTEM toolchain
for the CrayEnv software stack.


### Version 1.0

-   The EasyConfig is our own design.
    
    
### Version 1.1

-   The EasyConfig build upon the 1.0 one but with some important changes as there
    is now a tool that should only be installed in partition/G. So there are now
    makefile targets and additional variables for the Makefile.

-   For the recompile of 23.09 with ROCm 6 we needed to make the same changes
    as for 23.12, described below.

-   The cpeAMD version required changes to compile in 23.12:

    -   The `rocm` module now needs to be loaded explicitly to have acces to the
        HIP runtime libraries and header files.
        
    -   Needed to unload the accellerator module as we do use OpenMP but do not want
        to use OpenMP offload.
        
    -   There is a problem when linking with the AMD compilers of code that uses ROCm
        libraries when `LIBRARY_PATH` is set.

-   It looks like the compiler wrappers have changed in 24.03 as unloading the accelerator
    target module in the cpeAMD version was no longer needed.

    
### Version 1.2

-   Transformed the EasyConfig from version 1.1 to a Bundle to be able to add `hpcat` 
    using its own installation procedure.
    
-   Building `hpcat`: 

    -   LUMI lacks the `hwloc-devel` package so we simply copied the header files from another system
        and download them from LUMI-O.

    -   The Makefile was modified to integrate better with EasyBuild and to work around a problem with
        finding the `hwloc` library on LUMI. 

        Rather than writing a new Makefile or a patch, we actually used a number of `sed` commands to edit
        the Makefile:

        -   `mpicc` was replaced with `$(CC)` so that the wrappers are used instead.
        -   `-O3` was replaced with `$(CFLAGS)` to pick up the options from EasyBuild
        -   '-fopenmp' is managed by the Makefile though and not by EasyBuild. On one hand because the
            ultimate goal is to integrate with another packages that sometimes needs and sometimes does not
            need the OpenMP flags, on the other hand to use `$(CFLAGS)` also for `hipcc`.
        -   `-lhwloc` is replaced with `-Wl,/usr/lib64/libhwloc.so.15`. We had to do this through `-Wl` as
            the `hipcc` driver thought this was a source file.
        -   As '-L.' is not needed, it is omitted.

    -   As there is no `make install`, we simply use the `MakeCp` EasyBlock, doing the edits to the Makefile in
        `prebuiltopts`.
        
        Not that we copy the `libhip.so` file to the `lib` directory as that is the conventional 
        place to store shared objects, but it is not found there by `hpcat`, so we also create a
        symbolic link to it in the `bin` subidrecitory.

    -   Note that the accelerator target module should not be loaded when using the wrappers as the OpenMP offload
        options cause a problem in one of the header files used.

