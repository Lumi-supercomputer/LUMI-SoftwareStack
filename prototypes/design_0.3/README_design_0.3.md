# Design 0.3 of the module system

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

  * Also experimented with a modulerc.lua file for the partitions to show version aliases with
    more meaningful but longer names.

Changes compared to design 0.1:

  * We rely on the Cray LMOD modules for the programming environment
    and don't try to copy those to our own directory structures as
    there is not that much to gain from it given the hierarchical
    structure.
  * We avoid reading environment variables in the partition and stack
    modules and instead produce them via running a template through
    the gpp preprocessor. This is simpler than letting each module
    remember its settings.
  * We need to see if we will create PrgEnv-* equivalents in the
    LUMI/yy.mm software stacks using EasyBuild (as in CSCS) or via
    our own script, in which case we would put them elsewhere. In that
    case we could even initialise a LUMI/yy.mm software stack without
    using EasyBuild, which granted is not a good match with the
    "EasyBuild first" strategy.

## Hierarchy with software stack first, partition/architecture second, flat otherwise - Prototype module_stack_partition

Here we mount the same file system with applications and modules
everywhere, but within that file system we have binaries for each
architecture in separate directories

Directory hierarchy

  * Cray modules in their own hierarchy.

  * appl

      * modules

          * generic: A directory where we store the generic implementations of some
            of the modules below and link to. This directory should not be in the
            MODULEPATH! Note that in the prototype we actually link to the git
            repository to make editing easier. In the real situation this would be
            copies to avoid accidental changes.

          * SoftwareStack: A module file that enables the default Cray
            environment, and one for each of our LUMI software stacks,
            of the form ``LUMI/version.lua``.

          * SystemPartition/LUMI/yy.mm: The next level in the hierarchy. It contains modules by
            LUMI SoftwareStack to enable the different partitions. Structure:
              * The modules are called ``partition/C.lua`` etc.

                *We could not use LUMIpartition as this lead to problems with the Lmod
                ``hierachyA`` function which produced wrong results for ``LUMIpartition/L.lua``
                but not for ``LUMIpartition/C.lua`` even though both modules had identical
                code.*
              * Modules for the ``LUMI/yy.mm`` software stack are in
                ``LUMIpartition/LUMI/yy.mm``.

          * easybuild/LUMI/yy.mm/partition/part: Directory for the EasyBuild-generated
            modules for the ``LUMI/yy.mm`` software stack for the ``LUMI-part``
            partition (``part`` actually being a single letter)

          * spack/LUMI/yy.mm/partition/part: Similar as the above, but for
            Spack-installed software.

          * manual/LUMI/yy.mm/partition/part: Similar as the above, but for
            manually installed software.

      * software : This is for the actual binaries, lib directories etc.

          * LUMI-21.02

              * LUMI-C

                  * easybuild

                  * spack

                  * manual

              * LUMI-G

              * LUMI-D

              * LUMI-L

      * mgmt: Files that are not stored in our GitHub, but are generated
        on the fly and are only useful to those users who want to
        build upon our software stack or for those who install
        software in our stacks. 

          * ebrepo_files

              * LUMI-21.02

                  * LUMI-C

                  * LUMI-G

                  * LUMI-D

                  * LUMI-L

      * github: GitHub repository with all managed files

          * easybuild

              * easyconfig

              * config: Configuration of EasyBuild

              * Structure for hooks and easyblocks to be decided.



### Assumptions

  * The system sets an environment variable LUMI_PARTITION with value
    LUMI-C, LUMI-G, LUMI-D or LUMI-L depending on the node type.
    This is used by the SoftwareStack module to then auto-load the
    module for the current partition when it is loaded.


### Default behaviour when loading modules

  * A user will always need to load a software stack module first.

      * For those software stack modules that further split up according
        to partition (the LUMI/yy.mm modules), the relevant partition
        module will be loaded automatically when loading the software
        stack.

  *  In this variant of the desing, we made the SoftwareStack and LUMIpartition
     modules sticky so that once loaded a user can use ``module purge`` if they
     want to continue working in the same software stack but load other packages.


### Advantages

  * Having the software stack as the highest level in the hierarchy
    makes it easy to also make other software stacks available through
    software stack modules that can then each have their own internal
    organisation, e.g., EESSI should it mature enough during the life of
    LUMI and become suitable for LUMI and should we find a distribution
    mechanism that would integrate with LUMI.

  * \...


### Disadvantages

  * \...


## Remarks

  * Since we want to use ``hierarchyA`` in a consistent manner in the modules, we only
    uses modules with a name of the form ``name/version`` so we no longer use the
    ``LUMI-C`` etc.  modules to switch partition.


## Hierarchy with the partition first, software stack second, flat otherwise - Prototype make_partition_stack

Here we mount the same file system with applications and modules
everywhere, but within that file system we again have binaries for each
architecture in separate directories

Directory hierarchy

  * Cray modules in their own hierarchy.

  * appl

      * modules

          * generic: A directory where we store the generic implementations of some
            of the modules below and link to. This directory should not be in the
            MODULEPATH! Note that in the prototype we actually link to the git
            repository to make editing easier. In the real situation this would be
            copies to avoid accidental changes.

          * SystemPartition: Modules to adapt the module path for a
            partition. The modules have a name in the form
            ``partition/part.lua``(so ``/appl/modules/SystemPartition/partition/part.lua``,
            and with ``part`` a single letter denoting the partition.)

          * SoftwareStack/partition/part: The next level of the hierarchy. It contains
            modules by LUMI partition for all software stacks provided. The modules
            for the LUMI software stack are called ``LUMI/yy.mm.lua``.

          * easybuild/partition/part/LUMI/yy.mm: Directory for the EasyBuild-generated
            modules for the ``LUMI/yy.mm`` software stack for the ``LUMI-part``
            partition (``part`` actually being a single letter)

          * spack/partition/part/LUMI/yy.mm: Similar as the above, but for
            Spack-installed software.

          * manual/partition/part/LUMI/yy.mm: Similar as the above, but for
            manually installed software.

      * software

          * LUMI-C

              * LUMI-21.02

                  * easybuild

                  * spack

                  * manual

      * mgmt

          * ebrepo_files

              * LUMI-C

                  * LUMI-21.02

      * github: GitHub repository with all managed files

          * easybuild

              * easyconfig

              * config: Configuration of EasyBuild

              * Structure for hooks and easyblocks to be decided.


### Assumptions

  * The system sets an environment variable LUMI_PARTITION with value
    LUMI-C, LUMI-G, LUMI-D or LUMI-L depending on the node type.
    The system also loads the matching partition module by default.


### Default behaviour when loading modules

  * The system will have the right partition module loaded for the
    partition type. These are sticky modules but can be swapped at the
    user\'s own risk.

  * In this design we chose to also make the software stack module sticky once loaded.
    Hence a user who wants to continue to work in a particular software stack can use
    ``module purge`` without having to reload the software stack and partition modules.


### Advantages

  * \...


### Disadvantages

  * This setup is more confusing if there are also software stacks that
    do not depend on the architecture (e.g., offering the native Cray
    environment) or that have other means to deal with the architecture
    (e.g., EESSI should we ever offer that, though we may as well not
    use the EESSI way to select the optimal architecture).


### Remarks

  * Since we want to use ``hierarchyA`` in a consistent manner in the modules, we only
    uses modules with a name of the form ``name/version`` so we no longer use the
    ``LUMI-C`` etc.  modules to switch partition.


## Issues

  * Lmod ``module avail`` in the tested version (8.4.31) again contains the bug that
    ``module avail`` shows extensions also when they are not available.
    This makes the output of ``module avail`` confusing and may cause a very long list
    of extensions that cannot be enabled by modules that are available, still to be
    shown which really goes against the spirit of ``module avail``.

    *We based our prototype module with extensions on what is done in EESSI. It seems
    that they may be using a hook to also show the extensions both as a "whatis"-line
    and as a section in the output of ``module help``. This is certainly something to
    investigate further as this is a useful feature. Having that list in a "whatis"-line
    makes it easy to find through ``module keyword`` also.*

  * We need to think on how the system with partition modules works with Slurm. The
    problem with Slurm is that it takes the environment from the node where the job
    is submitted, including the activated modules. So if the user does not load the
    right partition module before calling ``sbatch`` or any of the other Slurm commands
    to start a job, the job may be working in an environment that at best not optimal
    and at worst incompatible with the selected node type. The easiest workaround is
    to teach users to always load the partition and software stack module in their
    job scripts. If we could ensure that ``LUMI_PARTITION`` does get the right value
    rather than the one inherited through ``sbatch`` etc this is as easy as having
    ```bash
    module --force purge
    module load LUMI/21.03
    ```
    in the stack-first model where the ``LUMI`` module would then automatically load
    the right partition module, or
    ```bash
    module --force purge
    module load partition/$LUMI_PARTITION
    module load LUMI/21.03
    ```
    in the partition-first model. In fact, in both cases
    ```
    module load partition/$LUMI_PARTITION
    ```
    would even be sufficient (without the ``purge`` and other module loads)
    as in the stack-first model it would unload any other ``partiton``-module while
    in the partition-first model it would automatically reload the software stack
    module if the ``partition``-module has changed.

  * As with any setup where modules aren't managed consistently through a single tool,
    we need to take into account that conflicts can occur, e.g., when we would have two
    modules with the same name but managed by different tools (or one of them unmanaged).
    We may then see that when dependencies are loaded, the wrong dependency may be loaded.
    Similarly, as the same package may have different names when managed with different
    tools, we may be able to load both simultaneously, having twice the same library
    in the path, so that some packages may be using a different version then expected.

    There are however several ways to alleviate this problem:
      * Using rpath linking, which is the default in Spack and optional in EasyBuild,
        we strongly reduce the chance of loading the wrong library. Of course one may
        still need the module for other files it provides, but that may be far less
        critical.
      * Module names don't have an indentical structure as Spack adds a hash and
        EasyBuild adds toolchain information.
      * Even with a single module management tool we may still have problems if two
        packages use a different version of the same dependency. Users should be aware
        that in any case where they load more than one package problems may occur.

