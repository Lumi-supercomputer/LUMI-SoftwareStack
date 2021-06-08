#! /usr/bin/env python3

from lumitools.gen_EB_external_modules_from_CPEdef import gen_EB_external_modules_from_CPEdef
import sys

CPEpackages_dir = sys.argv[1]
EBconfig_dir    = sys.argv[2]
PEversion       = sys.argv[3]

#
# Execute the command
#
gen_EB_external_modules_from_CPEdef( CPEpackages_dir, EBconfig_dir, PEversion )
