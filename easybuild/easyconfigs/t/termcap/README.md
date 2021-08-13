# GNU termcap

  * [termcap home page]()

      * [termcap downloads](https://ftp.gnu.org/gnu/termcap/)


## EasyBuild

This is a library that would normally be taken from the OS. However, on some or all
Cray systems it seems to be missing in the default setup so this is a workaround for
those packages that require libtermcap.

  * There is no support in the EasyBuilders repository

  * There is no support in the CSCS repository


### Version 1.3.1 from CPE 21.06 on

  * This is a new EasyConfig.

  * Note that this is a very primitive library. Its configure doesn't even pick up
    CFLAGS correctly so we feed it to make ourselves.
