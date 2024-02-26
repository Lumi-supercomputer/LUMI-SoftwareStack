# EasyBuild-tools module

EasyBuild-tools offers a number of tools that EasyBuild expects from the OS for
processing some EasyConfigs, biut are not installed on LUMI. To avoid circular
dependencies it should not contain anything that EasyBuild needs for its own
bare installation and to install this module.

## Contents

| Package   | Remarks      | Version link |
|:----------|:-------------|:-------------|
| p7zip     | 23-09 -      |[version check](https://github.com/p7zip-project/p7zip/releases) |


### p7zip-specific information

The p7zip package is a POSIX/Linux port of some of the 
[p7zip Windows tools](https://www.7-zip.org/).
Note that the latest version of 7zip do now support Linux already.

The p7zip tools however are used in certain EasyConfigs to work with ISO files,
e.b., the [MATLAB EasyConfigs in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/m/MATLAB).

-   New developments [on GitHub](https://github.com/p7zip-project/p7zip/).
    It is a fork from previous versions that are no longer maintained.
    It also extends the tools of the [7zip project](https://sourceforge.net/projects/sevenzip/)

    -   [GitHub releases](https://github.com/p7zip-project/p7zip/releases)


-   Older versions [on SourceForge](https://p7zip.sourceforge.net/)

    -   [SourceForge downloads](https://sourceforge.net/projects/p7zip/files/p7zip/)
        (up to version 16.02)


## EasyBuild

-   [p7zip in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/p/p7zip)


### Version 23.09

-   First version of this bundle, with currently only p7zip that we
    needed for Matlab.
    
-   The p7zip installation procedure is taken from the EasyBuilders p7zip
    installation for version 17.04, but rewritten more fitting with more
    consistent use of quotes, etc., and specifying compiler variables
    specifically for LUMI. It also uses the SYSTEM toolchain rather than
    GCCcore.
 