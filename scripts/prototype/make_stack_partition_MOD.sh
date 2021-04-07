#! /bin/bash

testroot='/home/klust/appl_stack_partition_MOD'

PATH=/home/klust/LUMI-easybuild/scripts:/home/klust/LUMI-easybuild/scripts/prototype:$PATH

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
mkdir -p $testroot/modules/SoftwareStack/LUMI
for stack in 21.02
do

  test -s $testroot/modules/SoftwareStack/LUMI/$stack.lua || ln -s $testroot/github/modules/stack_partition_MOD/LUMI/stack.lua $testroot/modules/SoftwareStack/LUMI/$stack.lua

  for partition in C G D L
  do

  	test -s $testroot/modules/LUMI-$stack/LUMIpartition/LUMI-$partition.lua || ln -s $testroot/github/modules/stack_partition_MOD/LUMI-partition.lua $testroot/modules/LUMI-$stack/LUMIpartition/LUMI-$partition.lua

  done

done



#
# Instructions for the MODULEPATH etc
#
