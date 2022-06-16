# zlib

  * [zlib home page](http://www.zlib.net/)

## EasyBuild

  * [zlib in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/z/zlib)

  * [zlib in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/z/zlib)

### zlib 1.2.11 from CPE 21.06 on

  * The EasyConfig is the standard EasyConfig with additional documentation added
    from the University of Antwerpen.

### zlib 1.2.12 from CPE 22.05 on

  * The configure script is broken and the patch used in the EasyBuilders version is
    absolutely needed. Without it, the shared library is build incorrectly and lacks
    version information (the `A ZLIB_1.2.*` lines that show up in the output of
    `nm zlib.so`), causing several OS tools to complain, but also some of the tools
    of the CPE to complain. And the latter than causes misdetection of features in
    some configure scripts, leading to, e.g., the build of `cairo` to fail.

