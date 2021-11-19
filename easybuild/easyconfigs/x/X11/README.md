# X11 bundle

This is a bundle of X11 tools provided by EasyBuild.

## EasyBuild

  * [X11 bundle in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/main/easybuild/easyconfigs/x/X11)

  * The X11 bundle is not in the CSCS repository.


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

