# libtirpc instructions

  * [libtirpc on SourceForge](https://sourceforge.net/projects/libtirpc/)

  * [Development on linux-nfs.org](https://git.linux-nfs.org/?p=steved/libtirpc.git)


## EasyBuild

  * [libtirpc support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libtirpc)

  * There is no support for libtirpc in the CSCS repository


### Version 1.3.2 for CPE 21.08

  * The EasyConfig is a straightforward adaptation of the EasyBuilders one.

  
### Version 1.3.3 from CPE 22.12 on

  * The EasyConfig is a straightforward port of the 1.3.2. one.

  * For LUMI/23.12, license information was added to the installation and the
    sanity checks were improved.
    
    For clang-based compilers we used `--disable-symvers` as using that causes
    a failure with CCE when linking.

    
### Version 1.3.4 from LUMI/24.03 on

  * Trivial port of the EasyConfig for version 1.3.3 in LUMI/23.12.
    