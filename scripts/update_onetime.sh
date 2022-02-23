#! /bin/bash
#
# One-time script to update the LUMI installation.
#

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd "$(dirname $0)"
cd ..
repo="${PWD##*/}"
cd ..
installroot="$(pwd)"



mkdir -p "$installdir/modules/easybuild/system"
mkdir -p "$installroot/modules/manual/system"

mkdir -p "$installroot/SW/system"
mkdir -p "$installroot/SW/system/EB"
mkdir -p "$installroot/SW/system/MNL"

mkdir -p "$installroot/mgmt/ebrepo_files/system"

pushd "$installdir/modules/SystemPartition/LUMI/21.08/partition"
ln -s "$installdir/LUMI-SoftwareStack/modules/LUMIpartition/21.01.lua" system.lua
popd

mkdir -p "$installdir/modules/Infrastructure/LUMI/21.08/partition/CrayEnv/EasyBuild-production"
pushd "$installdir/modules/Infrastructure/LUMI/21.08/partition/CrayEnv/EasyBuild-production"
ln -s "$installdir/LUMI-SoftwareStack/modules/EasyBuild-config/21.01.lua" LUMI.lua
cd ..
/bin/rm -rf EasyBuild-CrayEnv
popd

mkdir -p "$installdir/modules/Infrastructure/LUMI/21.08/partition/system/EasyBuild-production"
pushd "$installdir/modules/Infrastructure/LUMI/21.08/partition/system/EasyBuild-production"
ln -s "$installdir/LUMI-SoftwareStack/modules/EasyBuild-config/21.01.lua" LUMI.lua
cd ..
mkdir -p EasyBuild-unlock
cd EasyBuild-unlock
ln -s "$installdir/LUMI-SoftwareStack/modules/EasyBuild-unlock/21.01.lua" LUMI.lua
cd ..
ln -s "$installdir/modules/easybuild/LUMI/21.08/partition/common/EasyBuild"
popd




