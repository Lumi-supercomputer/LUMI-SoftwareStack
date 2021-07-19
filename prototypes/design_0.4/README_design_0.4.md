# Design 0.4 of the module system

This prototype focuses on the EasyBuild setup.

TODO to finish this prototype:

  * cpe modules, and a script that generates them automatically?

    Some steps

     1. Hand-generated EasyConfigs in the Swiss style: Better to work with
        hard versions instead due to the problems with the cpe modules.

     2. How to deal with different targets for different partitions, or do we
        fully rely on optarch which would mean that by default we only load
        that set of modules that works for all of LUMI and then rely on the
        OPTARCH processing to load the architecture-specific ones?

     3. Automatically generate the EasyConfigs from a database of toolchain
        component versions and templates for the EasyConfig?

     4. Rework the EasyBlock so that we can avoid having all that LMOD code
        in the EasyConfig file.

    Challenge in case we switch to a hierarchical MNS

      * Ensure that when loading a cpe* module, the MODULEPATH for the modules
        installed by the user is also adapted.

  * Need to clarify how we will use .dev. Do we want both a 21.04 and 21.04.dev
    while building the stack? In that case, 21.04.dev should be used as the name
    of the toolchain everywhere. But it also means we cannot change it back to
    21.04 but need to re-install then.

  * Implementation of hooks:

      * Should hooks also be enabled for EasyBuild-user?

      * Versioning of the hooks file: Automatically select the right file with hooks
        as that may be a more scalable approach than keep adding tests to the EasyBuild
        module.


Changes compared to design 0.3:

  * We implemented only the stack_partition variant to reduce the amount of work.

  * The build process of the prototype is broken up in several scripts of which
    some are close to those that will be needed in production to, e.g., start a
    new software stack:

        * The build script still builds a shadow repository rather than working
          in the final repository because the structure is different.

        * ``prepare_LUMI.sh`` then further initializes the module tree and some other
          directories.

        * Next ``prepare_LUMI_stack.sh`` is called for each LUMI stack that should
          be initialised.

        * Finally the prototype build script still calls a script to make some demo
          LUMI stacks separate from those where we experiment with EasyBuild, and
          sets the default software stack.

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

  * Added a ``modules/Infrastructure`` tree which is used for modules that have to
    be present in the four regular and the common meta-partition of the software
    stack to be able to build correctly with EasyBuild and to ensure that
    module reload and changing partitions works as smoothly, reloading modules
    with the settings needed for the new partition.

  * ``partitionletter.lua``, the generic implementation of the partition module for
    the LUMI software stack, does no longer use ``LMOD_MODULE_ROOT``, but detects
    the root of the module installation from its own position using Lmod instrospection
    functions.

  * Scripts to generate the external modules configuration file for EasyBuild based
    on a Python script that defines the Cray PE compoments and then some more so that
    it should be possible to extend to other configuration files that need the same
    information.

  * Implemented ``EasyBuild-config`` to configure EasyBuild.

      * The generic module is linked as:

          * ``EasyBuild-production`` for installation in system application directories
            for a given partition

          * ``EasyBuild-infrastructure`` for installation in the system Infrastructure
            directory tree, for packages that are installed in all five partitions
            and for which we want reload to work properly.

          * ``EasyBuild-user`` for installation in user or project directories.

      * This is one module for which the Infrastructure subdirectory was needed
        as we want each variant of the module to be shown only once, and as we
        want reloads to work properly when switching partitions.

      * There is support for centrally installed custom toolchains and hooks.

  * We do support multiple stacks with EasyBuild installations to also be able to test
    this aspect of the LUMI setup.

  * modulerc information is now in a central location rather than split over directories.
    There are two files: A general one, and one that is enabled when a LUMI software
    stack is loaded.

  * Added several modules to customize the module display

  * We now define the versions of Cray PE components in a .csv file for reference in
    various scripts and module files.

      * This includes a new function in SitePackage.lua to extract the version of a
        Cray PE compoment for a given version of the PE from a .csv file which is used
        to load the right version of the Cray PE targeting modules in the LUMIpartition
        module.

      * The file is used to generate a modulerc.lua file for a specific LUMI stack
        to make the proper versions of CPE components the default version.

      * The file is used to generate the external module definition file for each CPE
        version (make_EB_external_modules.py)

  * The setup is independent of the location and the name of the repository. Whenever
    module files need that information,

      * The root of the installation is derived from the path to the module or to the
        scripts.

      * The name of the repository is derived from the value of LMOD_PACKAGE_PATH.
        This does assume however that ``SitePackage.lua`` is used from the repository.

  * We have an overload for the Cray cpe modules that works around some bugs in those,
    but as part of the problem comes from LMOD we could not work around it completely.
    Hopefully this will only be a temporary solution and we can work around the problems
    with Cray and the LMOD developer.

  * Implementation of the cpe toolchains in EasyBuild:

      * A script that generates the EasyConfigs (``make_CPE_EBfile.sh`` and
        ``lumitools/gen_CPE_EBfile.py`)

      * There is a hook that will fill in empty cray_targets (developed due to a problem
        in EasyBuild) but once that problem got solved we reverted to the approach
        of using os.environ in the EasyConfig and put the logic there. The hook is
        left in for now as a means of testing the hook functionality.

      * The toolchains itself are for now the standard CSCS toolchains.

      * Made a custom EasyBlock, CrayPEToolchain, to generate the modulefiles for the
        toolchains. It results in far cleaner EasyConfigs and has much wider applicability
        than just LUMI.

  * Implementation of Cray toolchains that are an extension of those of CSCS

      * Several problems solved with toolchain options for specific compilers.

      * Support for loading multiple targeting modules via ``EASYSUILD_OPTARCH``.

      * Support for specifying architecture options for multiple compilers simultaneously
        through ``EASYBUILD_OPTARCH`` so that we can also support the regular EasyBuild
        toolchains should this be needed.




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


## Running and installing the prototype

  * LMOD must be installed and correctly initialised before trying out the prototypes.
    ``gpp`` is not needed for this version of the prototype.

  * ``prototypes/design_0.4`` contains the ``build_prototype.sh`` script to build
    the prototype (in $HOME/appltest/design_0.4).

  * That directory also contains a `enable_prototype.sh`` script to initialise the environment
    to test the prototype. Source the script in the shell or use
    ```bash
    eval $(./enable_prototype.sh)
    ```
    in that directory. Then try ``module avail`` and ``module help`` to get started.


## Directory layout for modules and software: Hierarchy with software stack first, partition/architecture second, flat otherwise

Here we mount the same file system with applications and modules
everywhere, but within that file system we have binaries for each
architecture in separate directories

Directory hierarchy

  * Cray modules in their own hierarchy.

  * appl

      * modules: Key here was to follow Lmod guidelines on hierarchical structures
        as much as possible, though in fact we end up with a double hierarchy when
        implementing a hierarchical module naming scheme for applications: a hierarchy
        in the software stack activation, and then the hierarchy in the application
        modules.

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

              * Besides the four regular partitions, there is also a meta-partition
                common that is used to house software that is common to all regular
                partitions. The corresponding module is hidden from regular users.

              * Modules for the ``LUMI/yy.mm`` software stack are in
                ``LUMIpartition/LUMI/yy.mm``.

          * Infrastructure/LUMI/yy.mm/partition/part: Infrastructure modules.

          * easybuild/LUMI/yy.mm/partition/part: Directory for the EasyBuild-generated
            modules for the ``LUMI/yy.mm`` software stack for the ``LUMI-part``
            partition (``part`` actually being a single letter, except for the software
            that is common to all partitions, where ``part`` is ``common``)

          * spack/LUMI/yy.mm/partition/part: Similar as the above, but for
            Spack-installed software.

          * manual/LUMI/yy.mm/partition/part: Similar as the above, but for
            manually installed software.

      * SW : This is for the actual binaries, lib directories etc. Names are deliberately
        kept short to avoid problems with too long shebang lines. As shebang lines
        do not undergoe variable expansion, we cannot use the EBROOT variables and
        so on in those lines to save space.

          * LUMI-21.02

              * C

                  * EB

                  * SP

                  * MNL

              * G

              * D

              * L

              * common

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

                  * LUMI-common

      * sources

          * easybuild : Sources directory for EasyBuild, organised the EasyBuild way.

      * SystemRepo: GitHub repository with all managed files

          * easybuild: Follows the structure of EasyBuild repositories to be able to
            use the GitHub support if desired.

              * easyconfigs: The offical LUMI EasyConfig repository

              * easyblocks: Custom EasyBlocks

              * tools: Currently contains the custom implementations of the module
                naming schemes

              * config: Configuration of EasyBuild

              * Structure for hooks and other customizations to be decided.



### Advantages

  * This model fits better with the scenario where you chose your
    software stack but then may want to load a version for a different
    partition, e.g., because you really want to run a tool for LUMI-C
    on LUMI-G to not have to start a dependent job, or when using
    ``salloc``, where you would want to run on a different node type
    than the one on which you used ``salloc``.

  * Having the software stack as the highest level in the hierarchy
    makes it easy to also make other software stacks available through
    software stack modules that can then each have their own internal
    organisation and mechanism to specialise for certain sections of
    LUMI, e.g., EESSI should it mature enough during the life of
    LUMI and become suitable for LUMI and should we find a distribution
    mechanism that would integrate with LUMI.

  * It is easy to automatically load the optimal partition for a node so
    the less experienced user isn't confronted too much with that choice.
    Moreover our setup has a fairly elegant way of also offering software
    that should work on all partitions without having to install that
    four times.

### Disadvantages

  * When using RPATH linking one should be very careful to not link from
    code in the common partition to code in one of the other partitions
    as then the binary isn't really common anymore.


## Module design

Moved to [docs/module_setup.md](docs/module_setup.md).


## EasyBuild setup

Moved to [docs/easybuild_setup.md](docs/easybuild_setup.md).


## Impact of changes

  * Software directory  root (appl/software) and structure

      * ``EasyBuild-production`` module and if we want to reflect the changes in the structure
        of the user directory, also ``EasyBuild-user``.

      * All module files are affected as various variables contain the path to binaries,
        libraries, etc.

      * Some libraries generated by libtool may be affected as the path to dependend libraries
        is sometimes encoded in ``.la`` files.

      * When rpath linking is used, the binaries themselves are also affected.

  * Module directory

      * Changes to the root of the module directory

          * All software stack modules may need changes, and certainly ``partitionletter.lua``.

          * ``EasyBuild-production`` module and if we want to reflect the changes in the structure
            of the user directory, also ``EasyBuild-user``.

          * ``cpe*`` modules as they expand the module search path in the hierarchy.

      * Changes to the structure of the LUMI toolchain part

          * LUMI software stack modules need changes

          * ``EasyBuild-production`` and ``EasyBuild-user``, not only because it influences
            the directory where modules will be installed but also because the module
            gets its information about the active software stack and partition from
            the directory structure.

            One could consider moving that dependency to ``SitePAckage.lua`` by defining
            a function that returns the active software stack and partition.

          * ``cpe*`` modules as they expand the module search path in the hierarchy.

          * Generation of the labels in ``SitePackage.lua`` may be affected

  * Module naming scheme

      *  ``EasyBuild-production`` and ``EasyBuild-user``, where the module naming schemes
         are set.

      * ``cpe*`` modules as they behave differently in a flat and a hierarchical module
        naming scheme.

      * The whole module tree should be regenerated in case of a change of the module
        naming scheme.

      * It may have impact on the label generation in ``SitePAckage.lua``.

  * Cray toolchain component definition files

      * Currently defined in SystemRepo/CrayPE, file name is the release of the PE
        with the extension .csv.

      * This file is used by a function in SitePackage.lua


## Issues

### Cray cpe module and /opt/cray/cpe/yy.mm/restore_lmod_system_defaults.sh script

The Cray CPE system hijacks the ``LMOD_MODULERCFILE`` environment variable. This is
a PATH-style variable and several modulerc files can be used concurrently. In that
case they are specified as a column-separated list just as in, e.g., PATH. Hence
the variable can be managed through the LMOD ``prepend_path`` and ``append_path`` functions
and a site can add its own modulerc files too. Unfortunately this is not how the Cray
PE works. There are two problems:

  * The cpe module file contains

    ```
    setenv("LMOD_MODULERCFILE","/opt/cray/pe/cpe/21.04/modulerc.lua")
    ```

    which overwrites the current value of ``LMOD_MODULERC`` and hence deactivates any
    modulerc file that might already be active.

  * The script ``/opt/cray/pe/cpe/21.04/restore_lmod_system_defaults.sh`` is even worse.
    It is supposed to only run after unloading the ``cpe`` module. As ``LMOD_MODULERC``
    has already been unset at that time, it makes no sense to unset it at the start of
    the script. In fact, as the script does not unload ``cpe`` itself, it can now lead
    to an inconsistent situation: As ``LMOD_MODULERC`` is unset, the default versions of
    modules will no longer be determined by the modulerc file corresponding to the still
    loaded ``cpe`` module, so the ``restore_lmod_defaults`` switch will reload loaded
    modules with the version that LMOD considers the default (the one with the highest
    version number). This can sometimes even be observed on a system with just a single
    version of the programming environment. E.g., in the 21.04 release both the 9.3.0
    and 10.2.0 release of GCC are provided but the ``cpe/21.04`` module loads the 9.3.0
    module as default (at least on the Swiss Eiger system on which I tested). Now as
    running the ``restore_lmod_system_defaults`` script will unset ``LMOD_MODULERC``
    and then run over the loaded modules from the PE, it will reset the version of
    gcc (if loaded) to 10.2.0 instead of 9.3.0.

Proposed solution:

  * Be kind in ``cpe/yy.mm.lua`` and use ``prepend_path`` or ``append_path`` rather
    than ``setenv`` so that already loaded modulerc files remain active.

  * In the ``/opt/cray/pe/cpe/21.04/restore_lmod_system_defaults.[sh|csh]`` scripts,
    ensure that the ``cpe`` module is unloaded and if not unload it at the beginning
    of the module. This will also take care of ``LMOD_MODULERC`` and should ensure
    that the cpe-specific modulerc file is no longer in ``LMOD_MODULERC`` so that the
    following ``module switch`` commands will indeed restore the defaults.

To me it seems that the ``restore_lmod_system_defaults.[sh|csh]`` are even independent
of the version of the CPE as long as only versions 21.04 or more recent are installed
(I'm not sure about older versions) and that the script could be easily replaced by
a module file that when loaded reloads unversioned modules for all loaded modules in
exactly the same way as the current ``cpe/yy.mm`` modules reload versioned modules
for all loaded modules.




