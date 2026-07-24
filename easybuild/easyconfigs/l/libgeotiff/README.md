# libgeotiff instructions

In the pre-installed stack since 26.03, before that it was a user-installable module.

-   [libgeotiff Wiki](https://directory.fsf.org/wiki/Libgeotiff)
    
-   [GeoTIFF web page](https://trac.osgeo.org/geotiff/)
    
-   [libgeotiff on GitHub](https://github.com/OSGeo/libgeotiff)
    
    -   [GitHub releases](https://github.com/OSGeo/libgeotiff)
    
    
## EasyBuild

-   [libgeotiff in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libgeotiff)
    
-   [libgeotiff in the CSCS repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libgeotiff)
    
    
### Version 1.7.1 for cpeGNU/22.08 and cpeGNU/23.09

-   The EasyConfig is derived from the EasyBuilders one.


### Version 1.7.3 for cpeGNU 24.03

-   Trivial port of the EasyConfig for 1.7.1 in 23.09.


### Version 1.7.4 for cpeGNU 25.03

-   Trivial port of the EasyConfig for 1.7.3 in 24.03.

-   Moved to the LUMI-SoftwareStack repository for 26.03. The EasyConfig parameters were changed 
    to those compatible with EB 6.

    We also discovered that some packages use the include files in the form `geotifff/geotiff.h`
    rather than `geotiff.h`, which we solved by creating additional symbolic links in 
    `post_install_cmds`.
