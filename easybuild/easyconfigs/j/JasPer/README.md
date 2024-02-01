# JasPer

  * [JasPer on GitHub](https://github.com/jasper-software/jasper)

      * [GitHub releases](https://github.com/jasper-software/jasper/releases)

  * [JasPer home page (outdated downloads)](https://www.ece.uvic.ca/~frodo/jasper/)

## EasyBuild

  * [JasPer support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/j/JasPer)

  * [JasPer support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/j/JasPer)


## 2.0.33 from CPE 21.06 on

  * The EasyConfig is derived from the University of Antwerpen one with a version
    bump and change of download location.


### 3.0.4 from CPE 22.06 on

  * Trivial version bump of the EasyConfig

  * Did a check of the tests in the log file and there don't seem to be any new optional
    dependencies.


### Version 4.0.0 from CPE 22.12 on

  * Trivial version bump of the EasyConfig, but we did copy the improved sanity check
    from the EasyBuilders version.


### Version 4.1.2 from CPE 23.12 on

  * Reworked the EasyConfig a lot:
  
      * Generating both static and shared libraries.
      
      * Improved sanity checks
      
      * Copy license information to the installation directories.
