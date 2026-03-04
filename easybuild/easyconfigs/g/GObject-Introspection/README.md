# GObject-Introspection instructions

-   [GObject-Introspection web site](https://gi.readthedocs.io/en/latest/)


## General information

GObject-Introspection comes with its own built-in version of GLib. This creates a mess 
in EasyBuild,as EasyBuild also has its own GLib and even uses it as a dependency of
GObject-Introspection that is not even used. The issue is that GObject-Introspection
hence may use a different version of the GLib libraries as the GLib module, leading
to issues when using GObject-Introspection, as which version of the GLib libraries
will be used, will depend on the order of the directories in LD_LIBRARY_PATH or 
the RPATH. 


## EasyBuild

-   [GObject-Introspection in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/g/GObject-Introspection)

-   [GObject-Introspection in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/g/GObject-Introspection)



### Version 1.68.0 for cpe 21.08

-   The recipe is a mix of the EasyBuilders and CSCS ones, with some input from
    the UAntwerpen one also.

-   Tried with the system Python but that did not work as there are no development
    packages installed, so used cray-python as in the CSCS recipe.

    -   CSCS sets this as a build dependency, but that did not work in our case.

-   Added additional sanity checks to test if the commands actually work. This coul,
    e.g., catch the problem where cray-python is a build dependency.


### Version 1.71.0 for CPE 21.12

-   Updated to 1.71.0 rather than following the EasyBuild common toolchain for 21.12
    because of problems with Meson not finding a file.


### Version 1.72.0 for CPE 22.06

-   Trivial port of the EasyConfig, made last minute to align with EasyBuild 4.6.0.

  
### Version 1.74.0 from CPE 22.12 on

-   Trivial port of the EasyConfig of 1.72.0.


### Version 1.76.1 from CPE 23.09 on

-   Port of the 1.74.0 EasyConfig.

-   But needed to use a buildtools-python using the same version of cray-python
    and with a newer version of Meson. It is not clear if it was a Python version
    conflict or just a too old version of Meson that was causing problems, but
    it is likely the former.


### Version 1.78.1 for LUMI/24.03

-   Trivial port of the EasyConfig for version 1.76.1 in LUMI/23.12.


### Version 1.84.0 for 25.03

-   Almost trivial port of the 1.78.1 EasyConfig in 24.03/24.11, but used
    the same patch as the EasyBuilders.
    
-   Did some layout improvements to the EasyConfig.
    
-   Also removed the explicit addition to `XDG_DATA_DIRS` as EasyBuild does this automatically
    when generating the module.


### Version 1.86.0 for 25.09

-   Trivial version bump from 1.84.0 for 25.03.

