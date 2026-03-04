# libxml2

-   [libxslt home page](http://xmlsoft.org/xslt)

    -   [download link](http://xmlsoft.org/sources/)

## EasyBuild


-   [libxslt support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libxslt)

-   There is no support for libxslt in the CSCS repository


### Version 1.1.34 from CPE 21.06 on

-   The EasyConfig file is a mix of the EasyBuilders and University of
    Antwerpen ones with extra sanity checks.


### Version 1.1.37 from CPE 22.12 on

-   Port of the 1.1.34 one, but with two changes made based on the version in the
    EasyBuilders repository:
    
    -   Different set of sources (similar as the change to libxml2)
      
    -   Added the configuration options `--with-crypto=no --with-python=no` to ensure
        that the system Python and a potential sysstem libgcrypt would not be picked up.


### Version 1.1.38 from CPE 23.09 on

-   Trivial version bump of the 1.1.37 EasyConfig.

-   For LUMI/23.12, license information was added to the installation, and we also 
    build both shared and static libraries.

    
### Version 1.1.42 from CPE 25.03 on

-   Trivial version bump of the 1.1.38 EasyConfig.


### Version 1.1.45 from CPE 25.09 on

-   Trivial version bump of the 1.1.42 EasyConfig.

-   Needed to adapt the list of files to copy to the licenses directory.
