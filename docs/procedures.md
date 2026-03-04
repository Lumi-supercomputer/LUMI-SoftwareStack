# Some procedures


## Installing a new version of the Cray PE on the system

### Part 1: Making available in CrayEnv

These instructions are enough to make the new CPE available in the `CrayEnv` stack
but do not yet include instructions for EasyBuild

  * Install the CPE components using the instructions of HPE

  * Create the components file in the `CrayPE` subdirectory of the repository.
    This is currently a simple .csv-file but may be replaced by a different one if
    HPE would provide that information in machine-readable format in a future version
    of the CPE.

    Much of that information can be extracted from the HPE-Cray provided file
    `/opt/cray/pe/cpe/yy.mm/modulerc.lua`, though we do currently keep some additional
    packages in that file that don't have their defaults set in that file. One of them
    which is actually used in the LUMIpartition module file is the version of the
    craype-targets packages (essentially the CPE targeting modules).

  * **This step is only needed if you don't do part 2 as the installation script used
    in part 2 of this procedure will also do this:**

    Add a `cpe/yy.mm.lua` link for the just installed programming environment to
    the `modules/CrayOverwrite/core` subdirectory of the modules tree (NOT in the
    `modules` directory of the repository). This file does need the .csv file
    generated in the previous step to function properly.

    Note that this directory also contains a link named `.modulerc` to the
    `.version` file of `/opt/cray/pe/lmod/modulefiles/core/cpe`. It is essential
    that the default version of the `cpe` module is the same in the original module
    directory and in `CrayOverwrite` as otherwise the original one may get loaded
    in some circumstances. By using the symbolic link and the new name with higher
    priority we assure that the modules from `CrayOVerwrite` are used. One still
    needs to ensure that the overwrite modules also are more to the front of the
    `MODULEPATH` or things still go wrong.

    **Note: This step is not essential anymore, but the initialisation scrips still
    do it.** This was mostly done to work around old issues
    that seem solved now and we don't have the directory in the `MODULEPATH`
    anymore.

  * **This step is only needed if you don't do part 2 as the installation script used
    in part 2 of this procedure will also do this:**

    If `/opt/cray/pe/cpe/yy.mm/modulerc.lua` is missing on the system, an alternative
    needs to be generated and stored in `modules/CrayOverwrite/data-cpe/yy.mm` as
    it is used by the generic cpe module installed in the previous step.

    This can be done by running `./make_CPE_modulerc yy.mm` in the `scripts` subdirectory
    of `SystemRepo`.

  * **Before 21.08:** Hide the new cpe module installed in the Cray PE subdirectory by adding a line to
    `LMOD/modulerc.lua` in the `LUMI-SoftwareStack` repository.

    **Still relevant today:** Hide the `cpe-cuda` modules (if present) to not give
    users the impression that they can use CUDA on LUMI.

  * If there are new Cray targeting modules that are irrelevant for LUMI you may want to
    hide them in the respective code block in `LMOD/LUMIstack_modulerc.lua`
    in the `LUMI-SoftwareStack` repository.


### Part 2: Adding support as a LUMI/yy.mm(.dev) software stack

From here on the setup is largely automated by the `prepare_LUMI_stack.sh` script
in the `scripts` subdirectory of the repository. A few things need to be in place
though before running this script:

  * The component definition of the Cray PE software stack in the .csv file in the
    `CrayPE` subdirectory.

  * An EasyConfig file for the right version of EasyBuild in the
    `easybuild/easyconfigs/e/EasyBuild` subdirectory of the repository.

    Note that it is always possible to run `prepare_LUMI_stack.sh`-script
    with `EASYBUILD_IGNORE_CHECKSUMS=1` set if the checksums in the EasyConfig
    file are not yet OK.

  * Add a software stack-specific configuration file
    `easybuild-production-LUMI-yy.mm.cfg` for EasyBuild if
    needed in the `easybuild/config` subdirectory of the repository.

    We currently don't include the `.dev` extension, i.e., if there is a development
    and an LTS software stack for the same version of the CPE, they share the EasyBuild
    configuration file. This makes sense because the development stack is meant to
    prepare for a production stack.

Furthermore you may want to make sure that the proper versions of the following files
are available in the repository should you want to make changes compared to versions
installed before:

  * The generic `EasyBuild-config` module should you want to make changes to, e.g.,
    the environment variables et by that module.

  * The generic `LUMIstack` and `LUMIpartition` module.

  * The generic cpe module `cpe-generic`.

The software stack initialisation script will take the most recent one
(based on the yy.mm version number) that is not newer than the release
of the CPE for the software stack.

The `prepare_LUMI_stack.sh` script takes two arguments, and the order is important:

 1. The version of the software stack: the Cray PE version, with the extension `.dev`
    for a development stack (e.g., 21.05.dev or 21.06).

 2. A work directory for temporary files, used to install a bootstrapping copy
    of EasyBuild. Rather than trying to use an EasyBuild installation from an
    older software stack if present to bootstrap the new one, we simply chose
    to do a bootstrap every time the script is run as this is a procedure
    that simply always works, though it is more time consuming.

    The advantage however is that one can just clone the production repository
    anywhere, run an initialisation script to initialise the structure around
    the repository, then initialise a software stack and start working.

Earlier versions had three arguments and took the EasyBuild version as the second 
argument, but as this is also in the toolchain configuration file, it now uses
the value it gets from there.

The script then does the following steps:

  * Generate our own `cpe/yy.mm` module in `modules/CrayOverwrite/core` by creating
    a symbolic link to the right version of the generic modules in `SystemRepo`.

    *This step is not needed anymore since 21.08, but is not eliminated, just in 
    case we would need those files again.*

  * Check if the Cray PE comes with its own `modulerc.lua` file with the default components
    (if so, that file can be found in `/opt/cray/pe/cpe/yy.mm`). If not an alternative
    file is generated from the data in the compoments .csv file and stored in
    `modules/CrayOverwrite/data-cpe/yy.mm`.

    The file is used by the generic `cpe/yy.mm` module in `modules/CrayOVerwrite/core`.

  * Create the software stack module files by symlinking to the generic implementations
    in `SystemRepo`.

  * Create the partition modules (second level in the hierarchy) by symlinking to the
    generic implementations in `SystemRepo`.

  * Create the `LUMIstack_yy.mm_modulerc.lua` file in `mgmt/LMOD/ModuleRC`.
    Currently this file only contain references to Cray PE modules and as such correspond
    to the `modulerc.lua` file in `/opt/cray/pe/cpe/yy.mm` but his may change in
    a future version. Whereas the aforementioned `modulerc.lua` files are meant to
    be activated by the `cpe/yy.mm` modules and hence to be used by any software
    stack that uses the Cray PE, the `LUMIstack_yy.mm_modulerc.lua` are really meant
    exclusively for the LUMI software stack.

    This is done by running the `make_LUMIstack_modulerc.sh` script.

  * Creates the `CPE_modules_*.lua` file in `mgmt/LMOD/VisibilityHookData` for
    `module avail` visibility hook in `SitePackage.lua`. This is done by running
    the `make_CPE_VisibilityHookData.sh` script.

  * Creates the full directory structure for the software stack for the modules,
    the binary installations and the EasyBuild repo.

  * Creates the EasyBuild external modules definition file from the data in the
    corresponding `CPEpakcages_<CPE version>.csv` file (if the file does not yet
    exist). This file is stored in the repo as it may be useful for other people
    who check out the repository to know what is going on.

  * Creates the EasyBuild-production, EasyBuild-infrastructure and EasyBuild-user
    modules for each partition by softlinking to the matching generic file in
    the `SystemRepo`.

  * Downloads the selected version of EasyBuild to the EasyBuild sources directory
    if the files are not yet present.

  * Installs a bootstrapping version of EasyBuild in the work directory. As that
    version will only be used to install EasyBuild from our own EasyConfig file,
    there is no need to also install the EasyConfig files.

  * Loads the software stack module for the common partition and the EasyBuild-production
    module to install EasyBuild in the software stack.

  * Create EasyConfig files in the repository for the `cpeCray`, `cpeGNU`, `cpeAOCC` and `cpeAMD`
    toolchains (if those files do not yet exist) and use the just installed EasyBuild
    to install them in the `Infrastructure` module subdirectory for all 4 regular
    and the common partition.

    The toolchain definition EasyConfig files are generated by the `make_CPE_EBfile.sh`
    script.

    It skips the generation of `cpeAMD` and the installation of all toolchains in GPU partitions
    if it cannot find the requested `amd` module. This gives us the time to install our own while
    already using build dependencies such as `buildtools`. A second run, after installing the 
    `rocm` and `amd` modules, will then install the missing toolchains.

Things to do afterwards:

  * If you want to change the default version of the LUMI software stack module,
    you can do this by editing `.modulerc.lua` in
    `modules/SoftwareStack/LUMI`.

And now one should be ready to install other software...

  * Ensure the software stack module is loaded and the partition module for the
    location where you want to install the software is loaded (so the hidden module
    partition/common to install software in the location common to all regular
    partitions)

  * Load EasyBuild-production for an install in the production directories or
    EasyBuild-user for an install in the user or project directories (and you'll
    need to set some environment variables beforehand to point to that location).


## Making a master installation of the software stack

A master version is an installation of the full system that can run independently from
another installation. This is made easy so that it is possible to install a master
version under a personal account or on a test system for testing and development independent
from the central installation on the system.

 1. Create an empty directory which will be the root of the software installation.

 2. Clone the `LUMI-SoftwareStack` repository in that directory. You can change
    the name of the repository directory to anything as the whole installation is independent
    of that name provided that `LMOD_PACKAGE_PATH` refers to the LMOD installation in that
    repository. In the documentation, we call the directory `SystemRepo` (as opposed
    to `UserRepo` for a user installation that depends on a master installation).

 3. Also clone the `LUMI-EasyBuild-contriv` repository in that directory.

 3. Run the `prepare_LUMI.sh` script from `SystemRepo/scripts` to initialise the
    directory structure. The script takes no arguments but it is important to run the
    version in the `SytemRepo` in the software installation that needs to be initialised.

 4. Running the `enable_LUMI.sh` script from `SystemRepo/scripts` prints the (bash)
    shell commands that need to be executed to initialise the shell to start using this
    software installation. A very good way is to use it with `eval`:
    ```bash
    eval $(<directory>/SystemRepo/scripts/enable_LUMI.sh)
    ```

Now use the procedure "Installing a new version of the Cray PE on the system" to start
a new version of the LUMI software stack, skipping the creation of those files that
may already be in the repository because someone else has done them already.

**TODO:** Add information of how to fake the container repository which is elsewhere
on the system to do development in that one without interfering with the production
version on the system.


## Bumping the toolchain to a newer version without changing the other dependencies

For now, we use the script `upgrade-tc.py` developed at CSCS and kept in the `tools`
subdirectory. It is also available when any of our EasyBuild configuration modules is loaded.


## Bumping the toolchain to a newer version and changing the other dependencies

Two scripts situated in the `tools` subdirectory and available in the path when any of the
EasyBuild configuration modules is loaded can help with this:

-   `upgrade-tc.py` is a script developed at CSCS to upgrade the toolchain in the EasyConfig
    file. It will also update the name of the EasyConfig file to reflect the new toolchain version.
-   `upgrade-locals.lua` uses the set of `local_*_version` variable definitions in one of the
    `versions-yy.mm.txt` files to update those variables in one or more given EasyConfig file.
