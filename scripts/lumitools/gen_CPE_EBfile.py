#
# gen_CPE_EBfile( CPEmodule, PEversion, CPEpackages_dir, EBfile_dir )
#
# Generate an EasyConfig file for a given cpe* module
#
# Input arguments:
#   * CPEmodule: Name of the module. Currently supported are cpeCray, cpeGNU and cpeAMD
#   * PEversion: Version of the Cray PE.
#   * CPEpackages_dir: The directory where the CPEpackages_yy.mm.csv files can be found
#   * EBfile_dir: The directory where the generated EasyConfig file should be written.

#
# Mappings used by this module:
#
# - Define the mapping between cpe* module and compiler module.
map_cpe_compilermodule = {
    'cpeCray': 'cce',
    'cpeGNU':  'gcc',
    'cpeAOCC': 'aocc',
    'cpeAMD':  'rocm'
    }
# - Define the mapping between cpe* module and PE compiler package (the packages s used
#   in the CPEpackages_*.csv files)
map_cpe_compilerpackage = {
    'cpeCray': 'CCE',
    'cpeGNU':  'GCC',
    'cpeAOCC': 'AOCC',
    'cpeAMD':  'ROCM'
    }
# - Define the mapping between cpe* module and PRgEnv modules
map_cpe_PrgEnv = {
    'cpeCray': 'PrgEnv-cray',
    'cpeGNU':  'PrgEnv-gnu',
    'cpeAOCC': 'PrgEnv-aocc',
    'cpeAMD':  'PrgEnv-amd',
    }


EBfile = """
easyblock = 'CrayPEToolchain'

name =    '%(CPEname)s'
version = "%(CPEversion)s"

homepage = 'https://pubs.cray.com'

whatis = [
    "Desription: EasyBuild toolchain using the Cray compiler wrapper with %(compiler)s module (CPE release %(CPEversion)s)"
]

description = \"""
This module is the EasyBuild toolchain that uses the Cray compiler wrapper with
the %(compiler)s compiler activated. The components loaded are those of the Cray Programming
Environment (CPE) version %(CPEversion)s.

The module has the same effect as loading %(PrgEnv)s and cpe/%(CPEversion)s should have, but
does not use either of those modules. The use of %(PrgEnv)s is avoided since the
modules that it loads may change over time, reducing reproducibility, while loading
cpe/21.04 is avoided as this module is buggy and conflicts with the way the LUMI
software stack currently works. Instead, the module declares itself a member of
the PrgEnv family and sets an PE_ENV which would otherwise be set by %(PrgEnv)s,
ensuring that the Cray PE will work as if those modules are loaded.
\"""

toolchain = SYSTEM

PrgEnv_load   = False
PrgEnv_family = 'PrgEnv'
CPE_load      = None

import os
local_partition = os.getenv('LUMI_STACK_PARTITION')

if local_partition == 'common' or local_partition == 'L':
    cray_targets = [
        'craype-x86-rome',
        'craype-accel-host',
        'craype-network-ofi'
    ]
elif local_partition == 'C':
    cray_targets = [
        'craype-x86-milan',
        'craype-accel-host',
        'craype-network-ofi'
    ]
elif local_partition == 'G':
    cray_targets = [
        'craype-x86-trento',
        'craype-accel-amd-gfx90a',
        'craype-network-ofi'
    ]
elif local_partition == 'D':
    cray_targets = [
        'craype-x86-rome',
        'craype-accel-nvidia80',
        'craype-network-ofi'
    ]

dependencies = [
%(dependencies)s
]

moduleclass = 'toolchain'
"""


def gen_CPE_EBfile( CPEmodule, PEversion, CPEpackages_dir, EBfile_dir ):

    def generate_dependency( module, PEpackage, package_versions ):

        # Note that if a particular PEpackage does not exist in package_versions, no
        # error is printed. This is done in this way to be able to cope with evolutions
        # in the packages while still having a single script that works for all as
        # those packages will now simply be skipped.

        if PEpackage in package_versions:
            version = package_versions[PEpackage]
            return "    ('%s/%s', EXTERNAL_MODULE)," % (module, version)
        else:
            return "    ('%s', EXTERNAL_MODULE)," % module


    #
    # Core of the gen_EB_external_modules_from_CPEdef function
    #

    import os
    import csv

    #
    # Read the .csv file with toolchain data.
    #
    CPEpackages_file = os.path.join( CPEpackages_dir, 'CPEpackages_' + PEversion + '.csv' )
    print( 'Reading the toolchain composition from %s.' % CPEpackages_file )
    try:
        fileH = open( CPEpackages_file, 'r' )
    except OSerror:
        print( 'Failed to open the toolchain packages file %s.' % CPEpackages_file )
        exit()

    package_versions = {}

    package_reader = csv.reader( fileH )
    # Skip the header line
    next( package_reader )
    # Read the data and build the package_versions dictionary
    for row in package_reader :
        package_versions[row[0]] = row[1]

    fileH.close()

    #
    # Add missing packages or entries needed for this script
    #
    package_versions['CPE'] = PEversion

    #
    # Build the list of dependencies and their versions.
    #

    dependency_list = []
    compilermodule  = map_cpe_compilermodule[CPEmodule]
    compilerpackage = map_cpe_compilerpackage[CPEmodule]

    dependency_list.append( generate_dependency( compilermodule,   compilerpackage, package_versions ) )
    dependency_list.append( generate_dependency( 'craype',         'craype',        package_versions ) )
    dependency_list.append( generate_dependency( 'cray-mpich',     'MPICH',         package_versions ) )
    dependency_list.append( generate_dependency( 'cray-libsci',    'LibSci',        package_versions ) )
    dependency_list.append( generate_dependency( 'cray-dsmml',     'DSMML',         package_versions ) )
    dependency_list.append( generate_dependency( 'perftools-base', 'perftools',     package_versions ) )
    dependency_list.append( generate_dependency( 'xpmem',          'NONE',          package_versions ) )

    #
    # Open the CPE-specific modulerc file
    #
    extdeffile = '%s-%s.eb' % (CPEmodule, PEversion)
    extdeffileanddir = os.path.join( EBfile_dir, extdeffile )
    print( 'Generating %s...' % extdeffileanddir )
    fileH = open( extdeffileanddir, 'w' )

    fileH.write( EBfile % {
        'CPEname':      CPEmodule,
        'CPEversion':   PEversion,
        'compiler':     compilermodule,
        'PrgEnv':       map_cpe_PrgEnv[CPEmodule],
        'dependencies': '\n'.join( dependency_list ),
        } )

     #
    # Close the file and terminate
    #
    fileH.close( )


