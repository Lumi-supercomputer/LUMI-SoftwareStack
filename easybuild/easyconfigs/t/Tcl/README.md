# Tcl instructions

-   [Tcl web page](https://tcl.tk/)


## EasyBuild

-   [Tcl support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/t/Tcl)

-   [Tcl support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/t/Tcl)


### Version 8.6.11 from CPE 21.08 onwards

-   The EasyConfig file is a mix of the CSCS and EasyBuilder ones


### Version 8.6.12 from CPE 22.06 on

-   Trivial version bump of the 8.6.11 EasyConfig


### Version 8.6.13 from CPE 23.09 on

-   Trivial version bump of the 8.6.12 EasyConfig

-   From LUMI/23.12 onwards, license information was added to the installation.

  
### Version 8.6.16 for LUMI/25.03

-   Trivial version bump of the 8.6.13 EasyConfig.


### Version 9.0.3 for LUMI/25.09

-   Started from the EasyConfig for 8.6.16 for 25.03.

-   Switched to a download site that supports https and has one level of redirect 
    less before offering the source file.

-   Switched to the new EasyConfig parameters in 25.09.

-   Note that in the EasyBuilders repository, Tcl has libtommath as a dependency. As it is
    built internally we did not see the need to add this library which we use nowhere
    else.

-   For LUMI/26.03, we tried Tcl 9.0.4, but that didn't build: At some point `tclsh` failed 
    to find a shared library that was still in the same directory. As there may be more 
    issues, we did not want to work around it by playing with `LD_LIBRARY_PATH` during
    the build.
