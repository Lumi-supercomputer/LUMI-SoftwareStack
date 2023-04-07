#! /bin/bash
#
# Script to clean up some stuff in the system partition after the March 2023
# system update.
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
cd $installroot/modules/easybuild/system/lumi-tools ; /bin/rm -f  23.01.lua 23.02.lua
cd $installroot/modules/easybuild/system/ ;           /bin/rm -rf lumi workspaces
cd $installroot/modules/easybuild/system/lumi-vnc ;   /bin/rm -f  20220715.lua 20221010.lua

#
# Clean up the ebrepo files
#
cd $installroot/mgmt/ebrepo_files/system/lumi-tools ; /bin/rm -f  lumi-tools-23.01.eb lumni-tools-23.02.eb
cd $installroot/mgmt/ebrepo_files/system ;            /bin/rm -rf lumi-workspaces
cd $installroot/mgmt/ebrepo_files/system/lumi-vnc ;   /bin/rm -f  lumi-vnc-20220715.eb lumi-vnc-20221010.eb
  
#
# Clean up the software directories
#
cd $installroot/SW/system/EB/lumi-tools ; /bin/rm -rf 23.01 23.02
cd $installroot/SW/system/EB/ ;           /bin/rm -rf lumi-workspaces
cd $installroot/SW/system/EB/lumi-vnc ;   /bin/rm -rf 20220715 20221010
