# git

-   [Git home page](https://git-scm.com)

-   [Git on GitHub](https://github.com/git/git)

    -   [GitHub releases via tags](https://github.com/git/git/tags)


## Build instructions

To install git against the sytem toolchain, several libraries need to be installed
in development versions:
-   Header files libintl.h, iconv.h (glibc-devel on SUSE)
-   zlib with zlib.h (zlib-devel on SUSE)
-   libexpat with expat.h (libexpat-devel on SUSE)
-   libcurl with curl.h (libcurl-devel on SUSE)
-   OpenSSL development libraries?? Needed according to EasyBuilders but not found
    in the configure log.

To generate man pages or info pages, [AsciiDoc](https://asciidoc.org/)
is needed. Furthermore, to generate man pages, [xmlto](https://pagure.io/xmlto) is
needed and to generate info pages, TeX is needed (which we really don't want on a
cluster).


## EasyBuild

-   [Support for git in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/g/git)

-   [Support for git in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/g/git)


### git 2.33.1 for cpe 21.08

-   Started from the EasyBuilders recipe that doesn't build the documentation,
    but checked options from configure, switched to OS dependencies and the
    SYSTEM toolchain.

-   Further extended that one to one that can also generate the html documentation
    and man pages (but not the texinfo documentation at the moment) by building
    additional packages that provide the necessary tools. This is not yet finished
    on LUMI though as more packages are missing than on eiger.


### git 2.35.1 for LUMI/21.12

-   Straightforward port of the 2.33.1 EasyConfig file


### git 2.37.0 for LUMI/22.06

-   Straightforward port of the 2.35.1 EasyConfig file


### git 2.37.2 for LUMI/22.08

-   Straightforward port of the 2.37.0 EasyConfig file.
  

### git 2.40.0 for 22.12/23.03

-   Straightforward port of the 2.37.2 EasyConfig file.
  
-   Decided to not yet include git-lfs in the module itself as the latter is still 
    installed from binaries and needs some additional treatment in `postinstallcmds`.


### git 2.42.1 for 23.09

-   Straightforward port of the 2.40.0 EasyConfig file.


### git 2.43.4 for 23.09

-   Straightforward port of the 2.42.1 EasyConfig file.


### git 2.45.1 for 24.03

-   Straightforward port of the 2.43.4 EasyConfig file.


### git 2.49.0 for 24.11 and 25.03

-   Straightforward port of the 2.45.1 EasyConfig file.


### git 2.53.0 for 25.09

-   Straightforward update of the EasyConfig for 2.49.0.
