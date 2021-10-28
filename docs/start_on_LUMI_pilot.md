# Setting up the stack on LUMI

## Installing the stack

  * Create the directory where you want to install the software stack and move into that directory:

    ```bash
    mkdir LUMI-pilot
    cd LUMI-pilot
    ```

    If you want to share the installation with everybody in your project, doing so in your
    ``/projappl`` directory may be a good choice. However, beware as a full installation will
    eat into your file quota. Parallel file systems are really meant to work with large files
    while a software installation unfortunately can contain many small files.

    You can also work in scratch but the problem there is that the installation will be
    removed automatically after 90 days.

  * Clone the LUMI-SoftwareStack and LUMI-EasyBuild-contrib repositories:

    ```bash
    git clone git@github.com:Lumi-supercomputer/LUMI-SoftwareStack.git
    git clone git@github.com:Lumi-supercomputer/LUMI-EasyBuild-contrib.git
    ```
    or
    ```bash
    git clone https://github.com/Lumi-supercomputer/LUMI-SoftwareStack.git
    git clone https://github.com/Lumi-supercomputer/LUMI-EasyBuild-contrib.git
    ```
    depending on whether you have ssh access to GitHub or not.

    git clone  git@github.com:klust/LUMI-SoftwareStack.git

  * Move into the ``LUMI-SoftwareStack/scripts`` subdirectory

    ```bash
    cd LUMI-SoftwareStack/scripts
    ```

  * Now we will first build the raw structure of the software stack:

    ```bash
    ./prepare_LUMI.sh
    ```

  * Since currently CPE 21.05 is installed on LUMI, but we have no intention
    to use it in a LUMI software stack, we run a script to simply make CPE 21.05
    available in the CrayEnv stack of our system.

    ```bash
    ./prepare_CrayEnv_stack.sh 21.05
    ```

  * Now is time to prepare the LUMI/21.08 stack for which we used EasyBuild 4.4.1.
    Some work space is also needed but can be erased afterwards. Though not ideal,
    $HOME/work is used in the command as this variable is available to all users.

    ```bash
    ./prepare_LUMI_stack.sh 21.08 4.4.2 $HOME/work
    ```

    This step does take a while though.

  * Now we first need to activate LMOD and point it to the right module subdirectories.
    This is done by a script which is in the LUMI-SoftwareStack subdirectory itself
    (as it is only a temporary solution). The instructions to do this are generated
    by running the ``activate_LUMI_pilot.sh`` script in the LUMI-SoftwareStack
    directory:

    ```bash
    cd ..
    ./activate_LMOD_LUMI.sh
    ```

    You can call this script at any time to regenerate the instructions as long as you
    call it from within the repository so that it can detect the directory.

    Follow the instructions. We suggest that for now you simply copy the 5 lines of
    code as indicated in the text.

    Now we are ready to begin installing software.

  * Assuming you are still in the ``LUMI-pilot/LUMI-SoftwareStack`` directory:
    We'll use some lists of software that are in a subdirectory:

    ```bash
    cd easybuild/easystacks/LUMI-21.08
    ```

  * If you want some elementary build tools etc to be available in the ``CrayEnv``
    environment, which is really just the plain Cray Programming Environment with
    minimal interference from the LUMI software stacks, you can generate those
    using:

    ```bash
    module --force purge
    ml LUMI/21.08 partition/CrayEnv
    ml EasyBuild-CrayEnv
    eb --experimental --easystack  production-CrayEnv-21.08.yaml
    ```

  * The regular software stack consists of multiple parts:

      * A number of building blocks that are not performance-critical and have been
        installed with the system compilers.

      * Complete lines of software compiled with either ``PrgEnv-gnu``, ``PrgEnv-cray`` or ``PrgEnv-aocc``.
        However, in EasyBuild these toolchains are loaded by loading respectively the
        ``cpeGNU/21.08``, ``cpeCray/21.08`` or ``cpeAMD/21.08`` toolchains.

        At the moment of writing, ``cpeAMD/21.-08`` does not work as the modules are installed
        on the system by Cray but the software is missing.

    So this is the moment to consider what you want to use. The common building blocks
    are always needed though, though some users may not need the ``Rust`` module which
    will also be installed with the procedure below. However, if you only intend to
    use, e.g., the GNU compilers, it makes no sense to install all ``cpeCray`` or
    ``cpeAMD`` modules.

  * To install the common part of building blocks:

    ```bash
    module --force purge
    ml LUMI/21.08 partition/common
    ml EasyBuild-production
    eb --experimental --easystack  production-common-21.08.yaml
    ```

  * To install the cpeGNU modules:

    ```bash
    module --force purge
    ml LUMI/21.08 partition/L
    ml EasyBuild-production
    eb -r --experimental --easystack  production-L-21.08-GNU.yaml
    ```

    Note the ``-r`` argument that was absent before. This is because due to problems with the
    so-called EasyStack files (those yaml files) it was not yet possible to specify
    all required EasyBuild recipes, and recursive installations are disabled by default.

  * To install the cpeCraymodules:

    ```bash
    module --force purge
    ml LUMI/21.08 partition/L
    ml EasyBuild-production
    eb -r --experimental --easystack  production-L-21.08-Cray.yaml
    ```

    Note again the ``-r`` argument for the very same reasons.



```bash
mkdir LUMI-pilot
cd LUMI-pilot
git clone  git@github.com:klust/LUMI-SoftwareStack.git
git clone git@github.com:Lumi-supercomputer/LUMI-EasyBuild-contrib.git
cd LUMI-SoftwareStack/scripts
./prepare_LUMI.sh
./prepare_CrayEnv_stack.sh 21.05
./prepare_LUMI_stack.sh 21.08 4.4.2 $HOME/work
```


## Installing additional software

  * If you installed the full stack in your own project directory, you can actually
    have two locations to install software with EasyBuild

      * In the main stack (which you will of course not be able to do once we have
        a central installation): Use EasyBuild-production.

      * It is however also possible to have your own personal stack. By default this
        will be build in your home directory, but it might be better to share with
        your colleagues in your project.

        To use any other location then the default one, every user of the stack should
        ensure that the environment variable ``EBU_USER_PREFIX`` points to the directory.
        After that, the LUMI software stack will take care of everything and activate
        the right modules. However, you now have to use the module EasyBuild-user for
        the installation.

  * We recommend to have your own repository in ``$EBU_USER_PREFIX`` where you have
    all EasyConfig files that you want to use. The mandatory name of that repository
    directory is ``UserRepo``(as otherwise it is not found by EasyBuild-user), and
    EasyConfig files should be in ``UserRepo/easybuild/easyconfigs``.

    For more complete and technical information on our setup, please read the other
    pages pointed to in [the README document in this docs directory](README.md).

  * Note that we cannot support the common EasyBuild toolchains on LUMI in this phase
    as for now we concentrate on the Cray Programming Environment for which we have
    support from HPE-Cray. This does mean that EasyBuild recipes have to be reworked.

  * We're still working on reducing module clutter on the system. For now all basic
    libraries have their own module. Some of those may be hidden in the future as few
    users use them directly. However, even then they can still be found with
    ``module spider`` and be loaded.

    We have a few special modules on LUMI that bundle a lot of software that is otherwise
    in separate modules on a typical EasyBuild installation.

      * ``buildtools/21.08``(and other respective versions for each LUMI/yy.mm stack)
        bundles a number of popular build tools. This is done in a single module to
        have them all available in a single command and to try to use a very consistent
        set of build tools throughout most of our software installation process.

        Try ``module help buildtools/21.08`` to check what's in it.

      * ``systools/15.1.0`` contains some useful tools, such as ``tree`` and ``htop``.

      * ``syslibs/15.1.0`` is a hidden module and is really just meant as a build dependency
        for some basic tools that we install.


