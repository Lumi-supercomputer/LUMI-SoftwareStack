# wget

-   [GNU wget home page](https://www.gnu.org/software/wget/)

    -   [Download](https://ftp.gnu.org/gnu/wget/)

-   [GNU wget GitLab](https://gitlab.com/gnuwget/wget)


## EasyBuild

-   [wget in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/w/wget)

-   There is no support for wget in the CSCS repository.


### 1.21.1 from cpe 21.06 on

-   The EasyConfig is derived from the EasyBuilders one with documentation taken from
    the University of Antwerpen one.

-   On Cray one of the tests in configure fails on LUMI/C. This is because
    the compiler always prints a message that znver3 is not yet supported
    for optimisation. There are two possible solutions
    -   Either change some modules so that crape-x86-rome is loaded on all
        LUMI nodes until the Cray compiler supports zen3, which is tricky as
        it is likely EasyBuild has the last word and that option is the same
        for all Cray environments.
    -   Disable the warning via extra_cflags which is what we have done here.

### Version 1.21.2 for 21.12

-   Trivial port

### Version 1.21.3 for CPE 22.06

-   Trivial port

-   Added libpsl as a dependency. We do not use libmetalink though, and it looks
    like at least Red Hat linux wants to get rid of libmetalink.

-   For LUMI/23.12, license information was added to the installation.


### Version 1.21.4 for LUMI/24.03 and LUMI/24.11

-   Trivial port of the EasyConfig for version 1.21.3 in LUMI/23.12.


### Version 1.25.0 for LUMI/25.03

-   Trivial port of the EasyConfig for version 1.25.0 in 24.03/24.11.

