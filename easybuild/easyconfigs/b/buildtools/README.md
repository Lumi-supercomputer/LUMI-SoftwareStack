# buildtools module

## Contents

Links for quick checking for version updates:

| Package              | Version link |
|:---------------------|:-------------|
| GNU Autoconf         | [version check](https://ftp.gnu.org/gnu/autoconf/) |
| GNU Autoconf-archive | [version check](https://ftp.gnu.org/gnu/autoconf-archive/) |
| GNU Automake         | [version check](https://ftp.gnu.org/gnu/automake/) |
| GNU Bison            | [version check](https://ftp.gnu.org/gnu/bison/) |
| GNU libtool          | [version check](https://www.gnu.org/software/libtool/) |
| GNU M4               | [version check](https://www.gnu.org/software/m4/) |
| GNU make             | [version check](https://ftp.gnu.org/gnu/make/) |
| GNU sed              | [version check](https://ftp.gnu.org/gnu/sed/) |
| Byacc                | [version check](https://invisible-mirror.net/archives/byacc/) |
| CMake                | [version check](http://www.cmake.org/) |
| Flex                 | [version check](https://github.com/westes/flex/releases) |
| Ninja                | [version check](https://ninja-build.org/) |
| Meson                | [version check](https://pypi.org/project/meson/#history) |
| SCons                | [version check](https://pypi.org/project/SCons/#history) |
| NASM                 | [version check](http://www.nasm.us/) or [GitHub](https://github.com/netwide-assembler/nasm/tags) |
| Yasm                 | [version check](http://yasm.tortall.net/) |
| patchelf             | [version check](https://github.com/NixOS/patchelf/releases) |
| re2c                 | [version check](https://github.com/skvadrik/re2c/releases) |
| GNU gperf            | [version check](https://www.gnu.org/software/gperf/) |
| GNU help2man         | [version check](http://ftpmirror.gnu.org/help2man/) |
| Doxygen              | [version check](http://www.doxygen.nl/download.html) or [version check](https://github.com/doxygen/doxygen/tags) 
|
| xxd                  | [version check: part of vim](https://github.com/vim/vim/tags) |

Not included at the moment:

* git ([version check](https://github.com/git/git/releases))
  (due to OS dependencies not present on Eiger)
* pkg-config ([version check](https://www.freedesktop.org/wiki/Software/pkg-config/)):
  Including our own pkg-config interfers with the pkg-config included with the Cray
  PE and causes some configure processes to fail.


## EasyConfigs

### Notes

* CMake still requires an ncurses and OpenSSL library from the system.
* There are dependencies between those packages, so sometimes the order in the
  EasyConfig file does matter and is chosen to use the newly installed tools
  for the installation of some of the other tools in the bundle.


### 21.05 and 21.06 (the same)

* Started development from an EasyCofig file in use at UAntwerpen 2020a version)
* We did add EBROOT and EBVERSION variables for all components for increased compatibility
  with standard EasysBuild-generated modules (in case those variables would, e.g.,
  be used in EasyBlocks for certain software packages).
* Added re2c and SCons to the bundle.


### 21.08 and 21.09 (the same)

 * Version update of all components to the most recent version as of 14 September
   2021.


### 21.12

-   Version update of all components to the most recent version as of 4 February 2022.

-   SCons 4.3 now builds without problems. (in 21.08 the 4.x branch was avoided). Downloads
    changed to PyPi; SourceForge does no longer seem to contain the newest version.

-   Added `xxd`, a hexadecimal editor that comes with `vim`, as it is a build dependency
    for recent PLUMED versions. This ensures that the command will be present even if
    `vim` would be deleted again from the system images.
    
### 22.06

-   Version updates of components.
  
### 22.08

-   Major change: Split into a -minimal version which is linked against the system 
    libraries but does not have all functionality (left out some tools that are not
    needed in that version, and some commands, e.g., ccmake, are missing) and then the
    full version which is linked against the static library package `syslibs` which
    allows us to use `ncurses` and to minimize interference with other tools.
    
-   Major change: A `-noPython` version that leaves out Meson and SCons as those require
    Python and can interfer with software that needs a different version of Python.
    
-   Some version updates.

    
### 22.12 and 23.03

-   Further implementation of the changes
  
    -   Version that is used to bootstrap until we can build a proper `buildtools` 
        module now has the version suffix `-bootstrap`.
        
    -   The regular `buildtools` module no longer contains any Python-based tool that
        require `PYTHONPATH` to be set due to interference with other tools that might
        need a different version of Python.
        
    -   The separate `buildtools-python` modules provide the Python-based tools.
      
-   Otherwise just version updates of the packages used in 22.08.
  
-   Note that we first tried with SCons 4.5.1 but that version was too new for some
    other packages. Serf in syslibs, e.g., failed.



### 23.09

-   Some components have been updated to the latest version, others (SCons and Meson) were kept
    at the current version. Meson because it is the last version compatible with the system Python,
    and SCons because we've had problems with other software at the previous update.
    
    Some packages also do not compile in newer versions on SUSE 15 as either the compiler is too
    old or the system Python is no longer supported.
    

### 23.12

-   Minimal version updates, only CMake was updated as there it is important to have the 
    latest.
    

### 24.03

-   Total refresh of 23.12, except for those packages where newer versions offer compile problems
    with the current system compiler on LUM<I.


### 24.11

-   Trivial port of the 24.03 EasyConfig with just a lot of version updates.

-   It turns out that nasm.us is down, so download sources are not available.
    NASM does [have a GitHub however](https://github.com/netwide-assembler/nasm)
    where sources can be found. These are raw though and we couldn't get the build
    process to work.
    
    -   Certainly needed is `preconfigopts = './autogen.sh && '`.

    -   The start directory is now '%(namelower)s-%(namelower)s-%(version)s'.

    -   The build process however fails to generate the man pages while the `make install`
        phase does want to install them. It is not clear how they can be generated 
        from the GitHub sources. In the downloaded package from `nasm.us`, they were
        pre-generated.
        
    -   So for now we use the web archive as a second source for downloads.

      
### 25.03
      
-   Initially a minor update of 24.11, few packages changed as these were developed within three 
    weeks of each other.

-   Further corrections to installation directories and EasyConfig parameters were needed when
    moving to EasyBuild 5.

-   SCons was moved out of the `-bootstrap` version as it triggered an internal sanity check that
    failed as it insisted on having an executable called `python` rather than `python3`.

    
### 25.09

-   As the big work was done in the same period for 25.03 and the move to EasyBuild 5, the 25.09
    EasyConfigs are just a minor change of the 25.03 ones.
    
-   We made preparations to integrate both CMake 3 and 4, but in the end decided not to do as the
    CMake recipes are likely incompatible.

-   Also switched to the new set of EasyConfig parameters to prepare for EasyBuild 6.

