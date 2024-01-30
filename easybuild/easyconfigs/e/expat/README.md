# expat

  * [expat home page on github.io](https://libexpat.github.io/)

  * [expat on GitHub](https://github.com/libexpat/libexpat)

      * [GitHub releases](https://github.com/libexpat/libexpat/releases)

## EasyBuild

  * [expat support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/e/expat)

  * [expat support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/e/expat)


### Version 2.4.1 from CPE 21.06 on

  * The EasyConfig is a mix of the default EasyBuilders one with some extensions
    taken from the University of Antwerpen one.


### Version 2.4.6 from CPE 21.12 on

  * Rather than following the 2021b common toolchain versions for 21.12, we chose
    to upgrade expat to the latest available version due to a security vulnerability
    present in version up to 2.4.2.

  * Also switched to downloading from GitHub rather than from SourceForge


### Version 2.4.8 from CPE 22.06 on

  * Trivial port of the EasyConfig


### Version 2.4.9 from CPE 22.12 on

  * Trivial port of the EasyConfig, with one additional configopt ( `--without-docbook`)
    taken from the 2022b EasyBuilders recipes.


### Version 2.5.0 from CPE 23.09 on

  * Version bump to align with 2023a, trivial.

  * For LUMI/23.12: Add license information to the installation.
