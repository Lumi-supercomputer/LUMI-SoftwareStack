##
# Copyright 2012-2023 Ghent University
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
EasyBlock for installing jaxlib, implemented as an easyblock

@author: Denis Kristak (INUITS)
@author: Alexander Grund (TU Dresden)
@author: Alex Domingo (Vrije Universiteit Brussel)
"""

import os
import re
import tempfile

from distutils.version import LooseVersion

import easybuild.tools.environment as env
from easybuild.easyblocks.generic.pythonpackage import PythonPackage
from easybuild.framework.easyconfig import CUSTOM
from easybuild.tools.build_log import EasyBuildError, print_warning
from easybuild.tools.filetools import apply_regex_substitutions, which, write_file
from easybuild.tools.modules import get_software_root, get_software_version


class EB_jaxlib(PythonPackage):
    """Support for installing jaxlib. Extension of the existing PythonPackage easyblock"""

    @staticmethod
    def extra_options():
        """Custom easyconfig parameters specific to jaxlib."""
        extra_vars = PythonPackage.extra_options()

        extra_vars['use_pip'][0] = True
        # Run custom build script and install the generated whl file
        extra_vars['buildcmd'][0] = '%(python)s build/build.py'
        extra_vars['install_src'][0] = 'dist/*.whl'

        # Custom parameters
        extra_vars.update({
            'use_mkl_dnn': [True, "Enable support for Intel MKL-DNN", CUSTOM],
            'binutils_root': [None, "Binutils prefix (specific to LUMI)", CUSTOM],
            'amdgpu_targets': [None, "AMD GPU targets to build for", CUSTOM],
        })

        return extra_vars

    def configure_step(self):
        """Custom configure step for jaxlib."""

        super(EB_jaxlib, self).configure_step()
        
        binutils_root = self.cfg['binutils_root']
        if binutils_root:
            oldpath = os.getenv('PATH')
            binutils_bin = os.path.join(binutils_root, 'bin')
            newpath = binutils_bin + ':' + oldpath if oldpath else binutils_bin

            config_env_vars = {
                'PATH': newpath,
                'GCC_HOST_COMPILER_PREFIX': binutils_bin,
            }

        else:
            binutils_root = get_software_root('binutils')
            if not binutils_root:
                raise EasyBuildError("Failed to determine installation prefix for binutils")
            config_env_vars = {
                # This is the binutils bin folder: https://github.com/tensorflow/tensorflow/issues/39263
                'GCC_HOST_COMPILER_PREFIX': os.path.join(binutils_root, 'bin'),
            }

        if 'CRAY_ACCEL_TARGET' in os.environ:
            cray_accel_target = os.getenv('CRAY_ACCEL_TARGET')
            tgt_matches = re.findall(r"gfx[0-9a-fA-F]+", cray_accel_target)
            tgt = tgt_matches[0] if len(tgt_matches) else None
            
            if tgt:
                if self.cfg['amdgpu_targets']:
                    if not tgt in self.cfg['amdgpu_targets']:
                        self.cfg['amdgpu_targets'] += [tgt]
                else:
                    self.cfg['amdgpu_targets'] = [tgt]
                
                self.log.info('amdgpu_targets set to %s using CRAY_ACCEL_TARGET' % self.cfg['amdgpu_targets'])

        # Collect options for the build script
        # Used only by the build script

        # C++ flags are set through copt below
        options = ['--target_cpu_features=default']

        # Passed directly to bazel
        bazel_startup_options = [
            '--output_user_root=%s' % tempfile.mkdtemp(suffix='-bazel', dir=self.builddir),
            '--host_jvm_args=-Xmx512m',
        ]

        # Passed to the build command of bazel
        bazel_options = [
            '--jobs=%s' % self.cfg['parallel'],
            '--subcommands',
            '--action_env=PYTHONPATH',
            '--action_env=EBPYTHONPREFIXES',
        ]
        if self.toolchain.options.get('debug', None):
            bazel_options.extend([
                '--strip=never',
                '--copt="-Og"'
            ])
        # Add optimization flags set by EasyBuild each as a separate option
        bazel_options.extend(['--copt=%s' % i for i in os.environ['CXXFLAGS'].split(' ')])

        cuda_root = get_software_root('CUDA')
        rocm_root = os.getenv('ROCM_PATH', None)
        if cuda_root:
            cudnn_root = get_software_root('cuDNN')
            if not cudnn_root:
                raise EasyBuildError('For CUDA-enabled builds cuDNN is also required')
            cuda_version = '.'.join(get_software_version('CUDA').split('.')[:2])  # maj.minor
            cudnn_version = '.'.join(get_software_version('cuDNN').split('.')[:3])  # maj.minor.patch
            options.extend([
                '--enable_cuda',
                '--cuda_path=' + cuda_root,
                '--cuda_compute_capabilities=' + self.cfg.get_cuda_cc_template_value('cuda_compute_capabilities'),
                '--cuda_version=' + cuda_version,
                '--cudnn_path=' + cudnn_root,
                '--cudnn_version=' + cudnn_version,
            ])

            if LooseVersion(self.version) >= LooseVersion('0.1.70'):
                nccl_root = get_software_root('NCCL')
                if nccl_root:
                    options.append('--enable_nccl')
                else:
                    options.append('--noenable_nccl')
            
            config_env_vars['GCC_HOST_COMPILER_PATH'] = which(os.getenv('CC'))
        elif rocm_root:
            options.extend([
                '--enable_rocm',
                '--rocm_path=' + os.path.realpath(rocm_root),
            ])
                        
            amdgpu_targets = self.cfg['amdgpu_targets']
            if amdgpu_targets:
                amdgpu_targets_list = ','.join(amdgpu_targets)
                options.append('--rocm_amdgpu_targets=' + amdgpu_targets_list)
                
                regex_subs = [
                    (r"TF_ROCM_AMDGPU_TARGETS=.*", "TF_ROCM_AMDGPU_TARGETS=\"%s\"" % amdgpu_targets_list),
                ]
                apply_regex_substitutions('.bazelrc', regex_subs)
                
                config_env_vars['TF_ROCM_AMDGPU_TARGETS'] = amdgpu_targets_list 
                config_env_vars['HIPCC_COMPILE_FLAGS_APPEND'] = ' '.join([f'--offload-arch={tgt}' for tgt in amdgpu_targets])
                
                # on Cray machine use the backend compiler instead of wrapper
                #if self.toolchain.toolchain_family() is 'CPE':
                if self.toolchain.toolchain_family() == toolchain.CPE:
                    gccprefix_vars = {'GCC': 'GCC_PREFIX', 'CCE': 'GCC_X86_64'}
                    
                    compfam = self.toolchain.comp_family()
                    if compfam in gccprefix_vars.keys():
                    	gccprefix = os.getenv(gccprefix_vars[compfam])
                    else:
                        raise EasyBuildError("Unsupported Programming environment")
                    
                    config_env_vars['GCC_HOST_COMPILER_PATH'] = os.path.join(gccprefix, 'bin/gcc')
                    bazel_options.append('--linkopt="-Wl,-rpath=/opt/cray/pe/gcc-libs"')
                else:
                    config_env_vars['GCC_HOST_COMPILER_PATH'] = which(os.getenv('CC'))

                bazel_options.append('--action_env=HIPCC_COMPILE_FLAGS_APPEND')

            #elif self.toolchain.toolchain_family() is 'CPE':
            elif self.toolchain.toolchain_family() == toolchain.CPE:
                print_warning("GPU target not set! Add craype-accel-amd-* module to the dependencies or load the partition/G module.")
        else:
            options.append('--noenable_cuda')

        if self.cfg['use_mkl_dnn']:
            options.append('--enable_mkl_dnn')
        else:
            options.append('--noenable_mkl_dnn')

        # Prepend to buildopts so users can overwrite this
        self.cfg['buildopts'] = ' '.join(
            options +
            ['--bazel_startup_options="%s"' % i for i in bazel_startup_options] +
            ['--bazel_options="%s"' % i for i in bazel_options] +
            [self.cfg['buildopts']]
        )

        for key, val in sorted(config_env_vars.items()):
            env.setvar(key, val)

        # Print output of build at the end
        apply_regex_substitutions('build/build.py', [(r'  shell\(command\)', '  print(shell(command))')])
