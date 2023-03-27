# GObject-Introspection instructions

  * [GObject-Introspection web site](https://gi.readthedocs.io/en/latest/)


## EasyBuild

  * [GObject-Introspection in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/g/GObject-Introspection)

  * [GObject-Introspection in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/g/GObject-Introspection)



### Version 1.68.0 for cpe 21.08

  * The recipe is a mix of the EasyBuilders and CSCS ones, with some input from
    the UAntwerpen one also.

  * Tried with the system Python but that did not work as there are no development
    packages installed, so used cray-python as in the CSCS recipe.

      * CSCS sets this as a build dependency, but that did not work in our case.

  * Added additional sanity checks to test if the commands actually work. This coul,
    e.g., catch the problem where cray-python is a build dependency.


### Version 1.71.0 for CPE 21.12

  * Updated to 1.71.0 rather than following the EasyBuild common toolchain for 21.12
    because of problems with Meson not finding a file.


### Version 1.72.0 for CPE 22.06

  * Trivial port of the EasyConfig, made last minute to align with EasyBuild 4.6.0.

  
### Version 1.74.0 from CPE 22.12 on

  * Trivial port of the EasyConfig of 1.72.0.

  