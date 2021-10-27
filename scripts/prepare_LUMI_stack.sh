#! /bin/bash
#
# TEST IN GRENOBLE: ./prepare_toolchain.sh 21.G.04.dev 4.4.0 $HOME/work
#
# Script to initialize a new software stack.
#
# The script takes the following arguments:
#  * Version of the software stack
#  * Version of EasyBuild to use
#  * Work directory for temporary files
#
# The root of the installation is derived from the place where the script is found.
# The script should be in <installroot>/<repo>/scripts with <installroot> the
# root for the installation and <repo> the name of the repository (which is
# hard-coded in some files so cannot be changed completely at will).
#

###############################################################################
#
# Checks of the arguments
#

if [ "$#" -ne 3 ]
then
	# Here document, but avoid using <<- as indentation breaks when tabs would
	# get replaced with spaces.
    cat <<EOF 1>&2

This script expects 3 and only 3 command line arguments:
   * The version of the software stack (CPE version, with the extension .dev for a development stack)
   * The version of EasyBuild to install in the software stack
   * A work directory for temporary files

EOF
    exit 1
fi

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd $(dirname $0)
cd ..
repo=${PWD##*/}
cd ..
installroot=$(pwd)

stack_version="$1"
EBversion="$2"
workdir="$3"
CPEversion=${stack_version%.dev}

cat <<EOF

  * Initialising software stack LUMI/$stack_version
  * Using EasyBuild $EBversion
  * Root of the installation: $installroot
  * Using the work directory $workdir

EOF

#
# Check: Does the EasyConfig exist?
#
EBconfig_file="$installroot/$repo/easybuild/easyconfigs/e/EasyBuild/EasyBuild-$EBversion.eb"

if [ ! -f "$EBconfig_file" ]
then
	# Here document, but avoid using <<- as indentation breaks when tabs would
	# get replaced with spaces.
    cat <<EOF 1>&2

Failed to find the EasyConfig file EasyBuild-$EBversion.eb for the requested
version of EasyBuild. The file should be in
$installroot/$repo/easybuild/easyconfigs/e/EasyBuild
before running this script.

EOF
    exit 1
fi

#
# Check: Does the CPE_packages-*.csv file exist?
#
CPEpackages_file="$installroot/$repo/CrayPE/CPEpackages_$CPEversion.csv"
if [ ! -f "$CPEpackages_file" ]
then
	# Here document, but avoid using <<- as indentation breaks when tabs would
	# get replaced with spaces.
    cat <<EOF 1>&2

Failed to find the CPE package file CPEpackages_$CPEversion.csv for the requested
software stack. The file should be in
$installroot/$repo/CrayPE
before running this script.

EOF
    exit 1
fi

###############################################################################
#
# Create the module structure for the software stack.
#
# Note that for now we link to the generic modules in modules/generic and not
# directly into the repository. We may want to change that in the production
# version, though we should then have a way of coping with different structures
# should we ever want to change the structure of the directory tree.
#

#
# Some functions and variables for this section
#

#
# create_link
#
# Links a file but first tests if the target already exists to avoid error messages.
#
# Input arguments:
#   + First input argument: The target of the link
#   + Second and mandatory argument: The name of the link
#
create_link () {

    #echo "Linking from: $1"
    #echo "Linking to: $2"
    #test -s "$2" && echo "File $2 found."
    #test -s "$2" || echo "File $2 not found."
    test -s "$2" || ln -s "$1" "$2"

}

#
# match_module_version
#
# Looks for the best match in a directory of yy.mm.lua files.
# The best match is the most recent of those module files (seen as yy/mm)
# that is not newer than the argument to match, which is a valid LUMI
# software stack version.
#
# Input arguments:
#   * First argument: LUMI software stack version to match.
#     Valid formats are:
#       + yy.mm , the regular format
#       + yy.mm-dev for development software stacks
#       + yy.G.mm and yy.G.mm-dev to support the non-standard Grenoble
#         toolchains in the prototype.
#   * Second argument: The directory to look for the yy.mm.lua module files
#
# The function prints the matching yy.mm.lua module to stdout
#
function match_module_version () {

    match_with=$1
    match_dir=$2

    pushd $match_dir >& /dev/null
    # List the versions of the modules and convert to 4-digit codes (yy.mm.lua -> yymm).
    # They should also be sorted correctly because of the way ls -1 works.
    # readarray is probably overkill as we now for sure that entries will have no spaces.
    # Note that we put 0000 at the front of the list as a sentinel as we will search backwards
    # in the list.
    sentinel_list=( 0000 $(/bin/ls -1 *.lua | egrep '^[[:digit:]]{2}\.[[:digit:]]{2}\.lua$' | sed -e 's/\([0-9]\{2\}\)\.\([0-9]\{2\}\)\.lua/\1\2/') )
    popd >& /dev/null

    #>&2 echo "List with sentinel sentinel_list: ${sentinel_list[@]} (${#sentinel_list[@]} elements)"

    # Extract yy and mm from match_with and transform to yymm, a 4-digit number
    match_number=$(echo $match_with | sed -e 's/\([0-9]\{2\}\).*\([0-9]\{2\}\).*/\1\2/')

    # Look for the largest number in sentinel_list that is smaller than or equal to match_number
    # This is the version of the module that we want to match with.
    counter=$(( ${#sentinel_list[@]} - 1 ))
    while [ ${sentinel_list[$counter]} -gt $match_number ]
    do
    	counter=$(( $counter - 1 ))
    done

    # Transform the result back to yy.mm.lua, but print an error message when counter would be 0
    if [ $counter -eq 0 ]
    then
    	>&2 echo "Couldn't find a matching module; all modules are newer than the requested match.\n"
    	echo '00.00.lua'
    	return 1
    else
        echo "$(echo ${sentinel_list[$counter]} | sed -e 's/\([0-9]\{2\}\)\([0-9]\{2\}\)/\1.\2.lua/')"
        return 0
    fi

}

partitions=( 'C' 'G' 'D' 'L' )

#
# - Create the cpe module in CrayOverwrite for the new stack
#
match_file=$(match_module_version "$stack_version" "$installroot/$repo/modules/CrayOverwrite/core/cpe-generic")
create_link "$installroot/$repo/modules/CrayOverwrite/core/cpe-generic/$match_file" \
            "$installroot/modules/CrayOverwrite/core/cpe/$CPEversion.lua"

#
# Check if we can find the Cray PE modulerc file that sets the defaults for the
# requested PE. If not, we generate our own in modules/CrayOverwrite/data-cpe.
# The file is used by the generic cpe/yy.mm alternative.
#
# This is currently definitely needed on our Grenoble test system as that one has
# an incomplete Cray PE.
#
if [ ! -f "/opt/cray/pe/cpe/$CPEversion/modulerc.lua" ]
then
    mkdir -p "$installroot/modules/CrayOverwrite/data-cpe/$CPEversion"
    $installroot/$repo/scripts/make_CPE_modulerc.sh ${stack_version%.dev}
fi

#
# - Create the software stack module
#   The directory likely already exists, but it doesn't hurt to use mkdir -p and it makes the script
#   more robust.
#
mkdir -p "$installroot/modules/SoftwareStack/LUMI"
match_file=$(match_module_version "$stack_version" "$installroot/$repo/modules/LUMIstack")
create_link "$installroot/$repo/modules/LUMIstack/$match_file" "$installroot/modules/SoftwareStack/LUMI/$stack_version.lua"

#
# - Create the partition modules
#
mkdir -p "$installroot/modules/SystemPartition/LUMI/$stack_version/partition"
match_file=$(match_module_version $stack_version $installroot/$repo/modules/LUMIpartition)
for partition in "${partitions[@]}"
do
  	create_link "$installroot/$repo/modules/LUMIpartition/$match_file" "$installroot/modules/SystemPartition/LUMI/$stack_version/partition/$partition.lua"
done
create_link     "$installroot/$repo/modules/LUMIpartition/$match_file" "$installroot/modules/SystemPartition/LUMI/$stack_version/partition/common.lua"
create_link     "$installroot/$repo/modules/LUMIpartition/$match_file" "$installroot/modules/SystemPartition/LUMI/$stack_version/partition/CrayEnv.lua"

#
# - Create the LUMIstack_..._modulerc.lua file with the default versions of Cray
#   modules for this stack
#
$installroot/$repo/scripts/make_LUMIstack_modulerc.sh ${stack_version%.dev}

#
# - Create the VisibilityHoodData/CPE_modules_*.lua file with the default versions of
#   Cray modules for this stack
#
$installroot/$repo/scripts/make_CPE_VisibilityHookData.sh ${stack_version%.dev}


#
# - Create the other directories for modules, and other toolchain-specific directories
#
mkdir -p $installroot/modules/easybuild/LUMI/$stack_version
mkdir -p $installroot/modules/easybuild/LUMI/$stack_version/partition
mkdir -p $installroot/modules/spack/LUMI/$stack_version
mkdir -p $installroot/modules/spack/LUMI/$stack_version/partition
mkdir -p $installroot/modules/manual/LUMI/$stack_version
mkdir -p $installroot/modules/manual/LUMI/$stack_version/partition
mkdir -p $installroot/modules/Infrastructure/LUMI/$stack_version
mkdir -p $installroot/modules/Infrastructure/LUMI/$stack_version/partition

mkdir -p $installroot/SW/LUMI-$stack_version

mkdir -p $installroot/mgmt/ebrepo_files/LUMI-$stack_version

for partition in ${partitions[@]} common
do

	mkdir -p $installroot/modules/easybuild/LUMI/$stack_version/partition/$partition
   	mkdir -p $installroot/modules/spack/LUMI/$stack_version/partition/$partition
   	mkdir -p $installroot/modules/manual/LUMI/$stack_version/partition/$partition
   	mkdir -p $installroot/modules/Infrastructure/LUMI/$stack_version/partition/$partition

   	mkdir -p $installroot/SW/LUMI-$stack_version/$partition
   	mkdir -p $installroot/SW/LUMI-$stack_version/$partition/EB
   	mkdir -p $installroot/SW/LUMI-$stack_version/$partition/SP
   	mkdir -p $installroot/SW/LUMI-$stack_version/$partition/MNL

   	mkdir -p $installroot/mgmt/ebrepo_files/LUMI-$stack_version/LUMI-$partition

done

mkdir -p $installroot/modules/Infrastructure/LUMI/$stack_version/partition/CrayEnv

###############################################################################
#
# Initialise the EasyBuild configuration.
#

#
# - Create the external modules file
#
$installroot/$repo/scripts/make_EB_external_modules.sh ${stack_version%.dev}

#
# - Link the EasyBuild-production and EasyBuild-user modules in the module structure
#
modsrc="$installroot/$repo/modules"
function module_root_infra () {
    echo "$installroot/modules/Infrastructure/LUMI/$1/partition/$2"
}
function module_root_eb () {
    echo "$installroot/modules/easybuild/LUMI/$1/partition/$2"
}

module_file=$(match_module_version $stack_version $installroot/$repo/modules/EasyBuild-config)
for partition in ${partitions[@]} common
do
    mkdir -p $(module_root_infra $stack_version $partition)/EasyBuild-production
    mkdir -p $(module_root_infra $stack_version $partition)/EasyBuild-infrastructure
    mkdir -p $(module_root_infra $stack_version $partition)/EasyBuild-user

    create_link $modsrc/EasyBuild-config/$module_file $(module_root_infra $stack_version $partition)/EasyBuild-production/LUMI.lua
    create_link $modsrc/EasyBuild-config/$module_file $(module_root_infra $stack_version $partition)/EasyBuild-infrastructure/LUMI.lua
    create_link $modsrc/EasyBuild-config/$module_file $(module_root_infra $stack_version $partition)/EasyBuild-user/LUMI.lua
done

mkdir -p $(module_root_infra $stack_version CrayEnv)/EasyBuild-CrayEnv
create_link $modsrc/EasyBuild-config/$module_file $(module_root_infra $stack_version CrayEnv)/EasyBuild-CrayEnv/LUMI.lua

#
# - Download EasyBuild from PyPi
#

mkdir -p $installroot
mkdir -p $installroot/sources
mkdir -p $installroot/sources/easybuild
mkdir -p $installroot/sources/easybuild/e
mkdir -p $installroot/sources/easybuild/e/EasyBuild
EB_tardir=$installroot/sources/easybuild/e/EasyBuild

pushd $EB_tardir

EBF_file="easybuild-framework-${EBversion}.tar.gz"
EBF_url="https://pypi.python.org/packages/source/e/easybuild-framework"
[[ -f $EBF_file ]] || curl -L -O $EBF_url/$EBF_file

EBB_file="easybuild-easyblocks-${EBversion}.tar.gz"
EBB_url="https://pypi.python.org/packages/source/e/easybuild-easyblocks"
[[ -f $EBB_file ]] || curl -L -O $EBB_url/$EBB_file

EBC_file="easybuild-easyconfigs-${EBversion}.tar.gz"
EBC_url="https://pypi.python.org/packages/source/e/easybuild-easyconfigs"
[[ -f $EBC_file ]] || curl -L -O $EBC_url/$EBC_file

popd

#
# - Now do a temporary install of the framework and EasyBlocks
#
mkdir -p $workdir
pushd $workdir

tar -xf $EB_tardir/$EBF_file
tar -xf $EB_tardir/$EBB_file

mkdir -p $workdir/easybuild

pushd easybuild-framework-$EBversion
python3 setup.py install --prefix=$workdir/easybuild
cd ../easybuild-easyblocks-$EBversion
python3 setup.py install --prefix=$workdir/easybuild
popd

#
# - Clean up files that are not needed anymore
#
rm -rf easybuild-framework-$EBversion
rm -rf easybuild-easyblocks-$EBversion

#
# - Activate that install
#
export EB_PYTHON='python3'
export PYTHONPATH=$(find $workdir/easybuild -name site-packages)

#
# - Install EasyBuild in the common directory of the $EBstack software stack
#
module --force purge
export MODULEPATH="$installroot/modules/SoftwareStack"
module help |& grep -q lmod
if [[ $? != 0 ]]
then
    # LMOD is not running yet in this shell
    source /usr/share/lmod/lmod/init/bash
fi
export LMOD_PACKAGE_PATH="$installroot/$repo/LMOD"
export LMOD_RC="$installroot/$repo/LMOD/lmodrc.lua"
export LUMI_OVERWRITE_PARTITION='common'
module load LUMI/$stack_version
module load partition/common
# Need to use the full module name as the module is hidden in the default view!
module load EasyBuild-production/LUMI
$workdir/easybuild/bin/eb --show-config
$workdir/easybuild/bin/eb $installroot/$repo/easybuild/easyconfigs/e/EasyBuild/EasyBuild-${EBversion}.eb

#
# - Clean up
#
rm -rf easybuild

popd

#
# Enable EasyBuild also for cross-installing by linking in the CrayEnv module directories
#
create_link $(module_root_eb $stack_version common)/EasyBuild $(module_root_infra $stack_version CrayEnv)/EasyBuild


###############################################################################
#
# Initialise the main toolchains
#

pushd $installroot/$repo/easybuild/easyconfigs/c

extended_partitions=( 'common' 'C' 'G' 'D' 'L' )
toolchains=( 'cpeCray' 'cpeGNU' 'cpeAMD' )

module load LUMI/$stack_version
module load EasyBuild-infrastructure/LUMI

for cpe in ${toolchains[@]}
do

	mkdir -p $installroot/$repo/easybuild/easyconfigs/c/$cpe
	[[ -f "$cpe/$cpe-$CPEversion.eb" ]] || $installroot/$repo/scripts/make_CPE_EBfile.sh "$cpe/$CPEversion"

	for partition in ${extended_partitions[@]}
	do

        module load "partition/$partition"

        eb "$cpe/$cpe-$CPEversion.eb" -f

	done

done

popd


###############################################################################
#
# The finishing touches:
#
# Print a message reminding the user of possible other work (and try to do the work)
#  - Make sure LMOD/modulerc.lua file is OK.
#  - Remind how to set the default software stack.
#
modulerc_file="$repo/LMOD/modulerc.lua"
egrep "hide_module.*cpe/$CPEversion" $modulerc_file >& /dev/null
if [[ $? != 0 ]]
then
	echo -e "\nhide_module( '/opt/cray/pe/lmod/modulefiles/core/cpe/$CPEversion' )" >>$modulerc_file
	echo "Please check $modulerc_file for the line \"hide_module( '/opt/cray/pe/lmod/modulefiles/core/cpe/$CPEversion' )\""
fi


