# Some procedures

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

TODO! NOT COMPLETE!

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

  * If there are new Cray targetting modules that are irrelevant for LUMI you may want to
    hide them in the respective code block in ``LMOD/LUMIstack_modulerc.lua``.


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

