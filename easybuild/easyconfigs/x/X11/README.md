# X11 bundle

This is a bundle of X11 tools provided by EasyBuild.

## EasyBuild

  * [X11 bundle in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/x/X11)

  * The X11 bundle is not in the CSCS repository.

### Own components in some version

  * [libXaw3d](https://www.x.org/releases/individual/lib/)

  * [libdrm](http://dri.freedesktop.org/libdrm/)

  * [DBus](http://dbus.freedesktop.org/releases/dbus)

  * [xprop](https://www.x.org/archive/individual/app/)

  * [xdpyinfo](https://www.x.org/archive/individual/app/)

  * [x11perf](https://www.x.org/archive/individual/app/)

  * [xauth](https://www.x.org/archive/individual/app/)


### Bundle for 21.06

  * The bundle is taken from the 20210802 one from the EasyBuilders repository.
    We did add some additional packages to save on dependencies for some other packages:
    xprop, ldrm and DBus.


### Bundle for 21.08

  * Same software versions as for 21.06, we did not check them again.

  * However, some modules were added with a library that was needed
    for some contributed software, and some tools to quickly check if
    an X11 connection is functional such as xdpyinfo and x11perf.
    xauth was also added in case this would still be useful for some
    users.


### Bundle for 21.12

  * Components taken from the 2021b bundle with own additions at the end.


### Bundle for 22.06 and 22.08

  * Started from the 21.12 bundle, but updated the packages with those of the
    GCCcore/11.3.0 - 2022a bundle. Also updated the local additions.


### Bundle for 22.12 and 23.03

  * Started from the 22.08 bundle, but updated the packages with those of the
    GCCcore/12.2.0 - 2022b bundle. Also updated the local additions.
    
  * Added xterm to the bundle.

