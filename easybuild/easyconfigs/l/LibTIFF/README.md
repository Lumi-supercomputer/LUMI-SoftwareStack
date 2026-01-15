# LibTIFF

-   [Home page 1](https://libtiff.gitlab.io/libtiff/)

-   [Home page 2 (if it works) on gitlab](https://libtiff.gitlab.io/libtiff/)

-   [Home page 3 (dead when I checked but used in the default EasyConfig)](http://libtiff.maptools.org/)

-   [GitLab repsitory](https://gitlab.com/libtiff/libtiff)

    -   [version tags on GitLab](https://gitlab.com/libtiff/libtiff/-/tags)

-   [Offical download site](https://download.osgeo.org/libtiff/)


## EasyBuild

-   [LibTIFF in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/LibTIFF)

-   [LibTIFF in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/l/LibTIFF)


### Special issues

-   Note that there is a circular dependency between LibTIFF and libwebp as both
    can use the other for their command line tools. In the 21.06 version of the LUMI
    stack, we let libwebp use LibTIFF but not the other way around.


### Version 4.3.0 from CPE 21.06 on

-   Our EasyConfig is derived from the University of Antwerpen one which has more
    dependencies (that are used by some of the command line tools it seems).


### Version 4.4.0 for CPE 22.06

-   Trivial version bump of the 4.3.0 one.

-   Added libdeflate as a dependency. libwebp can also be a dependency but then
    we'd create a circular dependency as libwebp can also use LibTIFF.

-   Support for OpenGL is incomplete in this version as the libraries are not installed 
    everywhere.


### Version 4.5.0 from CPE 23.09 on

-   Trivial version bump of the 4.4.0 EasyConfig

-   Support for OpenGL still incomplete.
  
-   For LUMI/23.12, license information was added to the installation.


### Version 4.6.0 from LUMI/24.03 on

-   Almost trivial version bump of the EasyConfig for 4.5.0 in LUMI/23.12.
  
-   The list of included executables has also changed so we needed to adapt the sanity checks.

-   When compiling with cpeGNU in partition/G, we needed to unload rocm as it was trying 
    to link with ROCm while producing an error when running.
 
-   Ensuring that in the whole chain of dependencies no unnecessary libraries are picked 
    up, turned out to be essential for `cpeAMD`.
 
 
### Version 4.7.0 for LUMI/25.03

-   Trivial version bump of the EasyConfig for 4.6.0 in 24.03/24.11.


### Version 4.7.1 for LUMI/25.09

-   Trivial version bump of the EasyConfig for 4.7.0 in 25.03.
 
 