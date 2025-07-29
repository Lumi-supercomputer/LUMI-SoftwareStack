# pixman

-   [pixman home page](http://www.pixman.org/)

    -   [pixman downloads](https://www.cairographics.org/releases/)

## EasyBuild

-   [pixman in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/p/pixman)

-   [pixman in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/p/pixman)


### 0.40.0 from CPE 21.06 on

-   The EasyConfig is derived from the University of Antwerpen one which itself
    is a variant of the default EasyBuilders one.

-   From LUMI/23.12 on, license information was added to the installation.

-   Stuck to 0.42.2 for 25.03 even though 2025a uses 0.46.2. The latter version makes 
    Meson and Ninja mandatory and after an hour of work still did not compile properly
    with the AMD ROCm compiler and this is at least parly due to dirty code.
  