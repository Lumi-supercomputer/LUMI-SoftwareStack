# Issues for 24.03

-   The Cray compiler now runs the linker with `--no-undefined-symbols` as default,
    which causes trouble with many packages that have version scripts that use exact
    patterns which doe not match a defined symbol. (And this is unfortunately a common
    thing in packages...)

-   For expat we don't follow the EasyBuild common toolchain 2023b as there are so 
    many CVEs for this package that we chose to use the newest version available at 
    the time of building the stack to ensure maximum security.

-   Using libidn2 2.3.7 rather than the 2.3.4 version used in the EasyBuild common 
    toolchain 2023b as 2.3.4 did not compile with the Cray compiler. 
    
-   No x265 yet for Clang-based compilers.

-   libevent does not offer support for OpenSSL as it did not compile in the test setup
    used to prepare the toolchain. 

    