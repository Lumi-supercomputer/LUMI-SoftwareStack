# METIS instructions

  * [METIS home page](http://glaros.dtc.umn.edu/gkhome/metis/metis/overview)

METIS is mature code, there doesn't really seem to be any development anymore.
The 5.1.0 release is from 2013.


## EasyBuild

  * [METIS support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/m/METIS)

    METIS has a software-specific EasyBlock.

  * [METIS support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/m/METIS)

  * [HPE-Cray METIS sample build script (TPSL)](https://github.com/Cray/pe-scripts/blob/master/sh/tpsl/metis.sh)

    METIS was part of the Cray Third-Party Scientific Libraries (TPSL) but is no longer
    delivered in a ready-to-use form,


### Version 5.1.0 from CPE 21.08 on

  * Our EasyConfig is derived from the CSCS one which itself is a direct
    adaptation of the EasyBuilders one.

    It uses the default EasyBuild METIS EasyBlock.

  * For 23.12: Add license information to the installation directories.
