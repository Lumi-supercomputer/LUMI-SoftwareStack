# LUMI prototype SitePackage.lua

SitePackage.lua is used to implement various customistations to Lmod.

The file defines both LMOD hooks and a number of new functions for the sandbox to ease
the implementation of modulefiles for LUMI.

Make sure that the environment variable ``LMOD_PACKAGE_PATH`` points to the directory
that contains this file to activate this file.


## Settings

### Target modules per partition

The target modules per partition are set via the init_module_list table. This also
includes other modules that are set at initialisation.


### Default programming environment

The default programming environment is set via the init_PrgEnv variable.


### List of LTS software stacks

In the initial implementation every software stack that was not a development stack
was marked as "LTS" but it turns out it will be very difficult initially to live up
to the promise of 2 years of support. We simply need to change the programming
environment too often and HPE Cray also does not keep supporting them.

The LUMI-stacks with long-term support are set in LTS_LUMI_stacks


## Hooks

### SiteName hook

This hook is used to define the prefix for some of the environment variables that
Lmod will generate internally. Rather then just setting it to ``LUMI`` we decided to
set it to ``LUMI_LMOD`` to lower the chance of conflicts with environment variables
that may be defined elsewhere.


### avail hook

This hook is used to replace directories with labels in the output of ``module avail``.

To work for the prototypes, one needs to set:
```bash
export LMOD_AVAIL_STYLE=<label>:PEhierarchy:system
```
which will make the labeled view the default but will still allow to see the directory
view using
```bash
module -s system avail
```

The ``ModuleLabel`` modules can also be used to switch between the three settings:

  * ``label``: User-friendly labels for the directories, some directories collapsed into
    a single category, and all Cray PE modules collapsed into a single category.

  * ``PEhierarchyy``: User-friendly labels for the directories, some directories collapsed into
    a single category, but with the original Cray PE module hierarchy.

  * ``system``: The view showing the full directory path for each module directory.


### msgHook

This hook is used to adapt the following messages:
  * output of ``module avail``:  Add more information about how to search for software
    and to contact LUMI User Support.


### Visibility hook

The visibility hook is currently used to hide the Cray modules of other CPE versions
in a particular version of the CPE software stack. It is also used to hide the 
``EasyBuild`` modules as users sometimes load these without loading the 
``EasyBuild-user`` module.

As the hook function is called many
times during a single call to ``module avail`` some effort was done to make it efficient
at the cost of readability.

  * The data about the Cray PE modules that should not be hidden is contained in a LUA script
    in ``mgmt/LMOD/VisibilityHookData``. This script is read via ``require`` so that
    it is cached and really processed only once. Furthermore, to make locating the
    script easy, the LUMI stack module stores the path and name in two environment
    variables that are ready-to-use without further substitutions.

    The file is auto-generated during the initialisation of a software stack.

    The name and location of the file is set through two environment variables set
    in the LUMI modules.

  * The code to hide EasyBuild is currently rather rudimentary. It doesn't try to do 
    so only for EasyBuild modules in the central software stack, but would hide an
    EasyBuild module that has been installed by a user also. This is partly the
    result of design flaws making it harder to distinguish user and central 
    modules.

  * Note that the feature is turned of for power users.


## Custom LMOD functions

### detect_LUMI_partition

``detect_LUMI_partition``is a function that can be used to request the current LUMI
partition. This is used by the generic ``modules/LUMIstack`` modules files but put
in ``SitePackage.lua`` to have a single point where this is implemented.

The alternative would be to use a trick that is also used in some CPE module
files to read in and execute code from an external file.

LUMI_OVERWRITE_PARTITION is defined and if so, the value of that variable is used.
It is assumed to be C, G, D or L depending on the node type (CPU compute, GPU compute,
data and visualisation or login), or can be common to install software in the
hidden common partition.

Currently the following rules are implemented for LUMI:

  * Node name starts with `uan`:  It must be a login node, so in partition/L

  * Nude number 16-23: LUMI-D with GPU

  * Node number 101-108: LUMI-D without GPY, assing to partition/L

  * Node number 1000-2535: Regular LUMI-C compute nodes, assign partition/C

  * Other nodes are for now assigned to partition/L.

The idea is to ensure that a ``module update`` would reload the loaded software
stack for the partition on which the ``module update`` command is run.


### get_CPE_component

``get_CPE_component`` is a function that can be used in modulefiles to request
the version of a CPE component. The data is read from the CPE definition files
in the ``CrayPE`` subdirectory of the repository.

The function is currently used in the ``modules/LUMIpartition`` generic implementation
of the partition modules for the LUMI stacks to determine the version of the
Cray targeting modules to add that directory to the MODULEPATH.


### get_CPE_versions

``get_CPE_versions`` is a function that can be used in module files to request
a table with the version for each package in a CPE release. The data is read
from the CPE definition files in the ``CrayPE`` subdirectory of the repository.

The function is used in the prototype in the ``cpe`` modules for the Grenoble
system as a proof-of-concept for a generic ``cpe`` module to reduce the number
of places where the version info of the Cray packages in a CPE release is kept.


### get_EasyBuild_version

``get_EasyBuild_version`` is a function that simply returns the version of 
EasyBuild for a given software stack (and actually a given CPE version in the
current implementation, so a `.dev` stack is assumed to have the same version
of EasyBuild as the regular stack). Currently we abuse the CPE definition
files in ``CrayPE`` to set the version of EasyBuild, but by making this a
separate function this can be changed in the future.


### get_versionedfile

``get_versionedfile`` is a function that can be used to find the suitable versioned
file for a given version of the LUMI software stack, i.e., the file which according
to the version number is the most recent one not newer than the software stack.


### get_hostname

``get_hostname`` gets the hostname from the output of the ``hostname`` command.
It is meant to be used by detect_LUMI_partition but is also exported so that other
module files can use it if needed.


### get_user_prefix_EasyBuild

``get_user_prefix_EasyBuild`` computes the root of the user EasyBuild installation
from the environment variable ``EBU_USER_PREFIX`` and the default name in the home
directory.

It is used in the ``EasyBuild-config`` module, the ``LUMIpartition`` module (to include
the user module directory in the ``MODULEPATH`) and in the ``avail_hook`` LMOD hook.


### get_init_module_list

``get_init_module_list`` is a function that returns the list of modules to load at
initialisation. This includes target modules, other modules, and optionally the
default programming environment.

The function takes two arguments:

 1. The partition (L, C, G, D)

 2. A boolean: When true the default programming environment is added to the list of
    modules that is generated as a result of the function.


### get_motd

``get_motd`` returns the message-fo-the-day as stored in ``etc/motd`` in the repository
root. The function takes no input arguments.


### get_fortune

``get_fortune`` works as the old UNIX ``fortune`` command. It returns a random tip
read from ``etc/lumi_fortune.txt`` in the repository root.


### is_interactive

``is_interactive`` returns true if it is called in an interactive shell, otherwise
false. The function takes no input arguments.

It is used to ensure that the message-of-the-day is not printed in cases where Linux
would not print it.


### is_LTS_LUMI_stack

``is_LTS_LUMI_stack`` takes one input argument: the version of the LUMI stack. It returns
true if that version is a LTS stack and returns false otherwise.
