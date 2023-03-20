# syslibs instructions

This is a bundle of basic libraries all of which were also present on LUMI except one
at the time of development, but without the development packages. They are all build
as static libraries using the system GCC and are meant to be used as build dependencies
for a number of tools that we want to be able to use without dependencies.

Currently included are:

  * ncurses [version check](https://ftp.gnu.org/pub/gnu/ncurses/)
  * libreadline [version check](https://ftp.gnu.org/pub/gnu/readline/)
  * bzip2 [version check](https://sourceware.org/git/?p=bzip2.git;a=summary)
  * zlib [version check](https://zlib.net/)
  * lz4 [version check](https://github.com/lz4/lz4/releases)
  * expat [version check](https://github.com/libexpat/libexpat/releases)
  * APR and APR-util [version check](https://apr.apache.org/)
  * Serf [version check](https://serf.apache.org/download)
  * file [version check](http://ftp.astron.com/pub/file/)
  * PCRE2 [version check](https://github.com/PhilipHazel/pcre2/releases)
  * SQLite3 (limited configuration, but enough for, e.g., subversion) [version check](https://www.sqlite.org/)

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

### 21.12

  * As we no longer try to mirror system libraries and instead use newer versions (they are
    statically linked anyway) the version numbering has been switched to follow those of the
    LUMI stack for which the file was updated.

  * PCRE2: Switched to download from GitHub.

  * Configure didn't work for ncurses 6.3 so we stuck to 6.2 rather than to start debugging.

### 22.06

  * No new version of ncurses yet with working configure, so stick to 6.2 instead of 6.3.

  * Several minor upgrades but no new packages.
  
  * Added checksums to make the installation on LUMI more robust.

### 22.08

  * Port of the 22.06 version with the addition of cURL.
  
    REVERSED AS IT SEEMS IMPOSSIBLE TO GET GIT TO LINK WITH THAT LIBRARY CORRECTLY 
    AND STATICALLY.
    
### 22.11 and 23.02

  * Trivial port of the 22.08 version (the later one without cURL).


