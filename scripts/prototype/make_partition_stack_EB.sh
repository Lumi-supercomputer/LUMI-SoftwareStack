#! /bin/bash

testroot='/home/klust/appl_partition_stack_EB'

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
# Instructions for the MODULEPATH etc
#
