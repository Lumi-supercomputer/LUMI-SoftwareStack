# util-linux

-   [Sources](https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/)


## EasyBuild

-   [util-linux support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/u/util-linux)

-   [util-linux support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/u/util-linux)


### 2.37.1 from cpe 21.06 on

-   The EasyConfig is derived from a mix of the EasyConfigs of the EasyBuilders repository,
    CSCS and University of Antwerpen, the latter for the documentation.

-   The list of dependencies was revised: added file for libmagic.

-   The configure options were also checked and extended.

-   We need to use ``--without-tinfo`` as otherwise we get an error message about
    ``cur_term`` not found.


### 2.38 from CPE 22.06 on

-   Trivial version bump of the EasyConfig,


### 2.38.1 from CPE 22.12 on

-   Trivial version bump of the EasyConfig of 2.38.

-   For LUMI/23.12, license information was added to the installation.


### **NO** 2.39 from CPE 23.09 on

-   Port of the 2.38.1 EasyConfig but with the patches of the EasyBuild version added.
  
-   Did not work so reverted to 2.38.1.


### Version 2.39.3 from LUMI/24.03 on

-   Version bump of 2.38.1 for LUMI/23.12
  
-   The bugs that hit us in 2.39 seem to be fixed without any patches that have since 
    been developed by the EasyBuild community, so we deviate from 2023b.


### Version 2.39.3 from LUMI/24.03 on

-   Version bump of 2.39.3 for LUMI/24.02 and 24.11,
  
-   but there is a new dependency: SQLite, for a function that is enabled by default.
  
-   And there is also an extra configure flag `--disable-symvers` needed for cpeCray 
    as there are issues with versioned symbols.


### Version 2.40.0 from LUMI/25.03 on

-   Trivial port of the 2.39.3 EasyConfig for 24.03, but added SQLite as a dependency.


### Version 2.41.3 from LUMI/25.09 on

-   Trivial port of the 2.40.0 EasyConfig for 25.03.

-   There is still an issue with the cpeAOCC option which in turn may be due to an issue
    with SQLite.
