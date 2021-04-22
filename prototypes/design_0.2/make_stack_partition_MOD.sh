#! /bin/bash

version="0.2"
testroot="$HOME/appltest/design_$version/stack_partition_MOD"

PATH=$HOME/LUMI-easybuild/prototypes:$HOME/LUMI-easybuild/prototypes/design_$version:$PATH

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
# Populate modules/SoftwareStack and modules/LUMI-XX.YY/LUMIpartition
#
modsrc="$testroot/github/prototypes/design_$version/modules"
moddest="$testroot/modules"
mkdir -p $moddest/SoftwareStack/LUMI
for stack in 21.02
do

  # LUMI software stack. The only OS environment variables used are variables that are
  # not supposed to change on the LUMI (but are for now set by the initialisation modules).
  generate_mod $modsrc/stack_partition/LUMI/stack.tmpl.lua $moddest/SoftwareStack/LUMI/$stack.lua "LUMI-$partition" "$stack" "$testroot"

  # Populate the LUMIpartition directory for this version of the LUMI software stack
  for partition in C G D L
  do
  	generate_mod $modsrc/stack_partition/LUMI-partition.MOD.tmpl.lua $moddest/LUMI-$stack/LUMIpartition/LUMI-$partition.lua "LUMI-$partition" "$stack" "$testroot"
  done

done

# Provide the CrayEnv stack. This module does not depend on variables set by modules so
# we can use a link for now.
generate_mod $modsrc/stack_partition/CrayEnv.tmpl.lua $moddest/SoftwareStack/CrayEnv.lua "LUMI-$partition" "$stack" "$testroot"

#
# Now build some demo modules
#
function software_root () {
    echo "$testroot/software/LUMI-$1/LUMI-$2/easybuild"
}

function module_root () {
    echo "$testroot/modules/LUMI-$1/LUMI-$2/easybuild"
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
cat <<EOF
To enable prototype stack_partition_MOD version $version, add the following directory
to the MOUDLEPATH:
$HOME/appltest/design_$version/stack_partition_MOD/modules/SoftwareStack
EOF
