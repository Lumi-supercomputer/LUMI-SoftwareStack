# zlib

-   [zlib (classic) home page](http://www.zlib.net/)

-   [zlib-ng on GitHub](https://github.com/zlib-ng/zlib-ng)

    -   [GitHub downloads](https://github.com/zlib-ng/zlib-ng/releases)


## EasyBuild

-   [zlib in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/z/zlib)

-   [zlib-ng in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/z/zlib-ng)

-   [zlib in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/z/zlib)


### zlib 1.2.11 from CPE 21.06 on

-   The EasyConfig is the standard EasyConfig with additional documentation added
    from the University of Antwerpen.


### zlib 1.2.12 from CPE 22.06 on

-   The configure script is broken and the patch used in the EasyBuilders version is
    absolutely needed. Without it, the shared library is build incorrectly and lacks
    version information (the `A ZLIB_1.2.*` lines that show up in the output of
    `nm zlib.so`), causing several OS tools to complain, but also some of the tools
    of the CPE to complain. And the latter than causes misdetection of features in
    some configure scripts, leading to, e.g., the build of `cairo` to fail.


### zlib 1.2.13 from CPE 23.09 on

-   Port of 1.2.12, but the patch file is no longer needed as the problem has been corrected
    in the zlib distribution.


### zlib 1.3.1 from CPE 23.12 on

-   Swithced to a CMakeMake build process to work around issues with the Cray compiler 
    that only generated static libraries.
  
-   Now also copying license information to the installation directories.


### zlib(-ng) 2.3.3 from CPE 26.03 on

-   Switched to the zlib-ng codebase, but compile in both compatibility mode and the 
    new API as both have separate libraries and header files.

    Both are included in a single module, contrary to the approach taken in the regular
    EasyBuild repositories. We do define `EBROOTZLIBMINNG` and `EBVERSIONZLIBMINNG` for
    compatibility with the `zlib-ng` module in the regular EasyBuild distribution.

-   The EasyConfig is developed out of the regular zlib ones, and is a LUST development. 
    We decided to stick to CMake rather than the configure version used in the regular
    EasyBuilders EasyConfigs.
