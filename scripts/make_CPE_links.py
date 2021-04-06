#! /bin/env python3

from lumitools.make_CPE import make_CPE
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
# Execute the command
#
make_CPE( moduleroot, system, package_versions )
