# Issues with 25.03

-   GMP may not be fully OK with cpeCray/25.03. A bunch of tests fail, but there is
    no error message that gives a proper indication of what is going on and we have 
    had no time for debugging so far.

-   pixman in 2025a is version 0.46.2 which requires Meson and Ninja. It did not build
    with the AMD ROCm compilers with justified error messages from the compiler, so we
    stuck to the version 0.42.2 that we used before. 
