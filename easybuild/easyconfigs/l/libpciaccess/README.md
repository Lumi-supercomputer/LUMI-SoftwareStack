# libpciaccess

-   [libpciaccess home page](https://cgit.freedesktop.org/xorg/lib/libpciaccess/)

-   [libpciaccess main development gitlab](https://gitlab.freedesktop.org/xorg/lib/libpciaccess)


## EasyBuild

-   [libpciaccess support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libpciaccess)

-   There is no support for libpciaccess in the CSCS repository


### Version 0.16 from CPE 21.06 on

-   The EasyConfig is derived from the EasyBuilders one with some refinements
    to the sanity checks.

    
### Version 0.17 from CPE 22.12 on

-   The EasyConfig is a trivial version bump of the 0.16 one.

-   For LUMI/23.12, license information was added to the installation.


### Version 0.18.1 for 25.03

-   Major reworking of the EasyConfig as the library now needs Meson and Ninja
    unfortunately.

-   Switched to the new EasyConfig parameters in 25.09.


### Version 0.19 for 26.03

-   Trivial port of the EasyConfig for 0.18.1 in 25.09.

-   It turned out that the program picks up a zlib from the system which was not
    in the dependencies, so that has been corrected.
