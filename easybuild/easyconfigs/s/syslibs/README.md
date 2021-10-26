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
  * expat
  * file
  * PCRE2

For those libraries that are present on SUSE Linux, we tried to take the same versions
as much as possible for optimal compatibility with other files that the libraries might
use.
