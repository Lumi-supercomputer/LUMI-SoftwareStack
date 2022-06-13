# GMP instructions

  * [Home page](https://gmplib.org/)
  * [GMP uses Mercurial for code development](https://gmplib.org/repo/)


## EasyBuild support

  * [GMP in the EasyBuilders repositories](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/g/GMP).

  * [GMP in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/g/GMP)

There is a difference in settings:

  * The CSCS version does not enable the C++ interfaces

  * Different toolchain options:

      * CSCS: ``toolchainopts = {'lowopt': True}``, and further down the EasyConfig
        file ``-mcmodel=large`` is added to the C compiler flags.

      * EasyBuilders: ``toolchainopts = {'precise': True, 'pic': True}``

    One of the differences is that with the CSCS EasyConfig ``-O1`` is used while with
    the EasyBuilders EasyConfig ``-O2 --ftree-vectorize`` is used. As the manual suggests
    to use ``-O2`` with gcc when compiling GMP, we followed the EasyBuilders settings.
    However, we do keep the the ``-mcmodel=large`` flag as it was likely added from
    experiences that are still valid.

### Differences between toolchains

  * ``cpeAMD`` generates an unused option warning when ``-mcmodel=large`` is used so
    it is omitted from the options in the ``cpeAMD`` version.

### Version 6.2.1 from CPE 21.06 on

  * The EasyConfig file is a mix of the CSCS one and one at use in the University of
    Antwerpen with more built-in checks, and some further sanity checks were added.

  * Check in the log files for the results of the test suite: Grep for "Testsuite",
    and there are multiple such tables.

