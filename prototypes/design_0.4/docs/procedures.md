# Some procedures

## Installing a new version of the Cray PE on the system

### Part 1: Making available in CrayEnv

These instructions are enough to make the new CPE available in the ``CrayEnv`` stack
but do not yet include instructions for EasyBuild

  * Install the CPE components using the instructions of HPE

  * Add a corrected cpe/yy.mm.lua file to the appropriate ``modules/CrayOverwrite``
    subdirectory. Take the existing files as an example.

      * Check if there are any new components that need to be added to either that file or
        to the ``cpe/restore-defaults`` module.

      * Consider switching the default cpe version in ``modules/CrayOVerwrite/.../cpe/.modulerc.lua``.

  * Hide the new cpe module installed in the Cray PE subdirectory by adding a line to
    ``LMOD/modulerc.lua`` in the repository.

### Part 2: Adding support as a LUMI/yy.mm(.dev) software stack

TODO! NOT COMPLETE!

  * Create the components file in the ``CrayPE`` subdirectory of the repository.
    This is currently a simple .csv-file but may be replaced by a different one if
    HPE would provide that information in machine-readable format in a future version
    of the CPE.

    Much of that information can be extracted from the HPE-Cray provided file
    ``/opt/cray/pe/cpe/yy.mm/modulerc.lua``, though we do currently keep some additional
    packages in that file that don't have their defaults set in that file. One of them
    which is actually used in the LUMIpartition module file is the version of the
    craype-targets packages (essentially the CPE targeting modules).

  * Create in the repository a matching ``LMOD/LUMIstack_yy.mm_modulerc.lua`` file. The
    contents of this file is the same as the HPE-Cray provided file
    ``/opt/cray/pe/cpe/yy.mm/modulerc.lua`` in the current interpretation. The only reason
    why we use our own copy rather than referring to the Cray-provided file is to ensure
    that the file remains part of the the ``LMOD_MODULERCFILE`` series of files independent
    of load and unload operations of the ``cpe`` modules.

  * If there are new Cray targetting modules that are irrelevant for LUMI you may want to
    hide them in the respective code block in ``LMOD/LUMIstack_modulerc.lua``.

