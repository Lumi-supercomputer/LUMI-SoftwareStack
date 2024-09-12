# Issues for 23.12

-   The Cray compiler now runs the linker with `--no-undefined-symbols` as default,
    which causes trouble with many packages that have version scripts that use exact
    patterns which doe not match a defined symbol. (And this is unfortunately a common
    thing in packages...)

-   For expat we don't follow 23.09 as there are so many CVEs for this package that
    we chose to use the newest version available at the time of building the stack
    to ensure maximum security.
    
-   FFmpeg was upgraded to 6.1.1 instead of kept at 6.0 due to build problems that 
    were solved by upgrading.
    
-   HarfBuzz was updated to 8.2.2 as version 5.3.1 did not compile with the Cray
    compiler due to stricter type cast checkings of that compiler.

-   Needed to update libidn2 to 2.3.7 as 2.3.4 did not compile with the 23.12 Cray 
    compiler.
    
-   MPFR has three failed tests with cpeCray.
    
-   zlib is already version 1.3.1 rather than 1.2.13 used in 23.09 due to compilation
    problems with the CCE compiler.

-   libevent does not offer support for OpenSSL as it did not compile in the test setup
    used to prepare the toolchain. 
   