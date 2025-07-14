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
    
    -   For GLib, versions up to and including 2.80.5 seem OK.
    
    -   GObject-Introspection: The EasyConfig, while using the same dependencies as 
        the EasyBuilders one, has issues. It specifies GLib as a dependency. However,
        it turns out that GObject-Introspection uses its own GLib code and hence
        `libglib-2.0.so.0` library. So recent versions of GObject-Introspection 
        have the same issue as GLib. E.g., GObject-Introspection 1.84.0 uses
        GLib 1.82.0 internally, which is already a problematic version. One issue is
        that it is hard to figure out which version of GObject-Introspection is using
        which version of GLib as they only recently started fixing the version in
        GitHub.
        
        Based on the release date, versions up to 1.80.1 are probably OK.

    It looks as if in some circumstances, the `libglib-2.so.0` from the system is being
    picked up rather than one from EasyBuild.
    