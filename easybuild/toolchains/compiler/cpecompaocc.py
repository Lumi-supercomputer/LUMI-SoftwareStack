##
# Copyright 2012-2020 Ghent University
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
Support for AOCC (AMD Optimizing C/C++ Compiler) as toolchain compiler used
via the Cray Programming Environment compiler drivers (aka cc, CC, ftn).

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
TC_CONSTANT_AOCC = "AOCC"


class cpeCompAOCC(Compiler):
    """AOCC support for using Cray compiler drivers"""
    TOOLCHAIN_FAMILY = TC_CONSTANT_CPE
    COMPILER_FAMILY = TC_CONSTANT_AOCC

    COMPILER_MODULE_NAME = ['cpeAOCC']
    CRAYPE_MODULE_NAME = ['cpeAOCC']

    COMPILER_FAMILY = TC_CONSTANT_AOCC

    COMPILER_UNIQUE_OPTS = {
        # AOCC-specific ones
        'loop-vectorize': (False, "Explicitly enable/disable loop vectorization"),
        'basic-block-vectorize': (False, "Explicitly enable/disable basic block vectorization"),
        'lto': (False, "Enable Link Time Optimization"),
        # Generic Cray options
        'dynamic': (True, "Generate dynamically linked executable"),
        'mpich-mt': (False, "Directs the driver to link in an alternate version of the Cray-MPICH library which \
                             provides fine-grained multi-threading support to applications that perform \
                             MPI operations within threaded regions."),
    }
    COMPILER_UNIQUE_OPTION_MAP = {
        'i8': 'fdefault-integer-8',
        'r8': 'fdefault-real-8',
        'lto': 'flto',
        'unroll': 'funroll-loops',
        'loop-vectorize': {False: 'fno-vectorize', True: 'f-vectorize' },
        'basic-block-vectorize': {False: 'no-slp-vectorize', True: 'fslp-vectorize' },
        'vectorize': {False: ['fno-vectorize', 'no-slp-vectorize'], True: ['f-vectorize', 'fslp-vectorize'] },
        # Clang's options do not map well onto these precision modes.  The flags enable and disable certain classes of
        # optimizations.
        #
        # -fassociative-math: allow re-association of operands in series of floating-point operations, violates the
        # ISO C and C++ language standard by possibly changing computation result.
        # -freciprocal-math: allow optimizations to use the reciprocal of an argument rather than perform division.
        # -fsigned-zeros: do not allow optimizations to treat the sign of a zero argument or result as insignificant.
        # -fhonor-infinities: disallow optimizations to assume that arguments and results are not +/- Infs.
        # -fhonor-nans: disallow optimizations to assume that arguments and results are not +/- NaNs.
        # -ffinite-math-only: allow optimizations for floating-point arithmetic that assume that arguments and results
        # are not NaNs or +-Infs (equivalent to -fno-honor-nans -fno-honor-infinities)
        # -funsafe-math-optimizations: allow unsafe math optimizations (implies -fassociative-math, -fno-signed-zeros,
        # -freciprocal-math).
        # -ffast-math: an umbrella flag that enables all optimizations listed above, provides preprocessor macro
        # __FAST_MATH__.
        #
        # Using -fno-fast-math is equivalent to disabling all individual optimizations, see
        # http://llvm.org/viewvc/llvm-project/cfe/trunk/lib/Driver/Tools.cpp?view=markup (lines 2100 and following)
        #
        # 'strict', 'precise' and 'defaultprec' are all ISO C++ and IEEE complaint, but we explicitly specify details
        # flags for strict and precise for robustness against future changes.
        'strict': ['ffp-model=strict'],
        'precise': ['ffp-model=precise'],
        'defaultprec': ['ffp-model=precise'],
        'loose': ['ffp-model=fast', 'fhonor-infinities', 'fhonor-nans', 'fsigned-zeros'],
        'veryloose': ['ffp-model=fast', 'funsafe-math-optimizations'],
        'ieee': '',
        # At optimzation level -O2 or above vectorisation is turned on by default so no need to turn it on
        # for DEFAULT_OPT_LEVEL as in the GCC compiler defintion.
        #
        # Generic Cray PE options
        'shared': '',
        'dynamic': '',
        'verbose': 'craype-verbose',
        'mpich-mt': 'craympich-mt',
    }

    # used when 'optarch' toolchain option is enabled (and --optarch is not specified)
    COMPILER_OPTIMAL_ARCHITECTURE_OPTION = {
        (systemtools.X86_64, systemtools.AMD): 'march=native',
        (systemtools.X86_64, systemtools.INTEL): 'march=native'
    }
    # used with --optarch=GENERIC
    COMPILER_GENERIC_OPTION = {
        (systemtools.X86_64, systemtools.AMD): 'march=x86-64 -mtune=generic',
        (systemtools.X86_64, systemtools.INTEL): 'march=x86-64 -mtune=generic',
    }

    COMPILER_CC = 'cc'
    COMPILER_CXX = 'CC'
    COMPILER_C_UNIQUE_FLAGS = ['dynamic', 'mpich-mt', 'loop-vectorize', 'basic-block-vectorize', 'lto']

    COMPILER_F77 = 'ftn'
    COMPILER_F90 = 'ftn'
    COMPILER_FC = 'ftn'
    COMPILER_F_UNIQUE_FLAGS = ['dynamic', 'mpich-mt', 'loop-vectorize', 'basic-block-vectorize', 'lto']

#    LIB_MULTITHREAD = ['pthread']
    LIB_MATH = ['m']

    # template for craype module (determines code generator backend of Cray compiler wrappers)
    CRAYPE_MODULE_NAME_TEMPLATE = 'craype-%(craype_mod)s'

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
        super(cpeCompAOCC, self).prepare(*args, **kwargs)

        if self.options['dynamic'] or self.options['shared']:
            self.log.debug("Enabling building of shared libs/dynamically linked executables via $CRAYPE_LINK_TYPE")
            env.setvar('CRAYPE_LINK_TYPE', 'dynamic')

