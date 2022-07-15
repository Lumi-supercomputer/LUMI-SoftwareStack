# lumi-vnc instructions

Installs a singularity container with the TurboVNC server and some scripts and shell
functions to start and stop the server.

  * See the (currently private) repository [Lumi-supercomputer/utility-tools](https://github.com/Lumi-supercomputer/utility-tools)
    for the scripts and container definition.


## Instructions for system staff

  * It is not yet possible to build the container on LUMI. Hence it has to be build
    offline. The EasyConfig file then expects to find the container in a tar file
    in the root directory of that archive, with the tar file named
    `turbovnc-container-<version>.tar` with `<version>` the version used for the module.
    The container file itself is called `vnc.sif`. The tar file is used to be able
    to store different versions of the container in the sources directory to be able
    to reproduce older versions in case of problems.

    That tar-file should then be put in a location where EasyBuild can find it, e.g.,
    in `/appl/lumi/sources/easybuild/l/lumi-vnc` on uan04.

  * The EasyConfig file can then be used to install the TurboVNC container. Note though
    that downloading the sources if they are not yet in a location where EasyBuild
    can find them, e.g., in the directory mentioned above which is the master copy
    for the software installation.


## Instructions for users

### If the module is not already on the system...

The source files needed are provided on lumi-uan04 and will be found automatically
by EasyBuild when installing from that node. To install and make the software available
in the LUMI software stack (assuming software stack version 21.08):

```bash
ml LUMI/21.08 partition/common
ml EasyBuild-user
eb lumi-vnc/20220125
```

## If the module is already installed...

You can check if a lumi-vnc module is already installed using
```bash
module spider lumi-vnc
```

To know how to start the VNC server, check the help information included in the most
recent version of the module returned by the above `module spider` command. E.g., assuming
that version is 20220125:
```bash
module spider lumi-vnc/20220125
```


## Known issues

### Container cannot follow symbolic links to a different file system

It is not possible to test a user install of the VNC container if the software directory
or any other directory is soft-linked to a different file system (e.g., to have a
personal repository in your home directory but have the installation which requires
a higher quota on a different file system). The startup file for VNC will not be found
and as a result the start-vnc command will fail to start a window manager.


### Missing fonts

When testing with x11perf (included in the X11 modules on LUMI), certain tests fail
due to missing fonts:

font '8x13'
font '9x15'
font '-misc-fixed-medium-r-normal--14-130-75-75-c-140-jisx0208.1983-*'
font '-jis-fixed-medium-r-normal--24-230-75-75-c-240-jisx0208.1983-*'
font '-adobe-times-medium-r-normal--10-100-75-75-p-54-iso8859-1'
font '-adobe-times-medium-r-normal--24-240-75-75-p-124-iso8859-1'
font '-adobe-times-medium-r-normal--10-100-75-75-p-54-iso8859-1'

## EasyBuild

### Version 20220125

-   This version was developed for LUMI as it was at the beginning of 2022 and continued
    to work after the February upgrade (which did upgrade the OS).


### Version 20220715

-   This version was not properly tested when installed but was still installed as it
    was kind of an emergency situation after the June-July 2022 upgrade.

    It included an OS update to SLES15SP3 and matching COS, but `lsof` which was used in
    the script that starts the container was no longer available.

    Due to the holiday schedule this version had to be installed without proper testing
    on the compute nodes and before the patch was merged in the main branch.

