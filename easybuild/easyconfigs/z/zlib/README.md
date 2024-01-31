# zlib

  * [zlib home page](http://www.zlib.net/)

## EasyBuild

  * [zlib in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/z/zlib)

  * [zlib in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/z/zlib)

### zlib 1.2.11 from CPE 21.06 on

  * The EasyConfig is the standard EasyConfig with additional documentation added
    from the University of Antwerpen.

### zlib 1.2.12 from CPE 22.06 on

  * The configure script is broken and the patch used in the EasyBuilders version is
    absolutely needed. Without it, the shared library is build incorrectly and lacks
    version information (the `A ZLIB_1.2.*` lines that show up in the output of
    `nm zlib.so`), causing several OS tools to complain, but also some of the tools
    of the CPE to complain. And the latter than causes misdetection of features in
    some configure scripts, leading to, e.g., the build of `cairo` to fail.


### zlib 1.2.13 from CPE 23.09 on

  * Port of 1.2.12, but the patch file is no longer needed as the problem has been corrected
    in the zlib distribution.

  
### zlib 1.3.1 from CPE 23.12 on

  * Swithced to a CMakeMake build process to work around issues with the Cray compiler 
    that only generated static libraries.
  
  * Now also copying license information to the installation directories.

