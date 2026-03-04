# Boost instructions

-   [Boost web site](https://www.boost.org/)

-   [Boost on GitHub](https://github.com/boostorg/boost)
  
    -   [GitHub releases](https://github.com/boostorg/boost/releases)
      
-   [Boost downloads that we use](https://boostorg.jfrog.io/artifactory/main/release/)


## EasyBuild

-   [Boost support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/b/Boost)

-   [Boost support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/b/Boost)

Note that the CSCS repository contains a custom EasyBlock for Boost as the MPI build
procedure of the regular one does not work. However, it seems to be based on a very
old version of the Boost EasyBlock.

HPE-Cray has a sample build script for Boost in their
[pe-scripts repository](https://github.com/Cray/pe-scripts).


### Version 1.77.0 for CPE 21.08

-   The EasyConfig is derived from the standard EasyBuild one with some additional help
    information added to it taken from the UAntwerpen EasyConfig.

    It does require additional parameters to specify the toolsets for bootstrapping
    and building as they are not always correctly recognized.

    Id does need some corrections to the EasyBlock to correctly support MPI

-   Our custom EasyBlock ``EB_BoostCPE`` is needed to enable MPI builds.

    -   Added code for correctly generating the ``user-config.jam`` file.

    -   Added an additional parameter ``bjam_features`` that allows to add additional
        features to the b2/bjam command line. It could be used when using old style
        Cray compilers though it seems that the options that the HPE-Cray build script
        adds are actually not all valid on recent versions of Boost.

-   cpeGNu: Seems to work with the CSCS EasyBlock. It is not clear if any of the Cray
    patches make sense in this case.

-   cpeCray: Work based on the ``boost.sh`` script from the
    [pe-scripts repository](https://github.com/Cray/pe-scripts).

    -   Patch ``boost-context-cray.path``:  Adds the ``cray`` toolset to
        ``libs/context/build/JAmfile.v2``. This patch doesn't seem to be needed
        anymore as it is for the toolset ``cray`` which is not used for the
        clang-based CCE compiler.

    -   Patch ``boost-cray-default-feature-fix.patch`` basically undoes some settings
        that ``tools/build/src/tools/cray.jam`` makes specifically for Cray.
        This patch doesn't seem to be needed anymore as it is for the toolset
        ``cray`` which is not used for the clang-based CCE compiler.

    -   Then the Cray script does a lot of editing in
        ``boost/config/compiler/cray.hpp`` that they claim is needed for CCE 8.6 and
        up. This is still used in our configuration for the Cray compiler.

    -   The edits in the Cray script in tools/build/src/tools are not needed for version
        1.77.0. The errors that those edits deal with have already been corrected
        (as of [commit 3385fe2aa699a45e722a1013658f824b6a7c761f](https://github.com/boostorg/build/commit/3385fe2aa699a45e722a1013658f824b6a7c761f).)

-   cpeAMD: Compiles if ``toolset == clang`` is added to the EasyConfig. It is not clear if
    any of the Cray patches actually make sense.

-   For 21.12, which switched to Python 3.9.4, the version detection is wrong so the sanity
    check goes looking for the files for Python 3.8 rather than 3.9.


### Version 1.79.0 for LUMI/22.06

-   Trivial port of the EasyConfigs.


### 1.81.0 from CPE 22.12 on

-   Trivial port of the EasyConfigs for the regular version.
  
-   We no longer have the -python3 versions of the modules. Instead a separate Boost.python
    module will be developed that installs the Python 3 interfaces on top of the regular
    Boost module. Unless the EasyBuilders repository though we do not distinguish between
    Boost and Boost.mpi, the latter still a full library but with MPI support, as we don't
    have those levels of hierarchy in our toolchains. 
    

### 1.82.0 from CPE 23.09 on

-   Trivial port of the EasyConfigs for the regular version of 1.81.0
    to follow the EasyBuild common toolchains version 2023a.

-   Except for cpe Cray 23.09 where some linking errors were generated. The solution turned
    out to be a special Clang feature to inject options late in the process: Before building,
    set
    
    ``` bash
    export CCC_OVERRIDE_OPTIONS="x--target=x86_64-pc-linux"
    ```

    which for building Boost we do via `prebuildopts` in the EasyConfig.
    
  -  *It might be that similar linking errors (about not finding libunwind) are generated when
    using Boost with this version of the compiler and the same workaround may be needed in that
    case!**
    

### 1.83.0 for LUMI/24.03

-   Trivial port of the EasyConfig for version 1.82.0 in LUMI/23.12.


### 1.88.0 for 25.03

-   Trivial port of the EasyConfig for 1.83 in 24.03/24.11.


### Version 1.90.0 for 25.09

-   Trivial port of the EasyConfig for 1.88.0 in 25.03.

