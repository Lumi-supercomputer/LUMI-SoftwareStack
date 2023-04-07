#! /bin/bash
#
# This is a wrapper script to call the gen_CPE_VisibilityHookData
#
# Currently there is only one version of that script. However, as the version of the
# CPE is one of the arguments, it is possible to add additional logic to select between
# versions of the routine should changes be made that break compatibility with older
# CPE versions.
#
# Input arguments of the script
#   1. The version of the programming environment
#   2. (Optional): Version of the programming environment to use for the version
#      information (for retired stacks, the version that is now used instead).
#
# The install root for the installation is derived from the directory in which the
# script resides. Hence make sure to call the correct version of this script for the
# stack that you're trying to set up!
#

#
# Check the arguments of the script
#
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]
then
	>&2 echo -e "\nThis script expects 1 or 2 command line arguments:" \
	            "\n  1. The version of the Cray PE to generate the file for." \
	            "\n  2. (Optional) The version of the Cray PE to use for the version numbers.\n"
    exit 1
fi

export PARAMETER_CPE_STACK=$1

if [ "$#" -eq 1 ]
then
    export PARAMETER_CPE_ALIAS=$1
else
    export PARAMETER_CPE_ALIAS=$2
fi

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd $(dirname $0)
cd ..
export PARAMETER_REPO_DIR=$(pwd)
cd ..
export PARAMETER_INSTALL_ROOT=$(pwd)

cd $PARAMETER_REPO_DIR/scripts

python3 -- <<END

from lumitools.gen_CPE_VisibilityHookData import gen_CPE_VisibilityHookData
import os

PEversion_stack = os.environ['PARAMETER_CPE_STACK']
PEversion_alias = os.environ['PARAMETER_CPE_ALIAS']
repo_dir =        os.environ['PARAMETER_REPO_DIR']
install_root =    os.environ['PARAMETER_INSTALL_ROOT']

#
# Compute the directory where the PE componenet defintion file can be found, and
# the directory where the external modules file should be stored.
#

CPEpackages_dir =        os.path.join( repo_dir,     'CrayPE' )
VisibilityHookData_dir = os.path.join( install_root, 'mgmt/LMOD/VisibilityHookData' )

#
# Execute the command
#
gen_CPE_VisibilityHookData( CPEpackages_dir, VisibilityHookData_dir, PEversion_stack, PEversion_alias )
END

