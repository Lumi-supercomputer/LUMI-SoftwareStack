# libcerf

-   [libderf home page on the Juelich GitLab](https://jugit.fz-juelich.de/mlz/libcerf)

    -   [Releases on the GitLab](https://jugit.fz-juelich.de/mlz/libcerf/-/releases)


## EasyBuild

-   [libcerf in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libcerf)

-   [libcerf in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/l/libcerf)


### Version 1.17 from CPE 21.06 on

-   The EasyConfig is derived from the EasyBuilders and University of Antwerpen ones
    with additional testing.

-   **NOTE: The build process also uses Perl which is currently taken from the system
    to avoid having to build an incomplete Perl that early in the build cycle.**


### Version 2.1 from CPE 22.06 on

-   Trivial update of the EasyConfig.


### Version 2.3 from CPE 22.12 on

-   Trivial update of the EasyConfig.

-   For LUMI 23.12, license information was added to the installation.


### Version 2.5 for 25.03

-   Even though 3.0 was out, we decided to stick with the last 2.x version as 
    the ABI has changed and that may break other installation scripts.
    
-   Hence a rather trivial port of the EasyConfig for 2.3 for 24.03/24.22.


### Version 3.3 for 25.09

-   Switching to a 3.X version as EasyBuild has also switched over.

-   Disabling running `pkg-config` for now as the structure of the .pc-file is not
    compatible with the command on LUMI.
