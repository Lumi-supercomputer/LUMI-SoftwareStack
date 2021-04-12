#! /bin/bash

version="0.2"
testroot="$HOME/appltest/design_$version/partition_stack_MOD"

PATH=$HOME/LUMI-easybuild/scripts:$HOME/LUMI-easybuild/scripts/prototype:$HOME/LUMI-easybuild/scripts/prototype/design_$version:$PATH

create_link () {

  test -s "$2" || ln -s "$1" "$2"

}

generate_mod () {

  gpp -o $2 -DLUMI_PARTITION="$3" -DLUMI_STACK_VERSION="$4" -DLUMITEST_ROOT=$5 $1

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

    mkdir -p $testroot/software/LUMI-$partition/LUMI-$stack
    mkdir -p $testroot/software/LUMI-$partition/LUMI-$stack/easybuild
    mkdir -p $testroot/software/LUMI-$partition/LUMI-$stack/spack
    mkdir -p $testroot/software/LUMI-$partition/LUMI-$stack/manual

    mkdir -p $testroot/mgmt/ebrepo_files/LUMI-$partition/LUMI-$stack

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
  generate_mod $modsrc/partition_stack/LUMI-partition.tmpl.lua    $moddest/LUMIpartition/LUMI-$partition.lua           "LUMI-$partition" "yy.mm" "$testroot"
  generate_mod $modsrc/partition_stack/LUMI-partition-s.tmpl.lua  $moddest/LUMIpartition/partition/LUMI-$partition.lua "LUMI-$partition" "yy.mm" "$testroot"

  # Populate the SoftwareStack directory for the present partition
  # - LUMI stacks
  mkdir -p $moddest/LUMI-$partition/SoftwareStack/LUMI
  for stack in 21.02
  do
    generate_mod "$modsrc/partition_stack/LUMI/stack.MOD.tmpl.lua" "$moddest/LUMI-$partition/SoftwareStack/LUMI/$stack.lua" "LUMI-$partition" "$stack" "$testroot"
  done
  # - Cray stack
  generate_mod "$modsrc/partition_stack/CrayEnv.tmpl.lua" "$moddest/LUMI-$partition/SoftwareStack/CrayEnv.lua" "LUMI-$partition" "yy.mm" "$testroot"

done

#
# Now build some demo modules
#
function software_root () {
    echo "$testroot/software/LUMI-$2/LUMI-$1/easybuild"
}

function module_root () {
    echo "$testroot/modules/LUMI-$2/LUMI-$1/easybuild"
}

stack="21.02"
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
