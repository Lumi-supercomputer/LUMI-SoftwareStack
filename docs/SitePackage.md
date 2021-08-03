# LUMI prototype SitePackage.lua

SitePackage.lua is used to implement various customistations to Lmod.

The file defines both LMOD hooks and a number of new functions for the sandbox to ease
the implementation of modulefiles for LUMI.

Make sure that the environment variable ``LMOD_PACKAGE_PATH`` points to the directory
that contains this file to activate this file.


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
in a particular version of the CPE software stack. As the hook function is called many
times during a single call to ``module avail`` some effort was done to make it efficient
at the cost of readability.

  * The data about the modules that should not be hidden is contained in a LUA script
    in ``mgmt/LMOD/VisibilityHookData``. This script is read via ``require`` so that
    it is cached and really processed only once. Furthermore, to make locating the
    script easy, the LUMI stack module stores the path and name in two environment
    variables that are ready-to-use without further substitutions.

    The file is auto-generated during the initialisation of a software stack.

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

If that environment variable is not defined, we currently emply the following algorithm
as a demo of what can be done on the final LUMI installation:

  * On eiger uan01 and uan02 the partition is set to L

  * On eiger uan03 the partition is set to common

  * On all other hosts we first check for the environment variable
    LUMI_PARTITION and use that one and otherwise we set the partition
    to L.

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


### get_versionedfile

``get_versionedfile`` is a function that can be used to find the suitable versioned
file for a given version of the LUMI software stack, i.e., the file which according
to the version number is the most recent one not newer than the software stack.


### get_hostname

``get_hostname`` gets the hostname from the output of the ``hostname`` command.
It is meant to be used by detect_LUMI_partition but is also exported so that other
module files can use it if needed.
