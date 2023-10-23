# EasyBuild for LUMI

-   [Main EasyBuild web site with links to documentation and sources](https://easybuild.io/)

-   PyPi:

    -   [easybuild install package](https://pypi.org/project/easybuild/)

    -   [easybuild-framework](https://pypi.org/project/easybuild-framework/)

    -   [easybuild-easyblocks](https://pypi.org/project/easybuild-easyblocks/)

    -   [easybuild-easyconfigs](https://pypi.org/project/easybuild-easyconfigs/)


## EasyBuild

-   [EasyBuild EasyConfigs in the easybuilders repo](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/e/EasyBuild)

### Version 4.4.2 for LUMI/21.08

-   Started from the default EasyConfig but added additional help information
    to the module file.


### Version 4.5.3 for LUMI/21.12

-   We activated the new feature to show a progress bar and also added support
    for `archspec`. This is done by adding additional packages via extensions
    in the EasyConfig. It is a very fragile combination though, only very
    specific combinations of version worked.


### Version 4.6.0 for LUMI/22.06 and LUMI/22.08

-   The additional packages that are used to activate `archspec` in EasyBuild
    and to provide the progress bar are a very fragile mix. Updating any of them
    to newer versions didn't work, maybe due to the lack of `pip` and the very
    old version of `python` as the system Python.

### Version 4.7.1 for LUMI/22.12 and LUMI/23.03

-   Trivial port of the 4.6.0 EasyConfig.


### Version 4.8.1 for LUMI/23.09

-   Trivial port of the 4.7.1 EasyConfig.

