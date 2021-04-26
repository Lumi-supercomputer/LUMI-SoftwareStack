#! /bin/bash
#
# This script creates an empty demo module in EasyBuild-style.
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
