#! /bin/bash

version="0.4"
testroot="$HOME/appltest/design_$version"
sourceroot="$HOME/LUMI-easybuild-prototype/prototypes/design_$version"

workdir=$HOME/Work

#PATH=$sourceroot/..:$sourceroot:$PATH

if [[ "$(hostname)" =~ ^o[0-9]{3}i[0-9]{3}$ ]]
then
	system="Grenoble"
	echo "Identified the Grenoble test system."
elif [[ "$(hostname)" =~ ^uan0[0-9]$ ]]
then
	system="CSCS"
	echo "Identified the CSCS cluster."
else
	system="Unknown"
	echo "Could not identify the system, quitting."
	exit
fi

declare -A EB_version
case $system in
    Grenoble)
        demo_stacks=( '21.D.02.dev' '21.D.03.dev' '21.D.04' )
        EB_stacks=( '21.G.02.dev' '21.G.04' )
        EB_version['21.G.02.dev']='4.3.4'
        EB_version['21.G.04']='4.4.0'
        default_stack='21.G.04'
    ;;
	CSCS)
        demo_stacks=( '21.D.02.dev' '21.D.03.dev' )
        EB_stacks=( '21.04' )
        EB_version['21.04']='4.4.0'
        default_stack='21.04'
	;;
esac
partitions=( 'C' 'G' 'D' 'L' )

create_link () {

#  echo "Linking from: $1"
#  echo "Linking to: $2"
#  test -s "$2" && echo "File $2 found."
#  test -s "$2" || echo "File $2 not found."
  test -s "$2" || ln -s "$1" "$2"

}

#
# Make the support directories
#
mkdir -p $testroot

################################################################################
################################################################################
##
## FIRST PART: Shadow SystemRepo directory
## For now, in the prototype we avoid to work directly in the repo as we
## do not want to set up a new repo for each prototype.
##
## However, in the release version this step is replaced by simply cloning the
## release repository.
##
################################################################################
################################################################################

mkdir -p $testroot/SystemRepo

mkdir -p $testroot/SystemRepo
# Normally $testroot/SystemRepo would just be our github repository, even though some files
# in there are generated from other files. However, to ease editing in the prototype
# and since we're running this on two clusters, we're selectively linking to some
# parts of the GitHub repository.
modsrc=$sourceroot
moddest=$testroot/SystemRepo
create_link $modsrc/modules $moddest/modules
create_link $modsrc/LMOD    $moddest/LMOD
create_link $modsrc/scripts $moddest/scripts
create_link $modsrc/CrayPE  $moddest/CrayPE

PATH=$modsrc/scripts:$PATH

mkdir -p mkdir -p $testroot/SystemRepo/easybuild
mkdir -p mkdir -p $testroot/SystemRepo/easybuild/config
create_link $sourceroot/easybuild/config/easybuild-production.cfg $testroot/SystemRepo/easybuild/config/easybuild-production.cfg

create_link $modsrc/easybuild/easyconfigs $moddest/easybuild/easyconfigs
create_link $modsrc/easybuild/easyblocks  $moddest/easybuild/easyblocks
create_link $modsrc/easybuild/tools       $moddest/easybuild/tools

#
# Add missing modules (if any)
#
if [ $system == "Grenoble" ]
then
	mkdir -p $testroot/modules # Make sure that the directory exists
	create_link $testroot/SystemRepo/modules/missing/$system $testroot/modules/missing
fi

#
# Create and populate the directory with EasyBuild sources simply to avoid
# excess downloading while we can still erase the whole directory structure.
#
mkdir -p $testroot/sources
mkdir -p $testroot/sources/easybuild
mkdir -p $testroot/sources/easybuild/e
mkdir -p $testroot/sources/easybuild/e/EasyBuild
cp $testroot/../sources/easybuild* $testroot/sources/easybuild/e/EasyBuild/


################################################################################
################################################################################
##
## SECOND PART: Toolchain-independent initializations
##
################################################################################
################################################################################

$testroot/SystemRepo/scripts/prepare_LUMI.sh


################################################################################
################################################################################
##
## THIRD PART: Install the EasyBuild toolchain(s)
##
##
################################################################################
################################################################################

for stack in "${EB_stacks[@]}"
do
    echo "Preparing software stack $stack..."
    $testroot/SystemRepo/scripts/prepare_LUMI_stack.sh "$stack" "${EB_version[$stack]}" "$workdir"
done


################################################################################
################################################################################
##
## FOURTH PART: Demo modules
## This is for the prototype only to be able to test certain aspects of the
## module tree without
##
##
################################################################################
################################################################################

$sourceroot/build_demo_modules.sh "$testroot" ${demo_stacks[@]}


################################################################################
################################################################################
##
## FIFTH PART: Finishing the whole construction of the prototype
##
##
################################################################################
################################################################################

#
# Create a modulerc file in the SoftwareStack subdirectory to mark the default software stack.
#
cat >$testroot/modules/SoftwareStack/LUMI/.modulerc.lua <<EOF
module_version( "LUMI/$default_stack", "default" )
EOF

#
# Instructions for the MODULEPATH etc
#
cat <<EOF


To enable LUMI prototype version $version, make sure LMOD is the
active module system and then run
eval \$(\$HOME/LUMI-easybuild-prototype/prototypes/design_$version/enable_prototype.sh)

Dummy demo modules are installed in ${demo_stacks[@]}

EasyBuild works in ${EB_stacks[@]}

EOF
