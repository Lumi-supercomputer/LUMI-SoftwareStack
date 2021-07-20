#! /bin/bash

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
echo "module --force purge ; "
echo "export MODULEPATH=$installroot/modules/SoftwareStack:$installroot/modules/StyleModifiers ; "
#echo "export LMOD_MODULE_ROOT=$installroot ; "
echo "export LMOD_PACKAGE_PATH=$installroot/$repo/LMOD ; "
echo "export LMOD_RC=$installroot/$repo/LMOD/lmodrc.lua ; "
echo "export LMOD_MODULERCFILE=$installroot/$repo/LMOD/modulerc.lua; "
echo "export LMOD_ADMIN_FILE=$installroot/$repo/LMOD/admin.list ; "
echo "export LMOD_AVAIL_STYLE='<label>:PEhierarchy:system' ; "
