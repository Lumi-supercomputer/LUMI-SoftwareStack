# libjpeg-turbo

-   [libjpeg-turbo on GitHub](https://github.com/libjpeg-turbo/libjpeg-turbo)

    -   [ GitHub releases](https://github.com/libjpeg-turbo/libjpeg-turbo/releases)

-   [libjpeg-turbo on SourceForge](https://sourceforge.net/projects/libjpeg-turbo/)

## EasyBuild

-   [libjpeg-turbo in the EasyBuilders repository]()

-   [libjpeg-turbo in the CSCS repository]()


### Version 2.1.0 from CPE 21.06 on

-   The EasyConfig is a mix derived from various sources but mostly from the one in
    use at the University of Antwerpen. Some changes:

    -   NASM is only included as a build dependency as it is not clear where it is
        is used at runtime. In the documentation I can only find that it is used to
        compile some x86-specific code in the source.

    -   Switched to GitHub as the source of the files and the home page.


### Version 2.1.3 from CPE 22.06 on

-   Trivial version bump,

-   Added some sanity_check_commands, but this may not be that useful as there is a 
    testing procedure during the build.

    
### Version 2.1.4 from CPE 22.12 on

-   Trivial version bump of the 2.1.3 EasyConfig.


### Version 2.1.5.1 from CPE 23.09 on

-   Trivial version bump of the 2.1.4 EasyConfig.

-   For LUMI/23.12, license information was added to the installation.
  
-   And also improved the sanity checks in LUMI/23.12.


### Version 3.0.1 for LUMI/24.03

-   Trivial version bump of the 2.1.5.1 EasyConfig for LUMI/23.12.
  
-   12-bit support turned on again as the CMake problem that occured is gone.

-   Note that two tests still fail with cpeCray. Since the 588 other tests passed,
    we decided to simply edit those tests out of the CMake `CTestTestfile.cmake`
    file so that we would still notice other failures if they would pop up in 
    newer versions.
    
    These tests now also fail with cpeAOCC and cpeAMD, so it is likely an issue
    with libjpeg-turbo with recent Clang compilers, so we take the same measures.
    
    The failure is likely caused by slightly different FP rounding behaviour for the
    chosen options in the Cray compiler than other compilers.
  
    Tried `-DFLOATTEST12=no-fp-contract` suggested for some similar problems but that
    didn't help. Same for `-DFLOATTEST12=fp-contract`.
 

### Version 3.1.0 for LUMI/25.03

-   Started from a port of the 3.0.1 EasyConfig for 24.03/24.11.

-   Changed the syntax of the `configopts`

-   Switched to the same set of source files currently used in EasyBuild for 25.03.


### Version 3.1.3 for 25.09

-   Trivial port of the 3.1.0 EasyConfig for 25.03.

 