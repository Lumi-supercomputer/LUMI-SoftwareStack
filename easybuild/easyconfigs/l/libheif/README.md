# libheif technical information

-   [libheif on GtHub](https://github.com/strukturag/libheif)

    -   [GitHub releases](https://github.com/strukturag/libheif/releases)


## Chosen configuration

-   SDL2 deliberately not supported as it is an input library for interactive use.
    We also do not support the `Gdk-Pixbuf` dependency that can be found in the EasyBuilders
    configuration as that may even make the package impossible to build with other compilers
    than the GNU compilers.

-   But after inspecting the output of the configure phase, we do include a lot more dependencies
    than the EasyBuilders version.

-   We did not include FFmpeg though as it would make this move even further down the build chain
    and as the documentation suggests that FFmpeg is mostly useful when hardware acceleration can
    be used, which is currently not the case on LUMI.


## EasyBuild

-   [libheif in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libheif)


### Version 1.23.1

-   Started from the configuration in the EasyBuilders repository, adapted to LUMI, but omitted the
    `Gdk-Pixbuf` dependency as that brings in too much junk.

-   Then based on the output of the configure step, added several other dependencies that are easy
    to build or were already available to add additional supported formats.
