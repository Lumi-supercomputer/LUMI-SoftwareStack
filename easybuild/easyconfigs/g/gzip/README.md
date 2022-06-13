# gzip

  * [gzip home page on gnu,org](https://www.gnu.org/software/gzip/)

      * [Download gzip from the GNU site](https://ftp.gnu.org/gnu/gzip/)

  * [Alternative gzip home page at gzip.org](https://www.gzip.org/)

## EasyBuild

  * [gzip support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/g/gzip)

  * There is no gzip in the CSCS repository

#### 1.10 from CPE 21.06 on

  * Standard EasyConfig converted to the LUMI conventions.

  * On Cray one of the tests in configure fails on LUMI/C. This is because
    the compiler always prints a message that znver3 is not yet supported
    for optimisation. There are two possible solutions
      * Either change some modules so that crape-x86-rome is loaded on all
        LUMI nodes until the Cray compiler supports zen3, which is tricky as
        it is likely EasyBuild has the last word and that option is the same
        for all Cray environments.
      * Disable the warning via extra_cflags which is what we have done here.

