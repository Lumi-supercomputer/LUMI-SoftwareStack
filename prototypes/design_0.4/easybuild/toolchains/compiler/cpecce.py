##
# Copyright 2014-2020 Ghent University
#
# This file is part of EasyBuild,
# originally created by the HPC team of Ghent University (http://ugent.be/hpc/en),
# with support of Ghent University (http://ugent.be/hpc),
# the Flemish Supercomputer Centre (VSC) (https://www.vscentrum.be),
# Flemish Research Foundation (FWO) (http://www.fwo.be/en)
# and the Department of Economy, Science and Innovation (EWI) (http://www.ewi-vlaanderen.be/en).
#
# https://github.com/easybuilders/easybuild
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
Support for the CCCE (Cray Compiler Environment) compilers as a toolchain compiler
used via the Cray Programming Environment compiler drivers (aka cc, CC, ftn).

The basic concept is that the compiler driver knows how to invoke the true underlying
compiler with the compiler's specific options tuned to Cray systems.

That means that certain defaults are set that are specific to Cray's computers.

The compiler drivers are quite similar to EB toolchains as they include
linker and compiler directives to use the Cray libraries for their MPI (and network drivers)
Cray's LibSci (BLAS/LAPACK et al), FFT library, etc.

:author: Petar Forai (IMP/IMBA, Austria)
:author: Kenneth Hoste (Ghent University)
:author: Kurt Lust (University of Antwerpen)
"""
import copy

import easybuild.tools.environment as env
from easybuild.tools.build_log import EasyBuildError
from easybuild.tools.config import build_option
from easybuild.tools.toolchain.compiler import Compiler


TC_CONSTANT_CPE = "CPE"
TC_CONSTANT_CCE = "CCE"


class cpeCCE(Compiler):
    """Generic support for using Cray compiler drivers."""
    TOOLCHAIN_FAMILY = TC_CONSTANT_CPE

    # compiler module name is PrgEnv, suffix name depends on CrayPE flavor (gnu, intel, cray)
    COMPILER_MODULE_NAME = ['cpeCray']
    CRAYPE_MODULE_NAME = ['cpeCray']
    # compiler family depends on CrayPE flavor
    COMPILER_FAMILY = TC_CONSTANT_CCE

    COMPILER_UNIQUE_OPTS = {
        'dynamic':  (True, "Generate dynamically linked executable"),
        'mpich-mt': (False, "Directs the driver to link in an alternate version of the Cray-MPICH library which \
                             provides fine-grained multi-threading support to applications that perform \
                             MPI operations within threaded regions."),
    }

    COMPILER_UNIQUE_OPTION_MAP = {
        'i8': '-s integer64',
        'r8': '-s real64',
        # We cannot assign proper precision options for the Cray compilers as they differ
        # between their C/C++ and Fortran compilers.
        'strict': '',
        'precise': '',
        'defaultprec': '',
        'loose': '',
        'veryloose': '',
        # handle shared and dynamic always via $CRAYPE_LINK_TYPE environment variable, don't pass flags to wrapper
        'shared': '',
        'dynamic': '',
        'verbose': 'craype-verbose',
        'mpich-mt': 'craympich-mt',
    }

    COMPILER_CC  = 'cc'
    COMPILER_CXX = 'CC'
    COMPILER_C_UNIQUE_FLAGS = ['dynamic', 'mpich-mt']

    COMPILER_F77 = 'ftn'
    COMPILER_F90 = 'ftn'
    COMPILER_FC  = 'ftn'
    COMPILER_F_UNIQUE_FLAGS = ['dynamic', 'mpich-mt']

    def _set_optimal_architecture(self):
        """Load craype module specified via 'optarch' build option."""
        optarch = build_option('optarch')
        if optarch is None:
            raise EasyBuildError("Don't know which 'craype' module to load, 'optarch' build option is unspecified.")
        else:
            if self.modules_tool.exist(self.CRAYPE_MODULE_NAME, skip_avail=True)[0]:
                self.modules_tool.load(self.CRAYPE_MODULE_NAME)
            else:
                raise EasyBuildError("Necessary craype module with name '%s' is not available (optarch: '%s')",
                                     self.CRAYPE_MODULE_NAME[0], optarch)

        # no compiler flag when optarch toolchain option is enabled
        self.options.options_map['optarch'] = ''

    def prepare(self, *args, **kwargs):
        """Prepare to use this toolchain; define $CRAYPE_LINK_TYPE if 'dynamic' toolchain option is enabled."""
        super(cpeCCE, self).prepare(*args, **kwargs)

        if self.options['dynamic'] or self.options['shared']:
            self.log.debug("Enabling building of shared libs/dynamically linked executables via $CRAYPE_LINK_TYPE")
            env.setvar('CRAYPE_LINK_TYPE', 'dynamic')
