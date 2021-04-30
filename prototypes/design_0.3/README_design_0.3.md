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

  * We also added the detect_LUMI_partition function to SitePackage.lua to take the
    code to detect on which LUMI partition we are running out of the module files so
    that we can change it more easily to something more robust then the current detection
    which is based on the environment variable LUMI_PARTITION that should be set by
    the system.

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


## Common features of both variants

  * The current design assumes that the system sets the environment variable
    ``LUMI_PARTITION`` to the partition on which the shell is executing, with the
    value ``L`` for the login nodes, ``C`` for the LUMI-C partition, ``G`` for the
    LUMI-G partition and ``D`` for the LUMI-D partition.

  * Loading any partition module will set the environment variable
    ``LUMI_OVERWRITE_PARTITION`` to the partition for which the software stack
    is activated.

  * Each LUMI/yy.mm module sets a number of environment variables:

      * ``LUMI_STACK_NAME`` to the name of the stack, ``LUMI``

      * ``LUMI_STACK_VERSION`` to the version of the stack, ``yy.mm``.

      * ``LUMI_STACK_NAME_VERSION`` to the full name and version of the stack,
        ``LUMI/yy.mm``.

    These variables may be used, e.g., by the EasyBuild-user module to adapt their
    behaviour to the software stack.

  * Great care was taken in the design to ensure proper working of ``module reload``
    and ``module --force purge`` also when those commands are called in an inherited
    environment on a different node type than when the modules were loaded.

Be careful though when using any of those environment variables in other module files
due to LMOD idiosyncracies.


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
    C, G, D or L depending on the node type (CPU compute, GPU compute,
    data and visualisation, login).
    This is used by the SoftwareStack module to then auto-load the
    module for the current partition when it is loaded.


### Default behaviour when loading modules

  * A user will always need to load a software stack module first.

      * For those software stack modules that further split up according
        to partition (the LUMI/yy.mm modules), the relevant partition
        module will be loaded automatically when loading the software
        stack. This is based on the partition detected by the
        detect_LUMI_partition function defined in SitePackage.lua.

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

  * The module tree should work correctly with "module reload". However, if the partition has
    changed, the result will actually be that the right partition module will be loaded
    during the reload. This is probably the preferred behaviour to protect the user
    from mistakes. This makes ``module reload`` at the start of a job script a usable
    option to ensure that all paths and variables that are set by module files are
    also set correctly.


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
    C, G, D or L depending on the node type (CPU compute, GPU compute,
    data and visualisation, login).
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

  * We need to be aware of interactions between the module setup and Slurm as Slurm
    copies the environment from the shell in which the job was launched. This means
    that if you launch a job from the login nodes with a software stack for the login
    partition loaded, it is that software stack for that partition that will still
    be active in your job script, even though you are running on LUMI-C or LUMI-G.

    This has a number of consequences

      * The job will not see packages that are only available on the compute node but
        not in the login node software stack.

      * The binaries that it loads may not be optimally optimised for the CPUs in the
        compute nodes, though that is currently a non-issue as the compilers don't
        seem to use Zen3-specific instructions or timing information.

      * When designing the modules, one needs to be carefull to ensure that a module
        can be correctly unloaded even if the environment variable ``LUMI_PARTITION``
        has changed. This requires a careful design of the module tree so that the
        modules can get information about how they were loaded from their position in
        the module tree, and/or extracting information from environment variables that
        were set by that specific module.

        This all is similar to another LMOD problem: Modules are not unloaded in the
        reverse order in which they were loaded, so even without changing partition,
        a module should never rely on environment variables set in another module for
        elements that need to be recomputed during a ``module unload``, e.g., a
        directory that has been added through ``prepend_path`` or ``append_path``.

    We did take those issues into account in the implementation. Specifically,

      * ``module --force purge`` will work correctly for the software stack and
        partition modules, also when executed in a different partition in an
        inherited environment. For this to work, some of those modules use different
        logic to detect the partition when loading and when unloading, to ensure that
        an unload would happen in the context in which the module was loaded.

      * In the stack-partition variant, the LUMI/yy.mm module will always activate
        the partition module for the partition on which the (re)load is run. Hence,
        if you do a ``module reload`` or a new ``module load LUMI/yy.mm`` in a
        environment that was inherited when launching a job, but with the value of
        LUMI_PARTITION set correctly, it will reload the software stack for the
        current partition.

        If we can ensure that ``LUMI_PARTITION`` is always right, also in a job
        script (which means that Slurm is configured to overwrite that variable
        with the correct value when starting a job),
        ``module load partition/$LUMI_PARTITION`` is actually
        enough to ensure that the right software modules ge (re)loaded.

        Note that simply using ``module purge`` will not switch to the correct
        partition, though that behaviour may be different on some older LMOD
        implementations or in some scenarios that we may not have foreseen, as
        I still found documentation that suggests that the effect of ``module purge``
        on sticky modules is that they are reloaded. An experiment with LMOD 8.4.31
        however contradicts this.

        Hence if a user really wants to try running a software stack for a different
        partition on the current partition, they should load the correct partition
        module after a ``module reload`` or ``module load LUMI/yy.mm``. The default
        behaviour is to reload to a safe state.

      * In the partition-stack variant, with ``partition/auto`` loaded, a ``module
        reload`` or simply again ``module load partition/auto`` will have the same
        effect as in the stack-partition variant: the already loaded ``LUMI/yy.mm``
        software stack (if one is loaded) will be re-initialised for the current
        partition.

        The latter is not the case though if a partition module for a particular
        module is loaded. Then the software stack for that partition remains loaded
        until a different ``partition/X`` partition module or the ``partition/auto``
        module is loaded.

        If we can ensure that ``LUMI_PARTITION`` is always right, also in a job
        script (which means that Slurm is configured to overwrite that variable
        with the correct value when starting a job),

        With respect to the use of ``module purge`` the same remark as for the
        stack-partition variant holds.

    What we should do towards the users:

      * At the start of a job script, you should ensure that all modules get
        reloaded to ensure that all modules refer to the right binaries for the
        partition. Some options are:

          * ``module --force purge`` and start from scratch, which guarantees a
            clean environment.

          * Use ``module reload`` and LMOD will do its best to even give you
            matching software modules for the different partition if they exist.

          * stack-partition variant only: Do a ``module load`` of the desired
            software stack. Even if you load the same one that is already loaded,
            it will reload it. If software modules are loaded, LMOD will do its best
            to find matching ones when switching partitions.

          * partition-stack variant only: Do a ``module load partition/auto`` to
            (re)load the authomatic partition switcher module.

      * A user who uses ``salloc`` on any heterogeneous machine should be very
        careful. With ``salloc``, you get a shell on the node on which you called
        ``salloc`` (e.g., the login nodes, called LUMI-L in this codument), but
        any job step started with ``srun`` will run on the partition
        on which your allocated resources are (e.g., LUMI-G) in an environment
        inherited from the shell from which ``srun`` was called. The automatic
        partition selection when loading a software stack module in the stack-partition
        variant or loading ``partition/auto`` in the partition-stack variant will
        not work and initialise the environment for the node type on which ``salloc``
        was run (LUMI-L in our example) rather than the one on which ``srun`` will
        start executables (LUMI-G in our example). Hence the user should expliclty
        load the partiton module for that node node type (``partiton/G`` in our example)
        or start wrapper scripts with ``srun`` that ensure that the actual commands
        are started from the proper binaries.

        As the most likely scenario is that ``salloc`` would be run on the LUMI-L
        nodes or maybe the LIUMI-D nodes, the problem should not be exaggerated.
        LUMI-L software should run everywhere though maybe not at optimal performance,
        LUMI-D software will also run everywhere except if it uses GPU libraries
        that are only installed on LUMI-D (which has NVIDIA GPUs rather than
        AMD GPUs hence a very different set of libraries).

  * The design still shows all Cray PE modules, not only those that we would prefer
    to use in the given LUMI/yy.mm toolchain.

    Possible solutions

      * Via a modulerc file: Problematic because it is (1) TCL-based so yet another
        language and (2) maybe it isn't meant to produce different results depending
        on which modules are already loaded.

      * ``module avail`` hook that hides the modules from view that are not used in
        the loaded LUMI-stsck (if one is loaded)?

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

  * One unanswered question is if and how we should further structure the EasyBuild and
    Spack subtrees.

      * In a flat scheme a user will immediately after loading a software stack see all
        software that is installed in that stack. Knowing how to use ``module spider`` to
        find software becomes less important in that case. It does not mean that any
        combination of modules can be loaded though. Packages that are compiled with
        different Cray toolchains, e/g/. cpeGNU and cpeCCE will not work together as
        there will be a conflict when both try to load their respective compiler
        modules.

        A hierarchical scheme based on the programming environment would prevent that.
        Adding more levels, and in particular the MPI implementation, may not make
        much sense though as it there is only a single MPI implementation in the Cray
        programming environment. Unless you want to mirror the almost ridiculous amount
        of levels in the Cray hierarchy.

      * In case of a hierarchy: Should we try to mirror the Spack hierarchy in EasyBuild
        or the other way around? It is not clear which one would be easiest to adapt to
        the other.

      * Would it be possible to create an equivalent of the ``GCCcore`` subtoolchain
        using components from the Cray PE to have a common set of base libraries that
        we would use with all Cray PE toolchains similar to what is done in the
        EasyBuild common toolchains?
