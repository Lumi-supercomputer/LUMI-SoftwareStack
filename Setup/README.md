# LUMI setup instructions

## Idea

  * The CPE is initialised by the /etc/cray-pe.d/cray-pe-configuration.[sh,csh] scripts.

  * These scripts are sourced from the /etc/bash.bashrc.local and csh.cshrc.local
    scripts.

To check:

  * The script is also sourced by /etc/cray-pe.d/cray-pe-overlay.sh script which may
    play a role when booting the system. So are the changes compatible with this script?

  * It is also sourced by /etc/cray-pe.d/gen-prgenv.sh so we need to check if it is
    compatible with that script also.

The only point where there could be a conflict is with loading lumi-init.


## Problems

  * We cannot preload the LUMI environment, or at least we have to tell the user to reload if
    they want their own modules to be visible. The reason is that we offer the user the option
    to indicate where personal EasyBuild-installed modules are located via an environment
    variable that may only be set after the execution of the system scripts.

    Or we still set this as the default but tell the user to reload the LUMI module.

  * There are three environment variables that should probably be set before `/etc/bash.bashrc`
    sources `/etc/bash.bashrc.local`:

    ```bash
    export LMOD_PACKAGE_PATH=/appl/lumi/LUMI-SoftwareStack/LMOD ;
    export LMOD_RC=/appl/lumi/LUMI-SoftwareStack/LMOD/lmodrc.lua ;
    export LMOD_ADMIN_FILE=/appl/lumi/LUMI-SoftwareStack/LMOD/admin.list ;
    ```

    I'm not sure if LMOD can appreciate it if changes are made to those variables after
    initialisation. The two other variables that are set by the `enable_LUMI.sh` script are no
    problem. The first one is most certainly the most dangerous one as this is the
    path to a file that LMOD uses to define functions and hooks that are used in MODULEFILES.
    If that variable is not present, the stack breaks down. I could protect it from
    being unset though.

    Moreover, I cannot set them in a module and in the same module already initialise
    the software stack.


## Two options for the first setup:

 1. Only install the new `cray-pe-configuration.sh` file (and its .csh equivalent)
    and let init-lumi take care of the remainder of the initialisation.

      * RISK still to be checked: Verify that the user can already do a module load
        of CrayEnv or LUMI in their .bashrc and job scripts. (I see no reason why this
        should not work though, but one has to be careful with module systems when
        changing the configuration in unsupported ways as we do by changing LMOD_PACKAGE_PATH.)

      * It is not possible to already load `CrayEnv` or `LUMI` without major changes to those
        modules that would also make maintenance more difficult (as code that is now contained
        in `SitePackage.lua` would have to move to those modules).

      * Impact for the current users: minimal, but not negligible. There are three differences
        for the user after logging in:

         1. The module system wil be Lmod instead of Environment Modules. Though all
            modules have the same name, Lmod is stricter in the order in which modules
            are loaded and also prevents some combinations that don't work (e.g., UCX
            mpich with `craype-network-ofi`).

         2. The CPE should now be loaded as intended, i.e., with `cray-dsmml`, `cray-mpich`
            and `cray-libsci` loaded. This is an aspect that I cannot test though before
            the `cray-pe-configuration.sh` file is in the right location. This file
            is read by the `PrgEnbv-*` modules and the path is hardcoded in those modules.

         3. The `init-lumi` module will be loaded and the display of the modules will be a
            little different, not just because of Lmod.

 2. Install the new `cray-pe-configuration.sh` file (and its .csh equivalent), ensure
    that

    ```bash
    export LMOD_PACKAGE_PATH=/appl/lumi/LUMI-SoftwareStack/LMOD ;
    export LMOD_RC=/appl/lumi/LUMI-SoftwareStack/LMOD/lmodrc.lua ;
    export LMOD_ADMIN_FILE=/appl/lumi/LUMI-SoftwareStack/LMOD/admin.list ;
    ```

    is executed before `bash.basrhc.local` is sourced (and do we support csh/tcsh also???),
    and then let `init-lumi` take care of the remainder of the initialisation, i.e.,
    set non-critical LMOD variables that certainly can be changed without risk after
    initialisation and load a version of the LUMI module (or CrayEnv module, LUST can
    change that completely independent of the sysadmins).

      * RISK: This is the way Lmod expects things to be done so the risk is lower than
        for the first option.

      * It is possible to already load one of the LUMI modules from the `init-lumi` module
        to encourage the user to use our environment.

      * Impact on the current users: Everything from the other option, but they will
        now also be confronted with the LUST LUMI environment that really encourages to use
        the programming environment in a different way, and uses version 21.08 as the default
        rather than the 21.05 version which is currently the default. This may also have more
        impact on the running jobs.

We could go for a two-step procedure:

  * Now we implement the first option. This should be very little work for the sysadmins
    and we have the pure Cray environment, though with Lmod, as an immediate fallback
    in case of problems (it is sufficient to remove some code in `init-lumi` so that
    it does nothing), while it remains easy for users to start using our LUST LUMI
    environment. All they need to do is load a module.

  * During the January maintenance interval we switch to the second option that would
    allow us to already put the users in the LUST LUMI environment immediately after
    login.

    As the system will have undergone major changes, all software needs to be checked
    then anyway, and users will have to verify whether their job scripts still work
    anyway, so this is probably not a bad moment for this change.


## Testing to do

  * Check if the default programming environment is correctly loaded.

  * Check if compiling works.

  * Check what happens when launching a job from the default.

  * Check what happens when CrayEnv is loaded

      * There may be some problems as the default versions for Cray and
        CrayEnv are likely different. Force a reload of some modules? This is
        tricky unless we simply load a cpe module?

      * And check what happens in a job script.

        Likely: Modules loaded but with the wrong targets until CrayEnv is reloaded.

  * Start from a clean environment, load LUMI

      * What happens to the PrgEnv? **Currently the wrong version until a cpeGNU/cpeCray/cpeAMD
        module is loaded, improve by loading a cpe module to force a reload?**

      * What is the effect on job scripts?

          * No reload of LUMI: You likely get the environment from the login nodes.

          * With a reload: Right partition for the selected nodes, may suprise you!

  * Try EasyBuild-user

  * Check if EasyBuild-production produces the expected warnings.


