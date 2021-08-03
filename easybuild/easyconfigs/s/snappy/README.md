# snappy instructions

  * [snappy on GitHub](https://github.com/google/snappy)
      * [Releases on GitHub](https://github.com/google/snappy/releases)

## General information

  * Snappy is build using CMake.
  * Snappy can use zlib and lzo2.
  * There are CMake flags to enforce AVX or AVX2 but it is not clear if these
    are needed as I cannot find where they define symbols that would then be
    used in the code. It does influence compiler options that are added though.
  * Note that building snappy requires two iterations if we want both static
    and shared libraries.

## EasyBuild

This README was developed starting with snappy 1.1.8 in the CPE 21.06.

  * [Support for snappy in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/s/snappy)
    but the dependencies are incomplete.

  * [Support for snappy in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/s/snappy)

### 1.1.8 from CPE 21.06 on.

  * We stuck to 1.1.8 even though 1.1.9 was out because in 1.1.9 the build process
    has changed and seems to require various Google tools.

  * This EasyConfig was made to prepare for inclusion in the baselibs Bundle.

  * The dependencies on zlib and LZO (lzo2) were added to the dependencies list to ensure
    a build with maximum potential.
