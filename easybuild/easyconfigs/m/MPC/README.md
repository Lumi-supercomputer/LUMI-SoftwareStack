# MPC

  * [MPC home page](http://www.multiprecision.org/mpc/)

  * [Download from GNU](https://ftp.gnu.org/gnu/mpc/)

  * [MPC source development is hosted in the INRIA GitLab](https://gitlab.inria.fr/mpc/mpc)


## Issues

  * MPC does build a mpc.pc file for pkg-config (at least not in 1.2.1 or earlier)


## EasyBuild

  * [MPC in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/m/MPC)

  * There is no support for MPC in the CSCS repository


### Version 1.2.1 from CPE 21.06 on

  * The EasyConfig is a mix of the EasyBuilders and University of Antwerpen versions,
    with improved URLs and help information.

  * To find the test results in the log files, grep for "Testsuite".

    **NOTE:** When compiled with cpeCray or cpeAMD two of the tests are skipped, while
    in the cpeGNU versions all tests pass.
