# ICU - International Components for UNICODE

-   [ICU home page](https://icu.unicode.org/)

    -   [Downloads from the ICU home page](https://icu.unicode.org/download)

-   [ICU on GitHub](https://github.com/unicode-org/icu)

    -   [GitHub releases of ICU](https://github.com/unicode-org/icu/releases)

## EasyBuild

-   [ICU support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/i/ICU)

-   ICU is not in the CSCS repository

-   ICU is [icu4c in the Spack repository](https://spack.readthedocs.io/en/latest/package_list.html#icu4c)


### 69.1 from 21.06 on

-   We started from an EasyConfig file from the University of Antwerpen which
    itself is based on the ones in the EasyBuilders repository.


### 71.1 from CPE 22.06 on

-   Trivial port of the EasyConfig.

-   Added `sanity_check_commands`.

-   Checked the documentation for further testing procedures bud coulnd't find any at the moment.
  
  
### 72.1 from CPE 22.12 on

-   Trivial port of the EasyConfig
  
-   Switched to the new home page URL, as in the EasyBuilders repository.

  
Build problem with cpeGNU when using the 12.2.0 compilers:

-   The .so files build correctly and take the runtime libraries from GCC 12.

-   The regular binaries however take the ones in /opt/cray/pe/gcc-libs/ instead
    which on LUMI are currently the ones from GCC 11
    

### 73.2 from CPE 23.09

-   Trivial port of the 72.1 EasyConfig.

-   For LUMI/23.12, license information was added to the installation.


### 74.1 for LUMI/24.03

-   Trivial port of the 73.2 EasyConfig for LUMI/23.12.


### 76.1 for LUMI/25.03

-   Almost trivial port of the 74.1 EasyConfig for LUMI/24.03 and LUMI/24.11.

-   But source URL structure has changed.

