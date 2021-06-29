# Some procedures


## Installing a new version of the Cray PE on the system

### Part 1: Making available in CrayEnv

These instructions are enough to make the new CPE available in the ``CrayEnv`` stack
but do not yet include instructions for EasyBuild

  * Install the CPE components using the instructions of HPE

  * Add a corrected cpe/yy.mm.lua file to the appropriate ``modules/CrayOverwrite``
    subdirectory. Take the existing files as an example.

      * Check if there are any new components that need to be added to either that file or
        to the ``cpe/restore-defaults`` module.

      * Consider switching the default cpe version in ``modules/CrayOVerwrite/.../cpe/.modulerc.lua``.

      * If you would be using a generic ``cpe`` module that reads its data from the
        CPE definition, first do the first step of part 2 of this procedure.

  * Hide the new cpe module installed in the Cray PE subdirectory by adding a line to
    ``LMOD/modulerc.lua`` in the repository.

### Part 2: Adding support as a LUMI/yy.mm(.dev) software stack

First make sure a number of files are present:

  * Create the components file in the ``CrayPE`` subdirectory of the repository.
    This is currently a simple .csv-file but may be replaced by a different one if
    HPE would provide that information in machine-readable format in a future version
    of the CPE.

    Much of that information can be extracted from the HPE-Cray provided file
    ``/opt/cray/pe/cpe/yy.mm/modulerc.lua``, though we do currently keep some additional
    packages in that file that don't have their defaults set in that file. One of them
    which is actually used in the LUMIpartition module file is the version of the
    craype-targets packages (essentially the CPE targeting modules).

  * Create in the repository a matching ``LMOD/LUMIstack_yy.mm_modulerc.lua`` file. The
    contents of this file is the same as the HPE-Cray provided file
    ``/opt/cray/pe/cpe/yy.mm/modulerc.lua`` in the current interpretation. The only reason
    why we use our own copy rather than referring to the Cray-provided file is to ensure
    that the file remains part of the the ``LMOD_MODULERCFILE`` series of files independent
    of load and unload operations of the ``cpe`` modules.

  * If there are new Cray targeting modules that are irrelevant for LUMI you may want to
    hide them in the respective code block in ``LMOD/LUMIstack_modulerc.lua``.

  * Add an EasyConfig file for the selected version of EasyBuild in the EasyConfig
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
    needed in the ``easybuild/confif`` subdirectory of the repository.

Next the ``prepare_LUMI_stack.sh``-script can be used to finish the initialization
of the software stack. It takes 3 input arguments:

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

    (The name ``SytemRepo`` is actually not hardcoded but the true name of the
    repository directory is derived from the directory of the script.)

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


## Making a master installation of the module system

A master version is an installation of the full system that can run independently from
another installation. This is made easy so that it is possible to install a master
version under a personal account or on a test system for testing and development independent
from the central installation on the system.

**This procedure is not for the prototype repository. That repository still uses a
different directory structure but contains a script to mimic the true repository by
linking to the prototype repository.**

 1. Create an empty directory which will be the root of the software installation.

 2. Clone the ``LUMI-software-setup`` repository in that directory. You can change
    the name of the repository directory to anything as the whole installation is independent
    of that name provided that ``LMOD_PACKAGE_PATH`` refers to the LMOD installation in that
    repository. In the documentation, we call the directory ``SystemRepo``.

 3. Run the ``prepare_LUMI.sh`` script from ``SystemRepo/scripts`` to initialise the
    directory structure. The script takes no arguments but it is important to run the
    version in the ``SytemRepo`` in the software installation that needs to be initialised.

 4. Running the ``enable_LUMI.sh`` script from ``SystemRepo/scripts`` prints the (bash)
    shell commands that need to be executed to initialise the shell to start using this
    software installation. A very good way is to use it with ``eval``:
    ```bash
    eval $(<directory>/SystemRepo/scripts/enable_LUMI.sh)
    ```

Now use the procedure "Installing a new version of the Cray PE on the system" to start
a new version of the LUMI software stack, skipping the creation of those files that
may already be in the repository because someone else has done them already.


### Variant: Making a master installation with a shadow repository

This variant of the procedure is needed for the prototype where the we do not yet
have the true LUMI repository but a subdirectory in the prototypes directory of the
prototype repository.

 1. Clone the ``LUMI-software-setup`` repository of the software installation.

 2. Create an empty directory elsewhere that will be the root of the software installation
    and location of the shadow repository which links into the actual repository.
    (This can be skipped as the script in the next step will create the directory
    if it does not exist.)

 3. Run the ``create_shadow.sh`` script from the ``scripts`` directory of the repo
    that you cloned in the first step. Specify the directory that you created in the
    previous step as the first argument, and if the site has a subdirectory in the
    ``shadow`` directory in the repository, specify that name as the second argument.

 4. Now go to the shadow repository that has been created in the previous step and
    use it as if it is the actual repository, proceeding with step 3 of that procedure
    to initialise the directory structure.


