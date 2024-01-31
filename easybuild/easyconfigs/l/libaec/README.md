# libaec - Adaptive Entropy Coding library

  * [libaec web site / gitlab](https://gitlab.dkrz.de/k202009/libaec)


## EasyBuild

  * There is no libaec support in the EasyBuilders repository.

  * [libaec in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/l/libaec)


### Version 1.0.6 for CPE 21.08 and later

  * The EasyConfig is derived from the CSCS EasyConfig with a version bump.

  * But switched to CMake as this is now the main configuration tool for
    libaec.

    
### Version 1.1.2 from 23.12 on

  * The EasyConfig is a straightforward port of the 1.0.6 one.
    From 1.1.0 on, libaec does no longer include the `aec` executable and its
    manual page. It does have `graec` now, but that executable is not installed
    as it is only meant for internal testing.
  
  * Added license information to the installation.
 
