#! /bin/bash

version="0.2"
testroot="/home/klust/appltest/design_$version/partition_stack_EB"

PATH=/home/klust/LUMI-easybuild/scripts:/home/klust/LUMI-easybuild/scripts/prototype/design_$version:$PATH

create_link () {

  test -s "$2" || ln -s "$1" "$2"

}

generate_mod () {

  gpp -o $2 -DLUMI_PARTITION="$3" -DLUMI_STACK_VERSION="$4" $1

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

#
# Populate modules/LUMIpartition and modules/LUMI-*/SoftwareStack
#
modsrc="$testroot/github/modules/design_$version"
moddest="$testroot/modules"
mkdir -p $moddest/LUMIpartition/partition
for partition in C G D L
do

  # LUMI partition
  create_link $modsrc/partition_stack/LUMI-partition.lua    $moddest/LUMIpartition/LUMI-$partition.lua           "LUMI-$partition" "yy.mm"
  create_link $modsrc/partition_stack/LUMI-partition-s.lua  $moddest/LUMIpartition/partition/LUMI-$partition.lua "LUMI-$partition" "yy.mm"

  # Populate the SoftwareStack directory for the present partition
  # - LUMI stacks
  mkdir -p $moddest/LUMI-$partition/SoftwareStack/LUMI
  for stack in 21.02
  do
    generate_mod "$modsrc/partition_stack/LUMI/stack.EB.tmpl.lua" "$moddest/LUMI-$partition/SoftwareStack/LUMI/$stack.lua" "LUMI-$partition" "$stack"
  done
  # - Cray stack
  generate_mod "$modsrc/partition_stack/CrayEnv.tmpl.lua" "$moddest/LUMI-$partition/SoftwareStack/CrayEnv.lua" "LUMI-$partition" "yy.mm"

done

#
# Instructions for the MODULEPATH etc
#
