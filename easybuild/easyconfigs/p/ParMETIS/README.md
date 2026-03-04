# ParMETIS instructions

-   [New METIS GitHub site](https://github.com/KarypisLab/ParMETIS)

-   [New Karypis homepage](https://karypis.github.io/)

    -   [ParMETIS on that site](https://karypis.github.io/glaros/software/metis/overview.html#parmetis---parallel-graph-partitioning-and-fill-reducing-matrix-ordering)

-   [Former ParMETIS home page (likely inactive)](http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview)

METIS is mature code, there doesn't really seem to be any development anymore.
The 4.0.3 release is from 2013.


## EasyBuild

-   [ParMETIS support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/p/ParMETIS)

    ParMETIS has a software-specific EasyBlock.

-   [ParMETIS support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/p/ParMETIS)

-   [HPE-Cray ParMETIS sample build script (TPSL)](https://github.com/Cray/pe-scripts/blob/master/sh/tpsl/parmetis.sh)

    ParMETIS was part of the Cray Third-Party Scientific Libraries (TPSL) but is no longer
    delivered in a ready-to-use form,


### Version 4.0.3 from CPE 21.08 on

-   Our EasyConfig is derived from the EasyBuilders one.

    It uses the default EasyBuild ParMETIS EasyBlock.

-   Note that the way the EasyBlock builds ParMETIS seems to differ somewhat
    from the way the Cray TPSL script does the job. The latter does seen to use
    METIS during the build.

-   For LUMI/23.12, license information was added to the installation.

-   For LUMI/25.03, we corrected all URLs to their new values.

-   LUMI 25.03: ParMETIS does not build with `cpeAMD` id OpenMP is enabled and no special steps 
    are taken. It turned out we had a double issue:

    -   The issue with OpenMP enabled, is that `llvm-link` goes looking for `libomptarget-amdgpu-gfx90a.bc`
        in the wrong directory, in fact, in the buildtools directory from which CMake is 
        taken instead of in the ROCm directories. It turns out the the `/opt/rocm/lib` directory
        should be first in `LIBRARY_PATH`.
        
    -   The second issue is then that the standard EasyBlock for ParMETIS does not 
        honour `preconfigopts` though it does honour `prebuildopts`, making an easy fix impossible.
        
    The issue was fixed by simply writing a patch for EasyBuild itself rather than starting another
    difficult-to-maintain own EasyBlock.

-   From 25.03 on, we include both static and dynamic libraries in the same module.


### Version 4.0.3 with precision versionsuffix

-   Thanks to a user ticket, we found out that METIS and ParMETIS (which uses a built-in METIS)
    used a different precision for the floating point data, and nothing in the module name indicated
    that. So we have made the EasyConfig more universal, making it easy to select the precision for
    the indices and the real data format, and also reflect that choice in the versionsuffix and document
    it in the module help.

    So rather than a patch which was used by EasyBuilders in their METIS EasyConfig we work with a `sed`
    to edit the `metis.h` header file. The procedure could actually be done in a modified EasyBlock, but
    we want to continue using the standard EasyBlock with just a small patch.

-   ParMETIS is currently incompatible with CMake 4 until we find a way to patch the configure script
    and/or CMake recipes.
