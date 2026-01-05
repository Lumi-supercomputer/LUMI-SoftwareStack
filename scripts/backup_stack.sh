#! /bin/bash
#
# Script to make a backup of a LUMI stack
#


# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd $(dirname $0)
cd ..
repo=${PWD##*/}
cd ..
installroot=$(pwd)


################################################################################
#
# Version of the stack to backup.
#

if [ "$#" -ne 1 ]
then
    echo "This script expects 1 and only 1 command line argument: The version of the stack to create a backup for."
    exit 1
fi

stack_version="$1"

################################################################################
#
# Prepare the archive.
#

mkdir -p "$installroot/archive"
tar_file="$installroot/archive/LUMI-${stack_version}-$(date -u +%Y%m%d).tar"
cd "$installroot" # Should be in this directory already but you never know...

################################################################################
#
# Buid the archive
#

echo "Building the archive..."
tar -cf $tar_file \
    modules/Infraststructure/LUMI/${stack_version} \
    modules/easybuild/LUMI/${stack_version} \
    mgmt/ebfiles_repo/LUMI-${stack_version} \
    mgmt/LMOD/ModuleRC/LUMIstack_${stack_version}_modulerc.lua \
    mgmt/LMOD/VisibilityHookData/CPEmodules_${stack_version}.lua \
    SW/LUMI-${stack_version}


################################################################################
#
# Compress the archive
#

echo "Compressing the archive..."
gzip -9 $tar_file
