# Boost instructions

  * [Boost web site](https://www.boost.org/)


## EasyBuild

  * [Boost support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/b/Boost)

  * [Boost support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/b/Boost)

Note that the CSCS repository contains a custom EasyBlock for Boost as the MPI build
procedure of the regular one does not work. However, it seems to be based on a very
old version of the Boost EasyBlock.

HPE-Cray has a sample build script for Boost in their
[pe-scripts repository](https://github.com/Cray/pe-scripts).


### Version 1.77.0 for CPE 21.08

  * The EasyConfig is derived from the standard EasyBuild one with some additional help
    information added to it taken from the UAntwerpen EasyConfig.

    It does require additional parameters to specify the toolsets for bootstrapping
    and building as they are not always correctly recognized.

    Id does need some corrections to the EasyBlock to correctly support MPI

  * Our custom EasyBlock ``EB_BoostCPE`` is needed to enable MPI builds.

      * Added code for correctly generating the ``user-config.jam`` file.

      * Added an additional parameter ``bjam_features`` that allows to add additional
        features to the b2/bjam command line. It could be used when using old style
        Cray compilers though it seems that the options that the HPE-Cray build script
        adds are actually not all valid on recent versions of Boost.

  * cpeGNu: Seems to work with the CSCS EasyBlock. It is not clear if any of the Cray
    patches make sense in this case.

  * cpeCray: Work based on the ``boost.sh`` script from the
    [pe-scripts repository](https://github.com/Cray/pe-scripts).

      * Patch ``boost-context-cray.path``:  Adds the ``cray`` toolset to
        ``libs/context/build/JAmfile.v2``. This patch doesn't seem to be needed
        anymore as it is for the toolset ``cray`` which is not used for the
        clang-based CCE compiler.

      * Patch ``boost-cray-default-feature-fix.patch`` basically undoes some settings
        that ``tools/build/src/tools/cray.jam`` makes specifically for Cray.
        This patch doesn't seem to be needed anymore as it is for the toolset
        ``cray`` which is not used for the clang-based CCE compiler.

      * Then the Cray script does a lot of editing in
        ``boost/config/compiler/cray.hpp`` that they claim is needed for CCE 8.6 and
        up. This is still used in our configuration for the Cray compiler.

      * The edits in the Cray script in tools/build/src/tools are not needed for version
        1.77.0. The errors that those edits deal with have already been corrected
        (as of [commit 3385fe2aa699a45e722a1013658f824b6a7c761f](https://github.com/boostorg/build/commit/3385fe2aa699a45e722a1013658f824b6a7c761f).)

  * cpeAMD: Compiles if ``toolset == clang`` is added to the EasyConfig. It is not clear if
    any of the Cray patches actually make sense.

  * For 21.12, which switched to Python 3.9.4, the version detection is wrong so the sanity
    check goes looking for the files for Python 3.8 rather than 3.9.
