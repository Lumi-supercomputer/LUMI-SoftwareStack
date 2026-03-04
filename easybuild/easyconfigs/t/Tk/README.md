# Tk instructions

-   [Tk web page](https://tcl.tk/)

## EasyBuild

-   [Tk support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/t/Tk)

-   [Tk support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/t/Tk)


### Version 8.6.11 from CPE 21.08 onwards

-   The EasyConfig file is a mix of the CSCS and EasyBuilder ones, but closer
    to the EasyBuilders one.

-   The patch has to do with a bug when compiling the Python package Tkinter
    and is discusssed in [easybuild-easyblock issue 728](https://github.com/easybuilders/easybuild-easyblocks/issues/728).


### Version 8.6.12 from CPE 22.06 onwards.

-   Trivial version bump of the 8.6.11 EasyConfig


### Version 8.6.13 from CPE 23.09 on

-   Trivial version bump of the 8.6.12 EasyConfig

-   For LUMI/23.12, license information was added to the installation.


### Version 8.6.16 from 25.03 on

-   Trivial port of the EasyConfig for 6.1.13 in 24.03/24.11.


### Version 9.0.3 from 25.09 on

-   Trivial port of the EasyConfig for 8.6.16 for 25.03.

-   Changed the download site to have one level of redirection less.

-   Needed to remove `--enable-threads` from `configopts`.

-   Updated `postinstallcmds` with commands found in the EasyBuilders EasyConfig.

-   Adapted the list of files to copy to the licenses directory.

-   Library names have also changed, requiring changes to the sanity checks.
