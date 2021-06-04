#! /usr/bin/env python3

from lumitools.CPE_to_EB import CPE_to_EB
import sys

package_versions = {
    '21.G.02': {
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
        'craypkg-gen':     '1.3.13',
        'craype-targets':  '1.2.0',
        'craype':          '2.7.5',
        'cpe-prgenv':      '8.0.0',
        'Cray-lmod':       '8.3.1.0',
        'HDF5':            '1.12.0.2', # Not the standard version for 21.02!
        'NetCDF':          '4.7.4.2',  # Not the standard version for 21.02!
        'parallel-netCDF': '1.12.1.1', # Not the standard version for 21.02!
        'iobuf':           '2.0.10',
        'GCC10':           '10.2.0',
        'GCC9':            '9.3.0',
        'GCC8':            '8.1.0',
        'GCC':             '9.3.0',     # The one loaded by the cpe module
        'cray-python':     '3.8.5.0',
        'cray-R':          '4.0.3.0',
        'libfabric':       '1.10.2pre1',
        'rocm':            'rocm',
    },
    '21.G.04': {
        'CCE':             '11.0.4',
        'MPICH':           '8.1.4',
        'DSMML':           '0.1.1', # Not the standard version for 21.02!
        'PMI':             '6.0.10',
        'OpenSHMEMX':      '11.1.0.beta',
        'ATP':             '3.13.1', # Not the standard version for 21.02!
        'CCDB':            '4.11.1',
        'CTI':             '2.13.5', # Not the standard version for 21.02!
        'gdb4hpc':         '4.11.5',
        'STAT':            '4.7.1',
        'valgrind4hpc':    '2.10.3', # Not the standard version for 21.02!
        'Perftools':       '21.02.0',
        'PAPI':            '6.0.0.6',
        'LibSci':          '21.04.1.1',
        'LibSci_acc':      '21.02.9.1',
        'FFTW':            '3.3.8.8', # Not the standard version for 21.02!
        'craypkg-gen':     '1.3.14',
        'craype-targets':  '1.3.0',
        'craype':          '2.7.6',
        'cpe-prgenv':      '8.0.0',
        'Cray-lmod':       '8.3.1.0',
        'HDF5':            '1.12.0.2', # Not the standard version for 21.02!
        'NetCDF':          '4.7.4.2',  # Not the standard version for 21.02!
        'parallel-netCDF': '1.12.1.1', # Not the standard version for 21.02!
        'iobuf':           '2.0.10',
        'GCC10':           '10.2.0',
        'GCC9':            '9.3.0',
        'GCC8':            '8.1.0',
        'GCC':             '9.3.0',     # The one loaded by the cpe module
        'cray-python':     '3.8.5.0',
        'cray-R':          '4.0.3.0',
        'libfabric':       '1.10.2pre1',
        'rocm':            'rocm',
    },
    '21.04': {
        'CCE':             '11.0.4',
        'MPICH':           '8.1.4',
        'DSMML':           '0.1.4',
        'PMI':             '6.0.10',
        'OpenSHMEMX':      '11.2.0',
        'ATP':             '3.13.1',
        'CCDB':            '4.11,1',
        'CTI':             '2.13.6',
        'gdb4hpc':         '4.12.5',
        'STAT':            '4.10.1',
        'valgrind4hpc':    '2.11.1',
        'Perftools':       '21.02.0',
        'PAPI':            '6.0.0.6',
        'LibSci':          '21.04.1.1',
#        'LibSci_acc':      '21.02.9.1',
        'FFTW':            '3.3.8.9',
        'craypkg-gen':     '1.3.14',
#        'craype-targets':  '1.2.0',
        'craype':          '2.7.6',
        'cpe-prgenv':      '8.0.0',
        'Cray-lmod':       '8.3.1.0',
        'HDF5':            '1.12.0.3',
        'NetCDF':          '4.7.4.3',  # CHECK: Mistake on my side or different in Cray documents (4.7.4.2)
        'parallel-netCDF': '1.12.1.3',
        'iobuf':           '2.0.10',
        'GCC10':           '10.2.0',
        'GCC9':            '9.3.0',
        'GCC8':            '8.1.0',
        'GCC':             '9.3.0',     # The one loaded by the cpe module
        'cray-python':     '3.8.5.0',
        'cray-R':          '4.0.3.0',
        'libfabric':       '1.10.2pre1',
# Nonstandard ones or not in the PE list
        'AOCC':            '2.2.0.1',
        'pmi':             '6.0.10',
        'Slurm':           '.default',
    },
}

EBconfigdir = sys.argv[1]
PEversion   = sys.argv[2]

#
# Execute the command
#
CPE_to_EB( EBconfigdir, PEversion, package_versions[PEversion] )
