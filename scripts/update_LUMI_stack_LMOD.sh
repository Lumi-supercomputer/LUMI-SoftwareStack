#! /bin/bash
#
# Script to re-initialize LMOD-related files in a software stack, to be run
# when corrections are made to the visibility data or to version numbers of
# modules that are not used in the cpe* modules (so they need not be 
# regenerated).
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

if [ "$#" -ne 1 ]
then
	# Here document, but avoid using <<- as indentation breaks when tabs would
	# get replaced with spaces.
    cat <<EOF 1>&2

This script expects 1 and only 1 command line arguments:
   * The version of the software stack (CPE version, with the extension .dev for a development stack)

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
CPEversion=${stack_version%.dev}

cat <<EOF

  * Re-initializing LMOD configuration in LUMI/$stack_version
  * Root of the installation: $installroot

EOF

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
# Define some "constants".
#

if [ -n "$SINGULARITY_CONTAINER" ]
then
	partitions=( 'C' 'G' 'L' )
	cpeGNU=( 'C:G:L' )
    cpeCray=( 'C:G:L' )
    declare -A cpeENV=( ['cpeGNU']=$cpeGNU ['cpeCray']=$cpeCray )
elif [[ -d '/appl/lumi' ]]
then
	#partitions=( 'C' 'G' 'D' 'L' 'EAP' )
	#cpeGNU=( 'common:C:G:D:L:EAP' )
    #cpeCray=( 'common:C:G:D:L:EAP' )
    #cpeAOCC=( 'common:C:D:L' )
    #cpeAMD=( 'G:EAP' )
	#partitions=( 'C' 'G' 'D' 'L' )
	#cpeGNU=( 'common:C:G:D:L' )
    #cpeCray=( 'common:C:G:D:L' )
    #cpeAOCC=( 'common:C:D:L' )
    #cpeAMD=( 'G' )
	partitions=( 'C' 'G' 'L' )
	cpeGNU=( 'common:C:G:L' )
    cpeCray=( 'common:C:G:L' )
    cpeAOCC=( 'common:C:L' )
    cpeAMD=( 'G' )
    declare -A cpeENV=( ['cpeGNU']=$cpeGNU ['cpeCray']=$cpeCray ['cpeAOCC']=$cpeAOCC ['cpeAMD']=$cpeAMD )
else # We're likely on eiger, we can't test everything here.
	partitions=( 'L' )
	cpeGNU=( 'common:L' )
    cpeCray=( 'common:L' )
    cpeAOCC=( 'common:L' )
    declare -A cpeENV=( ['cpeGNU']=$cpeGNU ['cpeCray']=$cpeCray ['cpeAOCC']=$cpeAOCC )
    #declare -A cpeENV=( ['cpeGNU']=$cpeGNU ['cpeCray']=$cpeCray )
fi


###############################################################################
#
# Repair the module structure for the software stack.
#
# Note that for now we link to the generic modules in modules/generic and not
# directly into the repository. We may want to change that in the production
# version, though we should then have a way of coping with different structures
# should we ever want to change the structure of the directory tree.
#

#
# Some functions and variables for this section
#

function die () {

    echo "$*" 1>&2
    exit 1

}

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
    test -s "$2" || ln -s "$1" "$2" || die "Failed to create a link from $1 to $2."

}

#
# make_dir
#
# Make a directory using mkdir -p and die with a message if this fails.
#
make_dir () {

	mkdir -p "$1" || die "Failed to create the directory $1."

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
    make_dir "$installroot/modules/CrayOverwrite/data-cpe/$CPEversion"
    $installroot/$repo/scripts/make_CPE_modulerc.sh ${stack_version%.dev}
fi

#
# - Create the software stack module
#   The directory likely already exists, but it doesn't hurt to use mkdir -p and it makes the script
#   more robust.
#
make_dir "$installroot/modules/SoftwareStack/LUMI"
match_file=$(match_module_version "$stack_version" "$installroot/$repo/modules/LUMIstack")
create_link "$installroot/$repo/modules/LUMIstack/$match_file" "$installroot/modules/SoftwareStack/LUMI/$stack_version.lua"

#
# - Create the partition modules
#
make_dir "$installroot/modules/SystemPartition/LUMI/$stack_version/partition"
match_file=$(match_module_version $stack_version $installroot/$repo/modules/LUMIpartition)
for partition in "${partitions[@]}" common container CrayEnv system
do
  	create_link "$installroot/$repo/modules/LUMIpartition/$match_file" "$installroot/modules/SystemPartition/LUMI/$stack_version/partition/$partition.lua"
done

#
# - Create the LUMIstack_..._modulerc.lua file with the default versions of Cray
#   modules for this stack
#
if [ -f "$installroot/mgmt/LMOD/ModuleRC/LUMIstack_${stack_version%.dev}_modulerc.lua" ]
then # Clear the existing file before regenerating just to be sure.
    /bin/rm -f "$installroot/mgmt/LMOD/ModuleRC/LUMIstack_${stack_version%.dev}_modulerc.lua"
fi
$installroot/$repo/scripts/make_LUMIstack_modulerc.sh ${stack_version%.dev}

#
# - Create the VisibilityHoodData/CPE_modules_*.lua file with the default versions of
#   Cray modules for this stack
#
if [ -f "$installroot/mgmt/LMOD/VisibilityHookData/CPEmodules_${stack_version%.dev}.lua" ]
then # Clear the existing file before regenerating just to be sure.
    /bin/rm -f "$installroot/mgmt/LMOD/VisibilityHookData/CPEmodules_${stack_version%.dev}.lua"
fi
$installroot/$repo/scripts/make_CPE_VisibilityHookData.sh ${stack_version%.dev}


#
# - Create the other directories for modules, and other toolchain-specific directories
#
make_dir $installroot/modules/easybuild/LUMI/$stack_version
make_dir $installroot/modules/easybuild/LUMI/$stack_version/partition
make_dir $installroot/modules/spack/LUMI/$stack_version
make_dir $installroot/modules/spack/LUMI/$stack_version/partition
make_dir $installroot/modules/manual/LUMI/$stack_version
make_dir $installroot/modules/manual/LUMI/$stack_version/partition
make_dir $installroot/modules/Infrastructure/LUMI/$stack_version
make_dir $installroot/modules/Infrastructure/LUMI/$stack_version/partition

make_dir $installroot/SW/LUMI-$stack_version

make_dir $installroot/mgmt/ebrepo_files/LUMI-$stack_version

for partition in ${partitions[@]} common
do

	make_dir $installroot/modules/easybuild/LUMI/$stack_version/partition/$partition
   	make_dir $installroot/modules/spack/LUMI/$stack_version/partition/$partition
   	make_dir $installroot/modules/manual/LUMI/$stack_version/partition/$partition
   	make_dir $installroot/modules/Infrastructure/LUMI/$stack_version/partition/$partition

   	make_dir $installroot/SW/LUMI-$stack_version/$partition
   	make_dir $installroot/SW/LUMI-$stack_version/$partition/EB
   	make_dir $installroot/SW/LUMI-$stack_version/$partition/SP
   	make_dir $installroot/SW/LUMI-$stack_version/$partition/MNL

   	make_dir $installroot/mgmt/ebrepo_files/LUMI-$stack_version/LUMI-$partition

done

for partition in CrayEnv container system
do

    make_dir $installroot/modules/Infrastructure/LUMI/$stack_version/partition/$partition

done


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
	echo -e "\nhide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/$CPEversion.lua' )" >>$modulerc_file
	echo "Please check $modulerc_file for the line \"hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/$CPEversion.lua' )\""
fi


