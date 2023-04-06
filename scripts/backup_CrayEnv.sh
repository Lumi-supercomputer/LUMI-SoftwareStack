#! /bin/bash
#
# Script to makea backup of CrayEnv
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
# Prepare the archive.
#

mkdir -p "$installroot/archive"
tar_file="$installroot/archive/CrayEnv-$(date -u +%Y%m%d).tar"
cd "$installroot" # Should be in this directory already but you never know...

################################################################################
#
# Buid the archive
#

echo "Building the archive..."
tar -cf $tar_file modules/easybuild/CrayEnv mgmt/ebrepo_files/CrayEnv SW/CrayEnv

################################################################################
#
# Compress the archive
#

echo "Compressing the archive..."
gzip -9 $tar_file
