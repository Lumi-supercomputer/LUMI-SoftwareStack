# GLib

  * [GLib home as part ot the GTK project](https://www.gtk.org/)

  * [GLib downloads (local_libiconv_version)](https://download.gnome.org/sources/glib/)


## EasyBuild

  * [GLib in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/g/GLib)

  * [GLib in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/g/GLib)


### 2.69.1 for CPE 21.06

  * Started from a mix of the EasyBuilders and University of Antwerpen
    EasyConfig files

  * An additional dependency was needed: libiconv.

  * NOTE 2021-12-06: Replaced PCRE2 dependency with PCRE dependency as it turned out
    that GLib downloaded PCRE during the installation process.


### Version 2.73.0 from CPE 22.06 on

  * Trivial version bump of the 2.69.1 one.


### Version 2.75.0 from CPE 22.12 on

  * Almost trivial version bump of the 2.73.0 one, 
  
      * but switched from PCRE to PCRE2
      
      * and trying the new fix_python_shebang_for option.


### Version 2.77.1 from CPE 23.03 on

  * Trivial version bump of the 2.75.0 one.

  * But it looks like the iconv flag is no longer supported, so remove this.
  
  * **Note:** Even though GLib itself installs fine with Clang 16, it looks like
    using its header files causes problems reporting type cast errors that 
    seem impossible to turn off.
