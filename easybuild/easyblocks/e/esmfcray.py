##
# Copyright 2013 Ghent University
#
# This file is part of EasyBuild,
# originally created by the HPC team of Ghent University (http://ugent.be/hpc/en),
# with support of Ghent University (http://ugent.be/hpc),
# the Flemish Supercomputer Centre (VSC) (https://vscentrum.be/nl/en),
# the Hercules foundation (http://www.herculesstichting.be/in_English)
# and the Department of Economy, Science and Innovation (EWI) (http://www.ewi-vlaanderen.be/en).
#
# http://github.com/hpcugent/easybuild
#
# EasyBuild is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation v2.
#
# EasyBuild is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with EasyBuild.  If not, see <http://www.gnu.org/licenses/>.
##
"""
EasyBuild support for building and installing ESMF, implemented as an easyblock
Adapted for Cray system

@author: Kenneth Hoste (Ghent University)
@author: Kurt Lust (University of Antwerp and LUMI User Support Team)
"""
import os

import easybuild.tools.environment as env
import easybuild.tools.toolchain as toolchain
from easybuild.easyblocks.generic.configuremake import ConfigureMake
from easybuild.framework.easyblock import EasyBlock
from easybuild.framework.easyconfig import CUSTOM
from easybuild.tools.build_log import EasyBuildError
from easybuild.tools.modules import get_software_root
from easybuild.tools.run import run_cmd
from easybuild.tools.systemtools import get_shared_lib_ext


class esmfcray(ConfigureMake):
    """Support for building/installing ESMF."""

    @staticmethod
    def extra_options():
        """Add extra easyconfig parameters for ESMF."""
        extra_vars = {
            'mpicomm':  [None, "Set MPI communicator (ESMF_COMM)", CUSTOM],
            'usepio':   [None, "Use PIO - internal, external, OFF or None (ESMF_PIO)", CUSTOM],
            'optlevel': [None, "Debug build or optimisation level: g, 0-4 (ESMF_BOPT and ESMF_OPTLEVEL)", CUSTOM]
        }
        return EasyBlock.extra_options(extra_vars)

    def configure_step(self):
        """Custom configuration procedure for ESMF through environment variables."""

        env.setvar('ESMF_DIR', self.cfg['start_dir'])
        env.setvar('ESMF_INSTALL_PREFIX', self.installdir)
        env.setvar('ESMF_INSTALL_BINDIR', 'bin')
        env.setvar('ESMF_INSTALL_LIBDIR', 'lib')
        env.setvar('ESMF_INSTALL_MODDIR', 'mod')

        # specify compiler
        toolchain_family = self.toolchain.toolchain_family()
        comp_family = self.toolchain.comp_family()
        if toolchain_family in [toolchain.CPE]:
            # Cray systems have a separate configuration in ESMF. gfortran, cce and aocc are 
            # among the supported values for ESMF_COMPILER.
            # This will also ensure that ESMF_PREPROCESSOR, ESMF_*COMPILER and ESMF_*LINKER
            # will be set automatically.
            env.setvar('ESMF_OS', 'Unicos')
            self.log.info( "CPE toolchains detected, setting ESMF_OS to Unicos for Cray-specific configuration" )
            # Note: With the current supported toolchains GCC, CCE and AOCC, the generic code 
            # for non-Cray systems also works, so we could simplify, but this may be more
            # future-proof.
            if comp_family in [toolchain.GCC]:
                compiler = 'gfortran'
            elif comp_family in [toolchain.CCE]:
                compiler = 'cce'
            elif comp_family in [toolchain.AOCC]:
                compiler = 'aocc'
            else:
                raise EasyBuildError( "Unsupported CPE toolchain commpiler family %s", comp_family )
        else:
            if comp_family in [toolchain.GCC]:
                compiler = 'gfortran'
            else:
                compiler = comp_family.lower()
        env.setvar('ESMF_COMPILER', compiler)
        
        # Build type and optimisation level
        optlevel = self.cfg.get('optlevel', default=None)
        if not optlevel is None:
            if optlevel.lower() == 'g':
                env.setvar('ESMF_BOPT', 'g')
            else:
                env.setvar('ESMF_BOPT', 'O')
                env.setvar('ESMF_OPTLEVEL', optlevel)
        
        # specify MPI communications library
        if self.cfg.get('mpicomm', None):
            comm = self.cfg['mpicomm']
        else:
            mpi_family = self.toolchain.mpi_family()
            if mpi_family in [toolchain.MPICH, toolchain.QLOGICMPI]:
                # MPICH family for MPICH v3.x, which is MPICH2 compatible
                comm = 'mpich2'
            else:
                comm = mpi_family.lower()
        env.setvar('ESMF_COMM', comm)

        # specify decent LAPACK lib
        env.setvar('ESMF_LAPACK', 'user')
        env.setvar('ESMF_LAPACK_LIBS', '%s %s' % (os.getenv('LDFLAGS'), os.getenv('LIBLAPACK_MT')))

        # specify netCDF
        netcdf = get_software_root('netCDF')
        if netcdf:
            env.setvar('ESMF_NETCDF', 'user')
            netcdf_libs = ['-L%s/lib' % netcdf, '-lnetcdf']

            # Fortran
            netcdff = get_software_root('netCDF-Fortran')
            if netcdff:
                netcdf_libs = ["-L%s/lib" % netcdff] + netcdf_libs + ["-lnetcdff"]
            else:
                netcdf_libs.append('-lnetcdff')

            # C++
            netcdfcxx = get_software_root('netCDF-C++')
            if netcdfcxx:
                netcdf_libs = ["-L%s/lib" % netcdfcxx] + netcdf_libs + ["-lnetcdf_c++4"]
            else:
                netcdf_libs.append('-lnetcdf_c++4')

            env.setvar('ESMF_NETCDF_LIBS', ' '.join(netcdf_libs))
            
        # specify PIO
        if not self.cfg.get('usepio', default=None) is None:
            env.setvar('ESMF_PIO', self.cfg['usepio'])

        # 'make info' provides useful debug info
        cmd = ' '.join( [ self.cfg['preconfigopts'], 'make info'] )
        run_cmd(cmd, log_all=True, simple=True, log_ok=True)

    def sanity_check_step(self):
        """Custom sanity check for ESMF."""
        shlib_ext = get_shared_lib_ext()

        custom_paths = {
            'files':
                [os.path.join('bin', x) for x in ['ESMF_PrintInfo', 'ESMF_PrintInfoC', 'ESMF_RegridWeightGen', 'ESMF_WebServController']] +
                [os.path.join('lib', x) for x in ['libesmf.a', 'libesmf.%s' % shlib_ext]],
            'dirs': ['include', 'mod'],
        }

        super(esmfcray, self).sanity_check_step(custom_paths=custom_paths)
