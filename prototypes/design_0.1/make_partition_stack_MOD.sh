#! /bin/bash

version="0.1"
testroot="$HOME/appltest/design_$version/partition_stack_MOD"

PATH=$HOME/LUMI-easybuild/prototypes/design_$version:$PATH

create_link () {

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
mkdir -p $testroot/modules/LUMIpartition
mkdir -p $testroot/modules/common

mkdir -p $testroot/software

mkdir -p $testroot/mgmt
mkdir -p $testroot/mgmt/ebrepo_files

#
# Make the directories for the partitions
#
for partition in C G D L
do

  mkdir -p $testroot/modules/LUMI-$partition
  mkdir -p $testroot/modules/LUMI-$partition/SoftwareStack
  mkdir -p $testroot/modules/LUMI-$partition/PrgEnv

  mkdir -p $testroot/mgmt/ebrepo_files/LUMI-$partition

  for stack in 21.02
  do

    mkdir -p $testroot/modules/LUMI-$partition/LUMI-$stack
    mkdir -p $testroot/modules/LUMI-$partition/LUMI-$stack/easybuild
    mkdir -p $testroot/modules/LUMI-$partition/LUMI-$stack/spack
    mkdir -p $testroot/modules/LUMI-$partition/LUMI-$stack/manual

    mkdir -p $testroot/software/LUMI-$partition
    mkdir -p $testroot/software/LUMI-$partition/easybuild
    mkdir -p $testroot/software/LUMI-$partition/spack
    mkdir -p $testroot/software/LUMI-$partition/manual

    mkdir -p $testroot/mgmt/ebrepo_files/LUMI-$partition/LUMI-$stack

  done

done

for stack in 21.02
do

	mkdir -p $testroot/modules/common/LUMI-$stack

done

#
# Populate with the relevant Cray modules
#
make_CPE_links.py $testroot/modules/common/LUMI-21.02

#
# Populate modules/LUMIpartition and modules/LUMI-*/SoftwareStack
#
modsrc="$testroot/github/prototypes/design_$version/modules"
moddest="$testroot/modules"
mkdir -p $moddest/LUMIpartition/partition
for partition in C G D L
do

  # LUMI partition
  create_link $modsrc/partition_stack/LUMI-partition.lua    $moddest/LUMIpartition/LUMI-$partition.lua
  create_link $modsrc/partition_stack/LUMI-partition-s.lua  $moddest/LUMIpartition/partition/LUMI-$partition.lua

  # Populate the SoftwareStack directory for the present partition
  # - LUMI stacks
  mkdir -p $moddest/LUMI-$partition/SoftwareStack/LUMI
  for stack in 21.02
  do
    create_link "$modsrc/partition_stack/LUMI/stack.MOD.lua" "$moddest/LUMI-$partition/SoftwareStack/LUMI/$stack.lua"
  done
  # - Cray stack
  create_link "$modsrc/partition_stack/CrayEnv.lua" "$moddest/LUMI-$partition/SoftwareStack/CrayEnv.lua"

  # Instal the PrgEnv-modules
  mkdir -p $moddest/LUMI-$partition/PrgEnv/PrgEnv
  for prgenv in cray gnu aocc manual
  do
    create_link "$modsrc/partition_stack/PrgEnv/PrgEnv-$prgenv.lua" "$moddest/LUMI-$partition/PrgEnv/PrgEnv-$prgenv.lua"
    create_link "$modsrc/partition_stack/PrgEnv/PrgEnv-$prgenv.lua" "$moddest/LUMI-$partition/PrgEnv/PrgEnv/$prgenv.lua"
  done

done

#
# Instructions for the MODULEPATH etc
#
cat <<EOF
To enable prototype partion_stack_MOD version $version, add the following directory
to the MOUDLEPATH:
$HOME/appltest/design_$version/partition_stack_MOD/modules/LUMIpartition
EOF
