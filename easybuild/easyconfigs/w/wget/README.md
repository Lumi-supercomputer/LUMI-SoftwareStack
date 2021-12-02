# wget

  * [GNU wget home page](https://www.gnu.org/software/wget/)

      * [Download](https://ftp.gnu.org/gnu/wget/)

## EAsyBuild

  * [wget in the EasyBuilders repository]()

  * There is no support for wget in the CSCS repository.


### 1.21.1 from cpe 21.06 on

  * The EasyConfig is derived from the EasyBuilders one with documentation taken from
    the University of Antwerpen one.

  * On Cray one of the tests in configure fails on LUMI/C. This is because
    the compiler always prints a message that znver3 is not yet supported
    for optimisation. There are two possible solutions
      * Either change some modules so that crape-x86-rome is loaded on all
        LUMI nodes until the Cray compiler supports zen3, which is tricky as
        it is likely EasyBuild has the last word and that option is the same
        for all Cray environments.
      * Disable the warning via extra_cflags which is what we have done here.

