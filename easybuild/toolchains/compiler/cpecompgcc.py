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

from easybuild.tools.version import VERSION as EB_VERSION # Note that this is already a value that went through LooseVersion
from easybuild.tools import LooseVersion

import easybuild.tools.systemtools as systemtools
from easybuild.tools.build_log import EasyBuildError
from easybuild.tools.modules import get_software_root, get_software_version
from easybuild.tools.toolchain.compiler import Compiler, DEFAULT_OPT_LEVEL

import easybuild.tools.environment as env
from easybuild.tools.config import build_option


TC_CONSTANT_CPE = "CPE"
TC_CONSTANT_GCC = "GCC"


class cpeCompGCC(Compiler):
    """GCC support for using Cray compiler drivers."""
    TOOLCHAIN_FAMILY = TC_CONSTANT_CPE
    COMPILER_FAMILY = TC_CONSTANT_GCC

    COMPILER_MODULE_NAME = ['cpeGNU']
    CRAYPE_MODULE_NAME = ['cpeGNU']

    COMPILER_FAMILY = TC_CONSTANT_GCC

    COMPILER_UNIQUE_OPTS = {
        # Taken from GCC.
        'loop':             (False, "Automatic loop parallellisation"),
        'f2c':              (False, "Generate code compatible with f2c and f77"),
        'lto':              (False, "Enable Link Time Optimization"),
        # GCC-specific added ourselves
        'gfortran9-compat': (False, "Add Fortran compile flags that improve compatibility with gfortran 9 (for 10 and later)"),
        # Generic Cray options
        'dynamic':          (True,  "Generate dynamically linked executable"),
        'mpich-mt':         (False, "Directs the driver to link in an alternate version of the Cray-MPICH library which \
                                     provides fine-grained multi-threading support to applications that perform \
                                     MPI operations within threaded regions."),
    }

    if EB_VERSION < LooseVersion( '5.0.0' ):

        COMPILER_UNIQUE_OPTION_MAP = {
            # Taken from GCC
            'i8': 'fdefault-integer-8',
            'r8': 'fdefault-real-8',
            'unroll': 'funroll-loops',
            'f2c': 'ff2c',
            'loop': ['ftree-switch-conversion', 'floop-interchange', 'floop-strip-mine', 'floop-block'],
            'lto': 'flto',
            'gfortran9-compat': 'fallow-argument-mismatch',
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
        COMPILER_F_UNIQUE_FLAGS = ['dynamic', 'mpich-mt', 'loop', 'lto', 'f2c', 'gfortran9-compat']

        #LIB_MULTITHREAD = ['pthread']
        LIB_MATH = ['m']

    else:  # EasyBuild 5 or newer

        COMPILER_UNIQUE_OPTION_MAP = {
            # Taken from GCC
            'i8': '-fdefault-integer-8',
            'r8': '-fdefault-real-8',
            'unroll': '-funroll-loops',
            'f2c': '-ff2c',
            'loop': ['-ftree-switch-conversion', '-floop-interchange', '-floop-strip-mine', '-floop-block'],
            'lto': '-flto',
            'gfortran9-compat': '-fallow-argument-mismatch',
            'ieee': ['-mieee-fp', '-fno-trapping-math'],
            'strict': ['-mieee-fp', '-mno-recip'],
            'precise': ['-mno-recip'],
            'defaultprec': ['-fno-math-errno'],
            'loose': ['-fno-math-errno', '-mrecip', '-mno-ieee-fp'],
            'veryloose': ['-fno-math-errno', '-mrecip=all', '-mno-ieee-fp'],
            'vectorize': {False: '-fno-tree-vectorize', True: '-ftree-vectorize'},
            DEFAULT_OPT_LEVEL: ['-O2', '-ftree-vectorize'],
            # Generic Cray PE options
            'shared': '',
            'dynamic': '',
            'verbose': '-craype-verbose',
            'mpich-mt': '-craympich-mt',
        }

        # gcc on aarch64 does not support -mno-recip, -mieee-fp, -mfno-math-errno...
        # https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html
        if systemtools.get_cpu_architecture() == systemtools.AARCH64:
            no_recip_alternative = ['-mno-low-precision-recip-sqrt', '-mno-low-precision-sqrt', '-mno-low-precision-div']
            COMPILER_UNIQUE_OPTION_MAP['strict'] = no_recip_alternative
            COMPILER_UNIQUE_OPTION_MAP['precise'] = no_recip_alternative

        # used when 'optarch' toolchain option is enabled (and --optarch is not specified)
        COMPILER_OPTIMAL_ARCHITECTURE_OPTION = {
            (systemtools.AARCH64, systemtools.ARM): '-mcpu=native',  # since GCC 6; implies -march=native and -mtune=native
            (systemtools.X86_64, systemtools.AMD): '-march=native',  # implies -mtune=native
            (systemtools.X86_64, systemtools.INTEL): '-march=native',  # implies -mtune=native
        }
        # used with --optarch=GENERIC
        COMPILER_GENERIC_OPTION = {
            (systemtools.AARCH64, systemtools.ARM): '-mcpu=generic',       # implies -march=armv8-a and -mtune=generic
            (systemtools.X86_64, systemtools.AMD): '-march=x86-64 -mtune=generic',
            (systemtools.X86_64, systemtools.INTEL): '-march=x86-64 -mtune=generic',
        }

        COMPILER_CC = 'cc'
        COMPILER_CXX = 'CC'
        COMPILER_C_UNIQUE_OPTIONS = ['dynamic', 'mpich-mt', 'loop', 'lto']

        COMPILER_F77 = 'ftn'
        COMPILER_F90 = 'ftn'
        COMPILER_FC = 'ftn'
        COMPILER_F_UNIQUE_OPTIONS = ['dynamic', 'mpich-mt', 'loop', 'lto', 'f2c', 'gfortran9-compat']

        #LIB_MULTITHREAD = ['pthread']
        LIB_MATH = ['m']

    # Back to common code for EasyBuild 4 and 5

    # template for craype module (determines code generator backend of Cray compiler wrappers)
    CRAYPE_MODULE_NAME_TEMPLATE = 'craype-%(craype_mod)s'

    def _set_compiler_vars(self):
        super(cpeCompGCC, self)._set_compiler_vars()

        if self.options.get('32bit', None):
            raise EasyBuildError("_set_compiler_vars: 32bit set, but not supported by the Cray PE")

        # to get rid of lots of problems with libgfortranbegin
        # or remove the system gcc-gfortran
        # also used in eg LIBBLAS variable
        # self.variables.nappend('FLIBS', "gfortran", position=5)


    def _set_optimal_architecture(self):
        """
        Load craype modules specified via 'optarch' build option.

        Several forms of optarch are recognized:
          * --optarch=<CPE options>
          * --optarch=CPE:<CPE options>;<other compilers>
          * --optarch=GENERIC is recognized but unsupported as it is not clear which targets
            are safe to chose. There doesn't seem to be an equivalent of a generic target on
            most systems.

        <CPE options> is one or more Cray targetting module names, omitting craype- from the
        name, and separated by a +. E.g., x86-rome+accel-amd-gfx908+network-ofi. These will
        overload those from the toolchain module.
        """
        optarch = build_option('optarch')
        if optarch is not None and isinstance(optarch, dict ):
            if TC_CONSTANT_CPE in optarch:
                optarch = optarch[TC_CONSTANT_CPE]
            else:
                optarch = None
                self.log.info("_set_optimal_architecture: no optarch found for compiler %s. Ignoring option.",
                              TC_CONSTANT_CPE)

        if optarch is None:
            self.log.info("The 'optarch' build option is unspecified so I am assuming the right targeting modules are loaded by the %s module."
                          % self.CRAYPE_MODULE_NAME[0])
        elif optarch == 'GENERIC':
            raise EasyBuildError("GENERIC is not yet supported as an 'optarch'.")
        else:
            for craype_mod in optarch.split('+'):
                craype_mod_name = self.CRAYPE_MODULE_NAME_TEMPLATE % {'craype_mod': craype_mod}
                if self.modules_tool.exist([craype_mod_name], skip_avail=True)[0]:
                    self.modules_tool.load([craype_mod_name])
                else:
                    raise EasyBuildError("Necessary craype module with name '%s' is not available (optarch: '%s')",
                                         craype_mod_name, optarch)

        # no compiler flag when optarch toolchain option is enabled
        self.options.options_map['optarch'] = ''

    def prepare(self, *args, **kwargs):
        """Prepare to use this toolchain; define $CRAYPE_LINK_TYPE if 'dynamic' toolchain option is enabled."""
        super(cpeCompGCC, self).prepare(*args, **kwargs)

        if self.options['dynamic'] or self.options['shared']:
            self.log.debug("Enabling building of shared libs/dynamically linked executables via $CRAYPE_LINK_TYPE")
            env.setvar('CRAYPE_LINK_TYPE', 'dynamic')

