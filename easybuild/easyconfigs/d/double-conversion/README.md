# double-conversion instructions

-   [double-conversion on GitHub](https://github.com/google/double-conversion)

    -   [Releases on GitHub](https://github.com/google/double-conversion/releases)

## General information

-   Version 3.1: There are three build procedures

    -   SCons which is advised according to the documentation in the
        [README.md](https://github.com/google/double-conversion)
        This build three libraries:
         -   A static library with regular position-dependent code
         -   A static library with position-independent code
         -   A shared library

    -   CMake: Can build only one library at a time.

    -   Makefile: It simply calls scons according to the documentation.


## EasyBuild

-   [double-conversion in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/d/double-conversion)

-   There is no support for double-conversion in the CSCS repository.

In EasyBuild 4.4, the current version when this documentation was started, it is based
on the CMake installation procedure, making three runs to install the three versions
of the library that SCons generates.


### 3.1.5, from CPE 21.06 on

-   The EasyConfig is derived from the EasyBuilders one with some changes based on
    the University of Antwerpen one.


### 3.2.0 from CPE 22.08 on

-   The EasyConfig is a trivial port of the 3.1.5 one.
  
  
### 3.2.1 from CPE 22.12 on

-   The EasyConfig is a trivial port of the 3.2.0 one.
  

### 3.3.0 from CPE 23.09 on

-   Trivial version bump of the 3.2.1 one.
  
-   Added additional license info from CPE 23.12 on.

 
### 3.3.1 from CPE 25.03 on

-   Trivial version bump of the 3.3.0 EasyConfig for 24.03/24.11.


### 3.4.0 from 25.09 on

-   Trivial version bump of the 3.3.1 EasyConfig for 25.03.
