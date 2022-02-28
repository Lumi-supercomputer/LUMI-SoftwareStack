#! /bin/bash
#
# Script to remove a LUMI software stack.
#
# The script takes the following arguments:
#  * Version of the software stack
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

This script expects 1 and only 1 command line argument:
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

cat <<EOF

  * Removing software stack LUMI/$stack_version
  * Root of the installation: $installroot

EOF

###############################################################################
#
# Some usefull functions
#

function die () {

    echo "$*" 1>&2
    exit 1

}


#
# rm_dir
#
# Removes a directory and its subdirectories
#
# Input arguments: 1
#   + Directory to remove (full path or path from current directory)
#
function rm_dir () {

    echo "Removing directory $1..."
    [[ -d "$1" ]] && ( /bin/rm -rf "$1" || die "Failed to remove directory $1" )

}


#
# rm_file
#
# Removes a file
#
# Input arguments: 1
#   + File to remove (full path or path from current directory)
#
function rm_file () {

    echo "Removing file $1..."
    [[ -f "$1" ]] && ( /bin/rm -f "$1" || die "Failed to remove file $1" )

}

################################################################################
#
# Ask for confirmation.
#
echo -e "\nCleaning up LUMI/$stack_version from $installroot, are you sure?"
select yn in "Yes" "No"; do
    case $yn in
        No ) exit  ;;
        * )  break ;;
    esac
done


################################################################################
#
# First step: Clean module directory
#

rm_file "/$installroot/modules/SoftwareStack/LUMI/$stack_version.lua"
for subdir in SystemPartition Infrastructure easybuild spack manual
do
	rm_dir "$installroot/modules/$subdir/LUMI/$stack_version"
done


################################################################################
#
# Second step: Clean the software directories
#
rm_dir "$installroot/SW/LUMI-$stack_version"


################################################################################
#
# Third step: Clean the repository
#
rm_dir "$installroot/mgmt/ebrepo_files/LUMI-$stack_version"


################################################################################
#
# Fourth step: Various files
#
rm_file "$installroot/mgmt/LMOD/ModuleRC/LUMIstack_${stack_version}_modulerc.lua"
for prgenv in cpeGNU cpeCray cpeAOCC cpeAMD
do
	rm_file "$installroot/$repo/easybuild/easyconfigs/c/$prgenv/$prgenv-$stack_version.eb"
done

