#
# gen_CPE_modulerc( CPEpackages_dir, modulerc_file, version )
#
# Input arguments
#   * CPEpackages_dir : Directory with the CPE definitinon files (in .csv format)
#   * VisibilityHookData_dir : Directory with the LMOD modulerc files
#   * version_stack : Release of the CPE to generate the file for (and providing the list of modules)
#   * version_alias: Release of the CPE to use for the module versions
#

import re

def gen_LUMIstack_modulerc( CPEpackages_dir, modulerc_file, version_stack, version_alias ):

    def write_package( fileH, PEpackage, module, package_versions, minv='00.00', maxv='99.99' ):

        # Note that if a particular PEpackage does not exist in package_versions, no
        # error is printed. This is done in this way to be able to cope with evolutions
        # in the packages while still having a single script that works for all as
        # those packages will now simply be skipped.

        nonlocal version_stack
        nonlocal version_alias
        
        nversion_stack = re.sub( '\D+', '', version_stack )
        nversion_alias = re.sub( '\D+', '', version_alias )
        nminv =    re.sub( '\D+', '', minv )
        nmaxv =    re.sub( '\D+', '', maxv )
            
        if PEpackage in package_versions['stack'] and PEpackage in package_versions['alias'] and nversion_stack >= nminv and nversion_stack <= nmaxv and nversion_alias >= nminv and nversion_alias <= nmaxv :
            mversion_stack = package_versions['stack'][PEpackage]
            mversion_alias = package_versions['alias'][PEpackage]
            if mversion_stack == mversion_alias :
                fileH.write( f'module_version( \'{module}/{mversion_stack}\', \'default\')\n' )
            else:
                fileH.write( f'module_version( \'{module}/{mversion_alias}\', \'{mversion_stack}\')\n' )
                fileH.write( f'module_version( \'{module}/{mversion_alias}\', \'default\')\n' )
            
    #
    # Core of the gen_CPE_modulerc function
    #

    import os
    import csv
    
    package_versions = {}

    #
    # Read the .csv file with PE version info for version_stack.
    #
    CPEpackages_file = os.path.join( CPEpackages_dir, f'CPEpackages_{version_stack}.csv' )
    print( f'Reading the toolchain composition from {CPEpackages_file}.' )
    try:
        fileH = open( CPEpackages_file, 'r' )
    except OSerror:
        print( f'Failed to open the toolchain packages file {CPEpackages_file}.' )
        exit()

    package_versions['stack'] = {}

    package_reader = csv.reader( fileH )
    # Skip the header line
    next( package_reader )
    # Read the data and build the package_versions dictionary
    for row in package_reader :
        package_versions['stack'][row[0]] = row[1]

    fileH.close()

    #
    # Add missing packages or entries needed for this script
    #
    package_versions['stack']['CPE'] = version_stack
    
    #
    # Read the .csv file with PE version info for version_alias (if different)
    #
    
    if version_stack == version_alias :
        
        package_versions['alias'] = package_versions['stack'] 
        
    else :
        
        CPEpackages_file = os.path.join( CPEpackages_dir, f'CPEpackages_{version_alias}.csv' )
        print( f'Reading the toolchain composition from {CPEpackages_file}.' )
        try:
            fileH = open( CPEpackages_file, 'r' )
        except OSerror:
            print( f'Failed to open the toolchain packages file {CPEpackages_file}.' )
            exit()
    
        package_versions['alias'] = {}
    
        package_reader = csv.reader( fileH )
        # Skip the header line
        next( package_reader )
        # Read the data and build the package_versions dictionary
        for row in package_reader :
            package_versions['alias'][row[0]] = row[1]
    
        fileH.close()
    
        #
        # Add missing packages or entries needed for this script
        #
        package_versions['stack']['alias'] = version_alias
    


    #
    # Open the CPE-specific modulerc file
    #
    print( 'Installing in the file: %s' % modulerc_file )
    #extdeffile = 'modulerc.lua'
    #extdeffileanddir = os.path.join( LMOD_dir, extdeffile )
    #print( 'Generating %s...' % extdeffileanddir )
    fileH = open( modulerc_file, 'w' )

    if version_stack == version_alias :
        fileH.write( '-- Make the CPE modules that belong to this version of the CPE the default versions.\n' +
                     '-- This file is auto-generated\n\n' )
    else:
        fileH.write( f'-- Create aliases to replace modules from {version_stack} with equivalent modules of\n' +
                     f'-- {version_alias} and make the versions of {version_alias}  the default ones\n' +
                     f'-- This fails for modules that are in {version_stack} but not in {version_alias};\n' +
                     f'-- these modules are missing from this file as they cannot be replaced with just a\n' +
                     f'-- different version of the module.\n\n' )

    #
    # Add the entries to the file
    #
    #                     PE package nm           Cray module
    write_package( fileH, 'cpe-prgenv',           'PrgEnv-cray',              package_versions )
    write_package( fileH, 'cpe-prgenv',           'PrgEnv-gnu',               package_versions )
    write_package( fileH, 'cpe-prgenv',           'PrgEnv-aocc',              package_versions )
    write_package( fileH, 'cpe-prgenv',           'PrgEnv-amd',               package_versions )
    #write_package( fileH, 'cpe-prgenv',           'PrgEnv-intel',             package_versions )
    #write_package( fileH, 'cpe-prgenv',           'PrgEnv-nvidia',            package_versions )
    #write_package( fileH, 'cpe-prgenv',           'PrgEnv-nvhpc',             package_versions, minv='22.06' )
    write_package( fileH, 'cpe-prgenv',           'PrgEnv-gnu-amd',           package_versions, minv='22.08' )
    write_package( fileH, 'cpe-prgenv',           'PrgEnv-cray-amd',          package_versions, minv='22.08' )

    write_package( fileH, 'CCE',                  'cce',                      package_versions )
    write_package( fileH, 'GCC',                  'gcc',                      package_versions )
    write_package( fileH, 'AOCC',                 'aocc',                     package_versions )
    write_package( fileH, 'ROCM',                 'amd',                      package_versions )
    #write_package( fileH, 'intel',                'intel',                    package_versions )

    write_package( fileH, 'CCE',                  'cce-mixed',                package_versions, minv='22.06' )
    write_package( fileH, 'GCC',                  'gcc_mixed',                package_versions, minv='22.06' )
    write_package( fileH, 'AOCC',                 'aocc_mixed',               package_versions, minv='22.06' )
    write_package( fileH, 'ROCM',                 'amd_mixed',                package_versions, minv='22.06' )

    write_package( fileH, 'ROCM',                 'rocm',                     package_versions )

    write_package( fileH, 'craype',               'craype',                   package_versions )
    write_package( fileH, 'CPE',                  'cpe',                      package_versions )

    write_package( fileH, 'gdb4hpc',              'gdb4hpc',                  package_versions )
    write_package( fileH, 'perftools',            'perftools-base',           package_versions )
    write_package( fileH, 'valgrind4hpc',         'valgrind4hpc',             package_versions )

    write_package( fileH, 'MPICH',                'cray-mpich',               package_versions )
    write_package( fileH, 'MPICH',                'cray-mpich-abi',           package_versions )
    write_package( fileH, 'PMI',                  'cray-pmi',                 package_versions )
    write_package( fileH, 'PMI',                  'cray-pmi-lib',             package_versions, maxv='22.06' )
    write_package( fileH, 'OpenSHMEMX',           'cray-openshmemx',          package_versions )
    write_package( fileH, 'MPIxlate',             'cray-mpixlate',            package_versions, minv='21.11' )

    write_package( fileH, 'FFTW',                 'cray-fftw',                package_versions )
    write_package( fileH, 'HDF5',                 'cray-hdf5',                package_versions )
    write_package( fileH, 'HDF5',                 'cray-hdf5-parallel',       package_versions )
    write_package( fileH, 'LibSci',               'cray-libsci',              package_versions )
    write_package( fileH, 'LibSci_acc',           'cray-libsci_acc',          package_versions )
    write_package( fileH, 'NetCDF',               'cray-netcdf',              package_versions )
    write_package( fileH, 'NetCDF',               'cray-netcdf-hdf5parallel', package_versions )
    write_package( fileH, 'parallel-netcdf',      'cray-parallel-netcdf',     package_versions )

    write_package( fileH, 'ATP',                  'atp',                      package_versions )
    write_package( fileH, 'CCDB',                 'cray-ccdb',                package_versions )
    write_package( fileH, 'CTI',                  'cray-cti',                 package_versions )
    write_package( fileH, 'DSMML',                'cray-dsmml',               package_versions )
    write_package( fileH, 'cray-dyninst',         'cray-dyninst',             package_versions, minv='21.12' )
    write_package( fileH, 'jemalloc',             'cray-jemalloc',            package_versions )
    write_package( fileH, 'STAT',                 'cray-stat',                package_versions )
    write_package( fileH, 'craypkg-gen',          'craypkg-gen',              package_versions )
    write_package( fileH, 'iobuf',                'iobuf',                    package_versions )
    write_package( fileH, 'PAPI',                 'papi',                     package_versions )

    write_package( fileH, 'cray-python',          'cray-python',              package_versions )
    write_package( fileH, 'cray-R',               'cray-R',                   package_versions )
    write_package( fileH, 'craype-dl-plugin-py3', 'craype-dl-plugin-py3',     package_versions, maxv='21.08' )

    # Grenoble-only?
    write_package( fileH, 'PALS',                 'cray-pals',                package_versions )
    write_package( fileH, 'PALS',                 'cray-libpals',             package_versions )

    #
    # Close the file and terminate
    #
    fileH.close( )
