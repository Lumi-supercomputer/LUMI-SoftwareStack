# oneTBB technical information

-   [oneTBB GitHub](https://github.com/uxlfoundation/oneTBB)
    
    -   [oneTBB GitHub releases](https://github.com/uxlfoundation/oneTBB/releases)


## EasyBuild

The oneTBB package is often also just known as TBB or tbb.

-   [tbb package in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/t/tbb)
    
-   There is no support in the CSCS repository.

-   [tbb package in the JSC repository](https://github.com/easybuilders/JSC/tree/2025/Golden_Repo/t/tbb)
    
-   [intel-oneapi-tbb package in Spack](https://packages.spack.io/package.html?name=intel-oneapi-tbb)


### Version 2021.13.0 for cpeGNU/24.03

-   The EasyConfig is derived from the JSC one.
    

### Version 2022.2.0 for cpeGNU/25.03

-   We would have preferred to stay with the older 2021.13.0 version, but that version
    gave issues with gcc 14.2.
    
-   The upgrade is otherwise a trivial upgrade of the 2021.13.0 EasyConfig for 24.03.


### Version 2022.3.0 for 25.09

-   Trivial port of the EasyConfig for 2022.2.0 in 25.03.

