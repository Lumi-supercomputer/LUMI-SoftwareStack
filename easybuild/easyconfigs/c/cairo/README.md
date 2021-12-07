# cairo instructions

  * [cairo web site](https://www.cairographics.org/)


## EasyBuild

  * [cairo support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/c/cairo)

  * [cairo support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/c/cairo)
    The current status (November 2021): Support is outdated and for a non-Cray toolchain.


### Version 1.17.4 for cpe 21.08

  * Note: EasyBuild is at this time still at version 1.16.0, so in case we
    run into trouble we may have to revert to this older version.

  * Started from the UAntwerpen and EasyBuilders recipes.

  * Currently tested with cpeGNU and cpeCray only.

     * cpeCVray needs '-Wno-unsupported-target-opt' or the compilation fails in the
       building phase.
