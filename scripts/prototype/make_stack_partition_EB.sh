#! /bin/bash

testroot='/home/klust/appl_stack_partition_EB'

PATH=/home/klust/LUMI-easybuild/scripts:/home/klust/LUMI-easybuild/scripts/prototype:$PATH

#
# Make the support directories
#
mkdir -p $testroot
test -s $testroot/github || ln -s $HOME/LUMI-easybuild $testroot/github

#
# Create the root modules with the software stacks
#
mkdir -p $testroot/modules/SoftwareStack

#
# Make the directories with the software stacks
#
for stack in 21.02
do

  mkdir -p $testroot/modules/LUMI-$stack
  mkdir -p $testroot/modules/LUMI-$stack/LUMIpartition

  mkdir -p stack
  mkdir -p $testroot/stack/LUMI-$stack

  for partition in C G D L
  do

    mkdir -p $testroot/stack/LUMI-$stack/LUMI-$partition

    mkdir -p $testroot/stack/LUMI-$stack/LUMI-$partition/easybuild
    mkdir -p $testroot/stack/LUMI-$stack/LUMI-$partition/easybuild/software
    mkdir -p $testroot/stack/LUMI-$stack/LUMI-$partition/easybuild/modules
    mkdir -p $testroot/stack/LUMI-$stack/LUMI-$partition/easybuild/ebrepo_files

    mkdir -p $testroot/stack/LUMI-$stack/LUMI-$partition/spack

    mkdir -p $testroot/stack/LUMI-$stack/LUMI-$partition/manual
    mkdir -p $testroot/stack/LUMI-$stack/LUMI-$partition/manual/software
    mkdir -p $testroot/stack/LUMI-$stack/LUMI-$partition/manual/modules

  done

done

#
# Populate with the relevant Cray modules
#
make_CPE_links.py $testroot/modules/LUMI-21.02




#
# Instructions for the MODULEPATH etc
#
