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

-   For LUMI/23.12: Also add license information to the installation directories.

