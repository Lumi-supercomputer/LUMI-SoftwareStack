# cairo instructions

-   [cairo web site](https://www.cairographics.org/)

-   [cairo downloads](https://www.cairographics.org/releases/)
  
-   [cairo in the freedesktop gitlab](https://gitlab.freedesktop.org/cairo/cairo)

    -   [tags corresponding to releases](https://gitlab.freedesktop.org/cairo/cairo/-/tags)

-   [cairo via the cgit interface](https://cgit.freedesktop.org/cairo/)


## General information

Cairo supports GLib, but it is not a necessity. When cairo is used in other packages 
from the Gnome ecosystem, it may be required though. It may also be used when binding
cairo to other languages.

Cairo ships a thin GObject wrapper (`cairo-gobject`) that turns its C API into loadable GType classes.

-   GLib’s GObject system powers the object model (inheritance, signals) around Cairo types

-   GObject-Introspection (GIRepository) uses GLib to generate `.typelib` metadata

-   Language bindings (Python, JavaScript, Rust, etc.) consume these typelib files to expose Cairo APIs 
    in high-level languages.
    
Without GLib, you’d lose the automatic introspection data and the GObject type system that 
make Cairo so easily accessible from many programming environments.

We have had issues in the past with cairo picking the wrong GLib library which were 
due to a package that we had in the X11 bundle that secretly also installed a version
of GLib.


## EasyBuild

-   [cairo support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/c/cairo)

-   [cairo support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/c/cairo)
    The current status (November 2021): Support is outdated and for a non-Cray toolchain.


### Version 1.17.4 for cpe 21.08

-   Note: EasyBuild is at this time still at version 1.16.0, so in case we
    run into trouble we may have to revert to this older version.

-   Started from the UAntwerpen and EasyBuilders recipes.

-   Currently tested with cpeGNU and cpeCray only.

   -   cpeCray needs '-Wno-unsupported-target-opt' or the compilation fails in the
       building phase.

-   For LUMI/23.12, license information was added to the software installations.

TODO: Problems on eiger likely because the configure process fails to find the pthread library...


### **NOT** Version 1.17.8 from 23.09 on

-   Switched to a meson build based on the EasyBuilders EasyConfig.
  
-   However, compilation fails in cpeAMD and it is not clear why we don't
    see a similar error with cpeCray as that uses an even newer and stricter
    version of Clang.


### Version 1.18.0 for LUMI/24.03

-   Started from the EasyConfig for 1.17.4 in LUMI/24.03.
  
-   However, we now have to switch to a MesonNinja build proces which has completely 
    different configuration options.

 
### Version 1.18.4 for LUMI/25.03

-   Initially a trivial port of the EasyConfig for 1.18.0 in 24.03/24.11, but needed to switch 
    to a different buildtools-python version as we needed a very recent meson.

-   But did a check of features and it turned out that the EasyBuilders EasyConfig is far from
    full-featured so we added some new dependencies that enabled new features.
    
    We also added very extensive sanity checks that will likely fail if one of the features that
    we have now activated, would not be present anymore.
    
-   We deliberately use `-Dsymbol-lookup=disabled` as that uses libbfd which comes with binutils.
    This library was taken from the system. Though we do have an EasyConfig for it in contrib
    as it is also used with Score-P, we did not want to move that one to the software stack 
    and make it a dependency as in the past it has not always been trivial to support this library
    so it would slow down the development of the software stack.
