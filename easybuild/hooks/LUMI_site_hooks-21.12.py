#
# Hooks for LUMI.
#
# This version: Used from LUMI/21.04 and EasyBuild 4.4.0 onwards
#
# Authors:
#   Kurt Lust, University of Antwerp and LUMI User Support Team
#

import os

LUMI_SUPPORT = 'LUMI User Support @ https://lumi-supercomputer.eu/user-support/need-help/'

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
    if ec.name == 'cpeCray' or ec.name == 'cpeGNU' or ec.name == 'cpeAOCC' or ec.name == 'cpeAMD' or ec.name == 'cpeIntel' or ec.name == 'cpeNVIDIA':
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
                    'craype-x86-milan',
                    'craype-accel-amd-gfx90a',
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
    # END of parse_hook
    #
