# lumi-vnc instructions

Installs a singularity container with the TurboVNC server and some scripts and shell
functions to start and stop the server.

  * See the repository [Lumi-supercomputer/utility-tools](https://github.com/Lumi-supercomputer/utility-tools)
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


## Known issues (other than those mentioned in USER.md)

### Container cannot follow symbolic links to a different file system

It is not possible to test a user install of the VNC container if the software directory
or any other directory is soft-linked to a different file system (e.g., to have a
personal repository in your home directory but have the installation which requires
a higher quota on a different file system). The startup file for VNC will not be found
and as a result the start-vnc command will fail to start a window manager.


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


### Version 20221010

-   This version makes some corrections in the `_start-vnc` script to work around a 
    race condition that could occur and then use port 0 instead of the right port 
    for the web access to the VNC server.


### Version 20230110

-   This version fixes a problem with non-routable hostnames that were used in the
    instructions for ssh port forwarding.

