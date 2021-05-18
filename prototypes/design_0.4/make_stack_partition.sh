#! /bin/bash

version="0.4"
testroot="$HOME/appltest/design_$version/stack_partition"
sourceroot="$HOME/LUMI-easybuild-prototype/prototypes/design_$version"

workdir=$HOME/Work

eb_bootstrap_version='4.3.4'
eb_version='4.3.4'

PATH=$sourceroot/..:$sourceroot:$sourceroot/scripts:$PATH

if [[ "$(hostname)" =~ ^o[0-9]{3}i[0-9]{3}$ ]]
then
	system="Grenoble"
	echo "Identified the Grenoble test system."
elif [[ "$(hostname)" =~ ^uan0[0-9]$ ]]
then
	system="CSCS"
	echo "Identified the CSCS cluster."
else
	system="Unknown"
	echo "Could not identify the system, quitting."
	exit
fi

case $system in
	Grenoble)
	stacks=( '21.02.dev' '21.03.dev' '21.04' '21.G.02' )
	EBstack='21.G.02'
	;;
	CSCS)
	stacks=( '21.02.dev' '21.03.dev' '21.04' )
    EBstack='21.04'
	;;
esac
partitions=( 'C' 'G' 'D' 'L' )

create_link () {

#  echo "Linking from: $1"
#  echo "Linking to: $2"
#  test -s "$2" && echo "File $2 found."
#  test -s "$2" || echo "File $2 not found."
  test -s "$2" || ln -s "$1" "$2"

}

#
# Make the support directories
#
mkdir -p $testroot
mkdir -p $testroot/github
# Normally $testroot/github would just be our github repoistory, even though some files
# in there are generated from other files. However, to ease editing in the prototype
# and since we're running this on two clusters, we're selectively linking to some
# parts of the GitHub repository.
modsrc=$sourceroot
moddest=$testroot/github
create_link $modsrc/modules $moddest/modules
create_link $modsrc/LMOD    $moddest/LMOD
create_link $modsrc/scripts $moddest/scripts

mkdir -p mkdir -p $testroot/github/easybuild
mkdir -p mkdir -p $testroot/github/easybuild/config

create_link $modsrc/easybuild/easyconfigs $moddest/easybuild/easyconfigs
create_link $modsrc/easybuild/easyblocks  $moddest/easybuild/easyblocks
create_link $modsrc/easybuild/tools       $moddest/easybuild/tools

#
# Create the root modules with the software stacks
#
mkdir -p $testroot/modules
mkdir -p $testroot/modules/generic
mkdir -p $testroot/modules/generic/LUMIstack
mkdir -p $testroot/modules/generic/LUMIpartition
mkdir -p $testroot/modules/SoftwareStack
mkdir -p $testroot/modules/SoftwareStack/LUMI   # For the LUMI/yy.mm module files
mkdir -p $testroot/modules/SystemPartition
mkdir -p $testroot/modules/SystemPartition/LUMI   # For LUMI/yy.mm subdirectories
mkdir -p $testroot/modules/easybuild
mkdir -p $testroot/modules/easybuild/LUMI
mkdir -p $testroot/modules/spack
mkdir -p $testroot/modules/spack/LUMI
mkdir -p $testroot/modules/manual
mkdir -p $testroot/modules/manual/LUMI

mkdir -p $testroot/software

mkdir -p $testroot/mgmt
mkdir -p $testroot/mgmt/ebrepo_files

mkdir -p $testroot/sources
mkdir -p $testroot/sources/easybuild

#
# Make the directories with the software stacks
#
for stack in "${stacks[@]}"
do

  mkdir -p $testroot/modules/SystemPartition/LUMI/$stack
  mkdir -p $testroot/modules/SystemPartition/LUMI/$stack/partition
  mkdir -p $testroot/modules/easybuild/LUMI/$stack
  mkdir -p $testroot/modules/easybuild/LUMI/$stack/partition
  mkdir -p $testroot/modules/spack/LUMI/$stack
  mkdir -p $testroot/modules/spack/LUMI/$stack/partition
  mkdir -p $testroot/modules/manual/LUMI/$stack
  mkdir -p $testroot/modules/manual/LUMI/$stack/partition

  mkdir -p $testroot/software/LUMI-$stack

  mkdir -p $testroot/mgmt/ebrepo_files/LUMI-$stack

  for partition in ${partitions[@]} common
  do

	mkdir -p $testroot/modules/easybuild/LUMI/$stack/partition/$partition
   	mkdir -p $testroot/modules/spack/LUMI/$stack/partition/$partition
   	mkdir -p $testroot/modules/manual/LUMI/$stack/partition/$partition

   	mkdir -p $testroot/software/LUMI-$stack/LUMI-$partition
   	mkdir -p $testroot/software/LUMI-$stack/LUMI-$partition/easybuild
   	mkdir -p $testroot/software/LUMI-$stack/LUMI-$partition/spack
   	mkdir -p $testroot/software/LUMI-$stack/LUMI-$partition/manual

   	mkdir -p $testroot/mgmt/ebrepo_files/LUMI-$stack/LUMI-$partition

  done

done

#
# First populate modules/generic
#
modsrc="$testroot/github/modules/stack_partition"
moddest="$testroot/modules/generic"
create_link $modsrc/LUMIstack/version.lua             $moddest/LUMIstack/version.lua
create_link $modsrc/LUMIpartition/partitionletter.lua $moddest/LUMIpartition/partitionletter.lua
create_link $modsrc/LUMIpartition/modulerc.lua        $moddest/LUMIpartition/modulerc.lua
create_link $modsrc/CrayEnv.lua                       $moddest/CrayEnv.lua

#
# Populate modules/SoftwareStack and modules/LUMIpartition/LUMI-yy.mm
#
modsrc="$testroot/modules/generic"
moddest="$testroot/modules"
for stack in "${stacks[@]}"
do

  # LUMI software stack. The only OS environment variables used are variables that are
  # not supposed to change on the LUMI (but are for now set by the initialisation modules).
  create_link   "$modsrc/LUMIstack/version.lua"             "$moddest/SoftwareStack/LUMI/$stack.lua"


  # Populate the LUMIpartition directory for this version of the LUMI software stack
  create_link   "$modsrc/LUMIpartition/modulerc.lua"        "$moddest/SystemPartition/LUMI/$stack/partition/.modulerc.lua"
  for partition in "${partitions[@]}"
  do
  	create_link "$modsrc/LUMIpartition/partitionletter.lua" "$moddest/SystemPartition/LUMI/$stack/partition/$partition.lua"
  done
  create_link   "$modsrc/LUMIpartition/partitionletter.lua" "$moddest/SystemPartition/LUMI/$stack/partition/common.lua"

done

# Provide the CrayEnv stack. This module does not depend on variables set by modules so
# we can use a link for now.
create_link     "$modsrc/CrayEnv.lua"                       "$moddest/SoftwareStack/CrayEnv.lua"

#
# Link the style modules
#
# We prefer to link the modules one by one to be able to set defaults without having
# hidden files in our repository.
#
mkdir -p $testroot/modules/StyleModifiers
mkdir -p $testroot/modules/StyleModifiers/ModuleLabel
mkdir -p $testroot/modules/StyleModifiers/ModuleColour
mkdir -p $testroot/modules/StyleModifiers/ModuleExtensions
modsrc=$testroot/github/modules/StyleModifiers
moddest=$testroot/modules/StyleModifiers
create_link "$modsrc/ModuleLabel/label.lua"         "$moddest/ModuleLabel/label.lua"
create_link "$modsrc/ModuleLabel/system.lua"        "$moddest/ModuleLabel/system.lua"
create_link "$modsrc/ModuleLabel/modulerc.lua"      "$moddest/ModuleLabel/.modulerc.lua"
create_link "$modsrc/ModuleColour/on.lua"           "$moddest/ModuleColour/on.lua"
create_link "$modsrc/ModuleColour/off.lua"          "$moddest/ModuleColour/off.lua"
create_link "$modsrc/ModuleColour/modulerc.lua"     "$moddest/ModuleColour/.modulerc.lua"
create_link "$modsrc/ModuleExtensions/show.lua"     "$moddest/ModuleExtensions/show.lua"
create_link "$modsrc/ModuleExtensions/hide.lua"     "$moddest/ModuleExtensions/hide.lua"
create_link "$modsrc/ModuleExtensions/modulerc.lua" "$moddest/ModuleExtensions/.modulerc.lua"

#
# Create a modulerc file in the SoftwareStack subdirectory to mark the default software stack.
#
cat >$testroot/modules/SoftwareStack/LUMI/.modulerc.lua <<EOF
module_version( "LUMI/$EBstack", "default" )
EOF

###############################################################################
#
# Create dummy modules for now
#

#
# Now build some demo modules
#
# - First modules that mimic EasyBuild
#
# Both functions take two arguments: The software stack version and LUMI partition letter (in that order)
#
# - First modules that mimic EasyBuild
#
function software_root () {
    echo "$testroot/software/LUMI-$1/LUMI-$2/easybuild"
}

function module_root () {
    echo "$testroot/modules/easybuild/LUMI/$1/partition/$2"
}

stack=${stacks[0]}
empty_module_EB.sh GROMACS 20.3 "cpeGNU-$stack" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_EB.sh GROMACS 20.3 "cpeGNU-$stack" "GPU" $(software_root $stack G) $(module_root $stack G)
empty_module_EB.sh GROMACS 21.1 "cpeGNU-$stack" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_EB.sh GROMACS 21.1 "cpeGNU-$stack" "GPU" $(software_root $stack G) $(module_root $stack G)

empty_module_EB.sh CMake 3.19.8 "" "" $(software_root $stack common) $(module_root $stack common)

stack=${stacks[1]}
empty_module_EB.sh GROMACS 21.1 "cpeGNU-$stack" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_EB.sh GROMACS 21.1 "cpeGNU-$stack" "GPU" $(software_root $stack G) $(module_root $stack G)
empty_module_EB.sh GROMACS 21.2 "cpeGNU-$stack" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_EB.sh GROMACS 21.2 "cpeGNU-$stack" "GPU" $(software_root $stack G) $(module_root $stack G)

empty_module_EB.sh gnuplot 5.4.0 "cpeGNU-$stack" "" $(software_root $stack L) $(module_root $stack L)
empty_module_EB.sh gnuplot 5.4.0 "cpeGNU-$stack" "" $(software_root $stack D) $(module_root $stack D)

empty_module_EB.sh GSL 2.5 "cpeGNU-$stack" "" $(software_root $stack C) $(module_root $stack C)
empty_module_EB.sh GSL 2.5 "cpeCCE-$stack" "" $(software_root $stack C) $(module_root $stack C)
empty_module_EB.sh GSL 2.5 "cpeGNU-$stack" "" $(software_root $stack G) $(module_root $stack G)
empty_module_EB.sh GSL 2.5 "cpeCCE-$stack" "" $(software_root $stack G) $(module_root $stack G)
empty_module_EB.sh GSL 2.5 "cpeGNU-$stack" "" $(software_root $stack D) $(module_root $stack D)
empty_module_EB.sh GSL 2.5 "cpeCCE-$stack" "" $(software_root $stack D) $(module_root $stack D)
empty_module_EB.sh GSL 2.5 "cpeGNU-$stack" "" $(software_root $stack L) $(module_root $stack L)
empty_module_EB.sh GSL 2.5 "cpeCCE-$stack" "" $(software_root $stack L) $(module_root $stack L)

empty_module_EB.sh CMake 3.20.2 "" "" $(software_root $stack common) $(module_root $stack common)

#
# - Next modules that mimic Spack
#
function software_root () {
    echo "$testroot/software/LUMI-$1/LUMI-$2/spack"
}

function module_root () {
    echo "$testroot/modules/spack/LUMI/$1/partition/$2"
}

stack=${stacks[0]}
empty_module_Spack.sh lammps 3Mar2020 "" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_Spack.sh lammps 3Mar2020 "" "GPU" $(software_root $stack G) $(module_root $stack G)

stack=${stacks[1]}
empty_module_Spack.sh cp2k   7.1      "" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_Spack.sh cp2k   7.1      "" "GPU" $(software_root $stack G) $(module_root $stack G)

#
# - Next modules that mimic manual installs
#
function software_root () {
    echo "$testroot/software/LUMI-$1/LUMI-$2/manual"
}

function module_root () {
    echo "$testroot/modules/manual/LUMI/$1/partition/$2"
}

stack=${stacks[0]}
empty_module_MN.sh Gaussian  g16_a03-avx2 $(software_root $stack C) $(module_root $stack C)

stack=${stacks[1]}
empty_module_MN.sh Gaussian  g16_c01-avx2 $(software_root $stack C) $(module_root $stack C)

#
# - Install some dummy Python3 modules to demonstrate the use of extensions in LMOD
#
function software_root () {
    echo "$testroot/software/LUMI-$1/LUMI-$2/easybuild"
}

function module_root () {
    echo "$testroot/modules/easybuild/LUMI/$1/partition/$2"
}

stack=${stacks[0]}
Python3_module_EB.sh "3.8.2" "cpeCCE-$stack" "1.19.3" "1.5.4" $(software_root $stack C) $(module_root $stack C)
Python3_module_EB.sh "3.8.2" "cpeCCE-$stack" "1.19.3" "1.5.4" $(software_root $stack G) $(module_root $stack G)
Python3_module_EB.sh "3.8.2" "cpeCCE-$stack" "1.19.3" "1.5.4" $(software_root $stack D) $(module_root $stack D)
Python3_module_EB.sh "3.8.2" "cpeCCE-$stack" "1.19.3" "1.5.4" $(software_root $stack L) $(module_root $stack L)

stack=${stacks[1]}
Python3_module_EB.sh "3.8.5" "cpeCCE-$stack" "1.19.3" "1.5.4" $(software_root $stack C) $(module_root $stack C)
Python3_module_EB.sh "3.8.5" "cpeCCE-$stack" "1.19.3" "1.5.4" $(software_root $stack G) $(module_root $stack G)
Python3_module_EB.sh "3.8.5" "cpeCCE-$stack" "1.19.3" "1.5.4" $(software_root $stack D) $(module_root $stack D)
Python3_module_EB.sh "3.8.5" "cpeCCE-$stack" "1.19.3" "1.5.4" $(software_root $stack L) $(module_root $stack L)
Python3_module_EB.sh "3.9.4" "cpeCCE-$stack" "1.20.2" "1.6.3" $(software_root $stack C) $(module_root $stack C)
Python3_module_EB.sh "3.9.4" "cpeCCE-$stack" "1.20.2" "1.6.3" $(software_root $stack G) $(module_root $stack G)
Python3_module_EB.sh "3.9.4" "cpeCCE-$stack" "1.20.2" "1.6.3" $(software_root $stack D) $(module_root $stack D)
Python3_module_EB.sh "3.9.4" "cpeCCE-$stack" "1.20.2" "1.6.3" $(software_root $stack L) $(module_root $stack L)


###############################################################################
#
# EasyBuild preparation
#
# - External module file
#
make_CPE_defs.py $testroot/github/easybuild/config $EBstack
#
# - EasyBuild config file
#
create_link "$sourceroot/easybuild/config/easybuild-production.cfg" "$testroot/github/easybuild/config/easybuild-production.cfg"


###############################################################################
#
# EasyBuild bootstrapping
#
# A slight compilication is that the system Python of Eiger doesn't have pip
# installed.
#
# Test: As we use our own EasyConfig file for EasyBuild, bootstrapping may work
# using just the EasyBuild framework and EasyBlocks?
#
# - Link the EasyBuild-production and EasyBuild-user modules in the module structure
#
modsrc="$testroot/github/modules/stack_partition"
moddest="$testroot/modules/generic"
mkdir -p $moddest/EasyBuild-production
mkdir -p $moddest/EasyBuild-user
create_link $modsrc/EasyBuild-production/$version-prod.lua $moddest/EasyBuild-production/default.lua
create_link $modsrc/EasyBuild-user/$version-user.lua       $moddest/EasyBuild-user/default.lua

stack=$EBstack
modsrc="$testroot/modules/generic"
function module_root () {
    echo "$testroot/modules/easybuild/LUMI/$1/partition/$2"
}
for partition in ${partitions[@]} common
do
	mkdir -p $(module_root $stack $partition)/EasyBuild-production
	mkdir -p $(module_root $stack $partition)/EasyBuild-user

    create_link $modsrc/EasyBuild-production/default.lua $(module_root $stack $partition)/EasyBuild-production/$partition.lua
    create_link $modsrc/EasyBuild-user/default.lua       $(module_root $stack $partition)/EasyBuild-user/$partition.lua
done

#
# - Download EasyBuild from PyPi (only framework and easyblocks are needed for bootstrapping)
#
mkdir -p $testroot/sources/easybuild/e
mkdir -p $testroot/sources/easybuild/e/EasyBuild
EB_tardir=$testroot/sources/easybuild/e/EasyBuild
pushd $EB_tardir

EBF_file="easybuild-framework-${eb_bootstrap_version}.tar.gz"
EBF_url="https://pypi.python.org/packages/source/e/easybuild-framework"
[[ -f $EBF_file ]] || curl -L -O $EBF_url/$EBF_file

EBB_file="easybuild-easyblocks-${eb_bootstrap_version}.tar.gz"
EBB_url="https://pypi.python.org/packages/source/e/easybuild-easyblocks"
[[ -f $EBB_file ]] || curl -L -O $EBB_url/$EBB_file

#EBC_file="easybuild-easyconfigs-${eb_bootstrap_version}.tar.gz"
#EBC_url="https://pypi.python.org/packages/source/e/easybuild-easyconfigs"
#[[ -f $EBC_file ]] || curl -L -O $EBC_url/$EBC_file

popd

#
# - Now do a temporary install of the framework and EasyBlocks
#
mkdir -p $workdir
pushd $workdir

tar -xf $EB_tardir/$EBF_file
tar -xf $EB_tardir/$EBB_file

mkdir -p $workdir/easybuild

pushd easybuild-framework-$eb_bootstrap_version
python3 setup.py install --prefix=$workdir/easybuild
cd ../easybuild-easyblocks-$eb_bootstrap_version
python3 setup.py install --prefix=$workdir/easybuild
popd

#
# - Clean up files that are not needed anymore
#
rm -rf easybuild-framework-$eb_bootstrap_version
rm -rf easybuild-easyblocks-$eb_bootstrap_version

#
# - Activate that install
#
export EB_PYTHON='python3'
export PYTHONPATH=$(find $workdir/easybuild -name site-packages)

#
# - Install EasyBuild in the common directory of the $EBstack software stack
#
module --force purge
export MODULEPATH=$testroot/modules/SoftwareStack:$testroot/modules/StyleModifiers
export LMOD_MODULE_ROOT=$testroot
export LMOD_MODULE_ROOT=$testroot
export LMOD_PACKAGE_PATH=$testroot/github/LMOD
export LMOD_RC=$testroot/github/LMOD/lmodrc.lua
export LMOD_ADMIN_FILE=$testroot/github/LMOD/admin.list
export LMOD_AVAIL_STYLE=label:system
export LUMI_PARTITION='common'
module load LUMI/$EBstack
module load partition/common
module load EasyBuild-production/common
$workdir/easybuild/bin/eb --show-config
$workdir/easybuild/bin/eb $testroot/github/easybuild/easyconfigs/e/EasyBuild/EasyBuild-${eb_version}.eb

#
# - Clean up
#
rm -rf easybuild
unset PYTHONPATH

popd


###############################################################################
#
# Instructions for the MODULEPATH etc
#
cat <<EOF
To enable prototype stack_partition version $version, make sure LMOD is the
active module system and then run
eval \$(\$HOME/LUMI-easybuild-prototype/prototypes/design_$version/enable_stack_partition.sh)
EOF
