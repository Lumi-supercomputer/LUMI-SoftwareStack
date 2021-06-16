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
"""

from easybuild.easyblocks.generic.bundle import Bundle
from easybuild.tools.build_log import EasyBuildError
from easybuild.framework.easyconfig import CUSTOM, MANDATORY

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


class CrayPEToolchain(Bundle):
    """
    Compiler toolchain: generate module file only, nothing to build/install
    """
    @staticmethod
    def extra_options():
        """Custom easyconfig parameters for CrayPEToolchain"""
        extra_vars = {
            'PrgEnv': [None, "PrgEnv module to load, e.g., cray to load PrgEnv-cray, or None for automatic determination", CUSTOM],
            'CPE_compiler': [None, "Compiler module to load, or None for automatic determination", CUSTOM],
            'CPE_version': [None, "Version of the CPE, if different from the version of the module", CUSTOM],
            'cray_targets': [[], "Targetting modules to load", CUSTOM],
            #'optional_example_param': [None, "Example optional custom parameter", CUSTOM],
        }
        return Bundle.extra_options(extra_vars)

    def prepare_step(self, *args, **kwargs):
        """Prepare build environment (skip loaded of dependencies)."""

        kwargs['load_tc_deps_modules'] = False

        super(CrayPEToolchain, self).prepare_step(*args, **kwargs)

    def make_module_dep(self):
        """
        Generate load/swap statements for the module file
        """

        # Determine the PrgEnv module
        if self.cfg['PrgEnv'] is None:
            prgenv_mod = 'PrgEnv-' + MAP_TOOLCHAIN_PRGENV[self.cfg['name']]
        else:
            prgenv_mod = 'PrgEnv-' + self.cfg['PrgEnv']

        self.log.debug("Detected PrgEnv-module: %s", prgenv_mod)

        if prgenv_mod is None:
            raise EasyBuildError("Could not find a PrgEnv-* module listed as dependency: %s",
                                 self.toolchain.dependencies)

        # unload statements for other PrgEnv modules
        prgenv_unloads = ['']
        for prgenv in [prgenv for prgenv in KNOWN_PRGENVS if not prgenv_mod.startswith(prgenv)]:
            prgenv_unloads.append(self.module_generator.unload_module(prgenv).strip())

        # load statement for selected PrgEnv module (only when not loaded yet)
        prgenv_load = self.module_generator.load_module(prgenv_mod, recursive_unload=False)

        # Prepare the load statements for the targeting modules
        targets_load = []
        for dep in self.cfg['cray_targets']:
            targets_load.append(self.module_generator.load_module(dep, recursive_unload=False).lstrip())

        self.log.debug("Load statements for targeting modules:%s", targets_load)

        # Determine the compiler module
        if self.cfg['CPE_compiler'] in [ None, 'auto']:
            compiler_mod = MAP_TOOLCHAIN_COMPILER[self.cfg['name']]
        else:
            compiler_mod = self.cfg['CPE_compiler']

        self.log.debug("Loading compiler module: %s", compiler_mod)

        # load statement for the selected compiler module
        compiler_load = self.module_generator.load_module(compiler_mod, recursive_unload=False).lstrip()

        # Load the Cray compiler wrapper module
        wrapper_load = self.module_generator.load_module('craype', recursive_unload=False).lstrip()

        # collect 'load' statements for dependencies
        deps_load = []
        for dep in self.toolchain.dependencies:
            mod_name = dep['full_mod_name']
            deps_load.append(self.module_generator.load_module(mod_name).lstrip())

        self.log.debug("Swap statements for dependencies of %s: %s", self.full_mod_name, deps_load)

        # Finally load the cpe module
        if self.cfg['CPE_version'] is None:
            cpe_load_version = self.cfg['version']
        else:
            cpe_load_version = self.cfg['CPE_version']

        self.log.debug("Loading CPE version: %s", cpe_load_version)

        cpe_load = self.module_generator.load_module('cpe/' + cpe_load_version, recursive_unload=False).lstrip()

        # Assemble all module unload/load statements.
        txt = '\n'.join(prgenv_unloads + [prgenv_load] + targets_load + [compiler_load] + [wrapper_load] + deps_load + [cpe_load])
        return txt
