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
