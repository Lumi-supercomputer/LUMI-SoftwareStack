# cairo instructions

-   [cairo web site](https://www.cairographics.org/)
  
-   [cairo via the cgit interface](https://cgit.freedesktop.org/cairo/)


## EasyBuild

-   [cairo support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/c/cairo)

-   [cairo support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/c/cairo)
    The current status (November 2021): Support is outdated and for a non-Cray toolchain.


### Version 1.17.4 for cpe 21.08

-   Note: EasyBuild is at this time still at version 1.16.0, so in case we
    run into trouble we may have to revert to this older version.

-   Started from the UAntwerpen and EasyBuilders recipes.

-   Currently tested with cpeGNU and cpeCray only.

   -   cpeCray needs '-Wno-unsupported-target-opt' or the compilation fails in the
       building phase.

-   For LUMI/23.12, license information was added to the software installations.

TODO: Problems on eiger likely because the configure process fails to find the pthread library...


### **NOT** Version 1.17.8 from 23.09 on

-   Switched to a meson build based on the EasyBuilders EasyConfig.
  
-   However, compilation fails in cpeAMD and it is not clear why we don't
    see a similar error with cpeCray as that uses an even newer and stricter
    version of Clang.


### Version 1.18.0 for LUMI/24.03

-   Started from the EasyConfig for 1.17.4 in LUMI/24.03.
  
-   However, we now have to switch to a MesonNinja build proces which has completely 
    different configuration options.

 
### Version 1.18.4 for LUMI/25.03

-   Trivial port of the EasyConfig for 1.18.0 in 24.03/24.11, but needed to switch 
    to a different buildtools-python version as we needed a very recent meson.
  
