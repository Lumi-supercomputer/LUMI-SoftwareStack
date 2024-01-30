# bzip2

  * [bzip2 home page at sourceware.org](https://www.sourceware.org/bzip2/)

  * [Old bzip2 home page](http://www.bzip2.org/)

  * [bzip2 download site](https://sourceware.org/pub/bzip2/)


## EasyBuild

  * [bzip2 support in the EasyBuilders repository]()

  * [bzip2 support in the CSCS repository]()


### Version 1.08 from CPE 21.06 on

  * The EasyConfig is based on an EasyConfig and patch from the EasyBuilders
    repository with additional documentation from UAntwerpen.

    The patch replaces work done with ``postinstallcmds`` in the CSCS EasyConfig.

    At the time of development, the patch used by the build recipes in the EasyBuilders
    repository contained a bug. The patch in this repository is already a corrected
    one and a bug report was submitted. We also modified the home page to a new one.

  * Switched to the modified way of specifying checksums from 22.12 on.

  * From 23.12 on: We now also copy the LICENSE file.
