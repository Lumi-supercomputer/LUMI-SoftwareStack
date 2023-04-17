# libjpeg-turbo

  * [libjpeg-turbo on GitHub](https://github.com/libjpeg-turbo/libjpeg-turbo)

      * [ GitHub releases](https://github.com/libjpeg-turbo/libjpeg-turbo/releases)

  * [libjpeg-turbo on SourceForge](https://sourceforge.net/projects/libjpeg-turbo/)

## EasyBuild

  * [libjpeg-turbo in the EasyBuilders repository]()

  * [libjpeg-turbo in the CSCS repository]()


### Version 2.1.0 from CPE 21.06 on

  * The EasyConfig is a mix derived from various sources but mostly from the one in
    use at the University of Antwerpen. Some changes:

      * NASM is only included as a build dependency as it is not clear where it is
        is used at runtime. In the documentation I can only find that it is used to
        compile some x86-specific code in the source.

      * Switched to GitHub as the source of the files and the home page.


### Version 2.1.3 from CPE 22.06 on

  * Trivial version bump,

  * Added some sanity_check_commands, but this may not be that useful as there is a 
    testing procedure during the build.

    
### Version 2.1.4 from CPE 22.12 on

  * Trivial version bump of the 2.1.3 EasyConfig.


