#! /bin/bash

testroot='/home/klust/appl_stack_arch_EB'

PATH=/home/klust/LUMI-easybuild/scripts:/home/klust/LUMI-easybuild/scripts/prototype:$PATH

#
# Create the root modules with the software stacks
#
mkdir -p $testroot/modules/SoftwareStack



#
# Make the directories with the software stacks
#
make_CPE_links.py $testroot/modules/LUMI-21.02



#
# Instructions for the MODULEPATH etc
#
