#! /bin/bash
#
# Script to clean up some stuff in the system partition after the March 2023
# system update.
#
# The script takes no arguments.
#
# The root of the installation is derived from the place where the script is found.
# The script should be in <installroot>/${repo}/scripts with <installroot> the
# root for the installation.
#
# To clean:
# - Subversion 1.14.1
# - Vim 8.2.3582 and 8.2.4487
# - buildtools 21.08, 21.12, 22.06
# - git 2.33.1, 2.35.1, 2.37.0
# - lumi-container-wrapper/0.2.2-cray-python-default
# - nano 5.9, 6.2 and 6.3
# - rocm 5.1.4
# - syslibs 15.1.0, 15.1.1-static, 21.12-static and 22.06-static
# - systools 15.1.0, 21.12 and 22.06
#

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd "$(dirname $0)"
cd ../..
repo="${PWD##*/}"
cd ..
installroot="$(pwd)"

#
# Warning
#
echo 'The script may produce error messages as "No such file or directory" but they can be safely ignored.'
#
# Clean up the modules
#
cd $installroot/modules/easybuild/CrayEnv/Subversion ;            /bin/rm -f 1.14.1.lua
cd $installroot/modules/easybuild/CrayEnv/Vim ;                   /bin/rm -f 8.2.3582.lua 8.2.4487.lua
cd $installroot/modules/easybuild/CrayEnv/buildtools ;            /bin/rm -f 21.08.lua 21.12.lua 22.06.lua
cd $installroot/modules/easybuild/CrayEnv/git ;                   /bin/rm -f 2.33.1.lua 2.35.1.lua 2.37.0.lua
cd $installroot/modules/easybuild/CrayEnv/lumi-container-wrapper; /bin/rm -f 0.2.2-cray-python-default.lua
cd $installroot/modules/easybuild/CrayEnv/nano ;                  /bin/rm -f 5.9.lua 6.2.lua 6.3.lua
cd $installroot/modules/easybuild/CrayEnv/rocm ;                  /bin/rm -f 5.1.4.lua
cd $installroot/modules/easybuild/CrayEnv/syslibs ;               /bin/rm -f 15.1.0.lua 15.1.1-static.lua 21.12-static.lua 22.06-static.lua
cd $installroot/modules/easybuild/CrayEnv/systools ;              /bin/rm -f 15.1.0.lua 21.12.lua 22.06.lua

#
# Clean up the ebrepo files
#
cd $installroot/mgmt/ebrepo_files/CrayEnv/Subversion ;            /bin/rm -f Subversion-1.14.1.eb
cd $installroot/mgmt/ebrepo_files/CrayEnv/Vim ;                   /bin/rm -f Vim-8.2.3582.eb Vim-8.2.4487.eb
cd $installroot/mgmt/ebrepo_files/CrayEnv/buildtools ;            /bin/rm -f buildtools-21.08.eb buildtools-21.12.eb buildtools-22.06.eb
cd $installroot/mgmt/ebrepo_files/CrayEnv/git ;                   /bin/rm -f git-2.33.1.eb git-2.35.1.eb git-2.37.0.eb
cd $installroot/mgmt/ebrepo_files/CrayEnv/lumi-container-wrapper; /bin/rm -f lumi-container-wrapper-0.2.2-cray-python-default.eb
cd $installroot/mgmt/ebrepo_files/CrayEnv/nano ;                  /bin/rm -f nano-5.9.eb nano-6.2.eb nano-6.3.eb
cd $installroot/mgmt/ebrepo_files/CrayEnv/rocm ;                  /bin/rm -f rocm-5.1.4.eb
cd $installroot/mgmt/ebrepo_files/CrayEnv/syslibs ;               /bin/rm -f syslibs-15.1.0.eb syslibs-15.1.1-static.eb syslibs-21.12-static.eb syslibs-22.06-static.eb
cd $installroot/mgmt/ebrepo_files/CrayEnv/systools ;              /bin/rm -f systools-15.1.0.eb systools-21.12.eb systools-22.06.eb
  
#
# Clean up the software directories
#
cd $installroot/SW/CrayEnv/EB/Subversion ;            /bin/rm -rf 1.14.1
cd $installroot/SW/CrayEnv/EB/Vim ;                   /bin/rm -rf 8.2.3582 8.2.4487
cd $installroot/SW/CrayEnv/EB/buildtools ;            /bin/rm -rf 21.08 21.12 22.06
cd $installroot/SW/CrayEnv/EB/git ;                   /bin/rm -rf 2.33.1 2.35.1 2.37.0
cd $installroot/SW/CrayEnv/EB/lumi-container-wrapper; /bin/rm -rf 0.2.2-cray-python-default
cd $installroot/SW/CrayEnv/EB/nano ;                  /bin/rm -rf 5.9 6.2 6.3
cd $installroot/SW/CrayEnv/EB/rocm ;                  /bin/rm -rf 5.1.4
cd $installroot/SW/CrayEnv/EB/syslibs ;               /bin/rm -rf 15.1.0 15.1.1-static 21.12-static 22.06-static
cd $installroot/SW/CrayEnv/EB/systools ;              /bin/rm -rf 15.1.0 21.12 22.06
