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
