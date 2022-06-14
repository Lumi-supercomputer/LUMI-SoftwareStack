# Build plan

**THIS DOCUMENT IS UNDER CONTINUOUS DEVELOPMENT**

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

  * [buildtools (SYSTEM in common)](b/buildtools)


## Block 1

### Common
 
  * [lumi-CPEtools (cpe*)](l/lumi-CPEtools): Requires buildtools

  * [syslibs (SYSTEM)](s/syslibs), requires buildtools

### Regular

  * [Eigen (SYSTEM in common)](e/Eigen) - Version of the template library installed without
    any dependencies in the module.

  * [xorg-macros (SYSTEM in common)](x/xorg-macros) - Needed for X11 and some of its dependencies

  * [Rust (SYSTEM in common)](r/Rust) - Needed for those users who want to install HyperQueue

  * [Blosc (cpe*)](b/Blosc) - meta-compression library

  * [Brotli (cpe*)](b/Brotli) - Lossless compression algorithm.

  * [bzip2 (cpe*)](b/bzip2) - Popular compression library, dependency for PCRE2.

  * [DB (cpe*)](d/DB) - Berkeley Database, used by a Perl package

  * [double-conversion (cpe*)](d/double-conversion) - Binary-decimal and decimal-binary conversions

    UPDATE!

  * [ELPA (cpeGNU)](e/ELPA) - Large-scale eigenvalue solver

    UPDATE! Synchronizes with EasyBuild.

  * [ESMF (cpe*)](e/ESMF) - Tool for coupling climate models, only used in contributed
    packages but as it needs adaptations to an EasyBlock we put it here as a
    courtasy to our users. Skip for now as it turns out to be a mistake in
    the EasyBuilders NCO EasyConfig. It is not linked into the package.

    UPDATE: To 8.3.0.

  * [expat (cpe*)](e/expat) - XML parser and a popular dependency for many packages

    UPDATE, synchronizes with EasyBuild.

  * [FriBidi (cpe*)](f/FriBidi) - Free Implementation of the Unicode Bidirectional Algorithm

    UPDATE, synchronizes with EasyBuild.

  * [giflib (cpe*)](g/giflib) - Library for working with gif-files

  * [gc (+ libatomic) (cpe*)](g/gc) - Boehm-Demers-Weiser conservative garbage collector

  * [GMP (cpe*)](g/GMP) - GNU Multiprecision library

  * [GSL (cpe*)](g/GSL) - GNU Scientific Library

    MINIOR UPDATE

  * [gzip (cpe*)](g/gzip) - Compression library and tools

    UPDATE, synchronizes with EasyBuild.

  * [ICU (cpe*)](i/ICU) - Dependency for libxml2 and hence frequently used

    UPDATE, synchronizes with EasyBuild.

  * [libaec (cpe*)](l/libaec) - Compression library popular in climate applications

  * [libb2 (cpe*)](l/libb2) - Provides BLAKE2

  * [libcerf (cpe*)](l/libcerf) - Complex error function library

    UPDATE: Try update to 2.1.

  * [libdeflate (cpe*)](l/libdeflate) - Compression library

    UPDATE, would be ahead of EasyBuild, otherwise try 1.10.

  * [libffi (cpe*)](l/libffi) - A fairly often used library, should be in any release.

  * [libidn (cpe*)](l/libidn) - GNU implementation of the Stringprep, Punycode and IDNA 2003 specifications.

  * [libidn2 (cpe*)](l/libidn2) - Newer version of libidn

    **TODO: Do we still need libidn or can it be replaced with libidn2 everywhere?**

  * [libjpeg-turbo (cpe*)](l/libjpeg-turbo) - Library and tools for jpeg files

    UPDATE, synchronizes with EasyBuild.

  * [libogg (cpe*)](l/libogg) - Ogg container format

  * [libopus (cpe*)](l/libopus) - Opus audio codec

  * [libtirpc (cpe*)](l/libtirpc) - A port of a sun RPC library

  * [libyaml (cpe*)](l/libyaml) - YAML parser and emitter

  * [LMDB (cpe*)](l/LMDB) - OpenLDAP's Lightning Memory-Mapped Database (LMDB) library

  * [lz4 (cpe*)](l/lz4) - Compression algorithm and tools.

  * [Lzip (cpe*)](l/Lzip) - Lossless data compressor tool

  * [LZO (cpe*)](l/LZO) - Lossless data compression library and tools

  * [METIS (cpe*)](m/METIS) - Graph partitioning software

  * [mpdecimal (cpe*)](m/mpdecimal) - Package for decimal floating point

  * [ncurses (cpe*)](n/ncurses) - Used by many packages that offer commands with a console interactive
    interface and by libreadline

  * [ParMETIS (cpe*)](p/ParMETIS) - Parallel graph partitioning software

  * [Szip (cpe*)](s/Szip) - Compression algorithm used by HDF5.

  * [termcap (cpe*)](t/termcap) - Needed for one of the Perl extensions included in the EasyBuild
    Perl module.

  * [x264 (cpe*)](x/x264) - x264 video compression library

  * [x265 (cpe*)](x/x265) - x265 video compression library

  * [VampirServer (cpe*)](v/VampirServer) - Vampir server component, in the appl EasyStack

  * [zlib (cpe*)](z/zlib) - Compression library and one of the most popular dependencies

    UPDATE, synchronizes with EasyBuild.


## Block 2

### Common

  * [git (SYSTEM)](g/git), requires buildtools and syslibs

  * [nano (SYSTEM)](n/nano), requires buildtools and syslibs

  * [systools (SYSTEM)](s/systools), requires buildtools and syslibs

  * [Vim (SYSTEM)](v/Vim), requires buildtools and syslibs

### Regular

  * [cURL (cpe*)](c/cURL) - Tools for transfering data via URLs. Needs Brotli and zlib (block
    1)

    UPDATE, bugfix release ahead of EasyBuild.

  * [FLAC (cpe*)](f/FLAC) - FLAC audio codec, needs libogg (block 1)

    UPDATE

  * [gettext -minmal version (cpe*)](g/gettext) - Depends upon ncurses

  * [JasPer (cpe*)](j/JasPer) - JPEG-2000, needs libjpeg-turbo (block 1)

    UPDATE: Try major version update, if not return to 2.0.33.

  * [LAME (cpe*)](l/LAME) - MP3 audo codec, depends on ncurses (block 1)

  * [libevent (cpe*)](l/libevent) - Event notification library. Needs zlib (block 1)

  * [libpciaccess (cpe*)](l/libpciaccess) - Depends on xorg-macros and is needed for X11

  * [libpng (cpe*)](l/libpng) - Depends on zlib

  * [libreadline (cpe*)](l/libreadline) - Needs ncurses and is used by many packages that offer commands
    with an interactive interface.

  * [libvorbis (cpe*)](l/libvorbis) - Vorbis audio codec, needs libogg (block 1)

  * [MPFR (cpe*)](m/MPFR) - Multi-precision floating point, needs GMP (block 1)

  * [snappy (cpe*)](s/snappy) - Compression/decompressio library, needs LZO and zlib (block 1)

  * [Tcl (cpe*)](t/Tcl) - Dynamic scripting language, needs zlib (block 1)

    UPDATE, synchronizes with EasyBuild.

  * [UDUNITS (cpe*)](u/UDUNITS) - Toolset to work with various unit systems. Needs expat (block
    1)


## Block 3

  * [freetype (cpe*)](f/freetype) - Depends on bzip2, zlib (block 1), libpng (block 2)

    UPDATE

  * [libiconv (cpe*)](l/libiconv) - Depends upon gettext -minimal and is itself a dependency
    for GLib and other popular packages.

    UPDATE

  * [libsndfile (cpe*)](l/libsndfile) - Library and tools encapsulating various audio codecs. Needs
    libogg, libopus (block 1), FLAC and libvorbis (block 2)

    UPDATE

  * [libtheora (cpe*)](l/libtheora) - Theora video codec. Needs libogg, libpng (block 1) and libvorbis
    (block 2)

  * [MPC (cpe*)](m/MPC) - Arbitrary precision arithmetic of complex numbers. Needs GMP (block 1) and MPFR (block 2)

  * [PCRE (cpe*)](p/PCRE) - A popular regular expression library, uses bzip2, zlib (block 1),
    libreadline (block2)

    **Check if we still need this or if it can be replaced everywhere with PCRE2.**

  * [PCRE2 (cpe*)](p/PCRE2) - A popular regular expression library, uses bzip2, zlib (block 1),
    libreadline (block2)

    UPDATE, synchronizes with EasyBuild.

  * [pixman (cpe*)](p/pixman) - Pixel manipulation library. Needs libpng (block 2)

  * [SQLite (cpe*)](s/SQLite) - Database library. Needs libreadline and Tcl (block 2)

    UPDATE, synchronizes with EasyBuild.

  * [XZ (cpe*)](x/XZ) - Depends upon the minimal version of gettext and is a dependency for
    libxml2.


## Block 4

  * [file (cpe*)](f/file) - Provides libmagic used by several tools, including util-linux, and
    depends upon zlib an bzip2 (block 1) and XZ (block 3)

    UPDATE

  * [libunistring (cpe*)](l/libunitstring) - Needs libiconv (block 3)

  * [libunwind (cpe*)](l/libunwind) - Needs XZ (block 3)

  * [libxml2 (cpe*)](l/libxml2) - A often used library

  * [SCOTCH (cpe*)](s/SCOTCH) - Uses bzip2, zlib (block 1) and XZ (block 3) though it can also
    be build without those libraries, that only provide extra file formats.

  * [wget (cpe*)](w/wget) - Package for retrieving files using HTTP/HTTPS, ... Needs libidn2,
    zlib (block 1) and PCRE2 (block 3)

  * [zstd (cpe*)](z/zstd) - Zstandard compression algorithm and tools. Needs gzip, lz4, zlib
    (block 1) and XZ (block 3)


## Block 5

  * [Boost (cpe*)](b/Boost) - Needs bzip2, ICU and zlib (block 1) and zstd (block 5)

  * [libarchive (cpe*)](l/libarchive) - Multi-format archive and compression library, needs
    bzip2, libb2, lz4, zlib (block 1), XZ (block 3 ) and zstd (block 4)

  * [gettext (cpe*) full version](g/gettext) - depends upon ncurses (block 1) and libxml2 (block
    4)

  * [LibTIFF (cpe*)](l/LibTIFF) - TIFF image files tools, depends on giflib, libjpeg-turbo, zlib
    (block 1), XZ (block 3) and zstd (block 4).

  * [libxslt (cpe*)](l/libxslt) - Depends upon libxml2 and used by util-linux

  * [Perl (cpe*)](p/Perl) - The Perl packages included in the 2021b version of Perl in the EasyBuilders
    repository need DB, expat, ncurses, termcap and zlib from block 1, libreadline
    from block 2 and libxml2 from block 4


## Block 6

  * [intltool (cpe*)](i/intltool) - A build dependency for the X11 bundle. The only reason why this
    package is so far down is because it requires a specific Perl package during the
    build so we wanted to build with our own Perl to be sure it is there.

  * [gdbm (cpe*)](g/gdbm) - Library of database functions. Needs ncurses (block 1), libreadline
    (block 2), libiconv (block 3), gettext (block 5)

  * [libwebp (cpe*)](l/libwebp) - Image library, depends on giflib, libjpeg-turbo (block 1), libpng
    (block 2) and LibTIFF (block 5)

  * [PROJ (cpe*)](p/PROJ) - Needs cURL (block 2), SQLite (block 3) and LibTIFF (block 5)

  * [util-linux (cpe*)](u/util-linux) - Depends on ncurses, zlib (block 1), libreadline, file (block
    2), gettext and libxslt (block 5), libxslt (block 6)


## Block 7

  * [fontconfig (cpe*)](f/fontconfig) - Depends on expat (block 1), freetype (block 3), util-linux
    (block 6) and is needed by X11

  * [GLib (cpe*)](g/GLib) - Depends on libffi (block 1), PCRE2, libiconv (block 3), libxml2 (block
    4), gettext (block 5), util-linux (block 6).


## Block 8

  * [libgd (cpe*)](l/libgd) - Depends on libjpeg-turbo, zlib (block 1), libpng (block 2) and
    fontconfig (block 7)

  * [X11 (cpe*)](x/X11) - Depends on bzip2, xorg-maxros, zlib (block 1), libpciacces (block 2), freetype
    (block 3), intltool (block 4), fontconfig (block 8)


## Block 9

  * [cairo (cpe*)](c/cairo) - A lot of dependencies, also X11 (block 8)

  * [FFmpeg (cpe*)](f/FFmpeg) - Depends on FriBidi, bzip2, zlib, x264, x265 (block 1), LAME (block 2),
    freetype (block 3), fontconfig (block 8) and X11 (block 8)

    TODO: FFmpeg for Cray and AOCC???

  * [Tk (cpe*)](t/Tk) - Depends on zlib (block 1), Tcl (block 2) and X11 (block 8)

    UPDATE, synchronizes with EasyBuild.


## Block 10

  * [GObject-Introspection (cpe*)](g/GObject-Introspection) - Depends on libffi (block 1), util-linux (block 6),
    GLib (block 7) and cairo (block 9)


## Block 11

  * [HarfBuzz (cpe*)](h/HarfBuzz) - Deopends on ICU (block 1), freetype (block 3), GLib (block 7),
    cairo (block 9) and GObject-Introspection (block 10)


## Block 12

  * [Pango (cpe*)](p/Pango) - Depends on FriBidi (block 1), GLib (block 7), X11 (block 8), cairo
    (block 9) and HarfBuzz (block 11).


## Block 13

  * [gnuplot without Qt5 (cpe*)](g/gnuplot) - Depends on ncurses, libcerf, libjpeg-turbo (block
    1), libpng (block 2), libgd, X11 (block 8), cairo (block 9), PAngo (block 12).





## Not in the scheme

  * DFTD4



