#! /bin/bash
#
# One-time script to update the LUMI installation.
#
# It turns out the fix is rather easy. The sanity check in EasyBuild does not fail so
# presumably it does not try to load the module. Which means that we only have to edit
# the module files to insert some code.
#

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd "$(dirname $0)"
cd ../..
repo="${PWD##*/}"
cd ..
installroot="$(pwd)"

stack_version='21.12'


###############################################################################
#
# Edit the cpeAOCC/21.12 module files
#

cd $installroot/modules/Infrastructure/LUMI/$stack_version/partition

for file in $(find . -name cpeAOCC)
do

	sed -z -i.bak -e 's|\(load("aocc/3.1.0")\).end|\1\nend\n\npushenv("CRAY_LMOD_COMPILER",  "aocc/3.0")\n-- Force rebuilding of MODULEPATH by loading craype-network-ofi as reloading aocc\n-- would reintroduce the wrong value of the environment variable.\nif mode() == "load" then load("craype-network-ofi") end|g' $file/$stack_version.lua

done
