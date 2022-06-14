# libarchive

  * [libarchive on GitHub](https://github.com/libarchive/libarchive)

      * [GitHub release](https://github.com/libarchive/libarchive/releases)

## EasyBuild

  * [libdeflate support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libarchive)

  * There is no support in the CSCS repository

### 3.5.1

  * The EasyConfig file is derived from the one used at the University of
    Antwerpen which supports more compression tools than the one from the
    EasyBuilders repository.

### 3.6.1 for CPE 22.05

  * Trivial port of the EasyConfig of 3.5.1

  * Added libxml2 as dependency as it turns out that it is looking for that
    libraries in the configure step.
