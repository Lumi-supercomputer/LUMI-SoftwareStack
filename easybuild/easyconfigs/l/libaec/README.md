# libaec - Adaptive Entropy Coding library

-   [libaec web site / gitlab](https://gitlab.dkrz.de/k202009/libaec)

-   [libaec on GitHub](https://github.com/Deutsches-Klimarechenzentrum/libaec)

    -   [GitHub downloads](https://github.com/Deutsches-Klimarechenzentrum/libaec/releases) (currently recommended)


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

-   Switched to the new EasyConfig parameters in 25.09.


### Version 1.1.7 for 26.03

-   Almost trivial port of the EasyConfig for 1.1.4 in 25.09.

-   The old download location does not work anymore. DKRZ recommended to switch to
    downloads from GitHub as the new download location on the old site is not reliable
    when using automated downloads.

-   Added the patch used in the EasyBuilders version for optimal compatibility of the
    installations (basically a binary that without the patch does not get installed).

-   Needed to correct the copying of some files to the licenses area as the directory name
    of the unpacked sources has changed and as one of the files is no longer there.

