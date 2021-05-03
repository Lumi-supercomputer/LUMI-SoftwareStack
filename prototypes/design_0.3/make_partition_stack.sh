#! /bin/bash

version="0.3"
testroot="$HOME/appltest/design_$version/partition_stack"
sourceroot="$HOME/LUMI-easybuild-prototype"

PATH=$sourceroot/prototypes:$sourceroot/prototypes/design_$version:$PATH

stacks=( '21.02.dev' '21.03' '21.04.dev' )
partitions=( 'C' 'G' 'D' 'L' )
default_stack='21.03'

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
test -s $testroot/github || ln -s $sourceroot $testroot/github

#
# Create the root modules with the partitions
#
mkdir -p $testroot/modules
mkdir -p $testroot/modules/generic
mkdir -p $testroot/modules/generic/LUMIstack
mkdir -p $testroot/modules/generic/LUMIpartition
mkdir -p $testroot/modules/SystemPartition
mkdir -p $testroot/modules/SystemPartition/partition
mkdir -p $testroot/modules/SoftwareStack
mkdir -p $testroot/modules/easybuild
mkdir -p $testroot/modules/spack
mkdir -p $testroot/modules/manual

mkdir -p $testroot/software

mkdir -p $testroot/mgmt
mkdir -p $testroot/mgmt/ebrepo_files

#
# Make the directories for the partitions
#
for partition in "${partitions[@]}"
do

  mkdir -p $testroot/modules/SoftwareStack/partition/$partition
  mkdir -p $testroot/modules/SoftwareStack/partition/$partition/LUMI
  mkdir -p $testroot/modules/easybuild/partition/$partition
  mkdir -p $testroot/modules/easybuild/partition/$partition/LUMI
  mkdir -p $testroot/modules/spack/partition/$partition
  mkdir -p $testroot/modules/spack/partition/$partition/LUMI
  mkdir -p $testroot/modules/manual/partition/$partition
  mkdir -p $testroot/modules/manual/partition/$partition/LUMI

  mkdir -p $testroot/software/LUMI-$partition

  mkdir -p $testroot/mgmt/ebrepo_files/LUMI-$partition

  for stack in "${stacks[@]}"
  do

    mkdir -p $testroot/modules/easybuild/partition/$partition/LUMI/$stack
    mkdir -p $testroot/modules/spack/partition/$partition/LUMI/$stack
    mkdir -p $testroot/modules/manual/partition/$partition/LUMI/$stack

    mkdir -p $testroot/software/LUMI-$partition/LUMI-$stack
    mkdir -p $testroot/software/LUMI-$partition/LUMI-$stack/easybuild
    mkdir -p $testroot/software/LUMI-$partition/LUMI-$stack/spack
    mkdir -p $testroot/software/LUMI-$partition/LUMI-$stack/manual

    mkdir -p $testroot/mgmt/ebrepo_files/LUMI-$partition/LUMI-$stack

  done

done

#
# First populate modules/generic
#
modsrc="$testroot/github/prototypes/design_$version/modules/partition_stack"
moddest="$testroot/modules/generic"
create_link $modsrc/LUMIstack/version.lua             $moddest/LUMIstack/version.lua
create_link $modsrc/LUMIpartition/auto.lua            $moddest/LUMIpartition/auto.lua
create_link $modsrc/LUMIpartition/partitionletter.lua $moddest/LUMIpartition/partitionletter.lua
create_link $modsrc/LUMIpartition/modulerc.lua        $moddest/LUMIpartition/modulerc.lua
create_link $modsrc/CrayEnv.lua                       $moddest/CrayEnv.lua

#
# Populate modules/LUMIpartition and modules/LUMI-*/SoftwareStack
#
modsrc="$testroot/modules/generic"
moddest="$testroot/modules"
create_link     "$modsrc/LUMIpartition/modulerc.lua"          "$moddest/SystemPartition/partition/.modulerc.lua"
create_link     "$modsrc/LUMIpartition/auto.lua"              "$moddest/SystemPartition/partition/auto.lua"
create_link     "$moddest/SystemPartition/partition/auto.lua" "$moddest/SystemPartition/partition/default"
for partition in "${partitions[@]}"
do

  # LUMI partition
  create_link   "$modsrc/LUMIpartition/partitionletter.lua"   "$moddest/SystemPartition/partition/$partition.lua"

  # Populate the SoftwareStack directory for the present partition
  # - LUMI stacks
  for stack in "${stacks[@]}"
  do
    create_link "$modsrc/LUMIstack/version.lua"               "$moddest/SoftwareStack/partition/$partition/LUMI/$stack.lua"
  done
  # - Cray stack
  create_link   "$modsrc/CrayEnv.lua"                         "$moddest/SoftwareStack/partition/$partition/CrayEnv.lua"

done

#
# Create a modulerc file in the SoftwareStack subdirectory to mark the default software stack.
#
for partition in "${partitions[@]}"
do

  cat >$testroot/modules/SoftwareStack/partition/$partition/LUMI/.modulerc.lua <<EOF
module_version( "LUMI/$default_stack", "default" )
EOF

done

#
# Now build some demo modules
#
# Both functions take two arguments: The software stack version and LUMI partition letter (in that order)
#
# - First modules that mimic EasyBuild
#
function software_root () {
    echo "$testroot/software/LUMI-$2/LUMI-$1/easybuild"
}

function module_root () {
    echo "$testroot/modules/easybuild/partition/$2/LUMI/$1"
}

stack=${stacks[0]}
empty_module_EB.sh GROMACS 20.3 "cpeGNU-$stack" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_EB.sh GROMACS 20.3 "cpeGNU-$stack" "GPU" $(software_root $stack G) $(module_root $stack G)
empty_module_EB.sh GROMACS 21.1 "cpeGNU-$stack" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_EB.sh GROMACS 21.1 "cpeGNU-$stack" "GPU" $(software_root $stack G) $(module_root $stack G)

stack=${stacks[1]}
empty_module_EB.sh GROMACS 21.1 "cpeGNU-$stack" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_EB.sh GROMACS 21.1 "cpeGNU-$stack" "GPU" $(software_root $stack G) $(module_root $stack G)
empty_module_EB.sh GROMACS 21.2 "cpeGNU-$stack" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_EB.sh GROMACS 21.2 "cpeGNU-$stack" "GPU" $(software_root $stack G) $(module_root $stack G)

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
# - Next modules that mimic Spack
#
function software_root () {
    echo "$testroot/software/LUMI-$2/LUMI-$1/spack"
}

function module_root () {
    echo "$testroot/modules/spack/partition/$2/LUMI/$1"
}

stack=${stacks[0]}
empty_module_Spack.sh lammps 3Mar2020 "" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_Spack.sh lammps 3Mar2020 "" "GPU" $(software_root $stack G) $(module_root $stack G)

stack=${stacks[1]}
empty_module_Spack.sh cp2k   7.1      "" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_Spack.sh cp2k   7.1      "" "GPU" $(software_root $stack G) $(module_root $stack G)

#
# - Next modules that mimic manual installs
#
function software_root () {
    echo "$testroot/software/LUMI-$2/LUMI-$1/manual"
}

function module_root () {
    echo "$testroot/modules/manual/partition/$2/LUMI/$1"
}

stack=${stacks[0]}
empty_module_MN.sh Gaussian  g16_a03-avx2 $(software_root $stack C) $(module_root $stack C)

stack=${stacks[1]}
empty_module_MN.sh Gaussian  g16_c01-avx2 $(software_root $stack C) $(module_root $stack C)

#
# - Install some dummy Python3 modules to demonstrate the use of extensions in LMOD
#
function software_root () {
    echo "$testroot/software/LUMI-$2/LUMI-$1/easybuild"
}

function module_root () {
    echo "$testroot/modules/easybuild/partition/$2/LUMI/$1"
}

stack=${stacks[0]}
Python3_module_EB.sh "3.8.2" "cpeCCE-$stack" "1.19.3" "1.5.4" $(software_root $stack C) $(module_root $stack C)
Python3_module_EB.sh "3.8.2" "cpeCCE-$stack" "1.19.3" "1.5.4" $(software_root $stack G) $(module_root $stack G)
Python3_module_EB.sh "3.8.2" "cpeCCE-$stack" "1.19.3" "1.5.4" $(software_root $stack D) $(module_root $stack D)
Python3_module_EB.sh "3.8.2" "cpeCCE-$stack" "1.19.3" "1.5.4" $(software_root $stack L) $(module_root $stack L)

stack=${stacks[1]}
Python3_module_EB.sh "3.8.5" "cpeCCE-$stack" "1.19.3" "1.5.4" $(software_root $stack C) $(module_root $stack C)
Python3_module_EB.sh "3.8.5" "cpeCCE-$stack" "1.19.3" "1.5.4" $(software_root $stack G) $(module_root $stack G)
Python3_module_EB.sh "3.8.5" "cpeCCE-$stack" "1.19.3" "1.5.4" $(software_root $stack D) $(module_root $stack D)
Python3_module_EB.sh "3.8.5" "cpeCCE-$stack" "1.19.3" "1.5.4" $(software_root $stack L) $(module_root $stack L)
Python3_module_EB.sh "3.9.4" "cpeCCE-$stack" "1.20.2" "1.6.3" $(software_root $stack C) $(module_root $stack C)
Python3_module_EB.sh "3.9.4" "cpeCCE-$stack" "1.20.2" "1.6.3" $(software_root $stack G) $(module_root $stack G)
Python3_module_EB.sh "3.9.4" "cpeCCE-$stack" "1.20.2" "1.6.3" $(software_root $stack D) $(module_root $stack D)
Python3_module_EB.sh "3.9.4" "cpeCCE-$stack" "1.20.2" "1.6.3" $(software_root $stack L) $(module_root $stack L)

#
# Instructions for the MODULEPATH etc
#
cat <<EOF
To enable prototype partion_stack_MOD version $version, add the following directory
to the MOUDLEPATH:
$HOME/appltest/design_$version/partition_stack/modules/SystemPartition
EOF
