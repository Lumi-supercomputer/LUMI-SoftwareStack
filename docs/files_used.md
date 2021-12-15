# An overview of files in the LUMI-SoftwareStack repository and where they are being used

*As GitHub markdown has pretty poor tables we currently use a list layout.*


## CrayPE subdirectory

  * ``CPEpackages_yy.mm.csv`` files: Two-column .csv files defining the components
    of the yy.mm CPE release.

    Much but not all of that data could be automatically extracted from the matching
    ``/opt/cray/pe/cpe/yy.mm/modulerc.lua`` file. See the [procedure to install a new
    version of the Cray PE on the system](procedures.md#-installing-a-new-version-of-the-Cray-PE-on-the-system).


## LMOD subdirectory

  * The [``LMOD``](../LMOD) subdirectory itself is set as the value of the environment variable
    ``LMOD_PACKAGE_PATH`` in the system setup.

  *  [``admin.list``](../LMOD/admin.list): Set as the value of the environment variable
     ``LMOD_ADMIN_FILE``      in the system setup.

  * [``lmodrc.lua``](../LMOD/lmodrc.lua): Set as the value of the environment variable
    ``LMOD_RC`` in the system setup.

  * [``LUMIstack_yy.mm_modulerc.lua``](../LMOD/) files: Added to the list of modulerc files in
    the ``LMOD_MODULERCFILE`` environment variable by the
    [``modules/LUMIstack``](../modules/LUMIstack) generic
    module files for the ``LUMI/yy.mm`` modules.

    Sets the default versions for the CPE release yy.mm in a way that is independent
    of everything the ``cpe/yy.mm`` modules might do (unless they really overwrite
    ``LMOD_MODULERCFILE``).

  * [``LUMIstack_modulerc.lua``](../LMOD/LUMIstack_modulerc.lua) files: Added to the
    list of modulerc files in the ``LMOD_MODULERCFILE`` environment variable by the
    [``modules/LUMIstack``](../modules/LUMIstack) generic
    module files for the ``LUMI/yy.mm`` modules.

    Used to hide a number of modules that are of no use to ordinary users when using
    the LUMI software stacks, and provide some user-friendly aliases for the partition
    modules.

  * [``SitePackage.lua``](../LMOD/SitePackage.lua): Referred to indirectly by the
    ``LMOD_PACKAGE_PATH`` system environment variable.

    [Additional information on this file](SitePackage.md)


## modules subdirectory

  * [``CraEnv.lua``](../modules/CrayEnv.lua): Module providing the plain nearly unmodified
    Cray Programming Environment.

    We do overwrite a number of CPE files in the [``modules/CrayOverwrite``](../modules/CrayOverwrite)
    subdirectory to work around problems in some of the Cray module files.

  * [``EasyBuild-config``](../modules/EasyBuild-config): A generic EasyBuild
    configuration module that instantiates into the ``EasyBuild-production``,
    ``EasyBuild-infrastructure``, ``EasyBuild-CrayEnv`` and ``EasyBuild-user``
    modules in the relevant partitions of the LUMI software stacks.

  * [``EasyBuild-unlock``](../modules/EasyBuild-unlock): A module that has to be
    loaded before any of the ``EasyBuild-production``, ``EasyBuild-infrastructure``
    or ``EasyBuild-CrayEnv`` modules can be loaded as additional protection to not
    accidentally overwrite a system installation.

  * [``init-lumi``](../modules/init-lumi): The module called from the Cray PE intialisation
    process (in ``/etc/cray-pe.d/cray-pe-configuration.sh``) to do the final steps
    of enabling the LUST software stacks.

  * [``LUMIstack``](../modules/LUMIstack): Generic implementation(s) of the LUMI software
    stack modules. The actual modules can simply link to the right version of the generic
    module file.

  * [``LUMIpartition``](../modules/LUMIpartition): Generic implementation(s) of the
    LUMI partition modules. The actual modules can simply link to the right version
    of the generic module file.

  * [``CrayOverwrite``](../modules/CrayOverwrite): A directory with modulefiles that
    should overwrite standard CPE module files that have behaviour that conflicts with
    our setup.

    The process of overruling a Cray module may not be easy: If one of those modules
    is set as default in the original CPE subdirectory, one should make sure that that
    is overruled in the ``CrayOverwrite`` subdirectory for that module.

  * [``StyleModifiers``](../modules/StyleModifiers): A set of small modules that change
    the presentation of the module display by ``module avail``. These modules simply
    set one or more environment variables, one LUMI-specific one and the other LMOD
    configuration variables.

    These modules include:

      * [``ModuleColour``](../modules/StyleModifiers/ModuleColour): Switch between
        colour and black-and-white display of the modules

      * [``ModuleExtensions``](../modules/StyleModifiers/ModuleExtensions): Show or
        hide the display of extensions in the output of ``module avail``.

      * [``ModuleLabel``](../modules/StyleModifiers/ModuleLabel): Switch between three
        ways of displaying the module subdirectories:

          * ``label``: Give the module subdirectories meaningful names and collapses
            all directories in the CPE module hierarchy.

          * ``PEhierarcy``: Give the module subdirectories meaningful names but do
            not collapse the directories in the CPE module hierarchy

          * ``system``: Show the directory names of all modules subdirectories

      * [``ModulePowerUser``](../modules/StyleModifiers/ModulePowerUser): Enables the power
        user view of the module system: Less modules are hidden, but using those modules
        that are otherwise hidden is not supported by the LUMI User Support Team. These
        modules may not work under a regular user account or are their use is not documented
        in the regular LUMI documentation as they are only meant for support staff.

      * [``ModuleStyle``](../modules/StyleModifiers/ModuleStyle): Used to return to
        the situation at login or the default for the system.

For the [``EasyBuild-config``](../modules/EasyBuild-config), [``LUMIstack``](../modules/LUMIstack)
and [``LUMIpartition``](../modules/LUMIpartition) modules we adopted a special version
numbering: They are numbered in the same way as CPE releases and a particular module
for any LUMI stack we use the most recent version that is not younger than the correpsonding
CPE/LUMI stack.


## easybuild/config subdirectory

The files are referred to by the [``EasyBuild-config``](../modules/EasyBuild-config)
generic module file.


## easybuild/easyblocks subdirectory

This is the subdirectory for the LUMI custom EasyBlocks. We use a scheme with subdirectories
as in the main EasyBlock repository.


## easybuild/easyconfigs subdirectory

EasyConfig repository for LUMI.


## easybuild/hooks subdirectoruy

This directory contains the custom hooks for EasyBuild on LUMI.

The file names end on the first version of the software stack that they support. As
such we can drop old code from hooks while still being able to regenerate old configirations.


## easybuild/toolchains subdirectoruy

This directory contains the custom Cray toolchain code for EasyBuild.

For LUMI:

  * Custom toolchain definition files:

      * ``cpecray.py``: Toolchain based on the Cray compiler

      * ``cpegnu.py``: Toolchain based on the GNU compilers provided by Cray

      * ``cpeamd.py``:  Toolchain based on the AMD AOCC compiler provided by Cray.

  * Compiler definitions to use compilers through the Cray wrappers:

      * ``compiler/cpecce.py``: Definitions for the Cray CCE compiler with the Cray
        wrappers.

      * ``compiler/cpegcc.py``: Definitions for the GNU compilers with the Cray wrappers.

      * ``compiler/cpeaocc.py``: Definitions for the AMD AOCC compilers with the Cray
        wrappers.


## easybuild/tools subdirectory

  * [``module_naming_scheme``](../easybuild/tools/module_naming_scheme) subdirectory:
    LUMI uses a customised flat EasyBuild naming scheme. The links by moduleclass are
    omitted as they are not used in our module system.

    Note that the [``EasyBuild-config``](../modules/EasyBuild-config) generic module
    also sets the environment variable ``EASYBUILD_SUFFIX_MODULES_PATH`` to the empty
    string to omit the ``all`` level in the EasyBuild modules directory structure.


# The etc subdirectory

This directory contains the [``motd.txt``](../etc/motd.txt) and
[`lumi_fortune.txt``](../etc/lumi_fortune.txt) files that are used
by the `init-lumi` module to augment the message of the day and to display a random
tip about LUMI.


## The scripts and scripts/lumitools subdirectories

The scripts subdirectory contains a number of shell scripts to initialise a new installation,
new software stack in the installation, or various substeps of this. Several of those
scripts are just wrapper scripts that call a Python routine to do the work.


## The Setup subdirectory

A directory where we keep our preferred setup of the system configuration files for
the HPE Cray PE, useful to communicate with the sysadmins who maintain those files.


## The tools subdirectory

This directory contains scripts that are useful to any user of EasyBuild of LUMI, e.g.,
to bump EasyConfig files to a new release of the Cray PE.

  * [``upgrade-tc.py``](../tools/upgrade-tc.py): Bump the version of the Cray PE in
    an EasyConfig file, also adapting the name of the file. Note that the regular
    dependencies are not updated to a new version.


## The Testing subdirectory

This directory contains various files to be used in component tests.

  * [``install_lmod_newest.sh``](../Testing/install_lmod_newest.sh) is a script to
    install a very recent version of LMOD to test compatibility of the module system
    agains more recent versions than the one that comes with a HPE-Cray system.


## Note: Files and directories referred to from outside the LUMI software structure

  * [``LMOD``](../LMOD) subdirectory itself as the value of the environment variable
    ``LMOD_PACKAGE_PATH``

  * [``LMOD/admin.list``](../LMOD/admin.list) as the value of the environment variable
     ``LMOD_ADMIN_FILE``

  * [``LMOD/lmodrc.lua``](../LMOD/lmodrc.lua) as the value of the environment variable
    ``LMOD_RC``

  * Not a reference to a file, but the system should set ``LMOD_AVAIL_STYLE`` to
    ``<label>:PEhierarchy:system``.

