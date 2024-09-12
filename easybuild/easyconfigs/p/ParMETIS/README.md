# ParMETIS instructions

  * [ParMETIS home page](http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview)

METIS is mature code, there doesn't really seem to be any development anymore.
The 4.0.3 release is from 2013.


## EasyBuild

  * [ParMETIS support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/p/ParMETIS)

    ParMETIS has a software-specific EasyBlock.

  * [ParMETIS support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/p/ParMETIS)

  * [HPE-Cray ParMETIS sample build script (TPSL)](https://github.com/Cray/pe-scripts/blob/master/sh/tpsl/parmetis.sh)

    ParMETIS was part of the Cray Third-Party Scientific Libraries (TPSL) but is no longer
    delivered in a ready-to-use form,


### Version 4.0.3 from CPE 21.08 on

  * Our EasyConfig is derived from the EasyBuilders one.

    It uses the default EasyBuild ParMETIS EasyBlock.

  * Note that the way the EasyBlock builds ParMETIS seems to differ somewhat
    from the way the Cray TPSL script does the job. The latter does seen to use
    METIS during the build.

  * For LUMI/23.12, license information was added to the installation.
