#! /bin/bash
#
# One-time script to update the LUMI installation.
#

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd "$(dirname $0)"
cd ../..
repo="${PWD##*/}"
cd ..
installroot="$(pwd)"


###############################################################################
#
# create_link
#
# Links a file but first tests if the target already exists to avoid error messages.
#
# Input arguments:
#   + First input argument: The target of the link
#   + Second and mandatory argument: The name of the link
#
create_link () {

    test -s "$2" || ln -s "$1" "$2"

}


###############################################################################
#
# Actual code
#

mkdir -p "$installroot/modules/easybuild/LUMI/21.08/partition/EAP"
mkdir -p "$installroot/modules/easybuild/LUMI/21.12/partition/EAP"
mkdir -p "$installroot/modules/manual/LUMI/21.08/partition/EAP"
mkdir -p "$installroot/modules/manual/LUMI/21.12/partition/EAP"

mkdir -p "$installroot/SW/LUMI-21.08/EAP/EB"
mkdir -p "$installroot/SW/LUMI-21.08/EAP/MNL"
mkdir -p "$installroot/SW/LUMI-21.08/EAP/SP"
mkdir -p "$installroot/SW/LUMI-21.12/EAP/EB"
mkdir -p "$installroot/SW/LUMI-21.12/EAP/MNL"
mkdir -p "$installroot/SW/LUMI-21.12/EAP/SP"

mkdir -p "$installroot/mgmt/ebrepo_files/LUMI-21.08/LUMI-EAP"
mkdir -p "$installroot/mgmt/ebrepo_files/LUMI-21.12/LUMI-EAP"

pushd "$installroot/modules/SystemPartition/LUMI/21.08/partition"
create_link "$installroot/LUMI-SoftwareStack/modules/LUMIpartition/21.01.lua" EAP.lua
popd
pushd "$installroot/modules/SystemPartition/LUMI/21.12/partition"
create_link "$installroot/LUMI-SoftwareStack/modules/LUMIpartition/21.01.lua" EAP.lua
popd
