# Buildtools user instructions


## What is buildtools?

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

The contents of the module evolved over time. It does contain a subset of:

* [GNU Autoconf](https://www.gnu.org/software/autoconf/)
* [GNU Autoconf-archive](https://www.gnu.org/software/autoconf-archive/)
* [GNU Automake](https://www.gnu.org/software/automake/)
* [GNU Bison](https://www.gnu.org/software/bison/)
* [GNU libtool](https://www.gnu.org/software/libtool/)
* [GNU M4](https://www.gnu.org/software/m4/)
* [GNU make](https://www.gnu.org/software/make/)
* [GNU sed](https://www.gnu.org/software/sed/)
* [Byacc](https://invisible-island.net/byacc/byacc.html)
* [CMake](https://cmake.org/)
* [Flex](https://github.com/westes/flex)
* [Ninja](https://ninja-build.org/)
* [NASM](https://www.nasm.us/)
* [Yasm](https://yasm.tortall.net/)
* [patchelf](https://github.com/NixOS/patchelf)
* [re2c](https://re2c.org/)
* [GNU gperf](https://www.gnu.org/software/gperf/)
* [GNU help2man](https://www.gnu.org/software/help2man/)
* [Doxygen](https://www.doxygen.nl/)
* [xxd](https://vim.fandom.com/wiki/Hex_dump) comes as part of [Vim](https://www.vim.org/)

Build tools written in Python such as Meson and SCons, have been moved to the
[buildtools-python](../buildtools-python) module as they can interfere with 
build processes if that build process uses a different version of Python than
the build tool.
