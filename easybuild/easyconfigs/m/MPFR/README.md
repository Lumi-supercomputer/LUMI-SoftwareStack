# MPFR

-   [MPFR home page](https://www.mpfr.org/)

-   [Download from GNU](https://ftp.gnu.org/gnu/mpfr/)

-   [MPFR source development is hosted in the INRIA GitLab](https://gitlab.inria.fr/mpfr/mpfr)


## EasyBuild

-   [MPFR in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/m/MPFR)

-   [MPFR in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/m/MPFR)

### Version 4.1.0 from CPE 21.06 on

-   The EasyConfig is a mix of the EasyBuilders and University of Antwerpen versions.

-   To find the test results in the log files, grep for "Testsuite".

  -  *NOTE:** When compiled with cpeCray or cpeAMD two of the tests are skipped, while
    in the cpeGNU versions all tests pass.

 
### Version 4.2.0 from CPE 22.12 on

-   The easyConfig is a trivial port of the 4.1.0 one.

-   From LUMI/23.12 onwards, license information was added to the installationb.

-   Had to disable tests for cpeCray/23.12 as 3 tests failed (in addition to two tests
    that are skipped with clang-based compilers).

    
### Version 4.2.2 from 24.03 on

-   The EasyConfig is a trivial port of the 4.2.2 EasyCponfig for 24.03/24.11.
    