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
Support for AOCC (AMD Optimizing C/C++ Compiler) as toolchain compiler.

:author: Stijn De Weirdt (Ghent University)
:author: Kenneth Hoste (Ghent University)
:author: Kurt Lust (University of Antwerpen)
"""

import re
from distutils.version import LooseVersion

import easybuild.tools.systemtools as systemtools
from easybuild.tools.build_log import EasyBuildError
from easybuild.tools.modules import get_software_root, get_software_version
from easybuild.tools.toolchain.compiler import Compiler, DEFAULT_OPT_LEVEL


TC_CONSTANT_AOCC = "AOCC"


class Aocc(Compiler):
    """AOCC compiler class"""

    COMPILER_MODULE_NAME = ['AOCC']

    COMPILER_FAMILY = TC_CONSTANT_AOCC
    COMPILER_UNIQUE_OPTS = {
        'loop-vectorize': (False, "Explicitly enable/disable loop vectorization"),
        'basic-block-vectorize': (False, "Explicitly enable/disable basic block vectorization"),
        'lto': (False, "Enable Link Time Optimization"),
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

    COMPILER_CC = 'clang'
    COMPILER_CXX = 'clang++'
    COMPILER_C_UNIQUE_FLAGS = []

    COMPILER_F77 = 'flang'
    COMPILER_F90 = 'flang'
    COMPILER_FC = 'flang'
    COMPILER_F_UNIQUE_FLAGS = []

    LIB_MULTITHREAD = ['pthread']
    LIB_MATH = ['m']

    def _set_compiler_vars(self):
        super(Aocc, self)._set_compiler_vars()

        if not ('aocc' in self.COMPILER_MODULE_NAME):
            raise EasyBuildError("_set_compiler_vars: missing aocc from COMPILER_MODULE_NAME %s",
                                 self.COMPILER_MODULE_NAME)

        aocc_root = get_software_root('AOCC')
        if gcc_root is None:
            raise EasyBuildError("Failed to determine software root for AOCC")

        # append lib dir paths to LDFLAGS (only if the paths are actually there)
        self.variables.append_subdirs("LDFLAGS", aocc_root, subdirs=["lib64", "lib"])

    def _set_optimal_architecture(self, default_optarch=None):
        """
        AOCC-specific adjustments for optimal architecture flags.

        :param default_optarch: default value to use for optarch, rather than using default value based on architecture
                                (--optarch and --optarch=GENERIC still override this value)
        """
        if default_optarch is None and self.arch == systemtools.AARCH64:
            aocc_version = get_software_version('AOCC')
            if aocc_version is None:
                raise EasyBuildError("Failed to determine software version for AOCC")

        super(Aocc, self)._set_optimal_architecture(default_optarch=default_optarch)
