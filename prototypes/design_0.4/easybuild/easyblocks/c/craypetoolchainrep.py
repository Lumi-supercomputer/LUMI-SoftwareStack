##
# Copyright 2015-2020 Ghent University
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
EasyBuild support for installing Cray cpe toolchains, implemented as an easyblock

@author: Kenneth Hoste (Ghent University)
@author: Guilherme Peretti Pezzi (CSCS)
@author: Petar Forai (IMP/IMBA)
#author: Kurt Lust (University of Antwerp and LUMI)
"""

from easybuild.easyblocks.generic.bundle import Bundle
from easybuild.tools.build_log import EasyBuildError
from easybuild.framework.easyconfig import CUSTOM, MANDATORY
from easybuild.tools.build_log import print_error, print_msg, print_warning

# Supported programming environments
KNOWN_PRGENVS = ['PrgEnv-aocc', 'PrgEnv-cray', 'PrgEnv-gnu', 'PrgEnv-intel']
# Mapping from supported toolchain modules to PrgEnv-* modules
MAP_TOOLCHAIN_PRGENV = {
    'cpeCray':  'cray',
    'cpeGNU':   'gnu',
    'cpeAMD':   'aocc',
    'cpeIntel': 'intel',
}
# Mapping from supported toolchain modules to compiler modules.
MAP_TOOLCHAIN_COMPILER = {
    'cpeCray':  'cce',
    'cpeGNU':   'gcc',
    'cpeAMD':   'aocc',
    'cpeIntel': 'intel',
}


class CrayPEToolchainRep(Bundle):
    """
    Compiler toolchain: generate module file only, nothing to build/install
    """
    @staticmethod
    def extra_options():
        """Custom easyconfig parameters for CrayPEToolchainRep"""
        extra_vars = {
            'PrgEnv': [None, "PrgEnv module to emulate, e.g., cray to load PrgEnv-cray, or None for automatic determination", CUSTOM],
            'cray_targets': [[], "Targetting modules to load", CUSTOM],
            #'optional_example_param': [None, "Example optional custom parameter", CUSTOM],
        }
        return Bundle.extra_options(extra_vars)

    def prepare_step(self, *args, **kwargs):
        """Prepare build environment (skip loaded of dependencies)."""

        kwargs['load_tc_deps_modules'] = False

        super(CrayPEToolchainRep, self).prepare_step(*args, **kwargs)

    def make_module_dep(self):
        """
        Generate load/swap statements for the module file
        """

        # Determine the PrgEnv module to emulate
        if self.cfg['PrgEnv'] is None:
            try:
                prgenv_mod = MAP_TOOLCHAIN_PRGENV[self.cfg['name']]
            except:
                raise EasyBuildError('%s is not a supported toolchain, you\'ll need to specify both PrgEnv and CPE_compiler.',
                                     self.cfg['name'])
        else:
            prgenv_mod = self.cfg['PrgEnv']
            if not 'PrgEnv-' + prgenv_mod in KNOWN_PRGENVS:
                print_warning('PrgEnv-%s is not a supported PrgEnv module. Are you sure it is not a typo?', prgenv_mod)

        self.log.debug("Emulating PrgEnv-module: %s", prgenv_mod)

        family = [ 'family(\'PrgEnv\')', '' ]

        # Prepare the load statements for the targeting modules
        targets_load = []
        for dep in self.cfg['cray_targets']:
            targets_load.append(self.module_generator.load_module(dep, recursive_unload=False).lstrip())

        self.log.debug("Load statements for targeting modules:%s", targets_load)

        # collect 'load' statements for dependencies
        deps_load = []
        for dep in self.toolchain.dependencies:
            mod_name = dep['full_mod_name']
            deps_load.append(self.module_generator.load_module(mod_name).lstrip())

        self.log.debug("Swap statements for dependencies of %s: %s", self.full_mod_name, deps_load)

        # Set an environment variable that would otherwise be set by PrgEnv.
        env_set = self.module_generator.set_environment('PE_ENV', prgenv_mod.upper(), False)

        # Assemble all module unload/load statements.
        txt = '\n'.join(family + targets_load + deps_load + [env_set])
        return txt
