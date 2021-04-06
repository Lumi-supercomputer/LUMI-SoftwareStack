#! /bin/env python3

import os
import sys

package_versions = {
    'CCE':             '11.0.2',
    'MPICH':           '8.1.2',
    'DSMML':           '0.1.1', # Not the standard version for 21.02!
    'PMI':             '6.0.9',
    'OpenSHMEMX':      '11.1.0.beta',
    'ATP':             '3.11.6', # Not the standard version for 21.02!
    'CCDB':            '4.10.4',
    'CTI':             '2.11.6', # Not the standard version for 21.02!
    'gdb4hpc':         '4.10.6',
    'STAT':            '4.7.1',
    'valgrind4hpc':    '2.10.3', # Not the standard version for 21.02!
    'Perftools':       '21.02.0',
    'PAPI':            '6.0.0.6',
    'LibSci':          '20.12.1.2',
    'LibSci_acc':      '21.02.9.1',
    'FFTW':            '3.3.8.8', # Not the standard version for 21.02!
    'craypkg-gen':     '1.3.12',
    'craype':          '2.7.5',
    'cpe-prgenv':      '7.0.0',
    'Cray-lmod':       '8.3.1.0',
    'HDF5':            '1.12.0.2', # Not the standard version for 21.02!
    'NetCDF':          '4.7.4.2',  # Not the standard version for 21.02!
    'parallel-netCDF': '1.12.1.1', # Not the standard version for 21.02!
    'iobuf':           '2.0.10',
    'GCC10':           '10.2.0',
    'GCC9':            '9.3.0',
    'GCC8':            '8.1.0',
    'cray-python':     '3.8.5.0',
    'cray-R':          '4.0.3.0',
    'libfabric':       '1.10.2pre1',
    'rocm':            'rocm',
}

moduleroot = sys.argv[1]
system = 'grenoble'

#
# Function to create a link to a module.
#

def create_link_reg( modulename, modulesrcdir, packagename, package_versions):

    # Check the module name
    try:
        modulename_tcl = os.path.join( modulesrcdir, modulename, package_versions[packagename] )
        modulename_lua = modulename_tcl + '.lua'
    except:
        raise Exception( 'Unexptected error, this should be a problem with the code' )
    if os.path.isfile( modulename_lua ):
        modulename_full =  modulename_lua
        modulename_short = package_versions[packagename] + '.lua'
    elif os.path.isfile( modulename_tcl ):
        modulename_full =  modulename_tcl
        modulename_short = package_versions[packagename]
    else:
        raise Exception( 'Could not locate the module file %s[.lua]' % modulename_tcl )
    # Create the subdirectory for the module link
    try:
        moduledir = os.path.join( moduleroot, modulename )
        if not os.path.isdir( moduledir ):
            os.mkdir( moduledir )
    except OSError:
        raise Exception( 'Failed to create %s, giving up.' % moduledir )
    # Create the module link.
    link_dest = os.path.join( moduleroot,   modulename, modulename_short )
    try:
        if not os.path.isfile( link_dest ):
            os.symlink( modulename_full, link_dest )
    except OSError:
        raise Exception( 'Failed to create the link %s to %s.' % (link_dest, modulename_full) )


def create_link_vpath( modulename, modulesrcdirstart, modulesrcdirend, packagename, package_versions):

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
        moduledir = os.path.join( moduleroot )
        if not os.path.isdir( moduledir ):
            os.mkdir( moduledir )
    except OSError:
        raise Exception( 'Failed to create %s, giving up.' % moduledir )
    # Create the module link.
    link_dest = os.path.join( moduleroot, modulename_short )
    try:
        if not os.path.isfile( link_dest ):
            os.symlink( modulename_full, link_dest )
    except OSError:
        raise Exception( 'Failed to create the link %s to %s.' % (link_dest, modulename_full) )


def create_link_nover( modulename, modulesrcdir ):

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
        moduledir = os.path.join( moduleroot, modulename)
        if not os.path.isdir( moduledir ):
            os.mkdir( moduledir )
    except OSError:
        raise Exception( 'Failed to create %s, giving up.' % moduledir )
    # Create the module link.
    link_dest = os.path.join( moduleroot,   modulename, modulename_short )
    try:
        if not os.path.isfile( link_dest ):
            os.symlink( modulename_full, link_dest )
    except OSError:
        raise Exception( 'Failed to create the link %s to %s.' % (link_dest, modulename_full) )



print( 'Installing in: %s' % moduleroot )

try:
    if not os.path.isdir( moduleroot ):
        os.makedirs( moduleroot )
except OSError:
    print( 'Failed to create the directory %s, giving up.' % moduleroot )
    exit()

#
# Now creating the modules for all components.
#
# - cce
create_link_reg( 'cce',                      '/opt/cray/pe/modulefiles', 'CCE',            package_versions )
# - MPICH
create_link_reg( 'cray-mpich',               '/opt/cray/pe/modulefiles', 'MPICH',          package_versions )
#create_link_reg( 'cray-mpich-abi',           '/opt/cray/pe/modulefiles', 'MPICH',          package_versions )
#create_link_reg( 'cray-mpich-ucx',           '/opt/cray/pe/modulefiles', 'MPICH',          package_versions )
create_link_reg( 'libfabric',                '/opt/cray/modulefiles',    'libfabric',      package_versions )
# - DSMML
create_link_reg( 'cray-dsmml',               '/opt/cray/pe/modulefiles', 'DSMML',          package_versions )
# - PMI
create_link_reg( 'cray-pmi',                 '/opt/cray/pe/modulefiles', 'PMI',            package_versions )
create_link_reg( 'cray-pmi-lib',             '/opt/cray/pe/modulefiles', 'PMI',            package_versions )
# - OpenSHMEMX
create_link_reg( 'cray-openshmemx',          '/opt/cray/pe/modulefiles', 'OpenSHMEMX',     package_versions )
# - ATP
create_link_reg( 'atp',                      '/opt/cray/pe/modulefiles', 'ATP',            package_versions )
# - CCDB
create_link_reg( 'cray-ccdb',                '/opt/cray/pe/modulefiles', 'CCDB',           package_versions )
# - CTI
create_link_reg( 'cray-cti',                 '/opt/cray/pe/modulefiles', 'CTI',            package_versions )
# - gdb4hpc
create_link_reg( 'gdb4hpc',                  '/opt/cray/pe/modulefiles', 'gdb4hpc',        package_versions )
# - STAT
create_link_reg( 'cray-stat',                '/opt/cray/pe/modulefiles', 'STAT',           package_versions )
# - valgrind4hpc
create_link_reg( 'valgrind4hpc',             '/opt/cray/pe/modulefiles', 'valgrind4hpc',   package_versions )
# - Perftools
create_link_reg( 'perftools-base',           '/opt/cray/pe/modulefiles', 'Perftools',      package_versions )
# - PAPI
create_link_reg( 'papi',                     '/opt/cray/pe/modulefiles', 'PAPI',           package_versions )
# - LibSci
create_link_reg( 'cray-libsci',              '/opt/cray/pe/modulefiles', 'LibSci',         package_versions )
# - LibSci_acc
create_link_reg( 'cray-libsci_acc',          '/opt/cray/pe/modulefiles', 'LibSci_acc',     package_versions )
# - FFTW
create_link_reg( 'cray-fftw',                '/opt/cray/pe/modulefiles', 'FFTW',           package_versions )
# - craype
create_link_vpath( 'craype-x86-rome', '/opt/cray/pe/craype', 'modulefiles', 'craype', package_versions )
if system == 'grenoble':
    create_link_vpath( 'craype-network-ofi', '/opt/cray/pe/craype', 'modulefiles', 'craype', package_versions )
create_link_nover( 'craype-accel-amd-gfx908', '/opt/cray/pe/craype-targets/default/modulefiles' )
# - cpe-prgenv: cpe modules for Cray, GNU and AMD (when available)
create_link_vpath( 'cpe-cray', '/opt/cray/pe/cpe-prgenv', 'modules', 'cpe-prgenv', package_versions )
create_link_vpath( 'cpe-gnu',  '/opt/cray/pe/cpe-prgenv', 'modules', 'cpe-prgenv', package_versions )
#create_link_path( 'cpe-aocc', '/opt/cray/pe/cpe-prgenv', 'modules', 'cpe-prgenv', package_versions )
# - HDF5
create_link_reg( 'cray-hdf5',                '/opt/cray/pe/modulefiles', 'HDF5',            package_versions )
create_link_reg( 'cray-hdf5-parallel',       '/opt/cray/pe/modulefiles', 'HDF5',            package_versions )
# - NetCDF
create_link_reg( 'cray-netcdf',              '/opt/cray/pe/modulefiles', 'NetCDF',          package_versions )
create_link_reg( 'cray-netcdf-hdf5parallel', '/opt/cray/pe/modulefiles', 'NetCDF',          package_versions )
# - parallel-netCDF
create_link_reg( 'cray-parallel-netcdf',     '/opt/cray/pe/modulefiles', 'parallel-netCDF', package_versions )
# - iobuf
# - GCC
if 'GCC10' in package_versions:
    create_link_reg( 'gcc',                  '/opt/modulefiles',         'GCC10',           package_versions )
if 'GCC9'  in package_versions:
    create_link_reg( 'gcc',                  '/opt/modulefiles',         'GCC9',            package_versions )
if 'GCC8'  in package_versions:
    create_link_reg( 'gcc',                  '/opt/modulefiles',         'GCC8',            package_versions )
# - cray-python
# - cray-R
create_link_reg( 'cray-R',                   '/opt/modulefiles',         'cray-R',          package_versions )


