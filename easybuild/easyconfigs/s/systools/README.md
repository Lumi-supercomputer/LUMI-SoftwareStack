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

-   libtree

    -   [libtree on GitHub](https://github.com/haampie/libtree)

        -   [libtree releases](https://github.com/haampie/libtree/releases)

-   tree

    -   [tree web page](http://mama.indstate.edu/users/ice/tree/)


## EasyBuild

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

  
  