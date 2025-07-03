# libaec - Adaptive Entropy Coding library

-   [libaec web site / gitlab](https://gitlab.dkrz.de/k202009/libaec)


## EasyBuild

-   There is no libaec support in the EasyBuilders repository.

-   [libaec in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/l/libaec)


### Version 1.0.6 for CPE 21.08 and later

-   The EasyConfig is derived from the CSCS EasyConfig with a version bump.

-   But switched to CMake as this is now the main configuration tool for
    libaec.

-   From LUMI/23.12 on, license information was added to the installation.

  
### Version 1.1.4 for 25.03

-   Almost trivial port of the EasyConfig for 1.0.6 for 24.03/24.11,
    
-   But the `aec` program does no longer exist. It is now called `graec` and needs
    to be compiled separately as it is only meant for internal testing. So it was 
    removed from the `sanity_check_commands`.
