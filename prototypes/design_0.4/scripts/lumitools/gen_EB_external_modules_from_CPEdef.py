#
# gen_EB_external_modules_from_CPEdef( CPEpackages_dir, EBconfig_dir, version )
#
# Input arguments
#   * CPEpackages_dir : Directory with the CPE definitinon files (in .csv format)
#   * EBconfig_diur : Directory with the EasyBuild configuration and external modules
#     files
#   * version : Release of the CPE to generate the file for.
#

def gen_EB_external_modules_from_CPEdef( CPEpackages_dir, EBconfig_dir, version ):

    def write_package( fileH, PEpackage, module, EBnames, prefix, package_versions ):

        # Note that if a particular PEpackage does not exist in package_versions, no
        # error is printed. This is done in this way to be able to cope with evolutions
        # in the packages while still having a single script that works for all as
        # those packages will now simply be skipped.

        if PEpackage in package_versions:

            EBnames_table = EBnames.replace( ' ', '' ).split( ',' )

            version = package_versions[PEpackage]
            version_table = [ version for i in range( len( EBnames_table ) ) ]

            fileH.write( '[%(module)s]\nname = %(EBnames)s\nprefix = %(prefix)s\nversion = %(version)s\n\n' %
                { 'module': module,
                  'EBnames': ', '.join( EBnames_table ),
                  'prefix': prefix,
                  'version': ', '.join( version_table )
                } )


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
    # Add some that are not part of the CPE packages file
    #
    package_versions['Slurm'] = '.default'

    #
    # Make sure the output directory exists
    #
    print( 'Installing in: %s' % EBconfig_dir )
    try:
        if not os.path.isdir( EBconfig_dir ):
            os.makedirs( EBconfig_dir )
    except OSError:
        print( 'Failed to create the EasyBuild config directory %s, giving up.' % EBconfig_dir )
        exit()

    #
    # Open the external module definition file
    #
    extdeffile = 'external_modules_metadata-LUMI-%s.cfg' % version
    extdeffileanddir = os.path.join( EBconfig_dir, extdeffile )
    print( 'Generating %s...' % extdeffileanddir )
    fileH = open( extdeffileanddir, 'w' )

    fileH.write( '# metadata useful to EasyBuild for modules provided by Cray on Cray systems\n' +
                 '# This file is auto-generated\n\n' )

    #
    # Add the entries to the file
    #
    #                     PE package nm  Cray module                 EasyBuild module(s)       PREFIX variable EBROOT equivalent
    write_package( fileH, 'AOCC',        'aocc',                     'AOCC',                   'CRAY_AOCC_PREFIX',                package_versions )
    write_package( fileH, 'FFTW',        'cray-FFTW',                'FFTW',                   'FFTW_DIR/..',                     package_versions )
    write_package( fileH, 'HDF5',        'cray-hdf5',                'HDF5',                   'CRAY_HDF5_PREFIX',                package_versions )
    write_package( fileH, 'HDF5',        'cray-hdf5-parallel',       'HDF5',                   'CRAY_HDF5_PARALLEL_PREFIX',       package_versions )
    write_package( fileH, 'LibSci',      'cray-libsci',              'LibSci',                 'CRAY_LIBSCI_PREFIX_DIR',          package_versions )
    write_package( fileH, 'NetCDF',      'cray-netcdf',              'netCDF, netCDF-Fortran', 'CRAY_NETCDF_PREFIX',              package_versions )
    write_package( fileH, 'NetCDF',      'cray-netcdf-hdf5parallel', 'netCDF, netCDF-Fortran', 'CRAY_NETCDF_HDF5PARALLEL_PREFIX', package_versions )
    write_package( fileH, 'cray-python', 'cray-python',              'Python',                 'CRAY_PYTHON_PREFIX',             package_versions )
    write_package( fileH, 'cray-R',      'cray-R',                   'R',                      'CRAY_R_PREFIX',                   package_versions )
    # TODO: GCC still different from CSCS
    write_package( fileH, 'GCC',         'GCC',                      'GCC',                    'GCC_PREFIX',                      package_versions )
    write_package( fileH, 'PAPI',        'papi',                     'PAPI',                   'CRAY_PAPI_PREFIX',                package_versions )
    write_package( fileH, 'PMI',         'pmi',                      'pmi',                    'CRAY_PMI_PREFIX',                 package_versions )
    write_package( fileH, 'Slurm',       'slurm/.default',           'slurm',                  'SLURMDIR',                        package_versions )

    #
    # Close the file and terminate
    #
    fileH.close( )
