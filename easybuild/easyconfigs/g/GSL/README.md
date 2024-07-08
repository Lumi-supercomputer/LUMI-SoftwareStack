# GSL

  * [GSL home page](https://www.gnu.org/software/gsl/)

      * [GSL download from the GNU server](https://ftp.gnu.org/gnu/gsl/)

## EasyBuild

  * [GSL support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/g/GSL)

  * [GSL support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/g/GSL)

### Version 2.7 from CPE 21.06 on

  * The EasyConfig is a mix of the CSCS and Univerity of Antwerpen ones.

### Version 2.7.1 from CPE 22.06 on

  * Build on the previous EasyConfig.

  * There are now versions with OpenMP enabled and without. When in doubt which one to use: One
    should never combine code compiled with the OpenMP version of LibSci with code with the 
    sequential version (or likely any code compiled without OpenMP) as this causes runtime crashed.

  * For LUMI/23.12, additional license information was added to the installation.
