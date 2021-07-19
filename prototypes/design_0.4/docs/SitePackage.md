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


## Custom LMOD functions

### detect_LUMI_partition

``detect_LUMI_partition``is a function that can be used to request the current LUMI
partition. This is used by the generic ``modules/LUMIstack`` modules files but put
in ``SitePackage.lua`` to have a single point where this is implemented.

The alternative would be to use a trick that is also used in some CPE module
files to read in and execute code from an external file.

The current implementation is a stub that relies on the environment variable
``LUMI_PARTITION`` but the goal is to replace this with something more robust
to ensure that it also works in SLURM job scripts where that environment variable
may have the wrong value as SLURM by default copies its environment from the
node where the job was submitted.

The idea is to ensure that a ``module reload`` would reload the loaded software
stack for the partition on which the ``module reload`` command is run.


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

