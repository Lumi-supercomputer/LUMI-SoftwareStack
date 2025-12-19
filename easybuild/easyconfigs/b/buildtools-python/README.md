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

-   Started from direct copies of the 24.11

-   But added the StreNum package as that was used by one of the packages in the 
    X11 bundle.

-   For the move to EasyBuild 5, we also moved up the package in the build sequence and
    it now uses the `-bootstrap` version of `buildtools`. This was done because we failed
    to install SCons properly in `buildtools`.

-   Meson was installed from a wheel to avoid having to install additional build dependencies
    of Meson.


### 25.09

-   As the heavy lifting was done for the transition to EasyBuild 5 in 25.03 not long
    before 25.09 was started, changes are minimal and this is mostly a trivial port of the
    EasyConfig for 25.03.
    
-   We stuck to the same version of SCons as in 25.03 as the newer version required 
    a newer version of some setup tools in Cray Python (likely setuptools).
    