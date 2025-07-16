# Issues with 25.03

-   GMP may not be fully OK with cpeCray/25.03. A bunch of tests fail, but there is
    no error message that gives a proper indication of what is going on and we have 
    had no time for debugging so far.

-   pixman in 2025a is version 0.46.2 which requires Meson and Ninja. It did not build
    with the AMD ROCm compilers with justified error messages from the compiler, so we
    stuck to the version 0.42.2 that we used before. 

-   GObject-Introspection and GLib are problematic packages. For some reason, recent 
    versions of those packages don't work correctly on LUMI and generate a long Python
    error that comes down to an `undefined symbol: g_string_free_and_steal`, a symbol 
    that comes from the GLib libraries.
    
    It looks as if in some circumstances, the `libglib-2.so.0` from the system is being
    picked up rather than one from EasyBuild. We had to play a bit with version to 
    find a combination that seems to work, but future issues cannot be excluded.

-   There are issues with ParMETIS on cpeAMD.

    
