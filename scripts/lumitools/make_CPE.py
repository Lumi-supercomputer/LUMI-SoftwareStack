def make_CPE( moduleroot, system, package_versions ):


    def create_link_reg( modulename, modulesrcdir, mdir, packagename, package_versions):

        import os

        # Check the source module name
        try:
            modulename_tcl = os.path.join( modulesrcdir, modulename, package_versions[packagename] )
            modulename_lua = modulename_tcl + '.lua'
        except:
            raise Exception( 'Unexptected error, this should be a problem with the code' )
        if os.path.isfile( modulename_lua ):
            modulename_full = modulename_lua
            moduleversion =   package_versions[packagename] + '.lua'
        elif os.path.isfile( modulename_tcl ):
            modulename_full = modulename_tcl
            moduleversion =   package_versions[packagename]
        else:
            raise Exception( 'Could not locate the module file %s[.lua]' % modulename_tcl )
        # Create the subdirectory for the module link
        try:
            moduledir = os.path.join( moduleroot, mdir, modulename )
            if not os.path.isdir( moduledir ):
                os.makedirs( moduledir )
        except OSError:
            raise Exception( 'Failed to create %s, giving up.' % moduledir )
        # Create the module link.
        link_dest = os.path.join( moduleroot, mdir, modulename, moduleversion )
        try:
            if not os.path.isfile( link_dest ):
                os.symlink( modulename_full, link_dest )
        except OSError:
            raise Exception( 'Failed to create the link %s to %s.' % (link_dest, modulename_full) )


    def create_link_vpath( modulename, modulesrcdirstart, modulesrcdirend, mdir, packagename, package_versions):

        import os

        # Check the module name
        try:
            modulename_tcl = os.path.join( modulesrcdirstart, package_versions[packagename], modulesrcdirend, modulename )
            modulename_lua = modulename_tcl + '.lua'
        except:
            raise Exception( 'Unexptected error, this should be a problem with the code' )
        if os.path.isfile( modulename_lua ):
            modulename_full =  modulename_lua
            modulename_short = modulename + '.lua'
        elif os.path.isfile( modulename_tcl ):
            modulename_full =  modulename_tcl
            modulename_short = modulename
        else:
            raise Exception( 'Could not locate the module file %s[.lua]' % modulename_tcl )
        # Create the subdirectory for the module link
        # It usually will already exist, except in the very first call to one of the create_link routines.
        try:
            moduledir = os.path.join( moduleroot, mdir )
            if not os.path.isdir( moduledir ):
                os.makedirs( moduledir )
        except OSError:
            raise Exception( 'Failed to create %s, giving up.' % moduledir )
        # Create the module link.
        link_dest = os.path.join( moduleroot, mdir, modulename_short )
        try:
            if not os.path.isfile( link_dest ):
                os.symlink( modulename_full, link_dest )
        except OSError:
            raise Exception( 'Failed to create the link %s to %s.' % (link_dest, modulename_full) )


    def create_link_nover( modulename, modulesrcdir, mdir ):

        import os

        # Check the module name
        try:
            modulename_tcl = os.path.join( modulesrcdir, modulename )
            modulename_lua = modulename_tcl + '.lua'
        except:
            raise Exception( 'Unexptected error, this should be a problem with the code' )
        if os.path.isfile( modulename_lua ):
            modulename_full =  modulename_lua
            modulename_short = modulename + '.lua'
        elif os.path.isfile( modulename_tcl ):
            modulename_full =  modulename_tcl
            modulename_short = modulename
        else:
            raise Exception( 'Could not locate the module file %s[.lua]' % modulename_tcl )
        # Create the subdirectory for the module link
        try:
            moduledir = os.path.join( moduleroot, mdir )
            if not os.path.isdir( moduledir ):
                os.makedirs( moduledir )
        except OSError:
            raise Exception( 'Failed to create %s, giving up.' % moduledir )
        # Create the module link.
        link_dest = os.path.join( moduleroot, mdir, modulename_short )
        try:
            if not os.path.isfile( link_dest ):
                os.symlink( modulename_full, link_dest )
        except OSError:
            raise Exception( 'Failed to create the link %s to %s.' % (link_dest, modulename_full) )


    #
    # Core of the make_CPE function
    #

    import os

    print( 'Installing in: %s' % moduleroot )

    try:
        if not os.path.isdir( moduleroot ):
            os.makedirs( moduleroot )
    except OSError:
        print( 'Failed to create the module root directory %s, giving up.' % moduleroot )
        exit()

    #
    # Now creating the modules for all components.
    #
    # We'll first populate Cray
    #
    # - cce
    create_link_reg( 'cce',                      '/opt/cray/pe/modulefiles', 'Cray', 'CCE',            package_versions )
    # - MPICH
    create_link_reg( 'cray-mpich',               '/opt/cray/pe/modulefiles', 'Cray', 'MPICH',          package_versions )
    #create_link_reg( 'cray-mpich-abi',           '/opt/cray/pe/modulefiles', 'Cray', 'MPICH',          package_versions )
    #create_link_reg( 'cray-mpich-ucx',           '/opt/cray/pe/modulefiles', 'Cray', 'MPICH',          package_versions )
    create_link_reg( 'libfabric',                '/opt/cray/modulefiles',    'Cray', 'libfabric',      package_versions )
    # - DSMML
    create_link_reg( 'cray-dsmml',               '/opt/cray/pe/modulefiles', 'Cray', 'DSMML',          package_versions )
    # - PMI
    create_link_reg( 'cray-pmi',                 '/opt/cray/pe/modulefiles', 'Cray', 'PMI',            package_versions )
    create_link_reg( 'cray-pmi-lib',             '/opt/cray/pe/modulefiles', 'Cray', 'PMI',            package_versions )
    # - OpenSHMEMX
    create_link_reg( 'cray-openshmemx',          '/opt/cray/pe/modulefiles', 'Cray', 'OpenSHMEMX',     package_versions )
    # - ATP
    create_link_reg( 'atp',                      '/opt/cray/pe/modulefiles', 'Cray', 'ATP',            package_versions )
    # - CCDB
    create_link_reg( 'cray-ccdb',                '/opt/cray/pe/modulefiles', 'Cray', 'CCDB',           package_versions )
    # - CTI
    create_link_reg( 'cray-cti',                 '/opt/cray/pe/modulefiles', 'Cray', 'CTI',            package_versions )
    # - gdb4hpc
    create_link_reg( 'gdb4hpc',                  '/opt/cray/pe/modulefiles', 'Cray', 'gdb4hpc',        package_versions )
    # - STAT
    create_link_reg( 'cray-stat',                '/opt/cray/pe/modulefiles', 'Cray', 'STAT',           package_versions )
    # - valgrind4hpc
    create_link_reg( 'valgrind4hpc',             '/opt/cray/pe/modulefiles', 'Cray', 'valgrind4hpc',   package_versions )
    # - Perftools
    create_link_reg( 'perftools-base',           '/opt/cray/pe/modulefiles', 'Cray', 'Perftools',      package_versions )
    # - PAPI
    create_link_reg( 'papi',                     '/opt/cray/pe/modulefiles', 'Cray', 'PAPI',           package_versions )
    # - LibSci
    create_link_reg( 'cray-libsci',              '/opt/cray/pe/modulefiles', 'Cray', 'LibSci',         package_versions )
    # - LibSci_acc
    create_link_reg( 'cray-libsci_acc',          '/opt/cray/pe/modulefiles', 'Cray', 'LibSci_acc',     package_versions )
    # - FFTW
    create_link_reg( 'cray-fftw',                '/opt/cray/pe/modulefiles', 'Cray', 'FFTW',           package_versions )
    # - cpe-prgenv: cpe modules for Cray, GNU and AMD (when available)
    create_link_vpath( 'cpe-cray', '/opt/cray/pe/cpe-prgenv', 'modules', 'Cray', 'cpe-prgenv', package_versions )
    create_link_vpath( 'cpe-gnu',  '/opt/cray/pe/cpe-prgenv', 'modules', 'Cray', 'cpe-prgenv', package_versions )
    #create_link_path( 'cpe-aocc', '/opt/cray/pe/cpe-prgenv', 'modules', 'Cray', 'cpe-prgenv', package_versions )
    # - HDF5
    create_link_reg( 'cray-hdf5',                '/opt/cray/pe/modulefiles', 'Cray', 'HDF5',            package_versions )
    create_link_reg( 'cray-hdf5-parallel',       '/opt/cray/pe/modulefiles', 'Cray', 'HDF5',            package_versions )
    # - NetCDF
    create_link_reg( 'cray-netcdf',              '/opt/cray/pe/modulefiles', 'Cray', 'NetCDF',          package_versions )
    create_link_reg( 'cray-netcdf-hdf5parallel', '/opt/cray/pe/modulefiles', 'Cray', 'NetCDF',          package_versions )
    # - parallel-netCDF
    create_link_reg( 'cray-parallel-netcdf',     '/opt/cray/pe/modulefiles', 'Cray', 'parallel-netCDF', package_versions )
    # - iobuf
    # - GCC
    if 'GCC10' in package_versions:
        create_link_reg( 'gcc',                  '/opt/modulefiles',         'Cray', 'GCC10',           package_versions )
    if 'GCC9'  in package_versions:
        create_link_reg( 'gcc',                  '/opt/modulefiles',         'Cray', 'GCC9',            package_versions )
    if 'GCC8'  in package_versions:
        create_link_reg( 'gcc',                  '/opt/modulefiles',         'Cray', 'GCC8',            package_versions )
    # - cray-python
    # - cray-R
    create_link_reg( 'cray-R',                   '/opt/modulefiles',         'Cray', 'cray-R',          package_versions )
    #
    # Now populate Cray-targets
    #
    # - craype
    #create_link_vpath( 'craype-x86-rome', '/opt/cray/pe/craype', 'modulefiles', 'Cray-targets', 'craype', package_versions )
    #if system == 'grenoble':
    #    create_link_vpath( 'craype-network-ofi', '/opt/cray/pe/craype', 'modulefiles', 'Cray-targets', 'craype', package_versions )
    create_link_nover( 'craype-x86-rome',         '/opt/cray/pe/craype-targets/default/modulefiles', 'Cray-targets' )
    create_link_nover( 'craype-x86-milan',        '/opt/cray/pe/craype-targets/default/modulefiles', 'Cray-targets' )
    if system == 'grenoble':
        create_link_nover( 'craype-network-ofi',      '/opt/cray/pe/craype-targets/default/modulefiles', 'Cray-targets' )
        create_link_nover( 'craype-accel-amd-gfx908', '/opt/cray/pe/craype-targets/default/modulefiles', 'Cray-targets' )
