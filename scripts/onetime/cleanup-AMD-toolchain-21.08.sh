#! /bin/bash
#
# Script to clean up a toolchain that didn't work due to a missing compiler
#
# The script takes no arguments.
#
# The root of the installation is derived from the place where the script is found.
# The script should be in <installroot>/${repo}/scripts with <installroot> the
# root for the installation.
#

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd "$(dirname $0)"
cd ../..
repo="${PWD##*/}"
cd ..
installroot="$(pwd)"

#
# Warning
#
echo 'The script may produce error messages as "No such file or directory" but they can be safely ignored.'
#
# Clean up the modules
#
cd $installroot/modules/Infrastructure/LUMI/21.08
find . -name cpeAMD -exec /bin/rm -rf '{}' \;

#
# Clean up the ebrepo files
#
cd $installroot/mgmt/ebrepo_files/LUMI-21.08
find . -name cpeAMD -exec /bin/rm -rf '{}' \;

#
# Clean up the dummy software directories
#
cd $installroot/SW/LUMI-21.08
find . -name cpeAMD -exec /bin/rm -rf '{}' \;

#
# Clean up the EasyConfig files in the repository
#
cd $installroot/$repo/easybuild/easyconfigs
find . -name cpeAMD-21.08.eb -exec /bin/rm -f '{}' \;
