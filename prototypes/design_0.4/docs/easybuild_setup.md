# Setup of a LUMI software stack and EasyBuild

## Transforming information about the Cray PE to other tools

For now, information (and in particular version numbers) of CPE components is provided
through a a .csv-file which is edited by hand and stored in the CrayPE subdirectory.
It would be possible to extract some of the information in that file from parsing \
``/opt/cray/pe/cpe/yy.mm/modulerc.lua``. In the future, HPE-Cray
may deliver that information in a more easily machiine-readable format.

There are several points where we need information about versions of specific packages
in releases of the Cray PE:

  * **We need to define external modules to EasyBuild.**

    That file is currently generate by ``make_EB_external_modules.py``
    which is a wrapper that calls ``lumitools/gen_EB_external_modules_from_CPEdef.py``
    to generate the EasyBuild external modules file for a particular version of the
    CPE. The external module definition file is stored in the easybuild configuration
    directory and is called ``external_modules_metadata-CPE-<CPE version>.cfg``. Hence
    in the current design it is named after the version of the CPE and not the name
    of the software stack, so the developer and release versions of a software stack
    would share the same file.

  * **For now we need to overwrite the Cray PE cpe module for the release of the CPE.**

    We use a generic implemenation of the module file that simply reads the .csv file
    to find out component versions.

  * For now, as the cpe module cannot work correctly due to restrictions in LMOD,
    we need to specify the exact versions of packages in the various cpe* toolchain
    easyconfigs.

  * **We need to define Cray PE components to Spack**

    Not developed yet.

  * **A module avail hook to hide those modules that are irrelevant to a particular LUMI/yy.mm
    toolchain could also use that information.**

    Not developed yet.

    Note that such a module only unclutters the display for users. A hidden module
    can still be loaded, and if that module is marked as default it would actually
    be loaded instead of another module with the same name and version.




## EasyBuild Module Naming Scheme

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


## Other configuration decisions

  * TODO: rpath or not?

  * TODO: Hiding many basic libraries


## Running EasyBuild

EasyBuild for LUMI is configured through a set of EasyBuild configuration files and
environment variables. The basic idea is to never load the EasyBuild module directly
without using one of the EasyBuild configuration modules. There are three such modules

  * EasyBuild-production to do the installations in the production directories.

  * EasyBuild-infrastructure is similar to EasyBuild-production but places the module
    in the Infrastructure tree rather than the easybuild tree.

  * EasyBuild-user is meant to do software installations in the home directory of a
    user or in their project directory. This module will configure EasyBuild such that
    it builds on top of the software already installed on the system, with a compatible
    directory structure.

    This module is not only useful to regular users, but also to LUST to develop EasyConfig
    files for installation on the system. We aim to develop the module in such a way
    that being able to install the module in a home or project subdirectory would also
    practically guarantee that the installation will also work in the system directories.

These three modules are implemented as one generic module, ``EasyBuild-config``, that
is symlinked to those three modules. The module will derive what it should do from
its name and also gets all information about the software stack and partition from
its place in the module hierarchy to ensure maximum robustness.


### Common settings that are made through environment variables in all modes

  * The buildpath and path for temporary files. The current implementation creates
    subdirectories in the directory pointed to by ``XDG_RUNTIME_DIR`` as this is a
    RAM-based file system and gets cleaned when the user logs out. This value is based
    on the CSCS setup.

  * Name and location of the EasyBuild external modules definition file.

  * Settings for the module naming scheme: As we need to point to a custom implementation
    of the module naming schemes, this is done through an environment variable. For
    consistency we also set the module naming scheme itself via a variable and set
    EASYBUILD_SUFFIX_MODULES_PATH as that together with the module naming scheme determines
    the location of the modules with respect to the module install path.

  * ``EASYBUILD_OPTARCH``, TODO: More information needed on how to set this on Cray.

  * Should we ever have custom toolchains then this will also be the place to indicate
    where they can be found.


### The EasyBuild-production and EasyBuild-infrastructure mode

Most of the settings for EasyBuild on LUMI are controlled through environment variables
as this gives us more flexibility and a setup that we can easily redo in a different
directory (e.g., to test on the test system). Some settings that are independent of
the directory structure and independent of the software stack are still done in regular
configuration files.

There are two regular configuration files:

 1. ``easybuild-production.cfg`` is always read. In the current implementation it is
    assumed to be present.

 2. ``easybuild-production-LUMI-yy.mm.cfg`` is read after ``production.cfg``, hence can be used
    to overwrite settings made in ``production.cfg`` for a specific toolchain. This
    allows us to evolve the configuration files while keeping the possibility to install
    in older versions of the LUMI software stack.

Settings made in the configuration files:

  * Modules tool and modules syntax.

  * Modules that may be loaded when EasyBuild runs

  * Modules that should be hidden. Starting point is currently the list of CSCS. TODO

  * Ignore EBROOT variables without matching module as we use this to implement Bundles
    that are detected by certain EasyBlocks as if each package included in the Bundle
    was installed as a separate package.

The following settings are made through environment variables:

  * Software and module install paths, according to the directory scheme given in the
    module system section.

  * The directory where sources will be stored, as indicated in the directory structure
    overview.

  * The repo directories where EasyBuild stores EasyConfig files for the modules that
    are build, as indicated in the directory structure overview.

  * Easybuild robot paths: we use EASYBUILD_ROBOT_PATHS and not EASYBUILD_ROBOT so
    searching the robot path is not enabled by default but can be controlled through
    the ``-r`` flag of the ``eb`` command. The search order is:

     1. The repository for the currently active partition

     2. The repository for the common partition

     3. The LUMI-specific EasyConfig directory.

    We deliberately put the ebrepo_files repositories first as this ensure that EasyBuild
    will always find the EasyConfig file for the installed module first as changes
    may have been made to the EasyConfig in the LUMI EasyConfig repository that are
    not yet reflected in the installed software.

    The default EasyConfig files that come with EasyBuild are not put in the robot
    search path for two reasons:

     1. They are not made for the Cray toolchains anyway (though one could of course
        use ``--try-toolchain`` etc.)

     2. We want to ensure that our EasyConfig repository is complete so that we can
        impose our own standards on, e.g., adding information to the help block or
        whatis lines in modules, and do not accidentally install dependencies without
        realising this.

  * Names and locations of the EasyBuild configuration files and of the external modules
    definition file.

  * Settings for the module naming scheme: As we need to point to a custom implementation
    of the module naming schemes, this is done through an environment variable. For
    consistency we also set the module naming scheme itself via a variable and set
    EASYBUILD_SUFFIX_MODULES_PATH as that together with the module naming scheme determines
    the location of the modules with respect to the module install path.

  * Custom EasyBlocks

  * Search path for EasyConfig files with ``eb -S`` and ``eb --search``

     1. Our own system repository

     2. Not yet done, but we could maintain a local copy of the CSCS repository and
        enable search in that also.

     3. Default EasyConfig files that come with EasyBuild (if we can find EasyBuild,
        which is if an EasyBuild-build EasyBuild module is loaded)

     4. Deliberately not included: Our ebrepo_files repositories. Everything in there
        should be in our own EasyConfig repository if the installations are managed
        properly.

  * We also set containerpath and packagepath even though we don't plan to use those,
    but it ensures that files produced by this option will not end up in our GitHub
    repository.


### The EasyBuild-user mode

  * The root of the user EasyBuild directory structure is pointed to by the
    environment variable ``EBU_USER_PREFIX``. The default value if the variable
    is not defined is ``$HOME/EasyBuild``.

  * The directory structure in that directory largely reflects the system
    directory structure. This may be a bit more complicated than really needed
    for the user who does an occasional install, but is great for user communities
    who install a more elaborate software stack in their project directory.

    Changes:

       * ``SystemRepo`` is named ``UserRepo`` instead but we do keep it
         as a separate level so that the user can also easily do version
         tracking via a versioning system such as GitHub.

       * The 'mgmt' level is missing as we do not take into account
         subdirectories that might be related to other software management
         tools.

       * As there are only modules generated by EasyBuild in this module tree,
         ``modules/easybuild`` simply becomes ``modules``.

  * The robot search path:

     1. The user repository for the currently active partition

     2. The user repository for the common partition (if different from
        the previous one)

     3. The system repository for the currently active partition

     4. The system repository for the common partition (if different from
        the previous one)

     5. The user EasyConfig directory

     6. The LUMI-specific EasyConfig directory.

  * The search path for EasyConfig files with ``eb -S`` and ``eb --search``

     1. The user EasyConfig repository

     2. Our own system repository

     3. Not yet done, but we could maintain a local copy of the CSCS repository and
        enable search in that also.

     4. Default EasyConfig files that come with EasyBuild

     5. Deliberately not included: Our ebrepo_files repositories. Everything in there
        should be in our own EasyConfig repository if the installations are managed
        properly.


There are two regular configuration files:

 1. The system ``easybuild-production.cfg`` is always read. In the current
    implementation it is assumed to be present.

 2. The user ``easybuild-user.cfg``(in ``UserRepo/easybuild/config`` in the user
    direcgtory) is read next and meant for user-specific settings that should be
    read for all LUMI software stacks.

 3. Then the system ``easybuild-production-LUMI-yy.mm.cfg`` is read after, hence can be used
    to overwrite settings made in ``production.cfg`` for a specific toolchain. This
    allows us to evolve the configuration files while keeping the possibility to install
    in older versions of the LUMI software stack. This will overwrite generic
    user options!

 4. Finally the user ``easybuild-user-LUMI-yy.mm.cfg`` is read for user
    customizations to a specific toolchain.

Only the first of those 4 files has to be present. Presence of the others is
detected when the module is loaded. Reload the module after creating one of
these files to start using it.



## Starting a new software stack and bootstrapping EasyBuild

This process is largely automated through the ``prepare_LUMI_stack.sh``-script.

Before running the script, the following elements are needed:

  * A suitable ``CPEpakcages_<CPE version>.csv`` file in the ``CrayPE`` subdirectory
    of the repository.

  * An EasyConfig file for the selected version of EasyBuild in the EasyConfig
    repository.

    Note that it is always possible to run ``prepare_LUMI_stack.sh``-script
    with ``EASYBUILD_IGNORE_CHECKSUMS=1`` set if the checksums in the module
    file are not yet OK. (TODO CHECK is this the correct variable?)

  * Make sure proper versions of the EasyBuild-config, LUMIstack and LUMIpartition
    modules are available in the repository.

    The software stack initialisation script will take the most recent one
    (based on the yy.mm version number) that is not newer than the release
    of the CPE for the software stack.

    *The software stacks and CPEs on the Grenoble test system use
    yy.G.mm version numbers, but the ``.G`` is dropped when determining
    the correct version of the modules mentioned above.*

  * Add a software stack-specific configuration file for EasyBuild if
    needed in the ``easybuild/confgi`` subdirectory of the repository.

The ``prepare_LUMI_stack.sh``-script takes 3 input arguments:

  * Version of the software stack

  * Version of EasyBuild to use

  * Work directory for temporary files, used to install a bootstrapping copy
    of EasyBuild. Rather than trying to use an EasyBuild installation from an
    older software stack if present to bootstrap the new one, we simply chose
    to do a bootstrap every time the script is run as this is a procedure
    that simply always works, though it is more time consuming.

    The advantage however is that one can just clone the production repository
    anywhere, run an initialisation script to initialise the structure around
    the repository, then initialise a software stack and start working.

Note that the install root is not an argument of the ``prepare_LUMI_stack.sh``-script.
The root of the installation is determined from the location of the script,
so one should make sure to run the correct version of the script (i.e., to
run from the clone of the repository in the installation root).

Steps that the ``LUMI_prepare_stack.sh`` script takes:

  * Creates the LUMI software stack module (by soft linking to the generic one
    in the ``SystemRepo``) and the partition modules for that stack (again by
    softlinking).

  * Creates the full directory structure for the software stack for the modules,
    the binary installations and the EasyBuild repo.

  * Creates the EasyBuild external modules definition file from the data in the
    corresponding ``CPEpakcages_<CPE version>.csv`` file.

  * Creates the EasyBuild-production, EasyBuild-infrastructure and EasyBuild-user
    modules for each partition by softlinking to the matching generic file in
    the ``SystemRepo``.

  * Downloads the selected version of EasyBuild to the EasyBuild sources directory
    if the files are not yet present.

  * Installs a bootstrapping version of EasyBuild in the work directory. As that
    version will only be used to install EasyBuild from our own EasyConfig file,
    there is no need to also install the EasyConfig files.

  * Loads the software stack module for the common partition and the EasyBuild-production
    module to install EasyBuild in the software stack.

Things to do afterwards:

  * If you want to change the default version of the LUMI software stack module,
    you can do this by editing ``.modulerc.lua`` in
    ``modules/SoftwareStack/LUMI``.

TODO

  * Create the Cray PE toolchain modules

    TODO: Use a script that uses the same data as used for the external module definition.

And now one should be ready to install other software...

  * Ensure the software stack module is loaded and the partition module for the
    location where you want to install the software is loaded (so the hidden module
    partition/common to install software in the location common to all regular
    partitions)

  * Load EasyBuild-production for an install in the production directories or
    EasyBuild-user for an install in the user or project directories (and you'll
    need to set some environment variables beforehand to point to that location).
