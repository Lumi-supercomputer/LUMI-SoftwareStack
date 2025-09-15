# Cray PE integration

## Cray PE components and the configuration of the module system and EasyBuild

At several places in the configuration of the module system and of EasyBuild, information
is needed about version numbers of CPE components per CPE release.
For now, this information (and in particular version numbers) of CPE components is provided
through a a .csv-file which is edited by hand and stored in the CrayPE subdirectory.
It would be possible to extract some of the information in that file from parsing
`/opt/cray/pe/cpe/yy.mm/modulerc.lua`. In the future, HPE-Cray
may deliver that information in a more easily machine-readable format.

There are several points where we need information about versions of specific packages
in releases of the Cray PE:

  * **We need to define external modules to EasyBuild.**

    That file is currently generate by `make_EB_external_modules.py`
    which is a wrapper that calls `lumitools/gen_EB_external_modules_from_CPEdef.py`
    to generate the EasyBuild external modules file for a particular version of the
    CPE. The external module definition file is stored in the easybuild configuration
    directory and is called `external_modules_metadata-CPE-<CPE version>.cfg`. Hence
    in the current design it is named after the version of the CPE and not the name
    of the software stack, so the developer and release versions of a software stack
    would share the same file.

  * For now, as the cpe module cannot work correctly due to restrictions in LMOD,
    we need to specify the exact versions of packages in the various cpe* toolchain
    easyconfigs.

    In a later phase this may not be needed anymore though we might still want to avoid
    relying on the PrgEnv-* modules as the only source for the toolchain components
    as the components included via that file might change over time and are determined
    by a single file on the system which has to be the same for all releases.

  * **Before 21.08: we needed to overwrite the Cray PE cpe module for the release of the CPE.**

    This was needed because the `cpe` module sets the `LMOD_MODULERCFILE` environment
    variable, a problem that should be solved from release 21.08 onwards. Moreover,
    our version implements a better strategy to reload modules so that (re)loading
    a `cpe` module at the end of the configuration of the PE will always set the
    right versions. But HPE Cray will use that method also starting from 21.08 onwards
    so that our own `cpe` modules will no longer be needed.

    We use a generic implementation of the module file that simply reads the .csv file
    to find out component versions.

  * **A module avail hook to hide those modules that are irrelevant to a particular LUMI/yy.mm
    toolchain could also use that information.**

    For efficiency reasons this hook actually uses a LUA file which is generated from
    the .csv file with the components.

    Note that such a module only unclutters the display for users. A hidden module
    can still be loaded, and if that module is marked as default it would actually
    be loaded instead of another module with the same name and version.

  * The information is also used to generate a modulerc file for each particular version
    of the LUMI/yy.mm software stack to mark the specific versions of the Cray PE modules
    for that release as the default (effectively already doing part of the work of
    the `cpe` modules when loading the software stack module).

  * Within the software stack module we ensure that we load the matching version of
    the Cray targeting modules.

  * **We may need it to define Cray PE components to Spack**

    Not developed yet.



