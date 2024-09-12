# Subversion instructions

  * [Subversion home page](https://subversion.apache.org/)

      * [Source download for version check](https://subversion.apache.org/download.cgi)


## EasyBuild

  * [Subversion support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/s/Subversion)

  * [Subversion support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/s/Subversion)

  * [Subversion support in Spack](https://github.com/spack/spack/tree/develop/var/spack/repos/builtin/packages/subversion)


### Subversion 1.14.1 for SYSTEM in LUMI/21.08 and LUMI/21.12.

  * Development started from the CSCS setup.

  * Getting the dependencies to compile and find each other was a bit of a pain,
    follow in our [background repository](https://github.com/Lumi-supercomputer/LUMI-EasyBuild-background).
    In particular the compilation of Serf turned out to be rather difficult as it failed
    to find the expat libraries when not included in a bundle with APR and APR-util,
    probably because they were included as build dependencies and EasyBuild didn't
    set all variables, but this is not sure.


### Subversion 1.14.2 for SYSTEM in LUMI/22.06

  * Straightforward port from the 1.14.1 EasyConfig

  * Added checksum to robustify the installation on LUMI.


### Subversion 1.14.3 for SYSTEM in 23.12/24.03

  * Straightforward port from the 1.14.2 EasyConfig.
