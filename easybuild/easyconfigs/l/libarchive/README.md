# libarchive

-   [libarchive on GitHub](https://github.com/libarchive/libarchive)

    -   [GitHub release](https://github.com/libarchive/libarchive/releases)

## EasyBuild

-   [libarchive support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libarchive)

-   There is no support in the CSCS repository


### 3.5.1

-   The EasyConfig file is derived from the one used at the University of
    Antwerpen which supports more compression tools than the one from the
    EasyBuilders repository.


### 3.6.1 for CPE 22.06

-   Trivial port of the EasyConfig of 3.5.1

-   Added libxml2 as dependency as it turns out that it is looking for that
    libraries in the configure step.


### Version 3.6.2 from CPE 23.09 on

-   Trivial version bump of the 3.6.1 EasyConfig

-   But aligned the sources with those used by EasyBuild.

-   For LUMI/23.12, license information was added to the installation and
    the sanity checks were improved.

  
### 3.7.2 ffrom LUMI/24.03 on

-   Almost trivial version bump of the 3.7.2 EasyConfig for LUMI/23.12
  
-   But there is now one additional executable in the package, so sanity checks were 
    updated.


### 3.7.7 for 25.03

-   Trivial version bump of the 3.7.2 EasyConfig in 24.03/24.11.

-   Note that the 3.8.x branch already existed, but we stuck to the version used in 
    EasyBuild common toolchains version 2025a.


### Version 3.8.4 for 25.09

-   Trivial version bump of the 3.7.7 EasyConfig in 25.03.

