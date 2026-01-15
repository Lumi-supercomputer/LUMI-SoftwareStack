#cURL

-   [cURL home page](https://curl.se/)

    -   [cURL downloads](https://curl.se/download/)


## EasyBuild

-   [cURL support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/c/cURL)

-   [cURL support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/c/cURL)


### Version 7.78.0 in CPE 21.06

-   The EasyConfig file is a mix of the EasyBuilders one and the one in use at the
    University of Antwerpen.

-   There was a new configure option for 7.78.0: a range of options to select the right
    TLS backend, so this has been added to the EasyConfig file.

-   Added additional sanity check commands to the file.


### Version 7.83.1 for LUMI/22.06

-   Trivial update of the EasyConfig, we did not check for new features that could be
    exploited via additional dependencies.


### Version 7.86.0 for CPE 22.12 and later

-   Trivial update of the EasyConfig, we did not check for new features that could be
    exploited via additional dependencies.


### Version 8.0.1 from CP 23.09 on

-   Version bump to 8.0.1 to follow 2023a, but trivial for the EasyConfig.

-   Fro LUMI 23.12/ license information was added.


### Version 8.3.0 for LUMI/24.03

-   Started from a version bump of the 8.0.1 EasyConfig for LUMI/23.12.
  
-   New dependency: libpsl.


### Version 8.11.1 for 25.03

-   Not the most recent version, but this one aligns with the 2025a toolchains.

-   Trivial port of the EasyConfig for 8.3.0 for 24.03/24.11.


### Version 8.17.0 for 25.09

-   Trivial port of the EasyConfig for 8.11.1 for 25.03.

