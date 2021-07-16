##
# Copyright 2012-2021 Ghent University
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
Support for GCC (GNU Compiler Collection) as toolchain compiler used via the
Cray Programming Environment compiler drivers (aka cc, CC, ftn).

The basic concept is that the compiler driver knows how to invoke the true underlying
compiler with the compiler's specific options tuned to Cray systems.

That means that certain defaults are set that are specific to Cray's computers.

The compiler drivers are quite similar to EB toolchains as they include
linker and compiler directives to use the Cray libraries for their MPI (and network drivers)
Cray's LibSci (BLAS/LAPACK et al), FFT library, etc.

:author: Stijn De Weirdt (Ghent University)
:author: Kenneth Hoste (Ghent University)
:author: Petar Forai (IMP/IMBA, Austria)
:author: Kurt Lust (University of Antwerpen)
"""

import re
from distutils.version import LooseVersion

import easybuild.tools.systemtools as systemtools
from easybuild.tools.build_log import EasyBuildError
from easybuild.tools.modules import get_software_root, get_software_version
from easybuild.tools.toolchain.compiler import Compiler, DEFAULT_OPT_LEVEL

import easybuild.tools.environment as env
from easybuild.tools.config import build_option


TC_CONSTANT_CPE = "CPE"
TC_CONSTANT_GCC = "GCC"


class cpeGCC(Compiler):
    """GCC support for using Cray compiler drivers."""
    TOOLCHAIN_FAMILY = TC_CONSTANT_CPE
    COMPILER_FAMILY = TC_CONSTANT_GCC

    COMPILER_MODULE_NAME = ['cpeGNU']
    CRAYPE_MODULE_NAME = ['cpeGNU']

    COMPILER_FAMILY = TC_CONSTANT_GCC

    COMPILER_UNIQUE_OPTS = {
        # Taken from GCC.
        'loop': (False, "Automatic loop parallellisation"),
        'f2c': (False, "Generate code compatible with f2c and f77"),
        'lto': (False, "Enable Link Time Optimization"),
        # Generic Cray options
        'dynamic': (True, "Generate dynamically linked executable"),
        'mpich-mt': (False, "Directs the driver to link in an alternate version of the Cray-MPICH library which \
                             provides fine-grained multi-threading support to applications that perform \
                             MPI operations within threaded regions."),
    }
    COMPILER_UNIQUE_OPTION_MAP = {
        # Taken from GCC
        'i8': 'fdefault-integer-8',
        'r8': 'fdefault-real-8',
        'unroll': 'funroll-loops',
        'f2c': 'ff2c',
        'loop': ['ftree-switch-conversion', 'floop-interchange', 'floop-strip-mine', 'floop-block'],
        'lto': 'flto',
        'ieee': ['mieee-fp', 'fno-trapping-math'],
        'strict': ['mieee-fp', 'mno-recip'],
        'precise': ['mno-recip'],
        'defaultprec': ['fno-math-errno'],
        'loose': ['fno-math-errno', 'mrecip', 'mno-ieee-fp'],
        'veryloose': ['fno-math-errno', 'mrecip=all', 'mno-ieee-fp'],
        'vectorize': {False: 'fno-tree-vectorize', True: 'ftree-vectorize'},
        DEFAULT_OPT_LEVEL: ['O2', 'ftree-vectorize'],
        # Generic Cray PE options
        'shared': '',
        'dynamic': '',
        'verbose': 'craype-verbose',
        'mpich-mt': 'craympich-mt',
    }

    # gcc on aarch64 does not support -mno-recip, -mieee-fp, -mfno-math-errno...
    # https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html
    if systemtools.get_cpu_architecture() == systemtools.AARCH64:
        no_recip_alternative = ['mno-low-precision-recip-sqrt', 'mno-low-precision-sqrt', 'mno-low-precision-div']
        COMPILER_UNIQUE_OPTION_MAP['strict'] = no_recip_alternative
        COMPILER_UNIQUE_OPTION_MAP['precise'] = no_recip_alternative

    # used when 'optarch' toolchain option is enabled (and --optarch is not specified)
    COMPILER_OPTIMAL_ARCHITECTURE_OPTION = {
        (systemtools.AARCH64, systemtools.ARM): 'mcpu=native',  # since GCC 6; implies -march=native and -mtune=native
        (systemtools.X86_64, systemtools.AMD): 'march=native',  # implies -mtune=native
        (systemtools.X86_64, systemtools.INTEL): 'march=native',  # implies -mtune=native
    }
    # used with --optarch=GENERIC
    COMPILER_GENERIC_OPTION = {
        (systemtools.AARCH64, systemtools.ARM): 'mcpu=generic',       # implies -march=armv8-a and -mtune=generic
        (systemtools.X86_64, systemtools.AMD): 'march=x86-64 -mtune=generic',
        (systemtools.X86_64, systemtools.INTEL): 'march=x86-64 -mtune=generic',
    }

    COMPILER_CC = 'cc'
    COMPILER_CXX = 'CC'
    COMPILER_C_UNIQUE_FLAGS = ['dynamic', 'mpich-mt', 'loop', 'lto']

    COMPILER_F77 = 'ftn'
    COMPILER_F90 = 'ftn'
    COMPILER_FC = 'ftn'
    COMPILER_F_UNIQUE_FLAGS = ['dynamic', 'mpich-mt', 'loop', 'lto', 'f2c']

#    LIB_MULTITHREAD = ['pthread']
    LIB_MATH = ['m']

    def _set_compiler_vars(self):
        super(cpeGCC, self)._set_compiler_vars()

        if self.options.get('32bit', None):
            raise EasyBuildError("_set_compiler_vars: 32bit set, but not supported by the Cray PE")

        # to get rid of lots of problems with libgfortranbegin
        # or remove the system gcc-gfortran
        # also used in eg LIBBLAS variable
        # self.variables.nappend('FLIBS', "gfortran", position=5)


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
        super(cpeGCC, self).prepare(*args, **kwargs)

        if self.options['dynamic'] or self.options['shared']:
            self.log.debug("Enabling building of shared libs/dynamically linked executables via $CRAYPE_LINK_TYPE")
            env.setvar('CRAYPE_LINK_TYPE', 'dynamic')

