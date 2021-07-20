#! /bin/bash

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd $(dirname $0)
cd ..
repodir=$PWD

# Name of the shadow repository
repo=SystemRepo

#
# Some functions used in this script
#

create_link () {

#  echo "Linking from: $1"
#  echo "Linking to: $2"
#  test -s "$2" && echo "File $2 found."
#  test -s "$2" || echo "File $2 not found."
  test -s "$2" || ln -s "$1" "$2"

}

#
# Process the arguments
#

if [ "$#" -ne 1 ] && [ "$#" -ne 2 ]
then
	>&2 echo -e "\nThis script expects one arguments: The directory in which to create tha shadow repository\n" \
	            "and the name to use for the repository as an optional second argument.\n"
    exit 1
fi

installroot="$1"

if [ "$#" -eq 2 ]
then
    repo="$2"
fi

#
# Make sure the directory $installroot exists and then create
# the shadowrepo "SystemRepo" in it.
#
mkdir -p "$installroot/$repo"

#
# In the current implementation we simply link a number of subdirectories.
# The structure has evolved such that it doesn't make much sense anymore
# to run from a shadow unless we would start linking individual files.
#
modsrc="$repodir"
moddest="$installroot/$repo"
create_link $modsrc/CrayPE    $moddest/CrayPE
create_link $modsrc/LMOD      $moddest/LMOD
create_link $modsrc/easybuild $moddest/easybuild
create_link $modsrc/modules   $moddest/modules
create_link $modsrc/scripts   $moddest/scripts
