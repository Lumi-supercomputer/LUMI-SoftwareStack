# PRoot

-   [PRoot home page](https://proot-me.github.io/)
    
-   [PRoot on GitHub](https://github.com/proot-me/proot)
    
    -   [PRoot GitHub releases](https://github.com/proot-me/proot/releases)


## EasyBuild

There is no support for PRoot in EasyBuild or Spack.


### 5.4.0 for `partition/container`

-   This EasyConfig is a LUST development, combining the installation of talloc and PRoot,
    also installed in `syslibs` and `systools` respectively, but to be used in 
    `partition/container` where we don't have those modules available.

    The idea is to obtain a single executable that only depends on system libraries,
    using a build process that EasyBuild can also do in `partition/container`, so with
    minimal tooling, using only the system gcc and make utility.
    
-   Done as a Bundle:

    -   First a static version of talloc is compiled. This is already tricky as it only
        installs shared libraries, so these are removed and replaced with a static one
        generated from the object files.
        
    -   Next we build PRoot, using the just built talloc library. Some trickery is 
        required to create the correct environment for the build process so that it uses
        the right compilers and compiler flags and can find the talloc package.
        
    -   In `postinstallcmds` we then remove all remaining pieces of talloc, to end with
        just a `proot` binary and information about its license.
