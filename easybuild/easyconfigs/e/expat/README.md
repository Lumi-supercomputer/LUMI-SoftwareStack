# expat

-   [expat home page on github.io](https://libexpat.github.io/)

-   [expat on GitHub](https://github.com/libexpat/libexpat)

    -   [GitHub releases](https://github.com/libexpat/libexpat/releases)

## EasyBuild

-   [expat support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/e/expat)

-   [expat support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/e/expat)


### Version 2.4.1 from CPE 21.06 on

-   The EasyConfig is a mix of the default EasyBuilders one with some extensions
    taken from the University of Antwerpen one.


### Version 2.4.6 from CPE 21.12 on

-   Rather than following the 2021b common toolchain versions for 21.12, we chose
    to upgrade expat to the latest available version due to a security vulnerability
    present in version up to 2.4.2.

-   Also switched to downloading from GitHub rather than from SourceForge


### Version 2.4.8 from CPE 22.06 on

-   Trivial port of the EasyConfig


### Version 2.4.9 from CPE 22.12 on

-   Trivial port of the EasyConfig, with one additional configopt ( `--without-docbook`)
    taken from the 2022b EasyBuilders recipes.


### Version 2.5.0 from CPE 23.09 on

-   Version bump to align with 2023a, trivial.


### Version 2.6.2 from CPE 23.12 on

-   One of the few packages that we upgraded between 23.09 and 23.12 due to security 
    concerns.

-   Starting from a trivial port, but adding more license info to the installation.


### Version 2.6.4 from CPE 25.03 on

-   Trivial version bump of the last EasyConfigs for 2.6.2.


### Version 2.7.3 from CPE 25.09 on

-   Trivial version bump of the EasyConfig for 2.6.4 in 25.03.
  
  