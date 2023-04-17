# ESMF

  * [ESMF on SourceForge](https://sourceforge.net/projects/esmf/)

  * [ESMF on GitHub](https://github.com/esmf-org/esmf)

      * [GitHub releases](https://github.com/esmf-org/esmf/releases)


## EasyBuild

  * [ESMF support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/e/ESMF)

  * [ESMF support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/e/ESMF)

Note that ESMF uses a custom EasyBlock which needs adaptations for Cray systems.


### ESMF 8.1.1 for CPE 21.08

  * The EasyConfig file is an adaptation from the CSCS one.

  * **TODO**: The EasyBuilders version uses a patch. Does this add functionality?

  * Building fails with cpeAMD, with very strange error messages.


### ESMF 8.2.0 for CPE 21.08

  * This version does not compile with gfortran unless the flag to allow argument
    mismatch is used. The problem is that the build procedure does not pick up
    `F90FLAGS` etc., so we've done some hand work with `preconfigopts` and
    `prebuildopts`.


### ESMF 8.3.0 for CPE 22.06

  * Near-trivial version bump, but the way the sources are distributed has changed.

  * Building with AOCC still fails.

  * Note that the build process does include some testing.


### Version 8.4.1 from CPE 22.12 on

  * Trivial version bump of the 8.3.0 EasyConfig

