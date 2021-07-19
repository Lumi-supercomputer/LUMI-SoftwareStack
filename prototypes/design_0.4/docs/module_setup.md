# Setup of the LUMI module system


### Features of the module system on LUMI

  * The module system is organised in software stacks enabled through loading a
    meta-module. ``CrayEnv`` will enable the native Cray environment for developers
    who prefer to do everything themselves, while the ``LUMI/yy.mm`` modules enable
    the LUMI software stacks, based on the corresponding yy.mm version of the Cray
    programming environment.

  * When it matters, the module system will automatically select the software for
    the partition on which the software stack was loaded (and change to the correct
    partition in Slurm batch scripts if you reload the LUMI module). It is always possible
    to overwrite by loading a partition module after (re)loading the software stack
    meta-module.

    Moreover, we ensure as much as possible that after loading a different partition,
    already loaded modules are reloaded in as reasonable versions as possible.

    NOTE:

      * LMOD 8.3.x, the default on Cray with the 21.06 software release: ``module update``
        does not work correctly and the way to trigger a reload of the software stack
        in case of a possible partition change is

        ```bash
        module load LUMI/$LUMI_STACK_VERSION
        ```

      * In LMOD 8.4.x and 8.5.x, it is possible to instead use ``module update``, and
        there seems to be an undocumented ``module reload`` that has exactly the same
        effect.

  * User-friendly presentation with clear labels is the default, and there is a user-friendly
    way to change the presentation through modules rather than by setting LMOD environment
    variables by hand.

    We also do an effort to hide modules that a regular user does not need at some
    point, e.g., EasyBuild configuration modules to install in the system directories,
    or those Cray PE modules that are not relevant for a particular version of the
    LUMI software stack.

  * Discoverability of software is a key feature. The whole module system is designed
    to make it easy to find installed software through ``module spider`` and ``module
    keyword`` even if that software may not be visible at some point through ``module
    avail``.

  * The modules that load the software stack and partition, and the modules that
    influence the presentation of the modules are sticky so that ``module purge``
    will not remove them. Hence a user who wants to continue working in the same
    software stack can use ``module purge`` to unload all software stack-specific
    modules without having to start from scratch.


### Assumptions in the implementation

  * The SoftwareStack module relies on the ``detect_LUMI_partition`` function in
    ``SitePackage.lua`` to determine on which partition it is running.

    The current implementation of that function assumes that the  system sets an environment
    variable LUMI_PARTITION with value C, G, D or L depending on the node type (CPU compute,
    GPU compute, data and visualisation, login).
    This is used by the SoftwareStack module to then auto-load the
    module for the current partition when it is loaded. That function can be implemented
    differently also so that the environment variable is no longer needed.

  * The current implementation assumes that ``LMOD_PACKAGE_PATH`` refers to the LMOD
    directory in the repository as that is used to determine the name of the repository
    (rather than use a hardcoded name, e./g/. ``SystemRepo``).


### Default behaviour when loading modules

  * A user will always need to load a software stack module first.

      * For those software stack modules that further split up according
        to partition (the LUMI/yy.mm modules), the relevant partition
        module will be loaded automatically when loading the software
        stack. This is based on the partition detected by the
        detect_LUMI_partition function defined in SitePackage.lua.

  *  We made the SoftwareStack and LUMIpartition
     modules sticky so that once loaded a user can use ``module purge`` if they
     want to continue working in the same software stack but load other packages.


### Module presentation

  * The LUMI module system supports three ways of presenting the module to the users

     1. The default way users user-friendly labels rather than subdirectories to present
        the modules. Sometimes several subdirectories may map to the same label when
        our feeling is that those modules belong together for the regular user.

        There are two variants of this view:

         a. All Cray PE module directories collapsed into a single category. This
            style is called ``label``.

         b. User-friendly names for the Cray PE module directories, but showing the
            full hierarchy. This is called the ``PEhierarchy`` style.

     2. But of course the view with subdirectories is also supported for the power
        user. This is called the ``system`` style.

    The implementation of the labeled view is done in the ``avail_hook`` hook in the
    ``SitePackage.lua`` file and is derived from an example in the Lmod manual.

  * To not confront the user directly with all Lmod environment variables that influence
    the presentation of the modules, we also have a set of modules that can be used
    to change the presentation, including

      * Switching between the label, PEhierarchy and system (subdirectory) view

      * Showing extensions in module avail

      * Turn on and off colour in the presentation of the modules as the colour selection
        can never be good for both white background and black background (though of
        course a power user can change the colour definitions in their terminal emulation
        software to ensure that both bright and dark colours are displayed properly).

    The presentation modules are sticky so that ``module purge`` doesn't change the
    presentation of the modules.

  * There is a "power user" view that will reveal a number of modules that are
    otherwise hidden. This is at their own risk. Use of this module is not documented
    on the regular LUMI-documentation.

  * There are also two ``ModuleStyle`` modules that try to reset the presentation to
    the system defaults or whatever the user may have set through environment variables.


### The common software subdirectories

  * We have a set of subdirectories for each of the 4 LUMI partitions on which the
    modules are available. However, we also have a directory to install software that
    is common to all partitions and doesn't need specific processor optimisations hence
    is simply compiled for the minimal configuration that works everywhere, Rome without
    accelerator.

  * We use a hidden partition module (``partition/common``) which can then be recognized
    by the EasyBuild configuration modules to install software in that partition.

      * Hiding is done via the ``LMOD/LUMIstack_modulerc.lua`` file.

      * The path to the common software modules is added in the other partition module
        files, always in such a way that the partition-specific directory comes before
        the equivalent common directory to ensure that partition-specific software
        has a higher priority.

        Yet because of the way that LMOD works, it is still better to either install
        a certain package only in the common partition or only in the other partitions
        as the order in the MODULEPATH is not always respected if a particular version
        is hard-marked as the default.

      * Moreover, the labeling in SitePackage.lua is such that in the labeled view one
        sees the common and partition-specific software is put together. This is another
        reason to not have a package in both the common subdirectory and in one or
        more of the regular partition subdirectories as it would appear twice in the
        list for that partition.

  * A hidden partition module did show up into the output of ``module spider`` as a way to
    reach certain other modules. This was the case even when it was hidden by using a name
    starting with a dot rather than a modulerc.lua file. This "feature" is also mentioned
    in [Lmod issue #289](https://github.com/TACC/Lmod/issues/289).

      * Our solution was to modify the module file itself to not include the paths when the
        mode is "spider" so that Lmod cannot see that it is a partition module that makes
        other modules available.

        **TODO: Do show for power users????**

  * We needed an additional module tree, ``Infrastructure``, which works a pure hierarchy
    (i.e., the common subdirectory is not loaded in the MODULEPATH of any other partition)
    to ensure that ``module update`` and changing partitions works well for modules
    that have to be present in all four regular partitions and the common meta-partition,
    e.g., cpe* modules needed by EasyBuild and EasyBuild configuration modules.

  * We also use a visibility hook for LMOD to hide modules from the Cray PE that are
    not relevant for a particular version of the LUMI software stack.

    The data used by that hook is stored in the ``mgmt/LMOD/VisibilityHookData`` directory
    in a format that favours speed over readability and is auto-generated by a script
    based on the description of a version of the CPE.


### Where do we set the default modules?

  * Style modifiers: LMOD/modulerc.lua (central moduler.lua file)

  * Software stack: Currently by a hidden ``.modulerc.lua`` file in the ``SoftwareStacks``
    subdirectory since we use different defaults on different test systems.

  * Partition: No assigned default, the software stack module determines the optimal
    partition based on the node where that module is loaded.

  * Cray PE compoments: Depending on the version of the LUMI stack loaded, different
    versions of the modules in the Cray PE will be the default ones, corresponding
    to the release of the PE used for that stack. These defaults are set in
    ``LMOD/LUMIstack_<version>_modulerc.lua``, which can be generated with the
    ``make_CPE_modulerc.sh`` script.

    Note that loading a ``cpe/yy.mm`` module may overwrite this depending on the implementation
    of that module.


### Helper functions in SitePackage.lua

See [the separate SitePackage information file](SitePackage.md).
