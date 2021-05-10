# Design 0.4 of the module system

This prototype focuses on the EasyBuild setup.

Changes compared to design 0.3:

  * We implemented only the stack_partition variant to reduce the amount of work.

  * Added a directory with LUA modules to change the presentation of the module tree.

  * Added a partition/common to be able to install software that is suitable for all
    partitions. That module is hidden however. It is there to be able to install
    software in that partition but it will not show up, e.g., in the output of
    "module spider" as a way to reach software.

    Elements of the implementation:
      * Hidden by a line in .modulerc.lua
      * Made sure it does not show up as a path to reach software in "module spider"
        by ensuring that the prepend_path statements of partition/common are not seen
        if mode() == "spider".
      * Add the common software to the path of the other partition modules.
      * Make sure it does not show up in the labeled view but that its software is
        added to the actual partition.

  * Scripts to generate the external modules configuration file for EasyBuild based
    on a Python script that defines the Cray PE compoments and then some more so that
    it should be possible to extend to other configuration files that need the same
    information.

Changes compared to design 0.2:

  * Design 0.2 is robust but it requires generating the software stack and partition
    modules by preprocessing templates. In design 0.3 we seek to avoid this by using
    the Lmod introspection functions, but this requires a different way of setting
    up the module structure to be compatible with the way Lmod handles a module hierarchy.

    A bonus is that it may be easier to from there extend the hierarchy with additional
    levels the way, e.g., Spack would do it.

  * As we ran into problems with the module ``LUMIpartition/L.lua`` where the Lmod
    ``hierarchyA`` function got confused and provided different results than if the
    module were called ``LUMIpartition/C.lua``, we decided to rework some of the names
    and simply use, e.g., ``partition`` for the module name even if that may cause
    confusion with SLURM partitions.

    *This appears to be a very subtle bug in LMOD, and it is not clear what triggers
    it as we have tried with other combinations of module names also appearing in the
    path and different version names of the modules, but couldn't trigger the bug.*

  * The prototype now also demonstrates the use of the ``extensions`` function in Lmod
    module files to make it easier to find extensions provided by some modules (e.g.,
    Python, R or Perl packages).

  * The prototype now also provides a "SitePackage.lua" file for Lmod to demonstrate
    various customizations that can be made this way. This includes an additional message
    in the ``module avail`` method to point the user to other (Lmod-specific) ways
    of searching for certain software, and providing more human-readable labels to
    the blocks in the output of ``module avail``.

  * We also added the detect_LUMI_partition function to SitePackage.lua to take the
    code to detect on which LUMI partition we are running out of the module files so
    that we can change it more easily to something more robust then the current detection
    which is based on the environment variable LUMI_PARTITION that should be set by
    the system.

  * Added an lmodrc.lua file to assign a state to the software stack: Lont-Term Support
    or development. This is done via a property in the module file, a modulerc file
    to ensure that the default is a LTS stack and an lmodrc.lua file to assign labels
    to each state and print a line of information below the table.

  * Also experimented with a modulerc.lua file for the partitions to show version aliases with
    more meaningful but longer names.

  * Added an admin.list file to demo how a user could be warned of deprecated modules.

  * Moved from LUMI-C etc. to C, G, D or L for the LUMI_PARTITION environment variable.

  * We ensure that ``module reload`` works correctly in both variants, with this special
    property:

      * In the stack-partition version, the reload will cause a switch to the partition
        module for the node on which the module reload is executed.

      * In the partition-stack variant with partition/auto loaded, a ``module reload``
        will reload with the software stacks activated for the partition on which the
        ``module reload`` was executed.

Changes compared to design 0.1:

  * We rely on the Cray LMOD modules for the programming environment
    and don't try to copy those to our own directory structures as
    there is not that much to gain from it given the hierarchical
    structure.

  * We avoid reading environment variables in the partition and stack
    modules and instead produce them via running a template through
    the gpp preprocessor. This
    is simpler than letting each module
    remember its settings.
  * We need to see if we will create PrgEnv-* equivalents in the
    LUMI/yy.mm software stacks using EasyBuild (as in CSCS) or via
    our own script, in which case we would put them elsewhere. In that
    case we could even initialise a LUMI/yy.mm software stack without
    using EasyBuild, which granted is not a good match with the
    "EasyBuild first" strategy.


## Running and installing the prototypes

  * LMOD must be installed and correctly initialised before trying out the prototypes.
    ``gpp`` is not needed for this version.

  * ``prototypes/design_0.3`` contains two ``make_*`` scripts to build both variants
    of the prototype (in subdirectories of $HOME/appltest/design_0.3).

  * That directory also contains two ``enable_*`` scripts to initialise the environment
    to test the respective prototype. Source the scripts in the shell or use
    ```bash
    eval $(./enable_stack_partition.sh)
    ```
    in that directory. Then try ``module avail`` and ``module help`` to get started.


## Difficulties that we need to deal with or experiment with

  * The CSCS approach is to go for fully separated toolchains, rebuilding everything
    in each toolchain, as they use the Cray compiler wrappers at the moment and they
    don't allow having GCC + another compiler loaded. The alternative is to try build
    a fake GCCcore module which would not use the Cray compiler wrappers to compile
    a number of packages and then make that one a subtoolchain of the regular Cray
    toolchains.

    Advantages
      * We may be able to use more of the common toolchains.
      * Some basic Linux libraries are still less tested with Clang then with GCC so
        we would have less problems compiling those packages.

    Disadvantages
      * Sharing with CSCS become harder
      * No guarantee that this would actually work.

    Questions
      * Should we go for a further level in the hierarchy based on the various
        cpe environments, and quid Spack in this case?




## Transforming information about the Cray PE to other tools

There are three points where we could use information about versions of specific packages
in releases of the Cray PE:

  * We need to define external modules to EasyBuild.

  * We need to define Cray PE components to Spack

  * A module avail hook to hide those modules that are irrelevant to a particular LUMI/yy.mm
    toolchain could also use that information.


## Implementation difficulties

  * A hidden partition module did show up into the output of ``module spider`` as a way to
    reach certain other modules. This was the case even when it was hidden by using a name
    starting with a dot rather than a modulerc.lua file. This "feature" is also mentioned
    in [Lmod issue #289](https://github.com/TACC/Lmod/issues/289).
      * Our solution was to modify the module file itself to not include the paths when the
        mode is "spider" so that Lmod cannot see that it is a partition module that makes
        other modules available.
