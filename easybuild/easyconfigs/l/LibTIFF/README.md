# LibTIFF
]
  * [Home page 1](https://libtiff.gitlab.io/libtiff/)

  * [Home page 2 (if it works) on gitlab](https://libtiff.gitlab.io/libtiff/)

  * [Home page 3 (dead when I checked but used in the default EasyConfig)](http://libtiff.maptools.org/)

  * [GitLAb repsitory](https://gitlab.com/libtiff/libtiff)

      * [version tags on GitLab](https://gitlab.com/libtiff/libtiff/-/tags)

  * [Offical download site](https://download.osgeo.org/libtiff/)


## EasyBuild

  * [LibTIFF in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/LibTIFF)

  * [LibTIFF in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/l/LibTIFF)


### Special issues

  * Note that there is a circular dependency between LibTIFF and libwebp as both
    can use the other for their command line tools. In the 21.06 version of the LUMI
    stack, we let libwebp use LibTIFF but not the other way around.


### Version 4.3.0 from CPE 21.06 on

  * Our EasyConfig is derived from the University of Antwerpen one which has more
    dependencies (that are used by some of the command line tools it seems).

### Version 4.4.0 for CPE 22.06

  * Trivial version bump of the 4.3.0 one.

  * Added libdeflate as a dependency. libwebp can also be a dependency but then
    we'd create a circular dependency as libwebp can also use LibTIFF.

  * Support for OpenGL is incomplete in this version as the libraries are not installed 
    everywhere.

