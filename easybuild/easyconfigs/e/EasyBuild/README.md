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



## EasyBuild installation on LUMI

-   [EasyBuild EasyConfigs in the easybuilders repo](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/e/EasyBuild)

-   [p7zip in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/p/p7zip)


### General guidelines

-   Uniform way of preparing patches:

    -   Uncompress the sources tar file.

    -   Rename in the same way as the `sources` field does: `easybuild_framework-5.1.1` to
        `easybuild-framework-5.1.1`, etc. This is needed because PyPi changed the way it treats
        packages with dashes in their name somewhere between the 4.9.1 and 4.9.2 releases
        of EasyBuild.

    -   Copy the file you want to change to a file with the additional extension `.orig`.

    -   Edit the file that needs changes.

    -   Create the patch. The command we use is something like:
        ``` bash
        diff -Nau easybuild-framework-5.1.1/easybuild/tools/filetools.py.orig easybuild-framework-5.1.1/easybuild/tools/filetools.py
        ```
        Comment lines can be copied from a previous version of the patch.


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

-   During the lifetime of 24.03, we switched to patched EasyBlocks for MesonNinja and for
    ParMETIS. Though the patch was first manually applied on LUMI, the EasyConfig was later 
    modified for easier re-installation on the TDS with an appropriate patch for both files.

    
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
    
-   We also added a patch to fix an issue in the ParMETIS EasyBlock which did honour 
    `prebuildopts` but does not honour `preconfigopts` and `preinstallopts`. We needed
    `preconfigopts` to work around an issue with the AMD ROCm compilers.
    
-   Three additional tools were installed:

    -   lzip has a very standard ConfigureMake build process
    
    -   p7zip uses a MakeCp build process and we based the build process on the one 
        in the EasyBuilders EasyConfig.

    -   PRoot as that is useful if we want to use the SingularityCE unprivileged proot 
        build process in an EasyConfig to modify an existing container.


### EasyBuild 5.1.2 for 25.03

-   Patches: The way of applying patches is different in an EasyConfig just for
    EasyBuild or in the Bundle.

    -   When installing in a single package EasyBlock, patching starts from the
        sources directory that contains the framework. Which makes it harder to 
        patch EasyBlocks or EasyConfigs.

    -   When installing EasyBuild as a Bundle component, patching starts from the 
        Bundle source directory that contains all sources of all Bundle components.

    So the `patches` part cannot just be copied, we need to make some changes to the 
    directory from which they are applied.

    We also experienced trouble trying to patch in both cases which is why for both the 
    single software install and the Bundle install, we use a more elaborate version of
    specifying the patches. 

    Note that the [documentation for `patches`](https://docs.easybuild.io/patch-files/) 
    in the EasyBuild documentation was wrong
    at the time of writing (September 2025) unless it has changed in EasyBuild 5. 
    In fact, the `opts` field does not exist in EB 4.9.

-   From EasyBuild 5 onwards, we started using Cray Python as the Python implementation to run EasyBuild as
    EasyBuild 5 still supported 3.6, but it was deprecated and not well tested anymore.

    To avoid having to load the `cray-python` module as a dependency, which may interfere with installations
    that would use some other Python module, and to robustify the `eb` command and various scripts installed
    by the other Python packages, we edit those scripts with `sed`:

    -   To robustify the `eb` command:

        -   `PYTHONPATH` is hard-coded in the `eb` shell script and overwrites anything from the environment:
            ```
            '-e \'s|^PYTHON=.*|export PYTHONPATH="%(installdir)s/lib/python{local_pyshortver}/site-packages:%(installdir)s/lib64/python{local_pyshortver}/site-packages"\\nPYTHON=|\' '
            ```

        -   In the loop that searches for a suitable Python command, we added the Cray Python `python3.XX` 
            command with full path and version at the front of the list:
            ```
            '-e \'s|for python_cmd in|for python_cmd in "{local_craypython_exe}"|\' '
            ```
            with
            ```
            local_pyshortver = '.'.join(local_craypython_version.split('.')[:2])
            local_craypython_exe = f'/opt/cray/pe/python/{local_craypython_version}/bin/python{local_pyshortver}'
            ```
            Therefore we don't need to load the `cray-python` module anymore when running if we do this
            in all such scripts.
            Hence strictly speaking EB_PYTHON is no longer needed.

    -   We used a similar strategy to robustify scripts from additional Python packages 
        that we installed. See the next step for how we built a list of packages and 
        package versions to install.
        
        Steps to robustify (applied to `archspec, `pygmentize`,`markdown-it` and `pycodestyle`):

        -   We change the shebang line to explicitly call `python3.XX` from `cray-python` with full path
            and version, and we added the -E option to avoid using the value of PYTHONPATH:
            ```
            '-e \'s|/opt/.*/python|{local_craypython_exe} -E|\''
            ```
            This again ensures that these scripts can run without the `cray-python` module loaded.

        -   We then used `sys.path.append` to add the `lib` subdirectory of the installation directory 
            to the Python search path.
            ```
            '-e \'s|import sys|import sys\\nsys.path.append("%(installdir)s/lib/python{local_pyshortver}/site-packages")|\''
            ```
    These steps were already the 4.9.2 version that we used from 23.12 onwards, but then using the system Python
    `python3.6` interpreter from the system installation instead.

-   Additional Python tools: We like to add them to the same module in the EasyBuild 
    installation, as that avoids a "chicken-and-egg" problem where we would need a 
    bootstrapping process to install a module with those packages which are then 
    used by another EasyBuild module, or we would have to add code to the module file
    that only tries to load that module if it can find it, but does not produce an
    error if it cannot load it (which in fact is easy in Lmod).
    
    Packages that are useful for EasyBuild 5:

    -   `rich` for rich output such as the progress bars.
    -   `PyYAML` for using EasyStack files. It is useful in containers where we do not yet have it,
        but note that Cray Python comes with yaml, so we don't need it in EasyBuild installations 
        based on `cray-python`.. 
    -   It looks like EasyBuild 5 does not use `archspec` anymore. It may still be useful to include to
        invest system properties, but we leave it out 
    -   `pycodestyle` for checking code style is also relatively innocent as it does not pull in other 
        dependencies. It is needed for `--check-style` and `--check-contrib`.
    -   `graphviz` is relatively innocent. It can be used for building dependency graphs in PDF or
        PNG formats and doesn't seem to need any dependencies.
    -   `python-graph-dot` builds dependency graphs in `.dit` format and this one also pulls in
        three other packages. 
    -   `GitPython` could be added and has a reasonable number of dependencies, but we have no clear
        use case for it at the moment.
    -   `keyring` could be added, but it may not even be fully functional on the compute nodes.
        And it comes with a crazy number of dependencies that also need to be installed.
   
    To prepare a list of package versions and their dependencies, experiment in a virtual 
    environment. For our EasyBuild 5.1.1 EasyConfig with `cray-python/3.11.7`, we explored:
    ``` bash
    python3.11 -m venv ebtest
    cd ebtest && source bin/activate
    # Need wheel as otherwise EasyBuild cannot properly install package is setuptools < 70.1
    pip3.11 install wheel
    # The rich package
    pip3.11 install rich
    # This also pulls in mdurl, pygments and markdown-it-py
    # archspec
    pip3.11 install archspec
    pip3.11 install pycodestyle
    ```
    
    Installing those packages, turned out to be painful though:

    -   Doing things the "regular" way, i.e., installing from sources, was cumbersome as now
        EasyBuild also requires that you install all build dependencies of those packages,
        and of course, do so in the right order. The result is an explosion of packages
        beyond control, and somehow we could not install `poetry` on top of Cray Python from sources.
        Moreover, those packages did not show up when we installed in the virtual environment,
        so it is hard labour to build the complete list.
        
    -   What worked better, and is as good as all the packages that we finally selected were pure
        Python packages anyway, was installing from wheels. The only thing you need to do is then 
        use `'source_tmpl': '%(name)s-%(version)s-py3-none-any.whl'` (most packages) or
        `'source_tmpl': '%(name)s-%(version)s-py2.py3-none-any.whl'` depending on the package
        (and you can put this into `exts_default_options` of course). Installation then went smoothly.
        
    -   The horror then came with the EasyBuild sanity checks as it absolutely wanted 
        a compatible Python in the `PATH` which we wanted to avoid. So for now we add 
        the Python binary at the end of the search `PATH`.
        
-   With the `EB_EasyBuildMeta` EasyBlock or its LUMI-specific variant, it is impossible to install EasyBuild
    so that it uses a different Python version than the one used by the `eb` command that does the installation.
    (Or is it impossible to use non-system Python?)
    
    Moreover, after creating a bootstrap version using the `pip install` procedure, 
    it turned out that the `EB_EasyBuildMeta` EasyBlock doesn't work with Cray Python, likely as 
    the `wheel` package that provides `bdist_wheel` is missing and the version of 
    `setuptools` is also older than 70.1 (the first version that actually contained the 
    `bdist_wheel` command itself).
    
    This was accomplished by using the `PackedBinary` generic EasyBlock with a custom
    `install_cmds` similar to what is done in the EasyBuilders recipes for NextFlow.
    The advantage of this is that we don't need to do any installation work anymore in a `postinstallcmds` 
    which is also a cleaner approach. (We still use it in the Bundle for work on other packages though.)

    After all, it is not clear though if the `EB_EasyBuildMeta` EasyBlock offers any advantages when used in a Bundle as it is mostly about 
    sanity checks that are not executed properly anyway when EasyBuild is installed as component in a Bundle as
    we started doing on LUMI at some point to include some other useful software for EasyBuild installations.

-   It turns out that EasyBuild 5.1 is less strict in its Python tests than EasyBuild 4.9:

    -   For 4.9.4, we need to add Cray Python to the `PATH` even though it is needed for nothing. 
        Otherwise the sanity checks fail.
        
        Of course, in the logic of using EasyBuild as a library, one would even need 
        to have the correct Python library as a depedency, but that could only cause issues
        when EasyBuild is then used to install another Python version or packages for a different
        Python version.
        
    -   For 4.9.4, we also needed to add `PYTHONPATH` (which is not done automatically in our case)
        to pass all sanity checks.
        
    These are not needed anymore in 5.1.2.
    
    So we developed a rather minimal `EasyBuild-5.1.2-bootstrap.eb` that can be installed with 4.9.4 
    to then use it to install `EasyBuild-5.1.2.eb` without going through our software stack build
    bootstrap procedure as for now we stick to 4.9.4 as the default EasyBuild for 25.03.

-   To make our EasyConfig work on the TDS without internet access, we also needed to install the
    `flit_core` and `wheel` package and make sure they were in the `PYTHONPATH` while doing the pip 
    installs of EasyBuild.

-   On SUSE 15 SP6, the semantics of the `sed` command have changed and it now resets the permissions of
    a file that is edited in-place to `600`, independent of the value of `umask`. So we need to restore
    the permissions on some of the scripts in the `bin` subdirectory.


### 5.2.0 for 25.09

-   Likely a temporary version as we will switch to 5.2.1 when this becomes available.

-   Direct port of the 5.1.2 EasyConfig but an extra LUMI-specific patch was needed to fix a regression.
    The patch is taken from the development version of EasyBuild 5.2.1.


## Fixes needed to EasyConfigs

### METIS

Issue: `preconfigopts` is not honoured while we want to use it to edit `metis.h` with `sed`.

The fix required changing 1 line the EasyBlock in 5.1.2:
[Line 62](https://github.com/easybuilders/easybuild-easyblocks/blob/easybuild-easyblocks-v5.1.2/easybuild/easyblocks/m/metis.py#L62):

```
            cmd = "make %s config prefix=%s" % (self.cfg['configopts'], self.installdir)
```
becomes
```
            cmd = "%s make %s config prefix=%s" % (self.cfg['preconfigopts'], self.cfg['configopts'], self.installdir)
```


### ParMETIS

Issue: `prebuildopts` is honoured correctly, `preconfigopts` and `preinstallopts` are 
not.

The fix requires changes to only 2 lines in the EasyBlock:

-   [Line 95-96](https://github.com/easybuilders/easybuild-easyblocks/blob/easybuild-easyblocks-v4.9.4/easybuild/easyblocks/p/parmetis.py#L95):

    ```
                    cmd = 'cmake .. %s -DCMAKE_INSTALL_PREFIX="%s"' % (self.cfg['configopts'],
                                                                       self.installdir)
    ```
    becomes
    ```
                    cmd = '%s cmake .. %s -DCMAKE_INSTALL_PREFIX="%s"' % (self.cfg['preconfigopts'], self.cfg['configopts'],
                                                                       self.installdir)
    ```
    
-   [Line 141](https://github.com/easybuilders/easybuild-easyblocks/blob/easybuild-easyblocks-v4.9.4/easybuild/easyblocks/p/parmetis.py#L141):
    ```
                cmd = "make install %s" % self.cfg['installopts']
    
    ```
    becomes
    ```
                cmd = "%s make install %s" % (self.cfg['preinstallopts'], self.cfg['installopts'])
    ```
    
This changes will also carry over easily to EasyBuild 5 as the major change to the EasyBlock 
there is the switch from `run_cmd` to `run_shell_cmd`. The line number of the second change has
changed though due to the removal of some Python 2 code.
