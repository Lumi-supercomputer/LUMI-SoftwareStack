# METIS instructions

-   [New METIS GitHub site](https://github.com/KarypisLab/METIS)

    -   Releases via GitHub tags](https://github.com/KarypisLab/METIS/tags)

-   [New Karypis homepage](https://karypis.github.io/)

    -   [METIS on that site](https://karypis.github.io/glaros/software/metis/overview.html)

-   [Former METIS home page (likely inactive)](http://glaros.dtc.umn.edu/gkhome/metis/metis/overview)

METIS is mature code, there doesn't really seem much development anymore.
The 5.1.0 release is from 2013, but then there was a 5.2.1 release onb GitHub.


## EasyBuild

-   [METIS support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/m/METIS)

    METIS has a software-specific EasyBlock.

-   [METIS support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/m/METIS)

-   [HPE-Cray METIS sample build script (TPSL)](https://github.com/Cray/pe-scripts/blob/master/sh/tpsl/metis.sh)

    METIS was part of the Cray Third-Party Scientific Libraries (TPSL) but is no longer
    delivered in a ready-to-use form,


### Version 5.1.0 from CPE 21.08 on

-   Our EasyConfig is derived from the CSCS one which itself is a direct
    adaptation of the EasyBuilders one.

    It uses the default EasyBuild METIS EasyBlock.

-   For LUMI/23.12, license information was added to the installation.

-   LUMI/25.03: There is a new version available at https://github.com/KarypisLab/METIS
    but so far we failed to build it as it seems to have new dependencies (at least, it
    cannot find a certain header file) and as we are concerned that dependencies cannot
    yet use that new version. We did update all URLs though as the old URLs in the 
    EasyConfig no longer existed.
