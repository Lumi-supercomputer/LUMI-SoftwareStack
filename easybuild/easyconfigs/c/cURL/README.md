#cURL

  * [cURL home page](https://curl.se/)

      * [cURL downloads](https://curl.se/download/)


## EasyBuild

  * [cURL support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/c/cURL)

  * [cURL support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/c/cURL)


### Version 7.78.0 in CPE 21.06

  * The EasyConfig file is a mix of the EasyBuilders one and the one in use at the
    University of Antwerpen.

  * There was a new configure option for 7.78.0: a range of options to select the right
    TLS backend, so this has been added to the EasyConfig file.

  * Added additional sanity check commands to the file.

### Version 7.83.1 for LUMI/22.06

  * Trivial update of the EasyConfig, we did not check for new features that could be
    exploited via additional dependencies.

