#! /bin/bash

version="0.4"
testroot="$HOME/appltest/design_$version"
sourceroot="$HOME/LUMI-easybuild-prototype/prototypes/design_$version"

workdir=$HOME/Work

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

declare -A EB_version
case $system in
    Grenoble)
        stacks=( '21.02.dev' '21.03.dev' '21.04' '21.G.02.dev' '21.G.04' )
        EB_stacks=( '21.G.02.dev' '21.G.04' )
        EB_version['21.G.02.dev']='4.3.4'
        EB_version['21.G.04']='4.4.0'
        default_stack='21.G.04'
    ;;
	CSCS)
        stacks=( '21.02.dev' '21.03.dev' '21.04' )
        EB_stacks=( '21.04' )
        EB_version['21.04']='4.4.0'
        default_stack='21.04'
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
mkdir -p $testroot/SystemRepo
# Normally $testroot/SystemRepo would just be our github repository, even though some files
# in there are generated from other files. However, to ease editing in the prototype
# and since we're running this on two clusters, we're selectively linking to some
# parts of the GitHub repository.
modsrc=$sourceroot
moddest=$testroot/SystemRepo
create_link $modsrc/modules $moddest/modules
create_link $modsrc/LMOD    $moddest/LMOD
create_link $modsrc/scripts $moddest/scripts
create_link $modsrc/CrayPE  $moddest/CrayPE

mkdir -p mkdir -p $testroot/SystemRepo/easybuild
mkdir -p mkdir -p $testroot/SystemRepo/easybuild/config

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
mkdir -p $testroot/modules/Infrastructure
mkdir -p $testroot/modules/Infrastructure/LUMI

mkdir -p $testroot/SW

mkdir -p $testroot/mgmt
mkdir -p $testroot/mgmt/ebrepo_files

mkdir -p $testroot/sources
mkdir -p $testroot/sources/easybuild

#
# Add missing modules (if any)
#
if [ $system == "Grenoble" ]
then
	create_link $testroot/SystemRepo/modules/missing/$system $testroot/modules/missing
fi

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
  mkdir -p $testroot/modules/Infrastructure/LUMI/$stack
  mkdir -p $testroot/modules/Infrastructure/LUMI/$stack/partition

  mkdir -p $testroot/SW/LUMI-$stack

  mkdir -p $testroot/mgmt/ebrepo_files/LUMI-$stack

  for partition in ${partitions[@]} common
  do

	mkdir -p $testroot/modules/easybuild/LUMI/$stack/partition/$partition
   	mkdir -p $testroot/modules/spack/LUMI/$stack/partition/$partition
   	mkdir -p $testroot/modules/manual/LUMI/$stack/partition/$partition
   	mkdir -p $testroot/modules/Infrastructure/LUMI/$stack/partition/$partition

   	mkdir -p $testroot/SW/LUMI-$stack/$partition
   	mkdir -p $testroot/SW/LUMI-$stack/$partition/EB
   	mkdir -p $testroot/SW/LUMI-$stack/$partition/SP
   	mkdir -p $testroot/SW/LUMI-$stack/$partition/MNL

   	mkdir -p $testroot/mgmt/ebrepo_files/LUMI-$stack/LUMI-$partition

  done

done

#
# First populate modules/generic
#
modsrc="$testroot/SystemRepo/modules"
moddest="$testroot/modules/generic"
create_link $modsrc/LUMIstack/version.lua             $moddest/LUMIstack/version.lua
create_link $modsrc/LUMIpartition/partitionletter.lua $moddest/LUMIpartition/partitionletter.lua
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
# We simply link the directory. The defaults are set in LMOD/modulerc.lua
#
create_link $testroot/SystemRepo/modules/StyleModifiers $testroot/modules/StyleModifiers

#
# Create a modulerc file in the SoftwareStack subdirectory to mark the default software stack.
#
cat >$testroot/modules/SoftwareStack/LUMI/.modulerc.lua <<EOF
module_version( "LUMI/$default_stack", "default" )
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
    echo "$testroot/SW/LUMI-$1/$2/EB"
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
    echo "$testroot/SW/LUMI-$1/$2/SP"
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
    echo "$testroot/SW/LUMI-$1/$2/MNL"
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
    echo "$testroot/SW/LUMI-$1/$2/EB"
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
# - External module files
#
for stack in "${EB_stacks[@]}"
do
	make_EB_external_modules.py $testroot/SystemRepo/CrayPE $testroot/SystemRepo/easybuild/config ${stack%.dev}
done
#
# - EasyBuild config file
#
create_link "$sourceroot/easybuild/config/easybuild-production.cfg" "$testroot/SystemRepo/easybuild/config/easybuild-production.cfg"


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
modsrc="$testroot/SystemRepo/modules"
moddest="$testroot/modules/generic"
mkdir -p $moddest/EasyBuild-config
create_link $modsrc/EasyBuild-config/$version.lua $moddest/EasyBuild-config/default.lua

modsrc="$testroot/modules/generic"
function module_root () {
    echo "$testroot/modules/Infrastructure/LUMI/$1/partition/$2"
}
for stack in "${EB_stacks[@]}"
do
    for partition in ${partitions[@]} common
    do
        mkdir -p $(module_root $stack $partition)/EasyBuild-production
        mkdir -p $(module_root $stack $partition)/EasyBuild-infrastructure
        mkdir -p $(module_root $stack $partition)/EasyBuild-user

        create_link $modsrc/EasyBuild-config/default.lua $(module_root $stack $partition)/EasyBuild-production/LUMI.lua
        create_link $modsrc/EasyBuild-config/default.lua $(module_root $stack $partition)/EasyBuild-infrastructure/LUMI.lua
        create_link $modsrc/EasyBuild-config/default.lua $(module_root $stack $partition)/EasyBuild-user/LUMI.lua
    done
done

#
# Function to install EasyBuild
#
# Arguments:
#   * First argument:  The testroot directory
#   * Second argument: Name of the LUMI stack
#   * Third argument:  Version of EasyBuild
#   * Fourth argument: Work directory
#

function install_EasyBuild() {

	testroot="$1"
	EBstack="$2"
	EBversion="$3"
	workdir="$4"

	#EBchecksums='--ignore-checksums'

    #
    # - Download EasyBuild from PyPi (only framework and easyblocks are needed for bootstrapping)
    #   We'll download them to a location that we don't clear when clearing the prototype to
    #   ensure that we don't need to reload them every time we rebuild the prototype.
    #
    mkdir -p $testroot/../sources
    pushd $testroot/../sources

    EBF_file="easybuild-framework-${EBversion}.tar.gz"
    EBF_url="https://pypi.python.org/packages/source/e/easybuild-framework"
    [[ -f $EBF_file ]] || curl -L -O $EBF_url/$EBF_file

    EBB_file="easybuild-easyblocks-${EBversion}.tar.gz"
    EBB_url="https://pypi.python.org/packages/source/e/easybuild-easyblocks"
    [[ -f $EBB_file ]] || curl -L -O $EBB_url/$EBB_file

    EBC_file="easybuild-easyconfigs-${EBversion}.tar.gz"
    EBC_url="https://pypi.python.org/packages/source/e/easybuild-easyconfigs"
    [[ -f $EBC_file ]] || curl -L -O $EBC_url/$EBC_file

    popd

    mkdir -p $testroot/sources/easybuild/e
    mkdir -p $testroot/sources/easybuild/e/EasyBuild
    EB_tardir=$testroot/sources/easybuild/e/EasyBuild
    pushd $EB_tardir

    [[ -f $EBF_file ]] || cp $testroot/../sources/$EBF_file .
    [[ -f $EBB_file ]] || cp $testroot/../sources/$EBB_file .
    [[ -f $EBC_file ]] || cp $testroot/../sources/$EBC_file .

    popd

    #
    # - Now do a temporary install of the framework and EasyBlocks
    #
    mkdir -p $workdir
    pushd $workdir

    tar -xf $EB_tardir/$EBF_file
    tar -xf $EB_tardir/$EBB_file

    mkdir -p $workdir/easybuild

    pushd easybuild-framework-$EBversion
    python3 setup.py install --prefix=$workdir/easybuild
    cd ../easybuild-easyblocks-$EBversion
    python3 setup.py install --prefix=$workdir/easybuild
    popd

    #
    # - Clean up files that are not needed anymore
    #
    rm -rf easybuild-framework-$EBversion
    rm -rf easybuild-easyblocks-$EBversion

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
    export LMOD_PACKAGE_PATH=$testroot/SystemRepo/LMOD
    export LMOD_RC=$testroot/SystemRepo/LMOD/lmodrc.lua
    export LMOD_ADMIN_FILE=$testroot/SystemRepo/LMOD/admin.list
    export LMOD_AVAIL_STYLE=label:system
    export LUMI_PARTITION='common'
    module load LUMI/$EBstack
    module load partition/common
    # Need to use the full module name as the module is hidden in the default view!
    module load EasyBuild-production/LUMI
    $workdir/easybuild/bin/eb --show-config
    $workdir/easybuild/bin/eb $EBchecksums $testroot/SystemRepo/easybuild/easyconfigs/e/EasyBuild/EasyBuild-${eb_version}.eb

    #
    # - Clean up
    #
    rm -rf easybuild
    unset PYTHONPATH

    popd

}  # End of the install_EasyBuild function

#
# Now install a version of EasyBuild in all EasyBuild stacks
#
for stack in "${EB_stacks[@]}"
do
    install_EasyBuild "$testroot" "$stack" "${EB_version[$stack]}" "$workdir"
done

###############################################################################
#
# Instructions for the MODULEPATH etc
#
cat <<EOF


To enable LUMI prototype version $version, make sure LMOD is the
active module system and then run
eval \$(\$HOME/LUMI-easybuild-prototype/prototypes/design_$version/enable_prototype.sh)

Dummy demo modules are installed in ${stacks[0]} and ${stacks[1]}

EasyBuild works in $EBstack

EOF
