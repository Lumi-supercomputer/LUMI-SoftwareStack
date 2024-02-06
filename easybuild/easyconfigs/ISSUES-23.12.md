# Issues for 24.03

-   x265 does not yet compile with CCE 17.

-   MPFR does fail a number of tests in cpeCray, so testing has been turned
    off for now.

-   libjpeg-turbo fails a number of tests in cpeCray, so testing has been turned
    off for now.

-   GNOME packages still missing due to too many problems building those with their
    exotic build tools: GLib, cairo, GObject-Introspection, HarfBuzz, Pango.
    Hence GNUplot also cannot be built.


## OLD

-   Boost does not compile with cpeCray... For some reason it goes looking for
    libunwind.so in the wrong compiler directory.

-   Check if the new FFmpeg works with the Cray compilers (and AMD compilers?)


To do later:

-   Installing buildtools with byacc 20230521 did not work. Check what is wrong with 
    that version for future installations?

-   Upgrading to util-linux 2.39 did not work, have a look at it in the future.


## OLD TEXT

-   With ncurses we're using 6.4 instead of the 6.3 from 2022b due to a bug in the processing of
    `--enable-pc-files --with-pkg-config-libdir` in 6.3.
    
    -   And there is still the incompatibility with gdb on SP3. This is due to some 
        very old version info missing in the shared library. Such info nowadays
        seems to be defined in package/*,map, but I have no idea how to patch the files
        to show the ancient versions that the gdb executable expects.
        
        Also google for `.gnu.version_d `.
        
        The workaround for the system gdb is to start it as
        
        ```
        LD_PRELOAD=/lib64/libncursesw.so.6 gdb
        ```
        
-   Still no GMP for cpeAMD as it fails in the tests.

-   Note that we were unable to upgrade SCons to 4.5.1 as that version was too new 
    for Serf included in syslibs.
    
-   The nano installation would like a newer groff with HTML support but since we
    have no browser on LUMI this has a very, very low priority.

-   Blosc should have another look as it actually also has dependencies on other 
    comnpression tools for which we currently use internal sources.
