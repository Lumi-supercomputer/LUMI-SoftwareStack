# Blosc

  * [Blosc home page](https://www.blosc.org/)

  * [c-blosc GitHub repository (Blosc 1)](https://github.com/Blosc/c-blosc)

      * [GitHub  Blosc 1](https://github.com/Blosc/c-blosc/releases/tag/v1.21.0)


## EasyBuild

  * [Blosc in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/b/Blosc)

  * [Blosc in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/b/Blosc)


### Version 1.21.0 from CPE 21.06 on

  * The EasyConfig is based on the EasyBuilders one with the documentation taken from
    the University of Antwerpen EasyConfig.

  * With the clang-based compilers CMake didn't like the ``'cstd': 'c++11'`` toolchain
    option used by the default EasyConfig files.


### Version 1.21.1 from CPE 22.08 on

  * Minor version bump of the 1.22.1 EasyConfig.


### Version 1.21.2 from CPE 22.12 on

  * Minor version bump of the 1.21.1 EasyConfig.


### Version 1.21.5 from CPE 23.09 on

  * Done before the package was even added to 2023a. The 1.21.3 version that was
    used by EasyBuild for 2022b was even removed from the repository so likely contained
    some annoying bugs.

  * Trivial bump of the 1.21.2 EasyConfig.
  
  * From CPE 23.12 on: Adding information about the license.
  
  * From CPE 23.12 on, switching to installing in lib instead of lib64 for more uniformity.
 
 
### Version 1.21.6 for CPE 25.03 and 25.09

-   Trivial version update of 1.21.5 for 24.03

-   For 25.09, we needed to add ` -DCMAKE_POLICY_VERSION_MINIMUM=3.5` to the `configopts`
    for compatibility with CMake 4.
