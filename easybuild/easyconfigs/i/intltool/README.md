# intltool

A tool usually used as a build dependency so we may consider building it in a
different way to avoid multiple installations? It is used. e.g., in the installation
of certain X11 libraries.

  * [intltool home page](https://freedesktop.org/wiki/Software/intltool/)

  * [Downloads]](https://launchpad.net/intltool/+download)


## Installation

  * intltool needs the Perl package XML::Parser during installation.


## EasyBuild

  * [intltool support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/main/easybuild/easyconfigs/i/intltool)

  * There is no support for intltool in the CSCS repository


### Version 0.51.0 from CPE 21.06 onwards.

  * The EasyConfig is taken from the EasyBuilders repository with documentation
    from the University of Antwerpen added to it.

  * On eiger the Perl package XML::Parser is actually installed in the system Perl
    so we may be able to build without the EasyBuild Perl as a dependency. However,
    for now we avoid this as we do not know what the situation on LUMI will be.
