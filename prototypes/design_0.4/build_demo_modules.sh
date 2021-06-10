#! /bin/bash
#
# Script to build a number of demo modules for the current prototype
#
# The script takes three or more
#   * The root of the installation
#   * the other ones are the stack versions for which we build the demo
#     structure. The first two are currently used for actual dummy modules.
#

#
# Process the input arguments
#
installroot="$1"
shift
demo_stacks=( $@ )

echo -e "\nInstalling ${#demo_stacks[@]} demo stacks: ${demo_stacks[@]}"

#
# Other variables
#
partitions=( 'C' 'G' 'D' 'L' )

###############################################################################
###############################################################################
###############################################################################
#
# Functions used by this script
#

function create_link () {

#  echo "Linking from: $1"
#  echo "Linking to: $2"
#  test -s "$2" && echo "File $2 found."
#  test -s "$2" || echo "File $2 not found."
  test -s "$2" || ln -s "$1" "$2"

}

function empty_module_EB() {

# This script creates an empty demo module in EasyBuild-style.
#
# Arguments:
# - $1: Name of the module
# - $2: Version of the module
# - $3: Toolchain for the module
# - $4: Versionsuffix for the module
# - $5: Software directory for the installation
# - $6: Module directory.
#

#
# Rename some parameters
#
software_root="$5"
module_root="$6"

#
# Compute the full version string of the module.
#
module_name=$1
if [ "$4" = "" ]
then
	if [ "$3" = "" ]
	then
        module_version="$2"
	else
	    module_version="$2-$3"
	fi
else
	if [ "$3" = "" ]
	then
        module_version="$2-$4"
	else
	    module_version="$2-$3-$4"
	fi
fi

#
# Create a "Hello, world!" script
#
software_dir="$software_root/$module_name/$module_version"
mkdir -p "$software_dir/bin"
cat >"$software_dir/bin/hello_$module_name" <<EOF
#! /bin/bash

echo "Hello from the EasyBuild $module_name/$module_version"
EOF
chmod a+x "$software_dir/bin/hello_$module_name"

#
# Create a sample module file
#
module_dir="$module_root/$module_name"
module_file="$module_dir/$module_version.lua"
mkdir -p "$module_dir"
cat >"$module_file" <<EOF
whatis("Description: $module_name/$module_version is an EasyBuild demo module for the LUMI prototype.")
help([==[

Description
===========
This is really just an empty demo module to demonstrate what the module tree on
LUMI could be like and how software could be found.

This module mimics the internal structure of an EasyBuild-generated module file.


Usage
=====
This module does provide the hello_$module_name command and sets a number of
variables that EasyBuild would also set.


More information
================
 - Homepage: https://www.lumi-supercomputer.eu/
]==])

local root = "$software_dir"

conflict("$module_name")

prepend_path("PATH", pathJoin(root, "bin"))
setenv("EBROOT${module_name^^}", "root")
setenv("EBVERSION${module_name^^}", $2)
-- Not built with EasyBuild
EOF

} # END of empty_module_EB


function empty_module_Spack() {

# This vunction creates an empty demo module in Spack-style.
#
# Arguments:
# - $1: Name of the module
# - $2: Version of the module
# - $3: Toolchain for the module
# - $4: Versionsuffix for the module
# - $5: Software directory for the installation
# - $6: Module directory.
#

#
# Rename some parameters
#
software_root="$5"
module_root="$6"

#
# Compute the full version string of the module.
#
module_name=$1
if [ "$4" = "" ]
then
	module_version="$2-$3"
	module_short_version="$2"
else
	module_version="$2-$3-$4"
	module_short_version="$2-$4"
fi

#
# Create a "Hello, world!" script
#
software_dir="$software_root/$module_name/$module_version"
mkdir -p "$software_dir/bin"
cat >"$software_dir/bin/hello_$module_name" <<EOF
#! /bin/bash

echo "Hello from the Spack $module_name/$module_version"
EOF
chmod a+x "$software_dir/bin/hello_$module_name"

#
# Create a sample module file
#
module_dir="$module_root/$module_name"
module_file="$module_dir/$module_short_version.lua"
mkdir -p "$module_dir"
cat >"$module_file" <<EOF
whatis([[Name : $module_name]])
whatis([[Version : $module_short_version]])
whatis([[Sort description : $module_name/$module_version is a Spack demo module for the LUMI prototype.]])

help([[
This is really just an empty demo module to demonstrate what the module tree on
LUMI could be like and how software could be found.

This module mimics the internal structure of a Spack-generated module file.
]])

local root = "$software_dir"

conflict("$module_name")

prepend_path("PATH", pathJoin(root, "bin"))

setenv("${module_name^^}_INSTALL_ROOT", root)
EOF

} # END of empty_module_Spack


function empty_module_MN() {

# This function creates an empty demo module in EasyBuild-style but for a manual installation
#
# Arguments:
# - $1: Name of the module
# - $2: Version of the module
# - $3: Software directory for the installation
# - $4: Module directory.
#

#
# Rename some parameters
#
module_name="$1"
module_version="$2"
software_root="$3"
module_root="$4"

#
# Create a "Hello, world!" script
#
software_dir="$software_root/$module_name/$module_version"
mkdir -p "$software_dir/bin"
cat >"$software_dir/bin/hello_$module_name" <<EOF
#! /bin/bash

echo "Hello from the EasyBuild $module_name/$module_version"
EOF
chmod a+x "$software_dir/bin/hello_$module_name"

#
# Create a sample module file
#
module_dir="$module_root/$module_name"
module_file="$module_dir/$module_version.lua"
mkdir -p "$module_dir"
cat >"$module_file" <<EOF
whatis("Description: $module_name/$module_version is a manually installed demo module for the LUMI prototype.")
help([==[

Description
===========
This is really just an empty demo module to demonstrate what the module tree on
LUMI could be like and how software could be found.

This module mimics the internal structure of a manually installed module file.


Usage
=====
This module does provide the hello_$module_name command and sets a number of
variables that EasyBuild would also set.


More information
================
 - Homepage: https://www.lumi-supercomputer.eu/
]==])

local root = "$software_dir"

conflict("$module_name")

prepend_path("PATH", pathJoin(root, "bin"))
setenv("EBROOT${module_name^^}", "root")
setenv("EBVERSION${module_name^^}", $2)
setenv("${module_name^^}_INSTALL_ROOT", root)
-- Not built with EasyBuild
EOF

} # END of empty_module_MN


function Python3_module_EB() {

# This script creates an empty demo module in EasyBuild-style.
#
# Arguments:
# - $1: Python version of the module
# - $3: Toolchain for the module
# - $3: NumPy version
# - $4: SciPy version
# - $5: Software directory for the installation
# - $6: Module directory.
#

#
# Rename some parameters
#
module_name="Python3"
module_version="$1-$2"
numpy_version="$3"
scipy_version="$4"
software_root="$5"
module_root="$6"

#
# Create a "Hello, world!" script
#
software_dir="$software_root/$module_name/$module_version"
mkdir -p "$software_dir/bin"
cat >"$software_dir/bin/hello_$module_name" <<EOF
#! /bin/bash

echo "Hello from the EasyBuild $module_name/$module_version"
EOF
chmod a+x "$software_dir/bin/hello_$module_name"

#
# Create a sample module file
#
module_dir="$module_root/$module_name"
module_file="$module_dir/$module_version.lua"
mkdir -p "$module_dir"
cat >"$module_file" <<EOF
whatis("Description: $module_name/$module_version is an EasyBuild Python demo module for the LUMI prototype.")
whatis("Extensions: numpy-$numpy_version, scipy-$scipy_version")
help([==[

Description
===========
This is really just an empty demo module to demonstrate what the module tree on
LUMI could be like and how software could be found.

This module mimics the internal structure of an EasyBuild-generated module file
with extensions defined.


Usage
=====
This module does provide the hello_$module_name command and sets a number of
variables that EasyBuild would also set.


More information
================
 - Homepage: https://www.lumi-supercomputer.eu/


Included extensions
===================
numpy-$numpy_version, scipy-$scipy_version
]==])

local root = "$software_dir"

conflict("$module_name")

if convertToCanonical(LmodVersion()) >= convertToCanonical("8.2.8") then
    extensions("numpy-$numpy_version, scipy-$scipy_version")
end

prepend_path("PATH", pathJoin(root, "bin"))
setenv("EBROOT${module_name^^}", "root")
setenv("EBVERSION${module_name^^}", "$1")
setenv("EBEXTSLISTPYTHON", "numpy-$numpy_version, scipy-$scipy_version")
-- Not built with EasyBuild
EOF

}  # END of Python3_module_EB


###############################################################################
###############################################################################
###############################################################################


###############################################################################
#
# Directory structures
#

#
# Make the directories with the demo software stacks
#
for stack in "${demo_stacks[@]}"
do

  mkdir -p $installroot/modules/SystemPartition/LUMI/$stack
  mkdir -p $installroot/modules/SystemPartition/LUMI/$stack/partition
  mkdir -p $installroot/modules/easybuild/LUMI/$stack
  mkdir -p $installroot/modules/easybuild/LUMI/$stack/partition
  mkdir -p $installroot/modules/spack/LUMI/$stack
  mkdir -p $installroot/modules/spack/LUMI/$stack/partition
  mkdir -p $installroot/modules/manual/LUMI/$stack
  mkdir -p $installroot/modules/manual/LUMI/$stack/partition
  mkdir -p $installroot/modules/Infrastructure/LUMI/$stack
  mkdir -p $installroot/modules/Infrastructure/LUMI/$stack/partition

  mkdir -p $installroot/SW/LUMI-$stack

  mkdir -p $installroot/mgmt/ebrepo_files/LUMI-$stack

  for partition in ${partitions[@]} common
  do

	mkdir -p $installroot/modules/easybuild/LUMI/$stack/partition/$partition
   	mkdir -p $installroot/modules/spack/LUMI/$stack/partition/$partition
   	mkdir -p $installroot/modules/manual/LUMI/$stack/partition/$partition
   	mkdir -p $installroot/modules/Infrastructure/LUMI/$stack/partition/$partition

   	mkdir -p $installroot/SW/LUMI-$stack/$partition
   	mkdir -p $installroot/SW/LUMI-$stack/$partition/EB
   	mkdir -p $installroot/SW/LUMI-$stack/$partition/SP
   	mkdir -p $installroot/SW/LUMI-$stack/$partition/MNL

   	mkdir -p $installroot/mgmt/ebrepo_files/LUMI-$stack/LUMI-$partition

  done

done

#
# Populate modules/SoftwareStack and modules/LUMIpartition/LUMI-yy.mm
#
modsrc="$installroot/SystemRepo/modules"
moddest="$installroot/modules"
for stack in "${demo_stacks[@]}"
do

  # LUMI software stack. The only OS environment variables used are variables that are
  # not supposed to change on the LUMI (but are for now set by the initialisation modules).
  create_link   "$modsrc/LUMIstack/21.01.lua"             "$moddest/SoftwareStack/LUMI/$stack.lua"

  # Populate the LUMIpartition directory for this version of the LUMI software stack
  for partition in "${partitions[@]}"
  do
  	create_link "$modsrc/LUMIpartition/21.01.lua" "$moddest/SystemPartition/LUMI/$stack/partition/$partition.lua"
  done
  create_link   "$modsrc/LUMIpartition/21.01.lua" "$moddest/SystemPartition/LUMI/$stack/partition/common.lua"

done

###############################################################################
#
# Create dummy modules
#

#
# Now build some demo modules
#
# - First modules that mimic EasyBuild
#
# Both functions take two arguments: The software stack version and LUMI partition letter (in that order)
#
# - First modules that mimic EasyBuild
#
function software_root () {
    echo "$installroot/SW/LUMI-$1/$2/EB"
}

function module_root () {
    echo "$installroot/modules/easybuild/LUMI/$1/partition/$2"
}

stack=${demo_stacks[0]}
toolchain=$(echo $stack | sed -e 's/\([0-9]\{2\}\).*\([0-9]\{2\}\).*/\1.\2/')
empty_module_EB GROMACS 20.3 "cpeGNU-$toolchain" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_EB GROMACS 20.3 "cpeGNU-$toolchain" "GPU" $(software_root $stack G) $(module_root $stack G)
empty_module_EB GROMACS 21.1 "cpeGNU-$toolchain" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_EB GROMACS 21.1 "cpeGNU-$toolchain" "GPU" $(software_root $stack G) $(module_root $stack G)

empty_module_EB CMake 3.19.8 "" "" $(software_root $stack common) $(module_root $stack common)

stack=${demo_stacks[1]}
toolchain=$(echo $stack | sed -e 's/\([0-9]\{2\}\).*\([0-9]\{2\}\).*/\1.\2/')
empty_module_EB GROMACS 21.1 "cpeGNU-$toolchain" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_EB GROMACS 21.1 "cpeGNU-$toolchain" "GPU" $(software_root $stack G) $(module_root $stack G)
empty_module_EB GROMACS 21.2 "cpeGNU-$toolchain" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_EB GROMACS 21.2 "cpeGNU-$toolchain" "GPU" $(software_root $stack G) $(module_root $stack G)

empty_module_EB gnuplot 5.4.0 "cpeGNU-$toolchain" "" $(software_root $stack L) $(module_root $stack L)
empty_module_EB gnuplot 5.4.0 "cpeGNU-$toolchain" "" $(software_root $stack D) $(module_root $stack D)

empty_module_EB GSL 2.5 "cpeGNU-$toolchain" "" $(software_root $stack C) $(module_root $stack C)
empty_module_EB GSL 2.5 "cpeCCE-$toolchain" "" $(software_root $stack C) $(module_root $stack C)
empty_module_EB GSL 2.5 "cpeGNU-$toolchain" "" $(software_root $stack G) $(module_root $stack G)
empty_module_EB GSL 2.5 "cpeCCE-$toolchain" "" $(software_root $stack G) $(module_root $stack G)
empty_module_EB GSL 2.5 "cpeGNU-$toolchain" "" $(software_root $stack D) $(module_root $stack D)
empty_module_EB GSL 2.5 "cpeCCE-$toolchain" "" $(software_root $stack D) $(module_root $stack D)
empty_module_EB GSL 2.5 "cpeGNU-$toolchain" "" $(software_root $stack L) $(module_root $stack L)
empty_module_EB GSL 2.5 "cpeCCE-$toolchain" "" $(software_root $stack L) $(module_root $stack L)

empty_module_EB CMake 3.20.2 "" "" $(software_root $stack common) $(module_root $stack common)

#
# - Next modules that mimic Spack
#
function software_root () {
    echo "$installroot/SW/LUMI-$1/$2/SP"
}

function module_root () {
    echo "$installroot/modules/spack/LUMI/$1/partition/$2"
}

stack=${demo_stacks[0]}
empty_module_Spack lammps 3Mar2020 "" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_Spack lammps 3Mar2020 "" "GPU" $(software_root $stack G) $(module_root $stack G)

stack=${demo_stacks[1]}
empty_module_Spack cp2k   7.1      "" ""    $(software_root $stack C) $(module_root $stack C)
empty_module_Spack cp2k   7.1      "" "GPU" $(software_root $stack G) $(module_root $stack G)

#
# - Next modules that mimic manual installs
#
function software_root () {
    echo "$installroot/SW/LUMI-$1/$2/MNL"
}

function module_root () {
    echo "$installroot/modules/manual/LUMI/$1/partition/$2"
}

stack=${demo_stacks[0]}
empty_module_MN Gaussian  g16_a03-avx2 $(software_root $stack C) $(module_root $stack C)

stack=${demo_stacks[1]}
empty_module_MN Gaussian  g16_c01-avx2 $(software_root $stack C) $(module_root $stack C)

#
# - Install some dummy Python3 modules to demonstrate the use of extensions in LMOD
#
function software_root () {
    echo "$installroot/SW/LUMI-$1/$2/EB"
}

function module_root () {
    echo "$installroot/modules/easybuild/LUMI/$1/partition/$2"
}

stack=${demo_stacks[0]}
toolchain=$(echo $stack | sed -e 's/\([0-9]\{2\}\).*\([0-9]\{2\}\).*/\1.\2/')
Python3_module_EB "3.8.2" "cpeCCE-$toolchain" "1.19.3" "1.5.4" $(software_root $stack C) $(module_root $stack C)
Python3_module_EB "3.8.2" "cpeCCE-$toolchain" "1.19.3" "1.5.4" $(software_root $stack G) $(module_root $stack G)
Python3_module_EB "3.8.2" "cpeCCE-$toolchain" "1.19.3" "1.5.4" $(software_root $stack D) $(module_root $stack D)
Python3_module_EB "3.8.2" "cpeCCE-$toolchain" "1.19.3" "1.5.4" $(software_root $stack L) $(module_root $stack L)

stack=${demo_stacks[1]}
toolchain=$(echo $stack | sed -e 's/\([0-9]\{2\}\).*\([0-9]\{2\}\).*/\1.\2/')
Python3_module_EB "3.8.5" "cpeCCE-$toolchain" "1.19.3" "1.5.4" $(software_root $stack C) $(module_root $stack C)
Python3_module_EB "3.8.5" "cpeCCE-$toolchain" "1.19.3" "1.5.4" $(software_root $stack G) $(module_root $stack G)
Python3_module_EB "3.8.5" "cpeCCE-$toolchain" "1.19.3" "1.5.4" $(software_root $stack D) $(module_root $stack D)
Python3_module_EB "3.8.5" "cpeCCE-$toolchain" "1.19.3" "1.5.4" $(software_root $stack L) $(module_root $stack L)
Python3_module_EB "3.9.4" "cpeCCE-$toolchain" "1.20.2" "1.6.3" $(software_root $stack C) $(module_root $stack C)
Python3_module_EB "3.9.4" "cpeCCE-$toolchain" "1.20.2" "1.6.3" $(software_root $stack G) $(module_root $stack G)
Python3_module_EB "3.9.4" "cpeCCE-$toolchain" "1.20.2" "1.6.3" $(software_root $stack D) $(module_root $stack D)
Python3_module_EB "3.9.4" "cpeCCE-$toolchain" "1.20.2" "1.6.3" $(software_root $stack L) $(module_root $stack L)

