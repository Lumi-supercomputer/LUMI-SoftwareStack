# PROJ instructions

  * [PROJ web site](https://proj.org/)

      * [Download from the PROJ web site](https://proj.org/download.html)


## EasyBuild

  * [PROJ support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/p/PROJ)

  * [PROJ support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/p/PROJ)


### Version 8.1.1 from 21.08 on

  * The EasyConfig file is a mix of the EasyBuilders and CSCS one. Specifically,
    an additional dependency (cURL) was taken from the EasyBuilders one.

  * The documentation was enhanced.

  * No version for cpeAMD as the indirect Tcl dependency does not compile with that
    compiler.

  * PROJ does contain a number of commands also but no easy way to test them like
    producing help or a version without producing an error code.

### Version 9.0.0 from CPE 22.05 on

  * Started from a version bump of the 8.1.1 EasyConfig but had to switch to a
    `CMakeMake` build process.

  * The new EasyBuilders EasyConfig also includes `nlohmann_json` as a dependency
    which we do not yet have.



