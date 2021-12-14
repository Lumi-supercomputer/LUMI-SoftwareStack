#! /bin/bash
#
# This is a script to enable the LUMI software stack avoiding using
# data from the system HPE Cray PE configuration file
# /etc/cray-pe.de/cray-pe-configuration.sh.
#

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd $(dirname $0)
cd ..
repo=${PWD##*/}
cd ..
installroot=$(pwd)

#
# Print the commands that should be executed via eval to initialise
# the LUMI module system from the location based on the location of this
# script.
#
# - Clear LMOD. We will restart it.
#   This is essential as otherwise restore will reset the MODULEPATH that
#   we build here,
#   The problem is that the script is not able to detect if it was called
#   from a shell not running LMOD. It seems that LMOD may be detected
#   somehow even if the parent claims it is running Environment Modules
#   if that parent is on a compute node obtained from an LMOD session.
#   Hence we always re-initialise just to clear immediately again.
echo "source /usr/share/lmod/lmod/init/profile ; "
echo "clearLmod ; "
#echo "unset _LUMI_INIT_FIRST_LOAD ; "

# - Set a number of LMOD environment variables
echo "export LMOD_PACKAGE_PATH=$installroot/$repo/LMOD ; "
echo "export LMOD_RC=$installroot/$repo/LMOD/lmodrc.lua ; "
echo "export LMOD_MODULERCFILE=$installroot/$repo/LMOD/modulerc.lua ; "

# - set the MODULEPATH
echo "export MODULEPATH=/opt/cray/pe/lmod/modulefiles/core:/opt/cray/pe/lmod/modulefiles/craype-targets/default:$installroot/modules/SoftwareStack:$installroot/modules/StyleModifiers:$installroot/modules/init-LUMI-SoftwareStack:/opt/cray/modulefiles:/opt/modulefiles ; "

# - Set the initial list of modules
echo "export LMOD_SYSTEM_DEFAULT_MODULES=craype-x86-rome:craype-network-ofi:perftools-base:xpmem:PrgEnv-cray:init-lumi ; "

# - Initialize LMOD but
echo "source /usr/share/lmod/lmod/init/profile ; "
echo "module --initial_load --no_redirect restore ; "
