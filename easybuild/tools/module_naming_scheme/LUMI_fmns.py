##
# An EasyBuild flat module naming scheme, dropping the "all" subdirectory and
# links to module classes from the default EasyBuildMNS as the moduleclasses
# are often rather arbitrary. Many packages are equally at home in multiple
# classes and some researchers may even be upset if a module for the package
# they use isn't in the moduleclass most associated with their research
# domain.
#
# When combining with the option --suffix-module-path='' one gets a cleam
# module structure without the links in moduleclass subdirectories that are not
# really useful and without the 'all' subdirectory extension to the MODULEPATH
# that is entirely unnecessary also.
#
import os

from easybuild.tools.module_naming_scheme.easybuild_mns import EasyBuildMNS


class LUMI_FlatMNS(EasyBuildMNS):

    def det_module_symlink_paths(self, ec):
        """
        Determine list of paths in which symlinks to module files must be created.
        """
        # no longer make symlinks from moduleclass sudirectory of $MODULEPATH
        return []
