#! /bin/bash

version="0.3"
testroot="$HOME/appltest/design_$version/partition_stack"

PATH=$HOME/LUMI-easybuild/prototypes:$HOME/LUMI-easybuild/prototypes/design_$version:$PATH

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
test -s $testroot/github || ln -s $HOME/LUMI-easybuild $testroot/github

#
# Create the root modules with the partitions
#
mkdir -p $testroot/modules
mkdir -p $testroot/modules/generic
mkdir -p $testroot/modules/generic/LUMIstack
mkdir -p $testroot/modules/generic/LUMIpartition
mkdir -p $testroot/modules/SystemPartition
mkdir -p $testroot/modules/SystemPartition/partition
mkdir -p $testroot/modules/SoftwareStack
mkdir -p $testroot/modules/easybuild
mkdir -p $testroot/modules/spack
mkdir -p $testroot/modules/manual

mkdir -p $testroot/software

mkdir -p $testroot/mgmt
mkdir -p $testroot/mgmt/ebrepo_files

#
# Make the directories for the partitions
#
for partition in C G D L
do

  mkdir -p $testroot/modules/SoftwareStack/partition/$partition
  mkdir -p $testroot/modules/SoftwareStack/partition/$partition/LUMI
  mkdir -p $testroot/modules/easybuild/partition/$partition
  mkdir -p $testroot/modules/easybuild/partition/$partition/LUMI
  mkdir -p $testroot/modules/spack/partition/$partition
  mkdir -p $testroot/modules/spack/partition/$partition/LUMI
  mkdir -p $testroot/modules/manual/partition/$partition
  mkdir -p $testroot/modules/manual/partition/$partition/LUMI

  mkdir -p $testroot/software/LUMI-$partition

  mkdir -p $testroot/mgmt/ebrepo_files/LUMI-$partition

  for stack in 21.02 21.03
  do

    mkdir -p $testroot/modules/easybuild/partition/$partition/LUMI/$stack
    mkdir -p $testroot/modules/spack/partition/$partition/LUMI/$stack
    mkdir -p $testroot/modules/manual/partition/$partition/LUMI/$stack

    mkdir -p $testroot/software/LUMI-$partition/LUMI-$stack
    mkdir -p $testroot/software/LUMI-$partition/LUMI-$stack/easybuild
    mkdir -p $testroot/software/LUMI-$partition/LUMI-$stack/spack
    mkdir -p $testroot/software/LUMI-$partition/LUMI-$stack/manual

    mkdir -p $testroot/mgmt/ebrepo_files/LUMI-$partition/LUMI-$stack

  done

done

#
# First populate modules/generic
#
modsrc="$testroot/github/prototypes/design_$version/modules/partition_stack"
moddest="$testroot/modules/generic"
create_link $modsrc/LUMIstack/version.lua             $moddest/LUMIstack/version.lua
create_link $modsrc/LUMIpartition/partitionletter.lua $moddest/LUMIpartition/partitionletter.lua
create_link $modsrc/CrayEnv.lua                       $moddest/CrayEnv.lua

#
# Populate modules/LUMIpartition and modules/LUMI-*/SoftwareStack
#
modsrc="$testroot/modules/generic"
moddest="$testroot/modules"
for partition in C G D L
do

  # LUMI partition
  create_link   "$modsrc/LUMIpartition/partitionletter.lua" "$moddest/SystemPartition/partition/$partition.lua"

  # Populate the SoftwareStack directory for the present partition
  # - LUMI stacks
  for stack in 21.02 21.03
  do
    create_link "$modsrc/LUMIstack/version.lua"             "$moddest/SoftwareStack/partition/$partition/LUMI/$stack.lua"
  done
  # - Cray stack
  create_link   "$modsrc/CrayEnv.lua"                       "$moddest/SoftwareStack/partition/$partition/CrayEnv.lua"

done

#
# Now build some demo modules
#
# Both functions take two arguments: The software stack version and LUMI partition letter (in that order)
#
function software_root () {
    echo "$testroot/software/LUMI-$2/LUMI-$1/easybuild"
}

function module_root () {
    echo "$testroot/modules/easybuild/partition/$2/LUMI/$1"
}

stack="21.02"
empty_module_EB.sh GROMACS 20.3 "cpeGNU-$stack" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_EB.sh GROMACS 20.3 "cpeGNU-$stack" "GPU" $(software_root $stack G) $(module_root $stack G)
empty_module_EB.sh GROMACS 21.1 "cpeGNU-$stack" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_EB.sh GROMACS 21.1 "cpeGNU-$stack" "GPU" $(software_root $stack G) $(module_root $stack G)

stack="21.03"
empty_module_EB.sh GROMACS 20.3 "cpeGNU-$stack" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_EB.sh GROMACS 20.3 "cpeGNU-$stack" "GPU" $(software_root $stack G) $(module_root $stack G)

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

#
# Instructions for the MODULEPATH etc
#
cat <<EOF
To enable prototype partion_stack_MOD version $version, add the following directory
to the MOUDLEPATH:
$HOME/appltest/design_$version/partition_stack/modules/SystemPartition
EOF
