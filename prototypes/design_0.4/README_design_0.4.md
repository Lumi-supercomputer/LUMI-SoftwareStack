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


## Directory structure: Hierarchy with software stack first, partition/architecture second, flat otherwise - Prototype module_stack_partition

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
            partition (``part`` actually being a single letter, except for the software
            that is common to all partitions, where ``part`` is ``common``)

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

              * LUMI-common

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

  *  In this variant of the design, we made the SoftwareStack and LUMIpartition
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



## Implementation details


### Module presentation

  * The LUMI module system supports two ways of presenting the module to the users

     1. The default way users user-friendly labels rather than subdirectories to present
        the modules. Sometimes several subdirectories may map to the same label when
        our feeling is that those modules belong together for the regular user.

     2. But of course the view with subdirectories is also supported for the power
        user.

    The implementation of the labeled view is done in the ``avail_hook`` hook in the
    ``SitePackage.lua`` file and is derived from an example in the Lmod manual.

  * To not confront the user directly with all Lmod environment variables that influence
    the presentation of the modules, we also have a set of modules that can be used
    to change the presentation, including

      * Switching between the labeled and subdirectory view

      * Showing extensions in module avail

      * Turn on and off colour in the presentation of the modules as the colour selection
        can never be good for both white background and black background (though of
        course a power user can change the colour defintions in their terminal emulation
        software to ensure that both bright and dark colours are displayed properly).

    The presentation modules are sticky so that ``module purge`` doesn't change the
    presentation of the modules.

### Transforming information about the Cray PE to other tools

There are three points where we could use information about versions of specific packages
in releases of the Cray PE:

  * We need to define external modules to EasyBuild.

  * We need to define Cray PE components to Spack

  * A module avail hook to hide those modules that are irrelevant to a particular LUMI/yy.mm
    toolchain could also use that information.

There is currently a set of Python scripts that define the components of the PE and
generate the EasyBuild external modules definition file for a particular release of
the PE.

  * ``make_CPE_defs.py`` defines the PE component version numbers and calls the script
    that generates the EasyBuild external modules file.

    If HPE-Cray would deliver the information on the PE components in a different way,
    e.g., a YAML file, it would make sense to rewrite that part.

  * ``lumitools/CPE_to_EB.py`` then generates the EasyBuild external modules file.


### The common software subdirectories

  * We use a hidden partition module (``partition/common``) which can then be recognized
    by the EasyBuild configuration modules to install software in that partition.

      * Hiding is done via a .modulerc.lua file

      * The path to the common software modules is added in the other partition module
        files, always in such a way that the partition-specific directory comes before
        the equivalent common directory to ensure that partition-specific software
        has a higher priority.

      * Morover, the labeling in SitePackage.lua is such that in the labeled view one
        sees the common and partition-specific software is put together.

  * A hidden partition module did show up into the output of ``module spider`` as a way to
    reach certain other modules. This was the case even when it was hidden by using a name
    starting with a dot rather than a modulerc.lua file. This "feature" is also mentioned
    in [Lmod issue #289](https://github.com/TACC/Lmod/issues/289).

      * Our solution was to modify the module file itself to not include the paths when the
        mode is "spider" so that Lmod cannot see that it is a partition module that makes
        other modules available.


### EasyBuild Module Naming Scheme

  * Options

      * A flat naming scheme, even without the module classes as they are of little
        use. May packages belong to more than one class, it is impossible to come up
        with a consistent categorization. Fully omitting the categorization requires
        a slightly customized naming scheme that can be copied from UAntwerpen. When
        combining with --suffix-modules-path='' one can also drop the 'all' subdirectory
        level which is completely unnecessary in that case.

      * A hierarchical naming scheme as used at CSCS and CSC. Note that CSCS has an
        open bug report at the time of writing (May 12) on the standard implementation
        in EasyBuild ([Issue #3626](https://github.com/easybuilders/easybuild-framework/issues/3626)
        and the related [issue 3575](https://github.com/easybuilders/easybuild-framework/issues/3575)).
        The solution might be to develop our own naming scheme module.

  * Current implementation in the prototype:

      * A flat naming scheme that is a slight customization of the default EasyBuildMNS
        without the categories, combined with an empty ``suffix-modules-path`` to avoid
        adding the unnecessary ``all`` subdirectory level in the module tree.

      * As we need to point to our own module naming scheme implementation which is
        hard to do in a configuration file (as the path needs to be hardcoded), the
        settings for the module scheme are done via ``EASYBUILD_*`` environment variables,
        specifically:
          * ``EASYBUILD_INCLUDE_MODULE_NAMING_SCHEMES`` to add out own module naming schemes
          * ``EASYBUILD_MODULE_NAMING_SCHEME=LUMI_FlatMNS``
          * ``EASYBUILD_SUFFIX_MODULES_PATH=''``


### Running EasyBuild

EasyBuild for LUMI is configured through a set of EasyBuild configuration files and
environment variables. The basic idea is to never load the EasyBuild module directly
without using one of the EasyBuild configuration modules. There are two such modules

  * EasyBuild-production to do the installations in the production directories.

    TODO: By setting an environment variable before loading the module, it is possible
    to do a test build instead. BUT THIS WILL REQUIRE COMPATIBLE CHANGES TO THE MODULES
    THAT LOAD THE SOFTWARE STACKS!

  * EasyBuild-user is meant to do software installations in the home directory of a
    user or in their project directory. This module will configure EasyBuild such that
    it builds on top of the software already installed on the system, with a compatible
    directory structure.

    This module is not only useful to regular users, but also to LUST to develop EasyConfig
    files for installation on the system. We aim to develop the module in such a way
    that being able to install the module in a home or project subdirectory would also
    practically guarantee that the installation will also work in the system directories.


### Starting a new software stack and bootstrapping EasyBuild

  * Create a ``LUMI/yy.mm`` module for the software stack (through linking to
    the generic implementation) and create the necessary partition modules at
    the next level in the software stack hierarchy (again using symbolic links
    to the generic implemenation). Do not forget to adapt (for the LUMI-module)
    or install (for the partition modules) the necessary .modulerc.lua files.

      * The one in the directory with the ``LUMI/yy.mm``-modules is used to
        set the default module so you may want to wait to adapt the default.

      * The one in the partition module directory sets a number of aliases to
        provide more user-readable names for the partitions and hides the common
        partition module.

  * Create the definition file for the external modules for EasyBuild

      * Procedure should be worked out further depending on the information we get
        from Cray. Currently it is a set of Python scripts that define the versions
        of the PE components and generate the file.

  * Add an EasyConfig file for the desired version of EasyBuild to the LUMI EasyConfig
    repository.

  * Check if a software stack-specific configuration file for EasyBuild is needed.

  * Install the EasyBuild-production and EasyBuild-user modules that take care of the
    setup of EasyBuild.

    TODO: Procedure? Symlinking to a generic implemenation in each of the partitions,
    including the ``common`` one.

    If one prefers to install EasyBuild-production and EasyBuild-user with EasyBuild
    instead, one can opt for symlinking a simplified bootstrap module in the common
    partition module tree to configure EasyBuild only for installing EasyBuild.

  * Load the new LUMI module and then ``partition/common``and then ``EasyBuild-production``
    or the bootstrap configuration module installed in the previous step.

  * Installing EasyBuild using EasyBuild: there are two options:

      * Ensure PYTHONPATH refers to the EasyBuild Python files from another software
        stack and call the corresponding binary using the full path to the ``eb`` script.

      * Install a version of EasyBuild by hand in a temporary directory (it is enough
        to only install the framework and EasyBlocks), point PYTHONPATH to the Python
        files and call the ``eb`` script using the full path. This temporary installation
        can be removed again once EasyBuild is installed.

        This is the procedure that we used in the script that generates the prototype
        (though defining the environment variables in the script rather than through
        a bootstrap module).

  * If not done yet previously, install the EasyBuild-production and EasyBuild-user
    modules for each of the partitions.

      * For EasyBuild-production this again requires playing with environment variables
        if the modules are installed through EasyBuild as it is precisely that module
        that should point EasyBuild to the right paths.

  * Create the Cray PE toolchain modules

    TODO: Use a script that uses the same data as used for the external module definition.

  * And now one should be ready to install other software...

      * Ensure the software stack module is loaded and the partition module for the
        location where you want to install the software is loaded (so the hidden module
        partition/common to install software in the location common to all regular
        partitions)

      * Load EasyBuild-production for an install in the production directories or
        EasyBuild-user for an install in the user or project directories (and you'll
        need to set some environment variables beforehand to point to that location).


### Implementation difficulties

  * All discussed above.
