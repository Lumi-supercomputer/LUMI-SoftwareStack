# buildtools module

Buildtools is a collection of various build tools installed in a single module and
directory tree. We update it once with every toolchain and give it a version number
based on the toolchain.

The original setup was to only include executables and not libraries. However, that
created a build dependency on sufficiently recent versions of Bison 3.0 and flex, so
we decided to include them also even though they provide libraries that we may want
to compile with a more recent GCC when used in applications (though I expect that
even then those libraries will only be used on a non-performance-critical part of
the code, I would expect in I/O. And by specifying other flex and/or Bison modules
in the right order when building those applications, we may even totally avoid
these problems.


## Contents

The contents of the module evolved over time. It does contain a subset of:
* GNU Autoconf [version check](https://ftp.gnu.org/gnu/autoconf/)
* GNU Autoconf-archive [version check](https://ftp.gnu.org/gnu/autoconf-archive/)
* GNU Automake [version check](https://ftp.gnu.org/gnu/automake/)
* GNU Bison [version check](https://ftp.gnu.org/gnu/bison/)
* GNU libtool [version check](https://www.gnu.org/software/libtool/)
* GNU M4 [version check](https://www.gnu.org/software/m4/)
* GNU make [version check](https://ftp.gnu.org/gnu/make/)
* GNU sed [version check](https://ftp.gnu.org/gnu/sed/)
* Byacc [version check](https://invisible-mirror.net/archives/byacc/)
* CMake [version check](http://www.cmake.org/)
* Flex [version check](https://github.com/westes/flex/releases)
* Ninja [version check](https://ninja-build.org/)
* Meson [version check](https://pypi.org/project/meson/#history)
* SCons [version check](https://pypi.org/project/SCons/#history)
* NASM [version check](http://www.nasm.us/)
* Yasm [version check](http://yasm.tortall.net/)
* patchelf [version check](https://github.com/NixOS/patchelf/releases)
* re2c [version check](https://github.com/skvadrik/re2c/releases)
* GNU gperf [version check](https://www.gnu.org/software/gperf/)
* GNU help2man [version check](http://ftpmirror.gnu.org/help2man/)
* Doxygen [version check](http://www.doxygen.nl/download.html) or [version check](https://github.com/doxygen/doxygen/tags)
* xxd [version check: part of vim](https://github.com/vim/vim/tags)

Not included at the moment:
* git [version check](https://github.com/git/git/releases)
  (due to OS dependencies not present on Eiger)
* pkg-config [version check](https://www.freedesktop.org/wiki/Software/pkg-config/):
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

  * Version update of all components to the most recent version as of 4 February 2022.

  * SCons 4.3 now builds without problems. (in 21.08 the 4.x branch was avoided). Downloads
    changed to PyPi; SourceForge does no longer seem to contain the newest version.

  * Added `xxd`, a hexadecimal editor that comes with `vim`, as it is a build dependency
    for recent PLUMED versions. This ensures that the command will be present even if
    `vim` would be deleted again from the system images.
    
### 22.06

  * Version updates of components.
  
### 22.08

  * Major change: Split into a -minimal version which is linked against the system 
    libraries but does not have all functionality (left out some tools that are not
    needed in that version, and some commands, e.g., ccmake, are missing) and then the
    full version which is linked against the static library package `syslibs` which
    allows us to use `ncurses` and to minimize interference with other tools.
    
  * Major change: A `-noPython` version that leaves out Meson and SCons as those require
    Python and can interfer with software that needs a different version of Python.
    
  * Some version updates.

    
### 22.12 and 23.03

  * Further implementation of the changes
  
      * Version that is used to bootstrap until we can build a proper `buildtools` 
        module now has the version suffix `-bootstrap`.
        
      * The regular `buildtools` module no longer contains any Python-based tool that
        require `PYTHONPATH` to be set due to interference with other tools that might
        need a different version of Python.
        
      * The separate `buildtools-python` modules provide the Python-based tools.
      
  * Otherwise just version updates of the packages used in 22.08.
  
  * Note that we first tried with SCons 4.5.1 but that version was too new for some
    other packages. Serf in syslibs, e.g., failed.



### 23.09

  * Some components have been updated to the latest version, others (SCons and Meson) were kept
    at the current version. Meson because it is the last version compatible with the system Python,
    and SCons because we've had problems with other software at the previous update.
    
    Some packages also do not compile in newer versions on SUSE 15 as either the compiler is too
    old or the system Python is no longer supported.
