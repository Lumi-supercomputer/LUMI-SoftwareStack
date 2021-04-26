#! /bin/bash
#
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
