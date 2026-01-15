# PROJ instructions

-   [PROJ web site](https://proj.org/)

    -   [Download from the PROJ web site](https://proj.org/download.html)

-   [PROJ on GitHub](https://github.com/OSGeo/PROJ)

    -   [GitHub releases](https://github.com/OSGeo/PROJ/releases)


## EasyBuild

-   [PROJ support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/p/PROJ)

-   [PROJ support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/p/PROJ)


### Version 8.1.1 from 21.08 on

-   The EasyConfig file is a mix of the EasyBuilders and CSCS one. Specifically,
    an additional dependency (cURL) was taken from the EasyBuilders one.

-   The documentation was enhanced.

-   No version for cpeAMD as the indirect Tcl dependency does not compile with that
    compiler.

-   PROJ does contain a number of commands also but no easy way to test them like
    producing help or a version without producing an error code.


### Version 9.0.0 from CPE 22.06 on

-   Started from a version bump of the 8.1.1 EasyConfig but had to switch to a
    `CMakeMake` build process.

-   The new EasyBuilders EasyConfig also includes `nlohmann_json` as a dependency
    which we do not yet have.


### Version 9.1.1 from 22.12 on

-   Version bump of the 9.0.0 EasyConfig


### Version 9.2.0 from 23.09 on

-   Version bump of the 9.2.0 EasyConfig
  
-   Needed to add an option to avoid generating errors on unused arguments as somehow 
    some ROCm libraries get added that are not needed.

-   For LUMI/23.12, license information was added to the installation, and the 
    installation of the libraries is done in `lib` rather than `lib64`. Moreover,
    `nlohmann-json` was added as a dependency to enable using an external one,
    and `googletest` was added to the build dependencies as it turned out it was
    auto-downloaded otherwise during the build.
    
    Note that contrary to what is done in the EasyBuilders repository, we made
    `nlohmann-json` a build dependency as it is only some header files and no
    library or other stuff that is needed when running.


### Version 9.3.1 from LUMI/24.03 on

-   Version bump of the 9.2.0 EasyConfig for LUMI/23.12.


### Version 9.6.2 for 25.03

-   Straightforward port of the EasyConfig for 9.3.1 in 24.03/24.11, but some changes needed
    to the copying of the license files at the end.


### Version 9.7.0 for 25.09

-   Straightforward port of the EasyConfig for 9.6.2 in 25.03.

