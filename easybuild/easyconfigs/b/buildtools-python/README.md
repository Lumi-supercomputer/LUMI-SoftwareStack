# buildtools-python module

## Contents

Links for quick checking for version updates:

| Package    | Version link |
|:-----------|:-------------|
| Meson      | [version check](https://pypi.org/project/meson/#history) |
| SCons      | [version check](https://pypi.org/project/SCons/#history) |


## EasyConfigs

### 22.12 and 23.03 and 23.09 and 23.12 and 24.03 and 24.11

-   Initial version directly derived from buildtools/22.08, leaving out all the
    components that are already in buildtools/22.12 or 23.03.
    
-   Stuck to these versions as:

    -   Meson 0.61.5 is the last version supporting Python 3.6
    
    -   SCons 4.8.1 may be the last version supporting Python 3.6, but
        gave installation problems as the `scons` binary was not generated.


### 23.09-cray-python3.10

-   Newer versions of Meson, but needs cray-python to run.


### 23.12-cray-python3.11

-   Stuck to the same versions of Meson and SCons as for 23.09 to minimize problems.


### 24.03-cray-python3.11

-   Updated Meson and SCons to the latest versions at the time of development of the
    EasyConfig.


### 24.11-cray-python3.11

-   Updated Meson and SCons to the latest versions at the time of development of the
    EasyConfig.

### 25.03 versions

-   For now direct copies from the 24.11 ones.

    