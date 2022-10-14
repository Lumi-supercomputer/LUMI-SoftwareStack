#
# Hooks for LUMI.
#
# This version: Used from LUMI/21.04 and EasyBuild 4.4.0 onwards
#
# Authors:
#   Kurt Lust, University of Antwerp and LUMI User Support Team
#

import os

from easybuild.tools.build_log import EasyBuildError, print_msg, print_warning

LUMI_SUPPORT = 'LUMI User Support @ https://lumi-supercomputer.eu/user-support/need-help/'

LUMI_CPE_TOOLCHAINS = [ 'cpeGNU', 'cpeCray', 'cpeAOCC', 'cpeAMD', 'cpeIntel', 'cpeNVIDIA' ]

def parse_hook(ec, *args, **kwargs):
    """LUMI parse hooks
         - cpeCray, cpeGNU, cpeAOCC, cpeAMD, cpeIntel, cpeNVIDIA: Add correct cray_targets list.
    """

    easybuild_mode = os.environ['LUMI_EASYBUILD_MODE']

    if easybuild_mode in ['production', 'infrastructure'] and ec['site_contacts'] == None:
        ec['site_contacts'] = LUMI_SUPPORT

    #
    # Processing cpeCray/cpeGNU/cpeAOCC/cpeAMD/cpeIntel/cpeNIVIDIA
    # Note that this is an example only and this part of code is irrelevant on LUMI
    # as currently we fill cray_targets via scripts/lumitools/gen_CPE_EBfile.py.
    #
    if ec.name in LUMI_CPE_TOOLCHAINS :
        # Fill in cray_targets if it is left empty.
        if ec['cray_targets'] == []:
            lumi_partition = os.environ['LUMI_STACK_PARTITION']
            if lumi_partition == 'common' or lumi_partition == 'L':
                ec['cray_targets'].extend( [
                    'craype-x86-rome',
                    'craype-accel-host',
                    'craype-network-ofi'
                ] )
            elif lumi_partition == 'C':
                ec['cray_targets'].extend( [
                    'craype-x86-milan',
                    'craype-accel-host',
                    'craype-network-ofi'
                ] )
            elif lumi_partition == 'G':
                ec['cray_targets'].extend( [
                    'craype-x86-trento',
                    'craype-accel-amd-gfx90a',
                    'craype-network-ofi'
                ] )
            elif lumi_partition == 'EAP':
                ec['cray_targets'].extend( [
                    'craype-x86-rome',
                    'craype-accel-amd-gfx908',
                    'craype-network-ofi'
                ] )
            elif lumi_partition == 'D':
                ec['cray_targets'].extend( [
                    'craype-x86-rome',
                    # 'craype-accel-nvidia80', # Does not work as cudatoolkit/11.0 is not installed.
                    'craype-accel-host',
                    'craype-network-ofi'
                ] )

        #
        # END of processing cpeCray/cpeGNU/cpeAOCC/cpeAMD/cpeIntel/cpeNIVIDIA
        #

    #
    # Detect when a user is trying to use wrong toolchain versions.
    #
    ec_toolchain_name =    ec.toolchain.name 
    ec_toolchain_version = ec.toolchain.version
    #print( '\n%s: Toolchain: %s/%s' % (ec.name, ec_toolchain_name, ec_toolchain_version) )
    
    if easybuild_mode == 'user' and ec_toolchain_name in LUMI_CPE_TOOLCHAINS :
        try:
            lumi_stack_cpe_version = os.environ['LUMI_STACK_CPE_VERSION']
            lumi_stack_version     = os.environ['LUMI_STACK_VERSION']
        except:
            raise EasyBuildError(
                "You are using an EasyBuild hook designed to be used in the LUMI software stacks "
                "but the environment variables LUMI_STACK_CPE_VERSION and/or LUMI_STACK_VERSION are not defined."
            )
        if ec_toolchain_version != lumi_stack_cpe_version :
            raise EasyBuildError(
                "You are using an EasyConfig for %s that is developed for the %s/%s toolchain, "
                "which is meant for the LUMI/%s software stack, but are using LUMI/%s instead."
                % ( ec.name, ec_toolchain_name, ec_toolchain_version, ec_toolchain_version, lumi_stack_version)
            )
                                
    #
    # END of parse_hook
    #
