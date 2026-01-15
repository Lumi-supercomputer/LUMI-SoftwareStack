# libxml2

-   [libxlm2 home page](http://xmlsoft.org/)

-   [Source downloads from gnome.org](https://download.gnome.org/sources/libxml2/)


## EasyBuild


-   [libxml2 support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libxml2)

-   [libxml2 support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/l/libxml2)


### Version 2.9.12 from CPE 21.06 on

-   The EasyConfig is derived from the University of Antwerpen one as that one does
    a more complete build of libxml2 with additional dependencies that the configure
    process searches for and may otherwise pick from the system. Additional sanity checks
    were also added.


### Version 2.9.14 from CPE 22.12 on

-   The EasyConfig is a port from the 2.9.12 one but with a new download location as 
    the old download location doesn't contain the latest versions anymore.


### Version 2.11.4 from CPE 23.09 on

-   Trivial version bump of the 2.9.14 EasyConfig.
  
-   But needed to explicitly enable static libraries in this version.

-   For LUMI/23.12, license information was added to the installation.


### Version 2.11.5 for LUMI/24.03

-   Trivial version bump of the EasyConfig for 2.11.4.


### Version 2.13.4 for LUMI/25.03

-   Trivial version bump of the EasyConfig for 2.11.5.


### Version 2.15.1 for LUMI/25.09

-   Trivial version bump of the EasyConfig for 2.13.4 in 25.03.

