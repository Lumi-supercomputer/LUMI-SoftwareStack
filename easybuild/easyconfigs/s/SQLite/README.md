# SQLite instructions

-   [SQLite web site](https://www.sqlite.org/)


## EasyBuild

-   [SQLite support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/s/SQLite)

-   [SQLite support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/s/SQLite)


### Version 3.36.0 from CPE 21.08 on

-   The EasyConfig file is a mix of the EasyBuilders and CSCS ones,
    with more input from the EasyBuilders one as that supports additional
    options that may come in useful given the broad user base of LUMI.

-  * No cpeAMD version for 21.08 as the compilation of the Tcl dependency
    fails with that compiler.


### Version 3.38.3 from CPE 22.06 on

-   Trivial port of the EasyConfig with some refinement to the download procedure.


### Version 3.39.4 from CPE 22.12 on

-   Trivial port of the EasyConfig for 3.38.3.


### Version 3.42.0 from CPE 23.09 on

-   Trivial port of the EasyConfig from 3.39.4.

-   software_license_urls was added for LUMI/23.12, but the license information is not
    included in the downloaded sources.


### Version 3.43.1 for LUMI/24.03 and LUMI/24.11

-   Trivial version bump of the 3.42.0 EasyConfig

    
### Version 3.47.2 for LUMI/25.03

-   Trivial version bump of the 3.43.1 EasyConfig


### Version 3.51.1 for LUMI/25.09

-   Trivial version bump of the 3.47.2 EasyConfig for 25.03.

