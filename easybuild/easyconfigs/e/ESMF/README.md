# ESMF

  * [ESMF on SourceForge](https://sourceforge.net/projects/esmf/)

  * [ESMF on GitHub]()

      * [GitHub releases](https://github.com/esmf-org/esmf/releases)


## EasyBuild

  * [ESMF support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/main/easybuild/easyconfigs/e/ESMF)

  * [ESMF support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/e/ESMF)

Note that ESMF uses a custom EasyBlock which needs adaptations for Cray systems.


### ESMF 8.1.1 for CPE 21.08

  * The EasyConfig file is an adaptation from the CSCS one.

  * **TODO**: The EasyBuilders version uses a patch. Does this add functionality?

  * Building fails with cpeAMD, with very strange error messages.
