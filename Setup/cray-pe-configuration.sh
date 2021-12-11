#! /bin/bash
################################################################################
#
# /etc/cray-pe.d/cray-pe-configuration.sh
#
# Defines site preferences for:
#    Module command, i.e. Environment Modules vs Lmod
#    Default PrgEnv
#    Additional, non-Cray module paths to use,
#    modules to load on initilization,
#    modules to be part of the PrgEnv module set.
#
# Sourced by:
#    /etc/profile.d/cray-pe.sh
#    /etc/cray-pe.d/gen-prgenv.sh
#
#
# Copyright 2020-2021 Hewlett Packard Enterprise Development LP
#
################################################################################

# Define the module command to use:
# environment modules (TCL) or lmod
module_prog="lmod"

# Define the default PrgEnv to use
default_prgenv="cray"

# Define any addtional module paths to use
mpaths="/appl/lumi/modules/SoftwareStack
        /appl/lumi/modules/StyleModifiers
        /appl/lumi/modules/init-LUMI-SoftwareStack"

# Define the list of modules in the PrgEnv collection
# excluding cpe-$env, craype, and compiler as those
# are added by the PrgEnv module itself.
# This list can  be space or colon separated.
prgenv_module_list="cray-dsmml cray-mpich cray-libsci"

# Define the list of modules to be loaded on login,
# e.g. workload managers, site modules.
# This list can be space or  colon separated.
init_module_list="
craype-x86-rome
craype-network-ofi
perftools-base
xpmem
PrgEnv-$default_prgenv
init-lumi
"

# Define set_default scripts to run.
# This enables a product default version
# outside of the default release.
# E.G. If 21.02 is the default release, but
#      you want the craype version from
#      the 20.12 release, you would add
#      /opt/cray/pe/admin-pe/set_default_files/set_default_craype_2.7.4
one_off_set_defaults=""

