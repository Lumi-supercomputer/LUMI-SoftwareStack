# LAME

  * [LAME home page on SourceForge](https://lame.sourceforge.io/)

      * [Downloads on SourceForge](https://sourceforge.net/projects/lame/files/)


## EasyBuild

  * [LAME in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/LAME)

  * There is no support for LAME in the CSCS repository

### version 3.100 from CPE 21.06 on

  * The EasyConfig is based on the EasyBuilders one with documentation from the
    University of Antwerpen.

  * For LUMI/23.12, license information was added to the EasyConfig.
  
    The EasyConfig for the Cray compiler also needed a fix: Adding 
    `-Wl,--undefined-version` to `LDFLAGS`, as otherwise linking failed with undefined
    version symbols which is really a bug in LAME, not in the Cray compiler, which
    follows what recent versions of Clang od, i.e., run the linker with `--no-undefined-symbols`
    as a default.
