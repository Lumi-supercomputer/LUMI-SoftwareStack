#
# gen_CPE_modulerc( CPEpackages_dir, VisibilityHookData_dir, version )
#
# Input arguments
#   * CPEpackages_dir : Directory with the CPE definitinon files (in .csv format)
#   * VisibilityHookData_dir : Directory with the LMOD modulerc files
#   * version : Release of the CPE to generate the file for.
#

def gen_CPE_VisibilityHookData( CPEpackages_dir, VisibilityHookData_dir, version ):

    def write_package( fileH, PEpackage, module, package_versions ):

        # Note that if a particular PEpackage does not exist in package_versions, no
        # error is printed. This is done in this way to be able to cope with evolutions
        # in the packages while still having a single script that works for all as
        # those packages will now simply be skipped.

        if PEpackage in package_versions:
            version = package_versions[PEpackage]
            fileH.write( "['%s']='%s'," % (module, version) )


    #
    # Core of the gen_EB_external_modules_from_CPEdef function
    #

    import os
    import csv

    #
    # Read the .csv file with toolchain data.
    #
    CPEpackages_file = os.path.join( CPEpackages_dir, 'CPEpackages_' + version + '.csv' )
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
    package_versions['CPE'] = version


    #
    # Open the CPE-specific modulerc file
    #
    print( 'Installing in: %s' % VisibilityHookData_dir )
    extdeffile = 'CPEmodules_%s.lua' % version.replace( '.', '_' )
    extdeffileanddir = os.path.join( VisibilityHookData_dir, extdeffile )
    print( 'Generating %s...' % extdeffileanddir )
    fileH = open( extdeffileanddir, 'w' )

    fileH.write( '-- Module versions for the CPE in a format that can be processed with the LUA require function.\n' +
                 '-- This file is auto-generated\n' )
    fileH.write( 'return {')

    #
    # Add the entries to the file
    #
    #                     PE package nm           Cray module
    write_package( fileH, 'cpe-prgenv',           'PrgEnv-cray',              package_versions )
    write_package( fileH, 'cpe-prgenv',           'PrgEnv-gnu',               package_versions )
    write_package( fileH, 'cpe-prgenv',           'PrgEnv-aocc',              package_versions )
    write_package( fileH, 'cpe-prgenv',           'PrgEnv-intel',             package_versions )
    write_package( fileH, 'cpe-prgenv',           'PrgEnv-nvidia',            package_versions )

    write_package( fileH, 'CCE',                  'cce',                      package_versions )
    write_package( fileH, 'GCC',                  'gcc',                      package_versions )
    write_package( fileH, 'AOCC',                 'aocc',                     package_versions )
    write_package( fileH, 'intel',                'intel',                    package_versions )

    write_package( fileH, 'craype',               'craype',                   package_versions )
    write_package( fileH, 'CPE',                  'cpe',                      package_versions )

    write_package( fileH, 'gdb4hpc',              'gdb4hpc',                  package_versions )
    write_package( fileH, 'perftools',            'perftools-base',           package_versions )
    write_package( fileH, 'valgrind4hpc',         'valgrind4hpc',             package_versions )

    write_package( fileH, 'MPICH',                'cray-mpich',               package_versions )
    write_package( fileH, 'MPICH',                'cray-mpich-abi',           package_versions )
    write_package( fileH, 'PMI',                  'cray-pmi',                 package_versions )
    write_package( fileH, 'PMI',                  'cray-pmi-lib',             package_versions )
    write_package( fileH, 'OpenSHMEMX',           'cray-openshmemx',          package_versions )

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
    write_package( fileH, 'jemalloc',             'cray-jemalloc',            package_versions )
    write_package( fileH, 'STAT',                 'cray-stat',                package_versions )
    write_package( fileH, 'craypkg-gen',          'craypkg-gen',              package_versions )
    write_package( fileH, 'iobuf',                'iobuf',                    package_versions )
    write_package( fileH, 'PAPI',                 'papi',                     package_versions )

    write_package( fileH, 'cray-python',          'cray-python',              package_versions )
    write_package( fileH, 'cray-R',               'cray-R',                   package_versions )
    write_package( fileH, 'craype-dl-plugin-py3', 'craype-dl-plugin-py3',     package_versions )

    # Grenoble-only?
    write_package( fileH, 'PALS',                 'cray-pals',                package_versions )
    write_package( fileH, 'PALS',                 'cray-libpals',             package_versions )

    #
    # Close the file and terminate
    #
    fileH.write( '}' )
    fileH.close( )
