# buildtools-python module

## Contents

Links for quick checking for version updates:

| Package    | Version link |
|:-----------|:-------------|
| Meson      | [version check](https://pypi.org/project/meson/#history) |
| SCons      | [version check](https://pypi.org/project/SCons/#history) |


## EasyConfigs

### 22.12 and 23.03 and 23.09

-   Initial version directly derived from buildtools/22.08, leaving out all the
    components that are already in buildtools/22.12 or 23.03.


### 23.09-cray-python3.10

-   Newer versions of Meson, but needs cray-python to run.

-   These were removed again for now as it turns out that when building without
    `pip` essential metadata is missing from the packages, while when running
    with `pip`, the `--no build-isolation` option causes a failure when the package
    builds the metadata, while it is not clear yet what exactly is missing.
