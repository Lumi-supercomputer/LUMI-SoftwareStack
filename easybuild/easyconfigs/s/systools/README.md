# systools instruction

Systools is just a bundle of various small Linux tools that are very useful on the
system.

The current content is

-   GPP: A General-Purpose Preprocessor (or sometimes called Generic PrePRocessor)

    -   [GPP web site](https://logological.org/gpp)

    -   [GPP on GitHub](https://github.com/logological/gpp)

        -   [GitHub releases](https://github.com/logological/gpp/releases)

-   htop

    -   [htop web site](https://htop.dev/)

    -   [htop on GitHub](https://github.com/htop-dev/htop)

        -   [GitHub releases](https://github.com/htop-dev/htop/releases)

-   pbzip2

    -   [pbzip2 home page](http://compression.great-site.net/pbzip2/)
        
    The code has not been unmaintained since 2015.

-   libtree

    -   [libtree on GitHub](https://github.com/haampie/libtree)

        -   [libtree releases](https://github.com/haampie/libtree/releases)

-   tree

    -   [New tree repository](https://gitlab.com/OldManProgrammer/unix-tree)
    
        -   [tags for download](https://gitlab.com/OldManProgrammer/unix-tree/-/tags)

    -   [Old tree web page](http://mama.indstate.edu/users/ice/tree/)

-   PRoot

    -   [PRoot home page](https://proot-me.github.io/)
        
    -   [PRoot on GitHub](https://github.com/proot-me/proot)
        
        -   [PRoot GitHub releases](https://github.com/proot-me/proot/releases)


## EasyBuild

-   pbzip2

    -   [PBZIP2 in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/p/PBZIP2)

-   libtree:

    -   [Support for libtree in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libtree)

    -   [Support for libtree in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/l/libtree)


### Bundle version 15.1.0 for SUSE Linux 15SP1

-   When compiling htop with unicode enable it causes a segmentation violation
    (but not with -h or --version so it is not detected in the EasyBuild sanity
    check). The likely cause is a problem with out ncursesw library that is part
    of syslibs and fully static.
    

### 21.12


### 22.06 and 22.08

-   Update of htop and some improvements to the EasyConfig.

-   Robustified the installation on LUMI with checksums.


### 22.12 and 23.03

-   Version bumps for GPP/htop/tree.

-   Adding libtree

-   Changing the layout of the EasyConfig a bit, also adding license information.


### 23.03

-   Version bumps for GPP/htop/tree.


### 23.09

-   Version bumps for GPP/htop/tree.

-   In a revised edition we also provided the proot command for use with singularity.

    -   We went for build that is fully static except for libc taken from the system to
        be as independent from anything else as possible. The procedure in the EasyConfig
        is a LUST development.
        
    -   Needed to fix the Makefile as the warnings about it not being a git repository
        caused EasyBuild to stop the build.


### 23.12 and 24.03

-   Version bump of `htop`, but otherwise similar as the 23.09 one with the `proot` 
    command.
    
-   Did have to change the download location for the `tree` command though which also 
    led to a slightly different build process.


### 24.03-1/-2 and 24.11
 
-   Added `pbzip2` to the bundle:

    -   The only dependency is libbz2, and we use a static version of it from the systools module.

    -   This part of the EasyConfig is heavily inspired on the EasyBuilders one for 
        PBZIP2.

    -   We developed a small patch to detect the number of cores available via the `sched_getaffinity` 
        function so that it works as expected in a Slurm job, and also limit the default number of 
        threads to 16 on the login nodes.

-   Tried htop 3.4.1 in 24.03-1 but had to switch back to 3.3.0. 3.4.1 still segfaults, 
    but it did not show in the ccpe container for some unknown reason.

-   Needed to remove `--static` from the `configopts` after the LUMI upgrade to SUSE 15SP6 and needed
    to rebuild.


### 25.03

-   Identical to the 24.11 version

-   Found the issue that prevented us from using 3.4.1 (and backported the fix to 24.03 but without updating
    to 3.4.1 there): Configure was picking up version 5 header files from the system while using version
    6 libraries from `systools`. We needed to add `--with-curses=ncursesw` to use the proper header files
    and keep UNICODE support also enabled.


### 25.09

-   Identical to the 25.03 version

-   Except that we switched over to the new set of EasyConfig parameters to prepare for EasyBuild 6.

