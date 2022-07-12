# util-linux

  * [Sources](https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/)


## EasyBuild

  * [util-linux support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/u/util-linux)

  * [util-linux support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/u/util-linux)


### 2.37.1 from cpe 21.06 on

  * The EasyConfig is derived from a mix of the EasyConfigs of the EasyBuilders repository,
    CSCS and University of Antwerpen, the latter for the documentation.

  * The list of dependencies was revised: added file for libmagic.

  * The configure options were also checked and extended.

  * We need to use ``--without-tinfo`` as otherwise we get an error message about
    ``cur_term`` not found.

### 2.38 from CPE 22.06 on

  * Trivial version bump of the EasyConfig,

