# SCOTCH instructions

  * [SCOTCH home page](https://gforge.inria.fr/projects/scotch/)


## EasyBuild

  * [SCOTCH support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/s/SCOTCH)

    SCOTCH has a custom EasyBlock. However, it does not support cpeCray and cpeAMD.

  * [SCOTCH support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/s/SCOTCH)

  * [HPE-Cray SCOTCH sample build script (TPSL)](https://github.com/Cray/pe-scripts/blob/master/sh/tpsl/scotch.sh)

    SCOTCH was part of the Cray Third-Party Scientific Libraries (TPSL) but is no longer
    delivered in a ready-to-use form,

### Version 6.1.1 for CPE 21.08

  * The EasyBlock does not support the Cray or AMD compilers so it was
    thorougnly reworked (and renamed to ``EB_SCOTCH_CPE`` so not automatically
    activated).

      * To compile with CPE, a separate template file is required in ``src/Make.inc``.
        For now, we inject this via the sources in the EasyConfig.

      * Added the EasyBlock option ``rename_parser`` to build with ``SCOTCH_RENAME_PARSER``
        defined as it is used in the Cray sample builds, so we can always activate it
        when needed.

      * Added the EasyBlock option ``metrix_prefix`` that enables prefixing all built-in
        METIS routines with ``SCOTCH_``. This is something which was done in the
        Cray TPSL library as there was also a METIS library to enable the regular
        METIS routines fronm the regular library and SCOTCH in the same code.

      * Improved the support for GZ-compression of graphs and added support for bz2
        and LZMA. These will be activated depending on the dependency list ( zlib,
        bzip2 or XZ modules) and the verification is done by looking for the EBROOT
        variables to better support bundles of tools (that only need to define the
        corresponding EBROOT variables to be compatible with the regular EasyBuild
        modules).

  * This implies that the resulting EasyConfig is actually almost completely rewritten.
