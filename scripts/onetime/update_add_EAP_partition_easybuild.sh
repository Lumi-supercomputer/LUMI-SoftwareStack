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

#mkdir -p "$installroot/modules/easybuild/LUMI/21.08/partition/EAP"
mkdir -p "$installroot/modules/easybuild/LUMI/21.12/partition/EAP"
#mkdir -p "$installroot/modules/manual/LUMI/21.08/partition/EAP"
mkdir -p "$installroot/modules/manual/LUMI/21.12/partition/EAP"

#mkdir -p "$installroot/SW/LUMI-21.08/EAP/EB"
#mkdir -p "$installroot/SW/LUMI-21.08/EAP/MNL"
#mkdir -p "$installroot/SW/LUMI-21.08/EAP/SP"
mkdir -p "$installroot/SW/LUMI-21.12/EAP/EB"
mkdir -p "$installroot/SW/LUMI-21.12/EAP/MNL"
mkdir -p "$installroot/SW/LUMI-21.12/EAP/SP"

#mkdir -p "$installroot/mgmt/ebrepo_files/LUMI-21.08/LUMI-EAP"
mkdir -p "$installroot/mgmt/ebrepo_files/LUMI-21.12/LUMI-EAP"

#pushd "$installroot/modules/SystemPartition/LUMI/21.08/partition"
create_link "$installroot/LUMI-SoftwareStack/modules/LUMIpartition/21.01.lua" EAP.lua
popd
pushd "$installroot/modules/SystemPartition/LUMI/21.12/partition"
create_link "$installroot/LUMI-SoftwareStack/modules/LUMIpartition/21.01.lua" EAP.lua
popd

mkdir -p "$installroot/modules/Infrastructure/LUMI/21.08/partition/EAP/EasyBuild-production"
pushd    "$installroot/modules/Infrastructure/LUMI/21.08/partition/EAP/EasyBuild-production"
create_link "$installroot/LUMI-SoftwareStack/modules/EasyBuild-config/21.01.lua" LUMI.lua
cd ..
mkdir -p EasyBuild-unlock
cd EasyBuild-unlock
create_link "$installroot/LUMI-SoftwareStack/modules/EasyBuild-unlock/21.01.lua" LUMI.lua
mkdir -p "$installroot/modules/Infrastructure/LUMI/21.08/partition/EAP/EasyBuild-infrastructure"
cd       "$installroot/modules/Infrastructure/LUMI/21.08/partition/EAP/EasyBuild-infrastructure"
create_link "$installroot/LUMI-SoftwareStack/modules/EasyBuild-config/21.01.lua" LUMI.lua
mkdir -p "$installroot/modules/Infrastructure/LUMI/21.08/partition/EAP/EasyBuild-user"
cd       "$installroot/modules/Infrastructure/LUMI/21.08/partition/EAP/EasyBuild-user"
create_link "$installroot/LUMI-SoftwareStack/modules/EasyBuild-config/21.01.lua" LUMI.lua
popd

mkdir -p "$installroot/modules/Infrastructure/LUMI/21.12/partition/EAP/EasyBuild-production"
pushd    "$installroot/modules/Infrastructure/LUMI/21.12/partition/EAP/EasyBuild-production"
create_link "$installroot/LUMI-SoftwareStack/modules/EasyBuild-config/21.01.lua" LUMI.lua
cd ..
mkdir -p EasyBuild-unlock
cd EasyBuild-unlock
create_link "$installroot/LUMI-SoftwareStack/modules/EasyBuild-unlock/21.01.lua" LUMI.lua
mkdir -p "$installroot/modules/Infrastructure/LUMI/21.12/partition/EAP/EasyBuild-infrastructure"
cd       "$installroot/modules/Infrastructure/LUMI/21.12/partition/EAP/EasyBuild-infrastructure"
create_link "$installroot/LUMI-SoftwareStack/modules/EasyBuild-config/21.01.lua" LUMI.lua
mkdir -p "$installroot/modules/Infrastructure/LUMI/21.12/partition/EAP/EasyBuild-user"
cd       "$installroot/modules/Infrastructure/LUMI/21.12/partition/EAP/EasyBuild-user"
create_link "$installroot/LUMI-SoftwareStack/modules/EasyBuild-config/21.01.lua" LUMI.lua
popd

exit

echo -e "\n## Initialising the main toolchains...\n"

pushd $installroot/$repo/easybuild/easyconfigs/c

for CPEversion in 21.12
do

    module load LUMI/$CPEversion partition/EAP
    module load EasyBuild-unlock/LUMI
    module load EasyBuild-infrastructure/LUMI
    
    #IFS=':'
    for cpe in cpeGNU cpeCray
    do
    
        echo "Installing toolchain $cpe/$CPEversion for partition EAP (if not present already)."
    
        # Install the toolchain module if it does not yet exist.
        module avail $cpe/$CPEversion |& grep -q "$cpe/$CPEversion"
        if [[ $? != 0 ]]
        then
            echo "Installing toolchain $cpe/$CPEversion for partition EAP."
            eb "$cpe/$cpe-$CPEversion.eb" -f || die "Failed to install $cpe/$CPEversion for partition EAP."
        fi
    
    done
    #unset IFS

done

popd


