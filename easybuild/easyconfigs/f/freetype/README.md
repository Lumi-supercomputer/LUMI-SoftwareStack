# freetype

  * [FreeType home page](https://www.freetype.org/)

  * [FreeType downloads](https://download.savannah.gnu.org/releases/freetype/)


## EasyBuild

  * [freetype in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/f/freetype)

  * [freetype in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/f/freetype)


### Version 2.10.4 from CPE 21.06 on

  * The EasyConfig is derived from the EasyBuilders one with documentation taken
    from the University of Antwerpen one.


### Version 2.11.0 from 21.12 on

  * Straightforward port of the 2.10.4 one.

### Version 2.12.1 from CPE 22.06 on

  * Started with a straightforward port of the 2.11.0 one.

  * Dependency check

      * Brotli added.

      * Can use harfbuzz but this was not added as a dependency as that requires a 
        complete reorganisation of the build process, and it is also a circular
        dependency.

      * Gnome librsvg not added as a dependency as that pulls in a lot of 
        annoying dependencies, and there seems to be a circular dependency with
        freetype.

