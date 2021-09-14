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
* Byacc [version check](ftp://ftp.invisible-island.net/byacc)
* CMake [version check](http://www.cmake.org/)
* Flex [version check](https://github.com/westes/flex/releases)
* Ninja [version check](https://ninja-build.org/)
* Meson [version check](https://pypi.org/project/meson/#history)
* SCons, due to build problems with version 4.
* NASM [version check](http://www.nasm.us/)
* Yasm [version check](http://yasm.tortall.net/)
* patchelf [version check](https://github.com/NixOS/patchelf/releases)
* re2c [version check](https://github.com/skvadrik/re2c/releases)
* GNU gperf [version check](https://www.gnu.org/software/gperf/)
* GNU help2man [version check](http://ftpmirror.gnu.org/help2man/)
* Doxygen [version check](http://www.doxygen.nl/download.html) or [version check](https://github.com/doxygen/doxygen/releases)

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


### 21.08

 * Version update of all components to the most recent version as of 14 September
   2021.
