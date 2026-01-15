# SCOTCH instructions

-   [SCOTCH home page](https://gforge.inria.fr/projects/scotch/)

-   [SCOTCH GitLab](https://gitlab.inria.fr/scotch/scotch)


## EasyBuild

-   [SCOTCH support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/s/SCOTCH)

    SCOTCH has a custom EasyBlock. However, it does not support cpeCray and cpeAMD.

-   [SCOTCH support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/s/SCOTCH)

-   [HPE-Cray SCOTCH sample build script (TPSL)](https://github.com/Cray/pe-scripts/blob/master/sh/tpsl/scotch.sh)

    SCOTCH was part of the Cray Third-Party Scientific Libraries (TPSL) but is no longer
    delivered in a ready-to-use form,

### Version 6.1.1 for CPE 21.08

-   The EasyBlock does not support the Cray or AMD compilers so it was
    thorougnly reworked (and renamed to ``EB_SCOTCH_CPE`` so not automatically
    activated).

    -   To compile with CPE, a separate template file is required in ``src/Make.inc``.
        For now, we inject this via the sources in the EasyConfig.

    -   Added the EasyBlock option ``rename_parser`` to build with ``SCOTCH_RENAME_PARSER``
        defined as it is used in the Cray sample builds, so we can always activate it
        when needed.

    -   Added the EasyBlock option ``metrix_prefix`` that enables prefixing all built-in
        METIS routines with ``SCOTCH_``. This is something which was done in the
        Cray TPSL library as there was also a METIS library to enable the regular
        METIS routines fronm the regular library and SCOTCH in the same code.

    -   Improved the support for GZ-compression of graphs and added support for bz2
        and LZMA. These will be activated depending on the dependency list ( zlib,
        bzip2 or XZ modules) and the verification is done by looking for the EBROOT
        variables to better support bundles of tools (that only need to define the
        corresponding EBROOT variables to be compatible with the regular EasyBuild
        modules).

-   This implies that the resulting EasyConfig is actually almost completely rewritten.


### Version 6.1.2 for CPE 21.12

-   The root directory name has changed, some tricks were needed to unpack in a directory
    with a more predictable name. Maybe this can be further improved with appropriate options
    of tar rather than the construction with a move.

-   We're not sure we will get exactly the same file every time so we disabled the sanity
    check.


### Version 6.1.3 for CPE 22.06 and later

-   We decided against upgrading to 7.0.1 in the central software stack as that release
    might need some more testing and as we may need to rework the custom application
    EasyBlock.

-   From 22.12 on: Link to the homepage changed to the new one.
  
-   For LUMI/23.12, license information was added to the installation.


### Version 7.0.3 from CPE 22.12 on

-   Changed the homepage link to the new one.

-   Tried a fairly trivial update and that seemed OK for cpeGNU.

-   For some reason, to get it to work with cpeCray, we needed to add definitions for FLEX
    and BISON to Makefile.inc. It is not clear why this was not needed for the other toolchains.

-   For LUMI/23.12, license information was added to the installation.


### Version 7.0.4 from LUMI/24.03 on

-   Trivial version update from the 7.0.3 EasyConfig for LUMI/23.12.


### Version 7.0.8 for LUMI/25.03

-   Trivial version update from the 7.0.4 EasyConfig for LUMI/24.03 and 24.11.


### Version 7.0.10 for LUMI/25.09

-   Trivial version update from the 7.0.8 EasyConfig for LUMI/25.03.

