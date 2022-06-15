# zlib

  * [zlib home page](http://www.zlib.net/)

## EasyBuild

  * [zlib in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/z/zlib)

  * [zlib in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/z/zlib)

### zlib 1.2.11 from CPE 21.06 on

  * The EasyConfig is the standard EasyConfig with additional documentation added
    from the University of Antwerpen.

### zlib 1.2.12 from CPE 22.05 on

  * We needed to switch to a CMake-based build process as there seems to be no way
    to include version info (a set of symbols shown as `A ZLIB_1.2*`) when using the 
    configure-based build process. Not including these symbols causes warnings when
    running various OS and Cray PE tools, and can cause the configure scripts of 
    other tools to wrongly fail some tests.

  * Tried to mimic a `ConfigureMake` installation as much as possible with our
    `CMakeMake` EasyConfig.

