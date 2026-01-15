# FFmpeg instructions

-   [FFmpeg home page](https://ffmpeg.org/)

-   [FFmpeg internal git](https://git.ffmpeg.org/gitweb/ffmpeg.git)


## EasyBuild

-   [FFmpeg support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/f/FFmpeg)

-   [FFmpeg support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/f/FFmpeg)

Note: It is not clear is NASM is really a dependency. From the documentation it looks
like it is only needed at build time so it appears to be wrongly marked as a dependency
in EasyBuild.

### 4.3.3 for CPE 21.08

-   We started from the EasyBuilders ones as those seem to be a lot more complete
    at least in the list of dependencies. It may be that this only influences
    the executables and not the libraries though.

-   Issues:

    -   Not tested yet with the AMD compiler.

    -   Crashes the Cray compiler

### Version 5.0.1 for CPE 22.06

-   We started from a version bump of the 4.3.3 EasyConfig.


### Version 5.1.2 from CPE 22.12 on

-   Almost trivial port of the 5.0.1 EasyConfig.
  
-   Note that we explicitly exclude the SDL2 dependency that is used in the EasyBuilders
    repository as SDL2 uses DBus and hence may not work on the compute nodes.

-   FFmpeg 5.1.2 causes a compiler crash in CCE 15.0.0, but that issue seems to be
    resolved in 15.0.1.


### Version 6.0 from 23.09 on

-   Fairly trivial port of the 5.1.2 EasyConfig

  
### Version 6.1.1 from 23.12 on

-   Trivial version bump of 6.0.
  
-   But we added license information to the installation directories.

-   For 24.11, we disabled some forms of help generation as they failed in the 24.11 
    container that we used during development, and switched to a more readable form
    of specifying configopts.

    
### Version 7.1.1 for 25.03

-   The EasyConfig is a straightforward port of the 6.1.1 for 24.03/24.11.

-   SDL2, a dependency in the EasyBuilders version, was still deliberately left
    out, also because a full-featured version may actually require building on top
    of the LUMI-D stack.


### Version 7.1.3 for 25.09

-   The EasyConfig is a straightforward port of the 7.1.1 EasyConfig for 25.03.

