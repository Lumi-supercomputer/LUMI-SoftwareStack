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


### 2.38.1 from CPE 22.12 on

  * Trivial version bump of the EasyConfig of 2.38.


### **NO** 2.39 from CPE 23.09 on

  * Port of the 2.38.1 EasyConfig but with the patches of the EasyBuild version added.
  
  * Did not work so reverted to 2.38.1.


### Version 2.39.3 from CPE 23.12 on

  * Version bump of 2.38.1
  
  * Added license information to the installation directories.

