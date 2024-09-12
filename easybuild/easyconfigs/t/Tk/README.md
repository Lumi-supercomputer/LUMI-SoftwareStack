# Tk instructions

  * [Tk web page](https://tcl.tk/)

## EasyBuild

  * [Tk support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/t/Tk)

  * [Tk support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/t/Tk)


### Version 8.6.11 from CPE 21.08 onwards

  * The EasyConfig file is a mix of the CSCS and EasyBuilder ones, but closer
    to the EasyBuilders one.

  * The patch has to do with a bug when compiling the Python package Tkinter
    and is discusssed in [easybuild-easyblock issue 728](https://github.com/easybuilders/easybuild-easyblocks/issues/728).


### Version 8.6.12 from CPE 22.06 onwards.

  * Trivial version bump of the 8.6.11 EasyConfig


### Version 8.6.13 from CPE 23.09 on

  * Trivial version bump of the 8.6.12 EasyConfig

  * For LUMI/23.12, license information was added to the installation.
