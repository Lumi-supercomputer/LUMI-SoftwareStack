# Buildtools-python user instructions

The `buildtools-python` module is an add-on to the `buildtools` module providing
some Python-based build tools. They have been put in a separate module as it
turns out that there can be interference with other Python tools that use a
different version of Python, so a specialised `buildtools-python` module would be
needed in that case. The reason is that the tools included in this module don't
include proper wrapper scripts or don't use any other technique to properly
set the search path to the right Python libraries without using `PYTHONPATH` 
which is not version-specific.

The module contains:

-   [meson](https://mesonbuild.com/)
-   [SCons](https://scons.org/)
