#! /bin/bash

testroot='/home/klust/appl_partition_stack_MOD'

PATH=/home/klust/LUMI-easybuild/scripts:/home/klust/LUMI-easybuild/scripts/prototype:$PATH

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
# Make the directories with the software stacks
#
make_CPE_links.py $testroot/modules/common/LUMI-21.02

#
# Instructions for the MODULEPATH etc
#
