# x265

-   [x265 home page](https://www.x265.org/) - It looks likes it misses
    some updates, the wiki mentioned below may be the better choice?

-   [x265 on BitBucket](https://bitbucket.org/multicoreware/x265_git/src/master/)

    -   [x265 wiki on BitBucket](https://bitbucket.org/multicoreware/x265_git/wiki/Home)

    -   [BitBucket downloads](https://bitbucket.org/multicoreware/x265_git/downloads/)

## EasyBuild

-   [x265 support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/x/x265)

-   [x265 support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/x/x265)


### Version 3.5 from CPE 21.06 on

-   The EasyConfig is a mix of the University of Antwerpen one and the
    EasyBuilders one.

    -   We did delete the numactl-devel OS dependency used in Antwerpen even
        though it may have a positive influence on the performance.

-   For LUMI/23.12, license information was added to the installation.


### Version 4.1 from 25.03 on

-   Almost trivial port of the EasyConfig for 3.5 for 24.03/24.11.

-   But added the 'configopts' parameter that is also used in the EasyBuilders repository.

-   It turns out that x265 is not compatible with CMake 4, so we had to prepare a special
    version of buildtools for now.
