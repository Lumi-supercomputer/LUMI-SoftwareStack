#! /bin/bash
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
# Define some "constants".
#

if [ -n "$SINGULARITY_CONTAINER" ]
then
	partitions=( 'C' 'G' 'L' )
	cpeGNU=( 'C:G:L' )
    cpeCray=( 'C:G:L' )
    cpeAMD=( 'G' )
    declare -A cpeENV=( ['cpeGNU']=$cpeGNU ['cpeCray']=$cpeCray ['cpeAMD']=$cpeAMD )
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
	partitions=( 'C' 'D' 'G' 'L' )
	cpeGNU=( 'common:C:D:G:L' )
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
$installroot/$repo/scripts/make_LUMIstack_modulerc.sh ${stack_version%.dev}

#
# - Create the VisibilityHoodData/CPE_modules_*.lua file with the default versions of
#   Cray modules for this stack
#
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
    make_dir $(module_root_infra $stack_version $partition)/EasyBuild-production
    make_dir $(module_root_infra $stack_version $partition)/EasyBuild-infrastructure
    make_dir $(module_root_infra $stack_version $partition)/EasyBuild-user

    create_link $modsrc/EasyBuild-config/$module_file $(module_root_infra $stack_version $partition)/EasyBuild-production/LUMI.lua
    create_link $modsrc/EasyBuild-config/$module_file $(module_root_infra $stack_version $partition)/EasyBuild-infrastructure/LUMI.lua
    create_link $modsrc/EasyBuild-config/$module_file $(module_root_infra $stack_version $partition)/EasyBuild-user/LUMI.lua
done

for partition in container
do
    make_dir $(module_root_infra $stack_version $partition)/EasyBuild-production
    make_dir $(module_root_infra $stack_version $partition)/EasyBuild-user

    create_link $modsrc/EasyBuild-config/$module_file $(module_root_infra $stack_version $partition)/EasyBuild-production/LUMI.lua
    create_link $modsrc/EasyBuild-config/$module_file $(module_root_infra $stack_version $partition)/EasyBuild-user/LUMI.lua
done

for partition in CrayEnv system
do
    mkdir -p $(module_root_infra $stack_version $partition)/EasyBuild-production
    create_link $modsrc/EasyBuild-config/$module_file $(module_root_infra $stack_version $partition)/EasyBuild-production/LUMI.lua
done

module_file=$(match_module_version $stack_version $installroot/$repo/modules/EasyBuild-unlock)
for partition in ${partitions[@]} common container CrayEnv system
do
    make_dir $(module_root_infra $stack_version $partition)/EasyBuild-unlock

    create_link $modsrc/EasyBuild-unlock/$module_file $(module_root_infra $stack_version $partition)/EasyBuild-unlock/LUMI.lua
done

#
# - Download EasyBuild from PyPi
#

make_dir $installroot
make_dir $installroot/sources
make_dir $installroot/sources/easybuild
make_dir $installroot/sources/easybuild/e
make_dir $installroot/sources/easybuild/e/EasyBuild
EB_tardir=$installroot/sources/easybuild/e/EasyBuild

pushd $EB_tardir

echo -e "\n## Downloading EasyBuild to $PWD...\n"

EBmajor=$(cut -d '.' -f 1,1 <<< "$EBversion")
EBminor=$(cut -d '.' -f 2,2 <<< "$EBversion")
EBpatch=$(cut -d '.' -f 3,3 <<< "$EBversion")

EBnewFormat=false
if (( EBmajor >= 5 )) 
then
    EBnewFormat=true
elif (( EBmajor == 4 )) && (( EBminor >= 10 ))
then
    EBnewFormat=true
elif (( EBmajor == 4 )) && (( EBminor == 9 )) && (( EBpatch >= 2 )) 
then
    EBnewFormat=true
fi

$EBnewFormat && eval EBF_file="easybuild_framework-${EBversion}.tar.gz" || eval EBF_file="easybuild-framework-${EBversion}.tar.gz"
EBF_url="https://pypi.python.org/packages/source/e/easybuild-framework"
[[ -f $EBF_file ]] || curl -L -O $EBF_url/$EBF_file

$EBnewFormat && eval EBB_file="easybuild_easyblocks-${EBversion}.tar.gz" || eval EBB_file="easybuild-easyblocks-${EBversion}.tar.gz"
EBB_url="https://pypi.python.org/packages/source/e/easybuild-easyblocks"
[[ -f $EBB_file ]] || curl -L -O $EBB_url/$EBB_file

$EBnewFormat && eval EBC_file="easybuild_easyconfigs-${EBversion}.tar.gz" || eval EBC_file="easybuild-easyconfigs-${EBversion}.tar.gz"
EBC_url="https://pypi.python.org/packages/source/e/easybuild-easyconfigs"
[[ -f $EBC_file ]] || curl -L -O $EBC_url/$EBC_file

popd

#
# - Initialise LMOD before installing EasyBuild
#   Load partion/common as that will be the one we need to install EasyBuild.
#

echo -e "\n## Initializing Lmod...\n"

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
export LMOD_IGNORE_CACHE=1
export LMOD_CACHED_LOADS=0
export LUMI_OVERWRITE_PARTITION='common'
module load LUMI/$stack_version
module load partition/common

#
# - Now if we cannot find the requested EasyBuild module, we'll install it.
#   We would find it if the toolchain has already been initialised and the script
#   is only run because changes were made in the directory structure.
#

echo -e "\n## Checking if the Easybuild/$EBversion module is already present...\n"

# 2 possible test:
#  - Checking in the output of module avail which inexplicably fails in certain
#    command sequences with Lmod 8.3.1
#  - Checking for the module file itself instead
# We currently take the second option.
#module avail EasyBuild/$EBversion |& grep -q "EasyBuild/$EBversion"
[[ -f "$installroot/modules/easybuild/LUMI/$stack_version/partition/common/EasyBuild/$EBversion.lua" ]]
if [[ $? != 0 ]]
then
    #
    # - Now do a temporary install of the framework and EasyBlocks
    #
    echo -e "\n## Easybuild/$EBversion module not found, starting the bootstrapping process...\n"
    make_dir $workdir
    pushd $workdir

    # - Untar the sources

    tar -xf $EB_tardir/$EBF_file
    tar -xf $EB_tardir/$EBB_file

    make_dir $workdir/easybuild

    # - Install EasyBuild in the work directory
    
    case $EBversion in

    4.*) 
        usepython=/usr/bin/python3.6
        pythonpathpostfix=''

        pushd ${EBF_file%.tar.gz}
        $usepython setup.py install --prefix=$workdir/easybuild
        cd ../${EBB_file%.tar.gz}
        $usepython setup.py install --prefix=$workdir/easybuild
        popd

        ;;

    5.*)
	# Somehow when using python3.11 from Cray Python we get an incomplete install and I can't
	# see why for now.
        usepython=/usr/bin/python3.11
        pythonpathpostfix=''
        #usepython=/opt/cray/pe/python/3.11.7/bin/python3.11
        #pythonpathpostfix=':/opt/cray/pe/python/3.11.7'

        pushd ${EBF_file%.tar.gz}
        $usepython setup.py install --prefix=$workdir/easybuild
        cd ../${EBB_file%.tar.gz}
        $usepython setup.py install --prefix=$workdir/easybuild
        popd

        ;;

    *)
        echo "Check the script, don't know which Python to use."

    esac

    #
    # - Clean up files that are not needed anymore
    #
    rm -rf ${EBF_file%.tar.gz}
    rm -rf ${EBB_file%.tar.gz}

    #
    # - Activate that install
    #
    #export EB_PYTHON="$usepython"
    #export PYTHONPATH="$(find $workdir/easybuild -name site-packages)${pythonpathpostfix}"

    #
    # - Install EasyBuild in the common directory of the $EBstack software stack
    #
    # Need to use the full module name as the module is hidden in the default view!
    echo -e "\n## Now properly installing Easybuild/$EBversion...\n"

    module load EasyBuild-unlock/LUMI
    module load EasyBuild-production/LUMI

    export EB_PYTHON="$usepython"
    export PYTHONPATH="$(find $workdir/easybuild -name site-packages)${pythonpathpostfix}"
    export EB_VERBOSE=1
    echo "EB_PYTHON is $EB_PYTHON"
    echo "PYTHONPATH is $PYTHONPATH"

    $workdir/easybuild/bin/eb --show-config || die "Something wrong with the work copy of EasyBuild, eb --show-config fails."
    $workdir/easybuild/bin/eb $installroot/$repo/easybuild/easyconfigs/e/EasyBuild/EasyBuild-${EBversion}.eb \
      || die "EasyBuild failed to install EasyBuild-${EBversion}.eb."

    #
    # - Clean up
    #
    rm -rf easybuild

    popd

else

	echo -e "## EasyBuild/$EBversion already present, skipping installation...\n"

fi

#
# Enable EasyBuild also for cross-installing by linking in the CrayEnv and system module directories
#
for partition in container CrayEnv system
do
    create_link $(module_root_eb $stack_version common)/EasyBuild $(module_root_infra $stack_version $partition)/EasyBuild
done

###############################################################################
#
# Initialise the main toolchains
#

echo -e "\n## Initialising the main toolchains...\n"

pushd $installroot/$repo/easybuild/easyconfigs/c

module load LUMI/$stack_version
module load EasyBuild-unlock/LUMI
module load EasyBuild-infrastructure/LUMI

#IFS=':'
for cpe in ${!cpeENV[@]}
do

    echo -e "\nBuilding EasyConfig file for toolchain $cpe/$CPEversion (if not present already)"
	make_dir $installroot/$repo/easybuild/easyconfigs/c/$cpe
	if [[ -f "$cpe/$cpe-$CPEversion.eb" ]]
	then
		echo -e "Found existing $cpe-$CPEversion.eb file, not rebuilding.\n"
	else
	    echo -e "Generating $cpe-$CPEversion.eb...\n"
	    $installroot/$repo/scripts/make_CPE_EBfile.sh "$cpe/$CPEversion"
	fi
	#[[ -f "$cpe/$cpe-$CPEversion.eb" ]] || $installroot/$repo/scripts/make_CPE_EBfile.sh "$cpe/$CPEversion"

	for partition in ${cpeENV[$cpe]//:/ }
	do

      	echo "Installing toolchain $cpe/$CPEversion for partition $partition (if not present already)."
        module load "partition/$partition"
        
        # Install the toolchain module if it does not yet exist.
        # It turns out that the following test does not always work with Lmod 8.3.1,
        # Though it is unclear why. It is no problem with 8.7.
        #module avail $cpe/$CPEversion |& grep -q "$cpe/$CPEversion"
        #is_present=$?
        
        # Check for the module file instead:
        [[ -f "$EASYBUILD_INSTALLPATH_MODULES/$cpe/$CPEversion.lua" ]]
        is_present=$?
        
        if [[ $is_present != 0 ]]
        then
            echo "Installing toolchain $cpe/$CPEversion for partition $partition."
            eb "$cpe/$cpe-$CPEversion.eb" -f || die "Failed to install $cpe/$CPEversion for partition $partition."
        fi

	done

done
#unset IFS

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
	echo -e "\nhide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/$CPEversion.lua' )" >>$modulerc_file
	echo "Please check $modulerc_file for the line \"hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/$CPEversion.lua' )\""
fi


