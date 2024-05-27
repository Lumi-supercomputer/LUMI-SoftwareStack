# libb2

  * [libb2 on GitHub](https://github.com/BLAKE2/libb2)

      * [GitHub releases](https://github.com/BLAKE2/libb2/releases)

## EasyBuild

  * There is no support in the EasyBuilders repository

  * There is no support in the CSCS repository

### Version 0.98.1

  * The EasyConfig is an adaptation of an internal EasyConfig file from the
    University of Antwerpen. It is a straightforward configure - make - make
    install process.
    
  * For LUMI/23.12: 
  
      * Copy the license information to the installation directories,
        and improved sanity checks.
        
      * Use `--enable-native=no` to avoid adding `-march=native` to the compiler
        flags to improve cross-compiling.
