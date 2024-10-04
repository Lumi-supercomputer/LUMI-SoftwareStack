# GNU termcap

  * [termcap home page](https://www.gnu.org/software/termutils/)

      * [termcap downloads](https://ftp.gnu.org/gnu/termcap/)


## EasyBuild

This is a library that would normally be taken from the OS. However, on some or all
Cray systems it seems to be missing in the default setup so this is a workaround for
those packages that require libtermcap. Also, in most cases packages should be able
to find the required functionality in ncurses.

  * There is no support in the EasyBuilders repository

  * There is no support in the CSCS repository


### Version 1.3.1 from CPE 21.06 on

  * This is a new EasyConfig.

  * Note that this is a very primitive library. Its configure doesn't even pick up
    CFLAGS correctly so we feed it to make ourselves.

  * From Clang 16 on the C standard needs to be set explicitly to c90 to avoid
    error messages about features forbidden in C99 or newer.

  * For LUMI/23.12, license information was added to the installation.

  * To recompile with ROCm 6.0 in 23.09 an additional toolchainopt was needed
    to force the compiler to use the C90 standard.
