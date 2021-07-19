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
#
# The install root for the installation is derived from the directory in which the
# script resides. Hence make sure to call the correct version of this script for the
# stack that you're trying to set up!
#

#
# Check the arguments of the script
#
if [ "$#" -ne 1 ]
then
	>&2 echo -e "\nThis script expects 1 and only 1 command line arguments: The version of the Cray PE.\n"
    exit 1
fi

export PARAMETER_CPE=$1

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

PEversion =    os.environ['PARAMETER_CPE']
repo_dir =     os.environ['PARAMETER_REPO_DIR']
install_root = os.environ['PARAMETER_INSTALL_ROOT']

#
# Compute the directory where the PE componenet defintion file can be found, and
# the directory where the external modules file should be stored.
#

CPEpackages_dir =        os.path.join( repo_dir,     'CrayPE' )
VisibilityHookData_dir = os.path.join( install_root, 'mgmt/LMOD/VisibilityHookData' )

#
# Execute the command
#
gen_CPE_VisibilityHookData( CPEpackages_dir, VisibilityHookData_dir, PEversion )
END

