import os
import re
import stat

from easybuild.easyblocks.generic.bundle import Bundle
from easybuild.tools.build_log import EasyBuildError
from easybuild.tools.filetools import download_file, mkdir, write_file, read_file, symlink, adjust_permissions, apply_regex_substitutions
from easybuild.tools.systemtools import get_shared_lib_ext
from easybuild.tools.run import run_cmd
from easybuild.framework.easyconfig import CUSTOM

try:
    from easybuild.tools import LooseVersion
except ImportError:
    from distutils.version import LooseVersion

class EB_rocmrpms(Bundle):

    def _process_index(self, index_content):
        """
        Parse the index file content. What is does is extract the RPM file name,
        name and version of the package
        """
        rpm_regex = r'<a href=\"(.*.rpm)\">.*'
        version_regex = r'\s*([\d.]+(%s|-sles[\d]+))' % self.version.replace('.', '0')
        name_regex = r'((^[a-zA-Z]+)((-)?([a-zA-Z]+))+(.*kdb)?(_gfx\d+)?)?.*'

        index = []
        for match in re.finditer(rpm_regex, index_content, re.MULTILINE):
            rpm = match.group(1)
            name = re.search(name_regex, rpm).group(1)
            version = re.search(version_regex, rpm).group(1)
            index.append((name, version, rpm))

        return index

    def _process_component(self, name, version, rpm):
        """
        Add a packgage (rpm) to the list of components of the bundle
        """
        component_dir = os.path.join(self.builddir, name)

        extract_cmds  = [
            'mkdir ' + component_dir,
            'cp %s ' + component_dir,
        ]

        rocm_dir_name = '-'.join(['rocm', self.version])

        find_cmd      = 'find . -type f -name "*.cmake" -exec '
        sed_cmd_ver   = 'sed -i s#/opt/'     + rocm_dir_name + '#' + self.installdir + '# {} +'
        sed_cmd_nover = 'sed -i s#/opt/rocm'                 + '#' + self.installdir + '# {} +'

        install_cmds = []    
        if '-debuginfo' in name :
            install_cmds = [
                'cd ' + component_dir,
                'rpm2cpio %s | cpio -idmv' % rpm,
                'cd ' + os.path.join(component_dir, os.path.join('usr/lib/debug/opt', rocm_dir_name)),
                'cp -ar . ' + os.path.join(self.installdir,'debug'),
                'cd ' + self.builddir,
                'rm -rf ' + component_dir,
            ]
        else : 
            install_cmds = [
                'cd ' + component_dir,
                'rpm2cpio %s | cpio -idmv' % rpm,
                'cd ' + os.path.join(component_dir, os.path.join('opt', rocm_dir_name)),
                find_cmd + sed_cmd_ver,
                find_cmd + sed_cmd_nover,
                'cp -ar . ' + self.installdir,
                'cd ' + self.builddir,
                'rm -rf ' + component_dir,
            ]

        component_cfgs = {
            'easyblock'       : 'Binary',
            'source_urls'     : [self.cfg.get('index_url')],
            'sources': [{
                'download_filename': rpm,
                'filename'         : rpm,
                'extract_cmd'      :  ' && '.join(extract_cmds),
            }],
            'install_cmd': ' && '.join(install_cmds),
        }

        if self.cfg.get('component_checksums'):
            checksum = self.cfg.get('component_checksums').get(name)
            if checksum:
                component_cfgs['checksums'] = [checksum]

        component = (name, version, component_cfgs)

        return component

    @staticmethod
    def extra_options(extra_vars=None):
        """Easyconfig parameters specific to the ROCm RPM packages."""
        if extra_vars is None:
            extra_vars = {}

        extra_vars.update({
            'index_url'           : [None, 'URL of the index file', CUSTOM],
            'pkg_config'          : [None, 'Content of the pkgconfig file', CUSTOM],
            'exclude_packages'    : [None, 'List of package names to exclude', CUSTOM],
            'gpu_archs'           : [None, 'List of GPU architecture used to filter miopen compiled for specific a architecture', CUSTOM],
            'component_checksums' : [None, 'Checksums of the ROCm RPMs', CUSTOM],
            'postinstall_script'  : [None, 'The content of a script to run after installation', CUSTOM],
            'exclude_asan'        : [True, 'exclude asan packages (default true)', CUSTOM],
            'exclude_debug'       : [True, 'exclude debug packages (default true)', CUSTOM],
        })

        return Bundle.extra_options(extra_vars=extra_vars)

    def __init__(self, *args, **kwargs):
        super(Bundle, self).__init__(*args, **kwargs)

        index_url = self.cfg.get('index_url')
        index_path = os.path.join(self.builddir, 'index')

        if not index_url:
            raise EasyBuildError("Not index URL provided. Please set the "
                                 "'index_url' parameter in the easyconfig.")

        self.log.info('Downloading index from %s', index_url)
        if not download_file('', index_url, index_path):
            raise EasyBuildError("Failed to download index")

        exclude = ['hip-runtime-nvidia', 'rdc', 'atmi', 'hipcc-nvidia']
        if self.cfg.get('exclude_packages'):
            exclude += self.cfg.get('exclude_packages')

        # If this is a dry run we don't have an index file, skipping init
        if self.dry_run:
            super(EB_rocmrpms, self).__init__(*args, **kwargs)
            return

        version = self.version.split('.')
        self.version_major = version[0]
        self.version_minor = version[1]
        exclude_asan=self.cfg.get('exclude_asan')
        exclude_debug=self.cfg.get('exclude_debug')

        components = []
        for (name, version, rpm) in self._process_index(read_file(index_path)):
            if any(x == name for x in exclude):
                self.log.debug('%s in exclusion list and ignored', rpm)
                continue
            if name.startswith('miopen-opencl'):
                self.log.debug('%s excluded, only miopen-hip is supported', rpm)
                continue
            if '-debuginfo' in name and exclude_debug:
                self.log.debug('%s excluded (debuginfo variant)', rpm)
                continue;
            if '-asan' in name and exclude_asan:
                self.log.debug('%s excluded (ASAN variant)', rpm)
                continue;
            if '-rpath' in name:
                self.log.debug('%s excluded (RPATH variant)', rpm)
                continue;
            if ('-test' in name or 'unittests' in name) and 'bandwidth' not in name:
                self.log.debug('%s excluded (test package)', rpm)
                continue;

            # This apply to miopenkernels and miopen-hip packages. It allow to
            # filter out package that we don't need
            if self.cfg.get('gpu_archs') and 'gfx' in name:
                should_exclude = True
                for arch in self.cfg.get('gpu_archs'):
                    if arch in name or arch in name + 'a':
                        should_exclude = False
                        break
                if should_exclude:
                    self.log.debug('%s excluded because not in arch list', rpm)
                    continue;

            self.log.info('Adding %s v%s to the components list', name, version)

            components.append(self._process_component(name, version, rpm))
            exclude.append(name)

        self.cfg['components'] = components

        super(EB_rocmrpms, self).__init__(*args, **kwargs)

    def post_install_step(self, *args, **kwargs):
        super(EB_rocmrpms, self).post_install_step(*args, **kwargs)

        if self.cfg.get('pkg_config'):
            self.log.info('Creating pkg-config file...')

            pkgconfig_dir = os.path.join(self.installdir, 'lib/pkgconfig')
            pkgconfig_filename = 'rocm-' + self.version + '.pc'
            pkgconfig_filename_short = 'rocm-' + '.'.join([self.version_major, self.version_minor]) + '.pc'
            pkgconfig_file = os.path.join(pkgconfig_dir, pkgconfig_filename)
            pkgconfig_content = self.cfg.get('pkg_config')

            mkdir(pkgconfig_dir)
            write_file(pkgconfig_file, pkgconfig_content)
            os.symlink(pkgconfig_file, os.path.join(pkgconfig_dir, pkgconfig_filename_short))
            os.symlink(pkgconfig_file, os.path.join(pkgconfig_dir, 'rocm.pc'))
            self.log.info(f'pkg-config file written: %s\n\n%s', pkgconfig_file, pkgconfig_content)

        amd_bins = ['clang', 'clang++', 'clang-cl', 'clang-cpp', 'flang', 'lld']

        symlinks_dsts = ['bin/amd%s' % x for x in amd_bins]
        symlinks_srcs = [os.path.join('llvm', x) for x in symlinks_dsts]

        for (src, dst) in zip(symlinks_srcs, symlinks_dsts):
            if not os.path.exists(os.path.join(self.installdir, src)):
                self.log.debug(f'%s do not exist, skipping symlink creation', src)
                continue

            self.log.info(f'Creating symlink %s -> %s', src, dst)

            if os.path.lexists(dst):
                self.log.debug('Removing existing symlink %s', class_mod_file)
                os.remove(dst)

            os.symlink(os.path.join(self.installdir, src),
                       os.path.join(self.installdir, dst))

        if self.cfg.get('postinstall_script'):
            self.log.info('Running post-install script...')
            postinstall_script = os.path.join(self.builddir, 'postinstall.sh')

            write_file(postinstall_script, self.cfg.get('postinstall_script'))
            adjust_permissions(postinstall_script, stat.S_IXUSR)
            run_cmd(postinstall_script, log_all=True, simple=True)

            self.log.info('Finished running post-install script')

    def make_module_extra(self, *args, **kwargs):
        """Extra statements to include in module file: update $PYTHONPATH."""
        txt = super(EB_rocmrpms, self).make_module_extra(*args, **kwargs)

        self.log.info('Adding ROCm specific environment variable to module')
        txt += self.module_generator.set_environment('ROCM_PATH', self.installdir)
        """
        Since ROCm 6, the transition to the new directory structure is completed
        These environement variable interfere with the compiler search for ROCm
        """
        if LooseVersion(self.version) < LooseVersion('6'):
            txt += self.module_generator.set_environment('HIP_PATH', os.path.join(self.installdir, 'hip'))
            txt += self.module_generator.set_environment('HIP_LIB_PATH', os.path.join(self.installdir, 'hip/lib'))
            txt += self.module_generator.set_environment('HSA_PATH', os.path.join(self.installdir, 'hsa'))

        return txt

    def sanity_check_step(self):
        libext = get_shared_lib_ext()

        bins = ['hipcc', 'hipconfig', 'amdclang', 'amdclang++', 'amdflang']
        libs = ['libamdhip64.%s.%s' % (libext, self.version_major), 'libhsa-runtime64.%s.1' % libext]

        bin_files = [os.path.join('bin', x) for x in bins]
        lib_files = [os.path.join('lib', x) for x in libs]

        custom_paths = {
            'files': bin_files + lib_files,
            'dirs': ['llvm']
        }

        super(EB_rocmrpms, self).sanity_check_step(custom_paths=custom_paths)


