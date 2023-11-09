# buildtools-python module

The `buildtools-python` module is an add-on to the `buildtools` module providing
some Python-based build tools. They have been put in a separate module as it
turns out that there can be interference with other Python tools that use a
different version of Python, so a specialised `buildtools-python` module would be
needed in that case. The reason is that the tools included in this module don't
include proper wrapper scripts or don't use any other technique to properly
set the search path to the right Python libraries without using `PYTHONPATH` 
which is not version-specific.


## Contents

The contents of the module evolved over time. It does contain a subset of:

-   Meson [version check](https://pypi.org/project/meson/#history)
-   SCons [version check](https://pypi.org/project/SCons/#history)


## EasyConfigs

### 22.12 and 23.03 and 23.09

-   Initial version directly derived from buildtools/22.08, leaving out all the
    components that are already in buildtools/22.12 or 23.03.


### 23.09-cray-python3.10

-   Newer versions of Meson, but needs cray-python to run.

