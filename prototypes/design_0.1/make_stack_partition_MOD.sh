#! /bin/bash

version="0.1"
testroot="$HOME/appltest/design_$version/stack_partition_MOD"

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
# Create the root modules with the software stacks
#
mkdir -p $testroot/modules
mkdir -p $testroot/modules/SoftwareStack
mkdir -p $testroot/modules/PrgEnv

mkdir -p $testroot/software

mkdir -p $testroot/mgmt
mkdir -p $testroot/mgmt/ebrepo_files

#
# Make the directories with the software stacks
#
for stack in 21.02
do

  mkdir -p $testroot/modules/LUMI-$stack
  mkdir -p $testroot/modules/LUMI-$stack/LUMIpartition

  mkdir -p $testroot/software/LUMI-$stack

  mkdir -p $testroot/mgmt/ebrepo_files/LUMI-$stack

  for partition in C G D L
  do

    mkdir -p $testroot/modules/LUMI-$stack/LUMI-$partition
	mkdir -p $testroot/modules/LUMI-$stack/LUMI-$partition/easybuild
   	mkdir -p $testroot/modules/LUMI-$stack/LUMI-$partition/spack
   	mkdir -p $testroot/modules/LUMI-$stack/LUMI-$partition/manual

   	mkdir -p $testroot/software/LUMI-$stack/LUMI-$partition
   	mkdir -p $testroot/software/LUMI-$stack/LUMI-$partition/easybuild
   	mkdir -p $testroot/software/LUMI-$stack/LUMI-$partition/spack
   	mkdir -p $testroot/software/LUMI-$stack/LUMI-$partition/manual

   	mkdir -p $testroot/mgmt/ebrepo_files/LUMI-$stack/LUMI-$partition

  done

done

#
# Populate with the relevant Cray modules
#
make_CPE_links.py $testroot/modules/LUMI-21.02

#
# Populate modules/SoftwareStack and modules/LUMI-XX.YY/LUMIpartition
#
modsrc="$testroot/github/prototypes/design_$version/modules"
moddest="$testroot/modules"
mkdir -p $moddest/SoftwareStack/LUMI
for stack in 21.02
do

  # LUMI software stack
  create_link $modsrc/stack_partition/LUMI/stack.lua $moddest/SoftwareStack/LUMI/$stack.lua

  # Populate the LUMIpartition directory for this version of the LUMI software stack
  for partition in C G D L
  do
  	create_link $modsrc/stack_partition/LUMI-partition.MOD.lua $moddest/LUMI-$stack/LUMIpartition/LUMI-$partition.lua
  done

done

create_link $modsrc/stack_partition/CrayEnv.lua $moddest/SoftwareStack/CrayEnv.lua

#
# Install the PrgEnv-* modules for use with the CrayEnv and CrayEnvMax software stacks
#
for prgenv in cray gnu aocc manual
do
  create_link $modsrc/stack_partition/PrgEnv/PrgEnv-$prgenv.lua $moddest/PrgEnv/PrgEnv-$prgenv.lua
done

#
# Instructions for the MODULEPATH etc
#
