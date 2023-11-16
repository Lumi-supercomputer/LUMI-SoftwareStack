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

mkdir -p "$installroot/modules/easybuild/container"

mkdir -p "$installroot/SW/container"
mkdir -p "$installroot/SW/container/EB"

mkdir -p "$installroot/mgmt/ebrepo_files/container"

for version in 22.08 22.12 23.03
do

	pushd "$installroot/modules/SystemPartition/LUMI/$version/partition"
	create_link "$installroot/LUMI-SoftwareStack/modules/LUMIpartition/21.01.lua" container.lua
	popd

	mkdir -p "$installroot/modules/Infrastructure/LUMI/$version/partition/container/EasyBuild-production"
	pushd "$installroot/modules/Infrastructure/LUMI/$version/partition/container/EasyBuild-production"
	create_link "$installroot/LUMI-SoftwareStack/modules/EasyBuild-config/21.01.lua" LUMI.lua
	cd ..
	mkdir -p EasyBuild-user
	cd EasyBuild-user
	create_link "$installroot/LUMI-SoftwareStack/modules/EasyBuild-config/21.01.lua" LUMI.lua
	cd ..
	mkdir -p EasyBuild-unlock
	cd EasyBuild-unlock
	create_link "$installroot/LUMI-SoftwareStack/modules/EasyBuild-unlock/21.01.lua" LUMI.lua
	cd ..
	create_link "$installroot/modules/easybuild/LUMI/$version/partition/common/EasyBuild" EasyBuild
	popd

done


