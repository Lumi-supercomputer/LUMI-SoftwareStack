# Pango instructions

-   [Pango web site](http://www.pango.org/)

-   [Pango on the Gnome GitLab](https://gitlab.gnome.org/GNOME/pango)

    -   [Pango releases](https://gitlab.gnome.org/GNOME/pango/-/tags)


## EasyBuild

-   [Pango support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/p/Pango)

-   There is no support for Pango in the CSCS repository


### Version 1.48.10 for cpe 21.08

-   Started from the UAntwerpen EasyConfig file which is mostly equivalent to
    the EasyBuilders one.


### Version 1.50.7 from CPE 22.06 on

-   Trivial version bump of the 1.48.10 EasyConfig.


### Version 1.50.12 from CPE 22.12 on

-   Trivial version bump of the 1.50.7 EasyConfig.


### Version 1.50.14 from CPE 23.09 on

-   Trivial version bump of the 1.50.12 EasyConfig.

-   For LUMI/23.12, license information was added to the installation.

  
### Version 1.51.0 for LUMI/24.03

-   Trivial port of the EasyConfig for version 1.50.14 in LUMI/24.03.


### Version 1.56.3 for 25.03

-   Trivial version update of the EasyConfig for version 1.51.0 in 24.03/24.11.

-   Made some layout improvements. We also made the sanity checks a lot tougher.
    
-   Removed the explicit path addition to `XDG_DATA_DIRS` as EasyBuild does this
    automatically. This removed a warning.


### Version 1.57.0 for 25.09

-   Trivial version update of the EasyConfig for version 1.56.3 in 25.03.

