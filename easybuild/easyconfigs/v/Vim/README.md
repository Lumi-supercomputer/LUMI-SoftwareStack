# Vim instructions

  * [Vim web site](https://www.vim.org/)

  * [Vim on GitHub](https://github.com/vim/vim)

      * There are no formal releases, but lots of tags with a patch release almost
        every week.


## EasyBuild

  * [Vim support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/v/Vim)

  * [Vim support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/v/Vim)


### Version 8.2.3852 for LUMI/21.08

  * EasyConfig derived from the CSCS one and adapted to our needs.

  * Build with our syslibs module of static libraries to have minimal runtime
    dependencies.


### Version 8.2.4487 for LUMI/21.12

  * Trivial port of the 8.2.3852 version


### Version 8.2.5172 for LUMI/22.06

  * Trivial port of the 8.2.4487 version. This is likely the final 8.2 version.


### Version 9.0.0016 for LUMI/22.06

  * Turned out to be an almost trivial port, though options of the configure script
    were checked and a few more enabled.

### Version 9.0.0193 for LUMI/22.08

  * Trivial port of the 9.0.0016 EasyConfig.

### Version 9.0.1392 for 22.12/23.03

  * Trivial port of the 9.0.0193 EasyConfig with some layout changes.

### Version 9.0.2059 for 23.09

  * Trivial port of the 9.0.1392 EasyConfig


### Version 9.1.0050 for 23.12
  
  * Trivial port of previous EasyConfigs  