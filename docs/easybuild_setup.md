# EasyBuild setup

## Configuration decisions

### EasyBuild Module Naming Scheme

-   Options

    -   A flat naming scheme, even without the module classes as they are of little
        use. May packages belong to more than one class, it is impossible to come up
        with a consistent categorization. Fully omitting the categorization requires
        a slightly customized naming scheme that can be copied from UAntwerpen. When
        combining with --suffix-modules-path='' one can also drop the 'all' subdirectory
        level which is completely unnecessary in that case.

    -   A hierarchical naming scheme as used at CSCS and CSC. Note that CSCS has an
        open bug report at the time of writing (May 12, 2021) on the standard implementation
        in EasyBuild ([Issue #3626](https://github.com/easybuilders/easybuild-framework/issues/3626)
        and the related [issue 3575](https://github.com/easybuilders/easybuild-framework/issues/3575)),
        but they seem to be resolved.
        If not, the solution might be to develop our own naming scheme module.

-   Choice implemented for the current software stacks:

    -   A flat naming scheme that is a slight customization of the default EasyBuildMNS
        without the categories, combined with an empty ``suffix-modules-path`` to avoid
        adding the unnecessary ``all`` subdirectory level in the module tree.

    -   As we need to point to our own module naming scheme implementation which is
        hard to do in a configuration file (as the path needs to be hardcoded), the
        settings for the module scheme are done via ``EASYBUILD_*`` environment variables,
        specifically:
        -   ``EASYBUILD_INCLUDE_MODULE_NAMING_SCHEMES`` to add out own module naming schemes
        -   ``EASYBUILD_MODULE_NAMING_SCHEME=LUMI_FlatMNS``
        -   ``EASYBUILD_SUFFIX_MODULES_PATH=''``


### Other configuration decisions

-   rpath or not? No rpath, as it makes it difficult to try to inject other versions to see if 
    that solves bugs.

-   In the LUMI stack, we hide the versions of Cray libraries that do not correspond to the 
    version of ther LUMI stack that is loaded.


## External modules for integration with the Cray PE

See the [Cray PE integration page](CrayPE_integration.md).


## Running EasyBuild

EasyBuild for LUMI is configured through a set of EasyBuild configuration files and
environment variables. The basic idea is to never load the EasyBuild module directly
without using one of the EasyBuild configuration modules. There are three such modules

-   ``EasyBuild-production`` to do the installations in the production directories.

-   ``EasyBuild-infrastructure`` is similar to ``EasyBuild-production`` but places the module
    in the Infrastructure tree rather than the easybuild tree.

-   ``EasyBuild-user`` is meant to do software installations in the home directory of a
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

**NOTE:** We deliberately chose to use EasyBuild-production, EasyBuild-user etc and
not EasyBuild-config/production, EasyBuild-config/user, etc. because of the way
EasyBuild acts when loading a different partition module. For additional safety
we want to avoid that LMOD would reload a different version of the EasyBuild-config
module and would rather get an error message that the EasyBuild-* partition is not
available in the new partition.


### Common settings that are made through environment variables in all modes

-   The buildpath and path for temporary files. The current implementation creates
    subdirectories in the directory pointed to by ``XDG_RUNTIME_DIR`` as this is a
    RAM-based file system and gets cleaned when the user logs out. This value is based
    on the CSCS setup.

-   Name and location of the EasyBuild external modules definition file.

-   Settings for the module naming scheme: As we need to point to a custom implementation
    of the module naming schemes, this is done through an environment variable. For
    consistency we also set the module naming scheme itself via a variable and set
    EASYBUILD_SUFFIX_MODULES_PATH as that together with the module naming scheme determines
    the location of the modules with respect to the module install path.

-   ``EASYBUILD_OPTARCH`` has been extended compared to the CSCS setup:

    -   We support multiple target modules so that it is possible to select both the
        CPU and accelerator via ``EASYBUILD_OPTARCH``. See the
        [EasyBuild CPE toolchains common options](Toolchains/toolchain_cpe_common.md)

    -   It is now also possible to specify arguments for multiple compilers. Use ``CPE:``
        to mark the options for the CPE toolchains. See also
        [EasyBuild CPE toolchains common options](Toolchains/toolchain_cpe_common.md)

-   As the CPE toolchains are not included with the standard EasyBuild distribution
    and as we have also extended them (if those from CSCS would ever be included),
    we set ``EASYBUILD_INCLUDE_TOOLCHAINS`` to tell EasyBuild where to find the toolchains.


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

-   Modules tool and modules syntax.

-   Modules that may be loaded when EasyBuild runs

-   Modules that should be hidden. Starting point is currently the list of CSCS.

-   We hide irrelevant modules via a modulerc file in
    the module system rather than via EasyBuild which has the advantage that
    they maintain regular version numbers rather than version numbers that start with
    a dot (as it seems that that version number with the dot should then also be used
    consistently).

-   Ignore EBROOT variables without matching module as we use this to implement Bundles
    that are detected by certain EasyBlocks as if each package included in the Bundle
    was installed as a separate package.

The following settings are made through environment variables:

-   Software and module install paths, according to the directory scheme given in the
    module system section.

-   The directory where sources will be stored, as indicated in the directory structure
    overview.

-   The repo directories where EasyBuild stores EasyConfig files for the modules that
    are build, as indicated in the directory structure overview.

-   EasyBuild robot paths: we use EASYBUILD_ROBOT_PATHS and not EASYBUILD_ROBOT so
    searching the robot path is not enabled by default but can be controlled through
    the ``-r`` flag of the ``eb`` command. The search order is:

     1. The repository for the currently active partition build by EasyBuild for
        installed packages (``ebfiles_repo``)

     2. The repository for the common partition build by EasyBuild for
        installed packages (``ebfiles_repo``)

     3. The LUMI-specific EasyConfig directory.

    We deliberately put the ebfiles_repo repositories first as this ensure that EasyBuild
    will always find the EasyConfig file for the installed module first as changes
    may have been made to the EasyConfig in the LUMI EasyConfig repository that are
    not yet reflected in the installed software.

    The default EasyConfig files that come with EasyBuild are not put in the robot
    search path for two reasons:

     4. They are not made for the Cray toolchains anyway (though one could of course
        use ``--try-toolchain`` etc.)

     5. We want to ensure that our EasyConfig repository is complete so that we can
        impose our own standards on, e.g., adding information to the help block or
        whatis lines in modules, and do not accidentally install dependencies without
        realising this.

-   Names and locations of the EasyBuild configuration files and of the external modules
    definition file.

-   Settings for the module naming scheme: As we need to point to a custom implementation
    of the module naming schemes, this is done through an environment variable. For
    consistency we also set the module naming scheme itself via a variable and set
    EASYBUILD_SUFFIX_MODULES_PATH as that together with the module naming scheme determines
    the location of the modules with respect to the module install path.

-   Custom EasyBlocks

-   Search path for EasyConfig files with ``eb -S`` and ``eb --search``

     1. Every directory of the robot search path is automatically included and 
        does not need to be added to EASYBUILD_SEARCH_PATHS

     2. The [LUMI-EasyBuild-contrib repository](https://github.com/Lumi-supercomputer/LUMI-EasyBuild-contrib),
        as that one is not in the robot path in non-user mode.

     3. Not yet done, but we could maintain a local copy of the CSCS repository and
        enable search in that also.

     4. Default EasyConfig files that come with EasyBuild (if we can find EasyBuild,
        which is if an EasyBuild-build EasyBuild module is loaded)

     5. Deliberately not included: Our ebfiles_repo repositories. Everything in there
        should be in our own EasyConfig repository if the installations are managed
        properly.

-   We also set containerpath and packagepath even though we don't plan to use those,
    but it ensures that files produced by this option will not end up in our GitHub
    repository.

-   `EASYBUILD_BUILDPATH` and `EASYBUILD_TMPDIR` are determined by the following strategy:

     1. If the environment variable `EBU_WORKDIR` is set, that one is used as the base
        for the directory names.

     2. If we detect we are running in a singularity container, `/tmp/$USER` is used as
        the base for the directory names.

     3. If we are on a login node, we try to use $XDG_RUNTIME_DIR, and if that environment
        variable isn't set, we try in `/tmp`.

     4. Finally, if we are on a compute node we construct a subdirectory in `/tmp` based
        on the Slurm job ID or user name.


### The EasyBuild-user mode

-   The root of the user EasyBuild directory structure is pointed to by the
    environment variable ``EBU_USER_PREFIX``. The default value if the variable
    is not defined is ``$HOME/EasyBuild``.

    Note that this environment variable is also used in the ``LUMI/yy.mm`` modules
    as these modules try to include the user modules in the MODULEPATH.

-   The directory structure in that directory largely reflects the system
    directory structure. This may be a bit more complicated than really needed
    for the user who does an occasional install, but is great for user communities
    who install a more elaborate software stack in their project directory.

    Changes:

     -   ``SystemRepo`` is named ``UserRepo`` instead and that name is fixed,
         contrary to the ``SytemRepo`` name. We do keep it
         as a separate level so that the user can also easily do version
         tracking via a versioning system such as GitHub.

     -   The ``mgmt`` level is missing as we do not take into account
         subdirectories that might be related to other software management
         tools.

     -   As there are only modules generated by EasyBuild in this module tree,
         ``modules/easybuild`` simply becomes ``modules``.

     -   Similarly, the ``EB`` level in the directory for installed software is
         omitted.

-   The robot search path:

     1. The user repository for the currently active partition

     2. The user repository for the common partition (if different from
        the previous one)

     3. The system repository for the currently active partition

     4. The system repository for the common partition (if different from
        the previous one)

     5. The user EasyConfig directory `UserRepo` (even if it is not there
        yet)

     1. The LUMI-EasyBuild-contrib repository, if present in the user 
        directory use that one and otherwise use the one from the central
        installation.

     2. The LUMI-specific EasyConfig directory from the application directory

-   The search path for EasyConfig files with ``eb -S`` and ``eb --search``

     1. The directories above in the robot search path are automatically also used
        for search.

     2. Not yet done, but we could maintain a local copy of the CSCS repository and
        enable search in that also.

     3. Default EasyConfig files that come with EasyBuild are deliberately not included
        in user mode as it was decided this is confusing for the users.

     4. Deliberately not included: Our ebfiles_repo repositories. Everything in there
        should be in our own EasyConfig repository if the installations are managed
        properly.

    So currently the additional search paths in user mode are empty. 

-   `EASYBUILD_BUILDPATH` and `EASYBUILD_TMPDIR` are determined by the following strategy:

     1. If the environment variable `EBU_WORKDIR` is set, that one is used as the base
        for the directory names.

     2. If we detect we are running in a singularity container, `/tmp/$USER` is used as
        the base for the directory names.

     3. If we are on a login node, we try to use $XDG_RUNTIME_DIR, and if that environment
        variable isn't set, we try in `/tmp`.

     4. Finally, if we are on a compute node we construct a subdirectory in `/tmp` based
        on the Slurm job ID or user name.

There are two regular configuration files:

 1. The system ``easybuild-production.cfg`` is always read. In the current
    implementation it is assumed to be present.

 2. The user ``easybuild-user.cfg``(in ``UserRepo/easybuild/config`` in the user
    directory) is read next and meant for user-specific settings that should be
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

Comparison:

| **robot path non-user**        | **robot path user**                   |
|:-------------------------------|:--------------------------------------|
| /                              | ebrepo user active partition          |
| /                              | ebrepo user common partition          |
| ebrepo system active partition | ebrepo system active partition        |
| ebrepo system common partition | ebrepo system common partition        |
|                                | EBU_USER_PREFIX/UserRepo              |
|                                | LUMI-EasyBuild-contrib user or system |
| LUMI-SoftwareStack system      | LUMI-SoftwareStack system             |
| **search path non-user**       | **search path user**                  |
| LUMI-EasyBuild-contrib system  | /                                     |
| Default easybuild EasyConfigs  | /                                     |
