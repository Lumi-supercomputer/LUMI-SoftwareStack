# libevent

  * [libevent home page](https://libevent.org/)

  * [libevent development on GitHub](https://github.com/libevent/libevent)

      * [GitHub releases](https://github.com/libevent/libevent/releases)


## EasyBuild

  * [libevent in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libevent)

  * [libevent in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/l/libevent)


### Version 2.1.12 from CPE 21.06 on

  * The EasyConfig was derived from the EasyBuilder one with some input from the
    University of Antwerpen one and additional checks.

  * For LUMI/23.12, license information was added to the installation.
  
  * In LUMI/23.12 and 24.03, we needed to disable support for OpenSSL as it failed 
    to compile when preparing the build in containers.
    