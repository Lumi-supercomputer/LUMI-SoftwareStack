# Build plan

**THIS DOCUMENT IS STILL VERY INCOMPLETE**

The table below gives an impression of the dependencies between packages.

Packages in block X only depend on packages in blocks X-1 or lower and can all
be build together.

## Block -1

The following EasyBuild packages are replaced by OS dependencies:

  * pkg-config: It is mandatory to use the Cray version. It is used internally
    in the compiler wrappers, and loading an EasyBuild one causes failures in
    those wrappers.

  * OpenSSL to ensure that security patches are applied


## Block 0

  * buildtools (SYSTEM in common)


## Block 1

  * xorg-macros (SYSTEM in common) - Needed for X11 and some of its dependencies

  * Rust (SYSTEM in common) - Needed for those users who want to install HyperQueue

  * bzip2 (cpe*) - Popular compression library, dependency for PCRE2.

  * DB (cpe*) - Berkeley Database, used by a Perl package

  * ELPA (cpeGNU) - Large-scale eigenvalue solver

  * expat (cpe*) - XML parser and a popular dependency for many packages

  * ICU (cpe*) - Dependency for libxml2 and hence frequently used

  * libffi (cpe*) - A fairly often used library, should be in any release.

  * ncurses (cpe*) - Used by many packages that offer commands with a console interactive
    interface and by libreadline

  * termcap (cpe*) - Needed for one of the Perl extensions included in the EasyBuild
    Perl module.

  * zlib (cpe*) - Compression library and one of the most popular dependencies


## Block 2

  * file (cpe*) - Provides libmagic used by several tools, including util-linux, and
    depends upon zlib (block 1)

  * libpciaccess (cpe*) - Depens on xorg-macros and is needed for X11

  * libpng (cpe*) - Depends on zlib

  * libreadline (cpe*) - Needs ncurses and is used by many packages that offer commands
    with an interactive interface.

  * gettext -minmal version (cpe*) - Depends upon ncurses



## Block 3

  * freetype (cpe*) - Depends on bzip2, zlib (block 1), libpng (block 2)

  * libiconv (cpe*) - Depends upon gettext -minimal and is itself a dependency
    for GLib and other popular packages.

  * libpciaccess (cpe*) - Used to build X11, depends on xorg-macros

  * PCRE2 (cpe*) - A popular regular expression library, uses bzip2, zlib (block 1),
    libreadline (block2)

  * Perl (cpe*) - The Perl packages included in the 2021b version of Perl in the EasyBuilders
    repository need DB, expat, ncurses, termcap and zlib from block 1 and libreadline
    from block 2.

  * XZ (cpe*) - Depends upon the minimal version of gettext and is a dependency for
    libxml2.


## Block 4

  * intltool (cpe*) - A build dependency for the X11 bundle. The only reason why this
    package is so far down is because it requires a specific Perl package during the
    build so we wanted to build with our own Perl to be sure it is there.

  * libxml2 (cpe*) - A often used library


## Block 5

  * gettext (cpe*) full version - depends upon ncurses (block 1) and libxml2 (block
    3)

  * libxslt (cpe*) - Depends upon libxml2 and used by util-linux

  * X11 (cpe*) - A collection of X11 libraries TODO: Dependencies


## Block 6

  * util-linux (cpe*) - Depends on ncurses, zlib (block 1), libreadline, file (block
    2), libxslt, gettext (block 5)


## Block 7

  * fontconfig (cpe*) - Depends on expat (block 1), freetype (block 3), util-linux
    (block 6) and is needed by X11

  * GLib (cpe*) - Depends on libffi (block 1), PCRE2, libiconv (block 3), libxml2 (block
    4), gettext (block 5), util-linux (block 6).


## Block 8

  * X11 (cpe*) - Depends on bzip2, xorg-maxros, zlib (block 1), libpciacces (block 2), freetype
    (block 3), intltool (block 4), fontconfig (block 7)




