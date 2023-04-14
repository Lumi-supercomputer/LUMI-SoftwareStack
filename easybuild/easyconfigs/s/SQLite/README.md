# SQLite instructions

  * [SQLite web site](https://www.sqlite.org/)


## EasyBuild

  * [SQLite support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/s/SQLite)

  * [SQLite support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/s/SQLite)


### Version 3.36.0 from CPE 21.08 on

  * The EasyConfig file is a mix of the EasyBuilders and CSCS ones,
    with more input from the EasyBuilders one as that supports additional
    options that may come in useful given the broad user base of LUMI.

  * No cpeAMD version for 21.08 as the compilation of the Tcl dependency
    fails with that compiler.


### Version 3.38.3 from CPE 22.06 on

  * Trivial port of the EasyConfig with some refinement to the download procedure.


### Version 3.39.4 from CPE 22.12 on

  * Trivial port of the EasyConfig for 3.38.3.

