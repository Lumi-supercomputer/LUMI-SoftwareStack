# DBus technical information

-   [DBus website](https://dbus.freedesktop.org/)

    -   [DBus releases on the DBus website](https://dbus.freedesktop.org/releases/dbus/)

    
## EasyBuild

-   [DBus support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/d/DBus)

-   There is no support for DBus in the CSCS repository

-   [dbus support in Spack](https://packages.spack.io/package.html?name=dbus)    


### 1.15.8 for cpeGNU 24.03

-   The EasyConfig is derived from the EasyBuilders one but in the LUST layout.

-   Needed to add the configure option `-D ENABLE_SYSTEMD=OFF`.
