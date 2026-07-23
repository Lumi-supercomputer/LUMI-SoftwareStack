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


### Version 9.0.4 for LUMI/26.03

-   Porting the EasyConfig was a little problematic:

    -   We needed to implement the changes used in the EasyBuilders version for 9.0.3 to use an 
        internal zlib library as somehow the build process tried to use the header files from
        both the internal one and the external one, which did cause conflicts as these are 
        different versions.

    -   Moreover, halfway the build process, a second step tries to use the `tclsh` command built
        in the first step, but cannot find it. To get that to work, two steps were needed:

        -   Add `'TCLSH_NATIVE=$PWD/tclsh'` to the arguments of the `configure` command so that 
            it finds a working tclsh and

        -   Also set `'LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH'` in the `pre_build_opts` so that 
            that `tclsh` command also finds its shared library.
