#! /bin/bash

version="0.3"
testroot="$HOME/appltest/design_$version/stack_partition"

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
# Create the root modules with the software stacks
#
mkdir -p $testroot/modules
mkdir -p $testroot/modules/generic
mkdir -p $testroot/modules/generic/LUMIstack
mkdir -p $testroot/modules/generic/LUMIpartition
mkdir -p $testroot/modules/SoftwareStack
mkdir -p $testroot/modules/SoftwareStack/LUMI   # For the LUMI/yy.mm module files
mkdir -p $testroot/modules/SystemPartition
mkdir -p $testroot/modules/SystemPartition/LUMI   # For LUMI/yy.mm subdirectories
mkdir -p $testroot/modules/easybuild
mkdir -p $testroot/modules/easybuild/LUMI
mkdir -p $testroot/modules/spack
mkdir -p $testroot/modules/spack/LUMI
mkdir -p $testroot/modules/manual
mkdir -p $testroot/modules/manual/LUMI

mkdir -p $testroot/software

mkdir -p $testroot/mgmt
mkdir -p $testroot/mgmt/ebrepo_files

#
# Make the directories with the software stacks
#
for stack in 21.02 21.03
do

  mkdir -p $testroot/modules/SystemPartition/LUMI/$stack
  mkdir -p $testroot/modules/SystemPartition/LUMI/$stack/partition
  mkdir -p $testroot/modules/easybuild/LUMI/$stack
  mkdir -p $testroot/modules/easybuild/LUMI/$stack/partition
  mkdir -p $testroot/modules/spack/LUMI/$stack
  mkdir -p $testroot/modules/spack/LUMI/$stack/partition
  mkdir -p $testroot/modules/manual/LUMI/$stack
  mkdir -p $testroot/modules/manual/LUMI/$stack/partition

  mkdir -p $testroot/software/LUMI-$stack

  mkdir -p $testroot/mgmt/ebrepo_files/LUMI-$stack

  for partition in C G D L
  do

	mkdir -p $testroot/modules/easybuild/LUMI/$stack/partition/$partition
   	mkdir -p $testroot/modules/spack/LUMI/$stack/partition/$partition
   	mkdir -p $testroot/modules/manual/LUMI/$stack/partition/$partition

   	mkdir -p $testroot/software/LUMI-$stack/LUMI-$partition
   	mkdir -p $testroot/software/LUMI-$stack/LUMI-$partition/easybuild
   	mkdir -p $testroot/software/LUMI-$stack/LUMI-$partition/spack
   	mkdir -p $testroot/software/LUMI-$stack/LUMI-$partition/manual

   	mkdir -p $testroot/mgmt/ebrepo_files/LUMI-$stack/LUMI-$partition

  done

done

#
# First populate modules/generic
#
modsrc="$testroot/github/prototypes/design_$version/modules/stack_partition"
moddest="$testroot/modules/generic"
create_link $modsrc/LUMIstack/version.lua             $moddest/LUMIstack/version.lua
create_link $modsrc/LUMIpartition/partitionletter.lua $moddest/LUMIpartition/partitionletter.lua
create_link $modsrc/CrayEnv.lua                       $moddest/CrayEnv.lua

#
# Populate modules/SoftwareStack and modules/LUMIpartition/LUMI-yy.mm
#
modsrc="$testroot/modules/generic"
moddest="$testroot/modules"
for stack in 21.02 21.03
do

  # LUMI software stack. The only OS environment variables used are variables that are
  # not supposed to change on the LUMI (but are for now set by the initialisation modules).
  create_link   "$modsrc/LUMIstack/version.lua"             "$moddest/SoftwareStack/LUMI/$stack.lua"


  # Populate the LUMIpartition directory for this version of the LUMI software stack
  for partition in C G D L
  do
  	create_link "$modsrc/LUMIpartition/partitionletter.lua" "$moddest/SystemPartition/LUMI/$stack/partition/$partition.lua"
  done

done

# Provide the CrayEnv stack. This module does not depend on variables set by modules so
# we can use a link for now.
create_link     "$modsrc/CrayEnv.lua"                       "$moddest/SoftwareStack/CrayEnv.lua"

#
# Now build some demo modules
#
# Both functions take two arguments: The software stack version and LUMI partition letter (in that order)
#
function software_root () {
    echo "$testroot/software/LUMI-$1/LUMI-$2/easybuild"
}

function module_root () {
    echo "$testroot/modules/easybuild/LUMI/$1/partition/$2"
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
To enable prototype stack_partition version $version, add the following directory
to the MOUDLEPATH:
$HOME/appltest/design_$version/stack_partition/modules/SoftwareStack
EOF
