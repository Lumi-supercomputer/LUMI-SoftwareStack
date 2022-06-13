# libwebp

  * [libwebp home page](https://developers.google.com/speed/webp/)

  * [libwebp on GitHub](https://github.com/webmproject/libwebp)

      * [GitHub releases](https://github.com/webmproject/libwebp/releases)


## Easybuild

  * [libwebp support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libwebp)

  * There is no libwebp support in the CSCS repository


### General issues

  * There is a potential circular dependency with LibTIFF as both can use each others
    libraries, so a choice has to be made which tool will support which libraries.

    A possible solution is to compile both in a bundle where LibTIFF is compiled first,
    then libwebp and then LibTIFF is recompiled.


### 1.2.0 from CPE 21.06 on

  * The EasyConfig is based on the one from the University of Antwerpen but
    mostly follows the EasyBuilders one with some additional configuration
    options.
