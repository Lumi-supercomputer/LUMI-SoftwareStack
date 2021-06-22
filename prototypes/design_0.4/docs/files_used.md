# An overview of files and where they are being used

*As GitHub markdown has pretty poor tables we currently use a list layout.*

[TOC]

## CrayPE subdirectory

  * ``CPEpackages_yy.mm.csv`` files: Two-column .csv files defining the components
    of the yy.mm CPE release.

    Much but not all of that data could be automatically extracted from the matching
    ``/opt/cray/pe/cpe/yy.mm/modulerc.lua`` file. See the [procedure to install a new
    version of the Cray PE on the system](procedures.md#-installing-a-new-version-of-the-Cray-PE-on-the-system).

## LMOD subdirectory

  * The ``LMOD`` subdirectory itself is set as the value of the environment variable
    ``LMOD_PACKAGE_PATH`` in the system setup.

  *  [``admin.lst``](../LMOD/admin.lst): Set as the value of the environment variable
     ``LMOD_ADMIN_FILE``      in the system setup.

  * [``lmodrc.lua``](../LMOD/lmodrc.ua): Set as the value of the environment variable
    ``LMOD_RC`` in the system setup.

  * [``LUMIstack_yy.mm_modulerc.lua``](../LMOD/) files: Added to the list of modulerc files in
    the ``LMOD_MODULERCFILE`` environment variable by the
    [``modules/LUMIstack``](../modules/LUMIstack) generic
    module files for the ``LUMI/yy.mm`` modules.

    Sets the default versions for the CPE release yy.mm in a way that is independent
    of everything the ``cpe/yy.mm`` modules might do (unless they really overwrite
    ``LMOD_MODULERCFILE``).

  * [``LUMIstack_modulerc.lua``](../LNMOD/LUMIstack_modulerc.lua) files: Added to the
    list of modulerc files in the ``LMOD_MODULERCFILE`` environment variable by the
    [``modules/LUMIstack``](../modules/LUMIstack) generic
    module files for the ``LUMI/yy.mm`` modules.

    Used to hide a number of modules that are of no use to ordinary users when using
    the LUMI software stacks, and provide some user-friendly aliases for the partition
    modules.

  * [``SitePackage.lua``](../LMOD/SitePackage.lua): Referred to indirectly by the
    ``LMOD_PACKAGE_PATH`` system environment variable.

    Used for various purposes

      * Site name hook to provide a base for some LMOD variable names.

      * Implementation of the module directory labeling in the avail hook.

      * A message hook that adds a reference to the LUMI support and some more information
        about the module display.

      * ``detect_LUMI_partition``: A function that can be used to request the current LUMI
        partition. This is used by the generic ``modules/LUMIstack`` modules files but put
        in ``SitePackage.lua`` to have a single point where this is implemented.

        The alternative would be to use a trick that is also used in some CPE module
        files to read in and execute code from an external file.

      * ``get_CPE_component``: A function that can be used in modulefiles to request
        the version of a CPE component. The data is read from the CPE definition files
        in the ``CrayPE`` subdirectory of the repository.

        The function is currently used in the ``modules/LUMIpartition`` generic implementation
        of the partition modules for the LUMI stacks to determine the version of the
        Cray targeting modules to add that directory to the MODULEPATH.


## Note: Files and directories referred to from outside the LUMI software structure

  * ``LMOD`` subdirectory itself as the value of the environment variable
    ``LMOD_PACKAGE_PATH``

  * ``LMOD/admin.lst`` as the value of the environment variable ``LMOD_ADMIN_FILE``

  * ``LMOD/lmodrc.lua`` as the value of the environment variable ``LMOD_RC``

