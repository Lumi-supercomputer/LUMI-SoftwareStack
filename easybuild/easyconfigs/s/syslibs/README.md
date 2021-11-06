# syslibs instructions

This is a bundle of basic libraries all of which were also present on LUMI except one
at the time of development, but without the development packages. They are all build
as static libraries using the system GCC and are meant to be used as build dependencies
for a number of tools that we want to be able to use without dependencies.

Currently included are:
  * ncurses
  * libreadline
  * bzip2
  * zlib
  * lz4
  * expat
  * APR and APR-util
  * Serf
  * file
  * PCRE2
  * SQLite3 (limited configuration, but enough for, e.g., subversion)

For those libraries that are present on SUSE Linux, we tried to take the same versions
as much as possible for optimal compatibility with other files that the libraries might
use.


## EasyBuild


### 15.1.0

  * First version of this library. The 15.1 in the name comes from SLES15 update 1.


### 15.1.1-static

  * Added lz4, APR/APR-util. Serf and SQLite-3 so that the module can be used to build
    Subversion.

  * Added -static as a versionsuffix to stress that the package only provides static libraries
    meant to be used as a build dependency and for consistency with other modules.

  * We now had to include buildtools as a build dependency since Serf needs SCons which
    is not available in the OS image.


