# SuiteSparse instructions

  * [SuiteSparse on GitHub](https://github.com/DrTimothyAldenDavis/SuiteSparse)
      * [Releases on GitHub](https://github.com/DrTimothyAldenDavis/SuiteSparse/releases)

## EasyBuild

  * [Support for SuiteSparse in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/s/SuiteSparse)

### 5.13.0 from LUMI/24.03

-   The easyconfig is an adaptation of the EasyBuilders one which uses an
    EasyBlock. Our easyconfig doesn't as the operations performed in the
    EasyBlock are simple and can easily be performed with a ConfigureMake
    EasyBlock.

-   SuiteSparse is a dependency of hipSolver for ROCm 6.2. This is why a very
    outdated version is provided (newest version at the time of writing is
    7.8.2). The version matches the version available in the OpenSUSE 15.5
    science repository.