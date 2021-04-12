#! /bin/bash

version="0.1"
testroot="$HOME/appltest/design_$version/partition_stack_EB"

PATH=$HOME/LUMI-easybuild/scripts:$HOME/LUMI-easybuild/scripts/prototype/design_$version:$PATH

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

mkdir -p $testroot/stack

#
# Make the directories for the partitions
#
for partition in C G D L
do

  mkdir -p $testroot/modules/LUMI-$partition
  mkdir -p $testroot/modules/LUMI-$partition/SoftwareStack

  mkdir -p $testroot/stack/LUMI-$partition

  for stack in 21.02
  do

  	mkdir -p $testroot/stack/LUMI-$partition/LUMI-$stack

  	mkdir -p $testroot/stack/LUMI-$partition/LUMI-$stack/easybuild
  	mkdir -p $testroot/stack/LUMI-$partition/LUMI-$stack/easybuild/software
  	mkdir -p $testroot/stack/LUMI-$partition/LUMI-$stack/easybuild/modules
  	mkdir -p $testroot/stack/LUMI-$partition/LUMI-$stack/easybuild/ebrepo_files

  	mkdir -p $testroot/stack/LUMI-$partition/LUMI-$stack/spack

  	mkdir -p $testroot/stack/LUMI-$partition/LUMI-$stack/manual
  	mkdir -p $testroot/stack/LUMI-$partition/LUMI-$stack/manual/software
  	mkdir -p $testroot/stack/LUMI-$partition/LUMI-$stack/manual/modules

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
modsrc="$testroot/github/modules/design_$version"
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
    create_link "$modsrc/partition_stack/LUMI/stack.EB.lua" "$moddest/LUMI-$partition/SoftwareStack/LUMI/$stack.lua"
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
