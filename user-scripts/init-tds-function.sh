# Suggestion: add
# [ -f /project/project_462000008/LUMI/LUMI-SoftwareStack/user-scripts/init-tds-function.sh ] && source /project/project_462000008/LUMI/LUMI-SoftwareStack/user-scripts/init-tds-function.sh
# to .bashrc on the TDS and then you can initialise the test software installation
# for the TDS with `init-tds`
#
function init-tds { # Re-)initialize the shared software installation on the TDS.

    ###################################################################
    #
    # First part: Ensure our initialisation variables are set in case
    # init-lumi would be configured to preload an environment,
    #

    # Place of the installation
    # installroot="$HOME/LUMI"
    local installroot="/project/project_462000008/LUMI"

    # Our matching LUMI-user
    export EBU_USER_PREFIX="/project/project_462000008/$USER/LUMI-user"
    mkdir -p "$EBU_USER_PREFIX"

    # Use the test container repository
    export LUMI_CONTAINER_REPOSITORY_ROOT='//project/project_462000008/LUMI/appl-local-containers'

    # Force partition L as the partition detection code will give wrong 
    # results on the TDS anyway.
    export LUMI_OVERWRITE_PARTITION='L'

    # LMOD to use
    local installroot_lmod="/opt/cray/pe/lmod/lmod"


    ###################################################################
    #
    # Second part: LMOD initialisation
    #

    # Clear LMOD. We will restart it.
    # As it is a function we use eval.
    eval 'clearLmod'
    unset LUMI_INIT_FIRST_LOAD

    # Clear the lmod cache as we may be switching between versions of Lmod.
    [ -d $HOME/.lmod.d/.cache ] && /bin/rm -rf $HOME/.lmod.d/.cache  # System Lmod 8.3.1
    [ -d $HOME/.cache/lmod ]    && /bin/rm -rf $HOME/.cache/lmod     # Lmod 8.7.x

    # Resource the program environment initialisation
    # source /appl/lumi/LUMI-SoftwareStack/Setup/cray-pe-configuration.sh
    source /etc/cray-pe.d/cray-pe-configuration.sh
    # As mpaths is not set on the TDS:
    mpaths="/appl/lumi/modules/SoftwareStack /appl/lumi/modules/StyleModifiers /appl/lumi/modules/init-LUMI-SoftwareStack"

    # Correct the path in some variables read from the system file.
    local sysroot='/appl/lumi'
    mpaths="${mpaths//$sysroot/$installroot}"
    export LMOD_PACKAGE_PATH="$installroot/LUMI-SoftwareStack/LMOD"
    export LMOD_RC="$installroot/LUMI-SoftwareStack/LMOD/lmodrc.lua"
    export LMOD_ADMIN_FILE="$installroot/LUMI-SoftwareStack/LMOD/admin.list"

    # Initialise LMOD
    source ${installroot_lmod}/init/profile

    # Build MODULEPATH
    mod_paths="/opt/cray/pe/lmod/modulefiles/core
               /opt/cray/pe/lmod/modulefiles/craype-targets/default
               $mpaths
               /opt/cray/modulefiles"
    MODULEPATH=''
    for p in $(echo $mod_paths) ; do
        if [ -d $p ] ; then
            MODULEPATH=$MODULEPATH:$p
        fi
    done
    export MODULEPATH=${MODULEPATH/:/} # Export and remove the leading :.

    # Build LMOD_SYSTEM_DEFAULT_MODULES
    LMOD_SYSTEM_DEFAULT_MODULES=$(echo ${init_module_list:-PrgEnv-$default_prgenv} | sed "s_  *_:_g")
    # Need to add init-lumi on the TDS as this is not done by the system init_module_list.
    export LMOD_SYSTEM_DEFAULT_MODULES=$LMOD_SYSTEM_DEFAULT_MODULES:init-lumi
    # Need eval on the next line as it is a shell function.
    eval "module --initial_load --no_redirect restore"


    ###################################################################
    #
    # Third part: Personal finishing touches
    #

    # Set some aliases
    alias cdesr="cd    $installroot"
    alias pdesr="pushd $installroot"
    alias cdeur='cd    $EBU_USER_PREFIX'
    alias pdeur='pushd $EBU_USER_PREFIX'
    alias cdes="cd     $installroot/LUMI-SoftwareStack/easybuild/easyconfigs"
    alias pdes="pushd  $installroot/LUMI-SoftwareStack/easybuild/easyconfigs"
    alias cdec="cd     $installroot/LUMI-EasyBuild-contrib/easybuild/easyconfigs"
    alias pdec="pushd  $installroot/LUMI-EasyBuild-contrib/easybuild/easyconfigs"
    alias cdecc="cd    $LUMI_CONTAINER_REPOSITORY_ROOT/LUMI-EasyBuild-containers/easybuild/easyconfigs"
    alias pdecc="pushd $LUMI_CONTAINER_REPOSITORY_ROOT/LUMI-EasyBuild-containers/easybuild/easyconfigs"
    alias cdeu='cd     $EBU_USER_PREFIX/UserRepo/easybuild/easyconfigs'
    alias pdeu='pushd  $EBU_USER_PREFIX/UserRepo/easybuild/easyconfigs'
    alias upgrade-tc="$installroot/LUMI-SoftwareStack/tools/upgrade-tc.py"
    alias upgrade-locals="$installroot/LUMI-SoftwareStack/tools/upgrade-locals.lua"
    echo -e "\nAliases introduced by this command:\n" \
    "cdesr/pdesr    : system install root     : $installroot\n" \
    "cdeur/pdeur    : user install root       : $EBU_USER_PREFIX\n" \
    "cdes/pdes      : system EasyConfigs      : $installroot/LUMI-SoftwareStack/easybuild/easyconfigs\n" \
    "cdec/pdec      : contributed EasyConfigs : $installroot/LUMI-EasyBuild-contrib/easybuild/easyconfigs\n" \
    "cdecc/pdecc    : container EasyConfigs   : $LUMI_CONTAINER_REPOSITORY_ROOT/LUMI-EasyBuild-containers/easybuild/easyconfigs\n" \
    "cdeu/pdeu      : user EasyConfigs        : $EBU_USER_PREFIX/UserRepo/easybuild/easyconfig\n" \
    "upgrade-tc     : CSCS script to upgrade a toolchain in an EasyConfig\n" \
    "upgrade-locals : script to upgrade the local_*_version lines in an EasyConfig\n\n" \
    "Lmod version: $(eval 'module --version' |& grep Version | sed -e 's|.*Version *\(8.[[:digit:]]*.[[:digit:]]*\).*|\1|')\n"

}
declare -fx init-lumi-tds
