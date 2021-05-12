def CPE_to_EB( EBconfigdir, version, package_versions ):

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
    # Core of the make_CPE function
    #

    import os

    print( 'Installing in: %s' % EBconfigdir )

    try:
        if not os.path.isdir( EBconfigdir ):
            os.makedirs( EBconfigdir )
    except OSError:
        print( 'Failed to create the EasyBuild config directory %s, giving up.' % EBconfigdir )
        exit()

    #
    # Open the external module definition file
    #
    extdeffile = 'external_modules_metadata-LUMI-%s.cfg' % version
    extdeffileanddir = os.path.join( EBconfigdir, extdeffile )
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
    write_package( fileH, 'cray-python', 'cray-python',              'Python',                 'CRA?Y_PYTHON_PREFIX',             package_versions )
    write_package( fileH, 'cray-R',      'cray-R',                   'R',                      'CRAY_R_PREFIX',                   package_versions )
    # TODO: GCC still different from CSCS
    write_package( fileH, 'GCC9',        'GCC',                      'GCC',                    'GCC_PREFIX',                      package_versions )
    write_package( fileH, 'PAPI',        'papi',                     'PAPI',                   'CRAY_PAPI_PREFIX',                package_versions )
    write_package( fileH, 'pmi',         'pmi',                      'pmi',                    'CRAY_PMI_PREFIX',                 package_versions )
    write_package( fileH, 'Slurm',       'slurm/.default',           'slurm',                  'SLURMDIR',                        package_versions )

    #
    # Close the file and terminate
    #
    fileH.close( )
