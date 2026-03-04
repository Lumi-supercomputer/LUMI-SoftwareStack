# xorg-macros

This is a set of autoconf macros used by the configure.ac scripts in
other Xorg modular packages, and is needed to generate new versions
of their configure scripts with autoconf.

-   [Home page](https://cgit.freedesktop.org/xorg/util/macros)


## EasyBuild

-   [xorg-macros support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/x/xorg-macros)

-   [xorg-macros support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/x/xorg-macros)


### 1.19.3 from CPE 21.06 on

-   The EasyConfig is derived from the EasyBuilders one. However, since this
    package is really just a bunch of autotools macros, we moved it to the
    SYSTEM toolchain (where autoconf also resides in buildtools). There is
    absolutely no reason to have separate versions for all Cray toolchains
    except that it is slightly easier to specify the dependency.

-   **Install in partition/common** as it is fully processor-independent and
    only uses buildtools during the installation which is also installed in
    partition/common.


### Version 1.20.0 from CPE 23.09 on

-   Trivial version bump of our 1.19.3 EasyConfig.


### Version 1.20.2 from CPE 25.03 on

-   Trivial version bump of our 1.20.0 EasyConfig.

-   Updated with the parameter names for EasyBuild 6 as this version is only used with
    EasyBuild 5 anyways.
