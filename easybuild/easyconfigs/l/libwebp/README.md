# libwebp

-   [libwebp home page](https://developers.google.com/speed/webp/)

-   [libwebp on GitHub](https://github.com/webmproject/libwebp)

    -   [GitHub releases](https://github.com/webmproject/libwebp/tags)


## Easybuild

-   [libwebp support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libwebp)

-   There is no libwebp support in the CSCS repository


### General issues

-   There is a potential circular dependency with LibTIFF as both can use each others
    libraries, so a choice has to be made which tool will support which libraries.

    A possible solution is to compile both in a bundle where LibTIFF is compiled first,
    then libwebp and then LibTIFF is recompiled.


### 1.2.0 from CPE 21.06 on

-   The EasyConfig is based on the one from the University of Antwerpen but
    mostly follows the EasyBuilders one with some additional configuration
    options.


### 1.2.2 from CPE 22.06 on

-   Trivial version bump of the 1.2.0 EasyConfig.


### 1.2.4 from CPE 22.12 on

-   Trivial port of the EasyConfig of 1.2.2, but with some improvements to the
    sanity check borrowed from the EasyBuilders version. 
    

### 1.3.2 from 23.09 on

-   Trivial port of the EasyConfig of version 1.2.4 for 22.12.

-   For LUMI/23.12, license information was added to the installation.


### 1.5.0 for 25.03

-   Trivial port of the EasyConfig of version 1.3.2 for 24.03/24.11.


### 1.6.0 for 25.09

-   Trivial port of the EasyConfig of version 1.5.0 for 25.03.

