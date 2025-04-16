# EasyBuild for LUMI

-   [Main EasyBuild web site with links to documentation and sources](https://easybuild.io/)

-   PyPi:

    -   [easybuild install package](https://pypi.org/project/easybuild/)

    -   [easybuild-framework](https://pypi.org/project/easybuild-framework/)

    -   [easybuild-easyblocks](https://pypi.org/project/easybuild-easyblocks/)

    -   [easybuild-easyconfigs](https://pypi.org/project/easybuild-easyconfigs/)

-   Additional tools:

    -   lzip:

        -   [Home page](https://www.nongnu.org/lzip/)
    
    	  -   [Downloads](https://download.savannah.gnu.org/releases/lzip/)
    	  
    -   p7zip
    
        -   [p7zip on GitHub](https://github.com/p7zip-project/p7zip/)

        -   [GitHub releases](https://github.com/p7zip-project/p7zip/releases)
    
    
## A note on p7zip

The p7zip package is a POSIX/Linux port of some of the 
[p7zip Windows tools](https://www.7-zip.org/).
Note that the latest version of 7zip do now support Linux already.

The p7zip tools however are used in certain EasyConfigs to work with ISO files,
e.b., the [MATLAB EasyConfigs in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/m/MATLAB).

-   New developments [on GitHub](https://github.com/p7zip-project/p7zip/).
    It is a fork from previous versions that are no longer maintained.
    It also extends the tools of the [7zip project](https://sourceforge.net/projects/sevenzip/)

    -   [GitHub releases](https://github.com/p7zip-project/p7zip/releases)


-   Older versions [on SourceForge](https://p7zip.sourceforge.net/)

    -   [SourceForge downloads](https://sourceforge.net/projects/p7zip/files/p7zip/)
        (up to version 16.02)



## EasyBuild

-   [EasyBuild EasyConfigs in the easybuilders repo](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/e/EasyBuild)

-   [p7zip in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/p/p7zip)


### Version 4.4.2 for LUMI/21.08

-   Started from the default EasyConfig but added additional help information
    to the module file.


### Version 4.5.3 for LUMI/21.12

-   We activated the new feature to show a progress bar and also added support
    for `archspec`. This is done by adding additional packages via extensions
    in the EasyConfig. It is a very fragile combination though, only very
    specific combinations of version worked.


### Version 4.6.0 for LUMI/22.06 and LUMI/22.08

-   The additional packages that are used to activate `archspec` in EasyBuild
    and to provide the progress bar are a very fragile mix. Updating any of them
    to newer versions didn't work, maybe due to the lack of `pip` and the very
    old version of `python` as the system Python.

### Version 4.7.1 for LUMI/22.12 and LUMI/23.03

-   Trivial port of the 4.6.0 EasyConfig.


### Version 4.8.2 for LUMI/23.09

-   Trivial port of the 4.7.1 EasyConfig.

-   In a later update we added support for loading `EasyBuild-tools` if available.


### Version 4.9.2 for LUMI/23.12 and 24.03

-   Started as a trivial port of the 4.8.2 EasyConfig

-   At first removed support for loading `EasyBuild-tools` as the reason for it is  
    no longer there (MATLAB installation done differently).
    
-   Added `PyYAML` to the list of extra Python packages as we also wanted to use EasyBuild
    with EasyStack files in a container that did not have `PyYAMSL` in its system Python
    installation.
    
    The problem with this package is that it installs its egg in `lib64` instead of 
    in `lib` so that two directories need to be added to `PYTHONPATH`.

-   Needed to modify `libsci.py` in `toolchains/linalg` in the framework as it should
    now check `CRAY_PE_LIBSCI_PREFIX_DIR` instead of `CRAY_LIBSCI_PREFIX_DIR`. For now
    we check for both so that the same EasyConfig can also be used to install EasyBuild
    for older versions of the Cray PE.
    
-   Wanted to use `postinstallcmds` to robustify a number of scripts, but that was  
    not supported by the EasyBlock so that one needed to be changed also.
    
    -   Robustify the `eb` command:
    
        -   `PYTHONPATH` is hard-coded in the `eb` shell script and overwrites anything 
            from the environment.
            
        -   In the loop that searches for a suitable Python command, we added the system
            Python with full path and version at the front of the list. Hence strictly
            speaking `EB_PYTHON` is no longer needed.

    -   Robustifying the `archspec`, `cmark` and `pygmentize` scripts put in the `bin`
        directory when installing their respective additional packages:
        
        -   Shebang line changed to explicitly call `python3.6`, and added the `-E` 
            option to avoid using the value of `PYTHONPATH`
            
        -   We then used `sys.path.append` to add the `lib` subdirectory to the Python 
            search path. The `lib64` subdirectory was not added as `PyYAML` is not needed
            by those commands.

-   And added sanity checks that explicitly unset `PYTHONPATH` to verify that these commands
    indeed work without `PYTHONPATH`.
    
-   The module however still sets `PYTHONPATH` as (1) this is difficult to turn off, it is 
    one of those variables generated automatically by EasyBuild if it finds a certain directory,
    and (2) it is still needed when using EasyBuild as a library.

    
### Version 4.9.4 for LUMI/24.11

-   A big reworking as we now include additional tools in the module. The EasyConfig 
    has been converted into a Bundle.

-   The patch for LibSci was not needed anymore, and the one for keyring has been modified 
    a bit.
    
-   The patch for keyring was revised and an additional patch was added to support 
    lzipped tarballs (simple by modifying `tools/filetools` in `easybuild-framework`). 
    
    The patches have to be made differently from before as otherwise EasyBuild could not find
    where to apply the patch. So we now start from the `system-system` subdirectory 
    in the unpacked installation and refer to the relative path with respect to this subdirectory
    for all patches. This may also require modifying patches that come from the EasyBuild 
    repository itself.
    
-   Two additional tools were installed:

    -   lzip has a very standard ConfigureMake build process
    
    -   p7zip uses a MakeCp build process and we based the build process on the one 
        in the EasyBuilders EasyConfig.

    