#! /bin/bash
# This is a wrapper script to call the gen_CPE_EBfile
#
# Currently there is only one version of that script. However, as the version of the
# CPE is one of the arguments, it is possible to add additional logic to select between
# versions of the routine should changes be made that break compatibility with older
# CPE versions.
#
# Input arguments of the script
#   1. The name of the module for which an EasyConfig should be generated, e.g.,
#      cpeGNU/21.04, cpeAMD/21.04 or cpeCray/21.04.
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
	# Here document, but avoid using <<- as indentation breaks when tabs would
	# get replaced with spaces.
	>&2 echo -e "\nThis script expects 1 and only 1 command line arguments: The name of the" \
	            "\ncpe* module for which an EasyConfig should be generated (e.g, cpeCray/21.04).\n"
    exit 1
fi

CPE_module="$1"
export PARAMETER_CPE_MODULE_NAME=${CPE_module%/*}
export PARAMETER_CPE_MODULE_VERSION=${CPE_module#*/}

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd $(dirname $0)
cd ..
export PARAMETER_REPO_DIR=$(pwd)

cd scripts

python3 -- <<END
from lumitools.gen_CPE_EBfile import gen_CPE_EBfile
import os

CPEmodule = os.environ['PARAMETER_CPE_MODULE_NAME']
PEversion = os.environ['PARAMETER_CPE_MODULE_VERSION']
repo_dir  = os.environ['PARAMETER_REPO_DIR']

#
# Compute the directory where the PE componenet defintion file can be found, and
# the directory where the external modules file should be stored.
#

CPEpackages_dir = os.path.join( repo_dir, 'CrayPE' )
EBfile_dir =      os.path.join( repo_dir, 'easybuild/easyconfigs/c', CPEmodule )

#
# Execute the command
#
gen_CPE_EBfile( CPEmodule, PEversion, CPEpackages_dir, EBfile_dir )
END

