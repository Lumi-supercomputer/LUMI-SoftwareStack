# libffi

-   [libffi home page](https://sourceware.org/libffi/)

-   [libffi on GitHub](https://github.com/libffi/libffi)

    -   [GitHub releases](https://github.com/libffi/libffi/releases)


## EasyBuild

-   [libffi in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libffi)

-   [libffi in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/l/libffi)


### Version 3.4.2 from CPE 21.06 on

-   The EasyConfig is a mix of the EasyBuilders and University of Antwerpen one, with
    some important changes:

    -   Switch to GitHub as the download site

    -   Install libraries in lib instead of in lib64 as most other packages install in lib.

      
### Version 3.4.4 from CPE 22.12 on

-   The EasyConfig is a trivial port of the 3.4.2 one.
      
-   But added the `--disable-exec-static-tramp` that is also used in the EasyBuilders
    EasyConfig.
    
-   From LUMI/23.12 on, license information was added to the installation.


### Version 3.4.5 for 25.03

-   3.5.1 was out, but we decided to stick to 3.4.5 to allign with the 2025a toolchain.

-   Trivial port of the 3.4.4 EasyConfig for 24.03/24.11.

