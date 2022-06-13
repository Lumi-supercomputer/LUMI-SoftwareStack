# GLib

  * [GLib home as part ot the GTK project](https://www.gtk.org/)

  * [GLib downloads](local_libiconv_version)


## EasyBuild

  * [GLib in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/g/GLib)

  * [GLib in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/g/GLib)


### 2.69.1 for CPE 21.06

  * Started from a mix of the EasyBuilders and University of Antwerpen
    EasyConfig files

  * An additional dependency was needed: libiconv.

  * NOTE 2021-12-06: Replaced PCRE2 dependency with PCRE dependency as it turned out
    that GLib downloaded PCRE during the installation process.
