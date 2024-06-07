# Issues for 23.12

-   For expat we don't follow 23.09 as there are so many CVEs for this package that
    we chose to use the newest version available at the time of building the stack
    to ensure maximum security.

-   Needed to update libidn2 to 2.3.7 as 2.3.4 did not compile with the 23.12 Cray 
    compiler.
    
-   No x265 yet for Clang-based compilers.

-   zlib is already version 1.3.1 rather than 1.2.13 used in 23.09 due to compilation
    problems with the CCE compiler.
