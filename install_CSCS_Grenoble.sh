#! /bin/bash

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd $(dirname $0)
reporoot="$(pwd)"
cd ..
installroot="$(pwd)"

repo=${installroot##*/}

workdir="$HOME/Work"

#PATH=$reporoot/..:$reporoot:$PATH

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
        #EB_stacks=( '21.G.02.dev' '21.G.04' )
        EB_stacks=( '21.G.04' )
        EB_version['21.G.02.dev']='4.3.4'
        EB_version['21.G.04']='4.4.1'
        default_stack='21.G.04'
    ;;
	CSCS)
        #EB_stacks=( '21.04''21.05' '21.06' )
        EB_stacks=( '21.05.dev' '21.06' )
        EB_version['21.04']='4.4.1'
        EB_version['21.05.dev']='4.4.1'
        EB_version['21.06']='4.4.1'
        default_stack='21.06'
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

PATH="$reporoot/scripts:$PATH"

################################################################################
################################################################################
##
## FIRST PART: Toolchain-independent initializations
##
################################################################################
################################################################################

$reporoot/scripts/prepare_LUMI.sh

#
# Create and populate the directory with EasyBuild sources simply to avoid
# excess downloading while we can still erase the whole directory structure.
#
mkdir -p $installroot/sources/easybuild/e
mkdir -p $installroot/sources/easybuild/e/EasyBuild
cp $HOME/sources/easybuild* $installroot/sources/easybuild/e/EasyBuild/


################################################################################
################################################################################
##
## SECOND PART: Install the EasyBuild toolchain(s)
##
##
################################################################################
################################################################################

for stack in "${EB_stacks[@]}"
do
    echo "Preparing software stack $stack..."
    $reporoot/scripts/prepare_LUMI_stack.sh "$stack" "${EB_version[$stack]}" "$workdir"
done


################################################################################
################################################################################
##
## THIRD PART: Finishing the whole installation with some manual interventions.
##
##
################################################################################
################################################################################

#
# Create a modulerc file in the SoftwareStack subdirectory to mark the default software stack.
#
cat >$installroot/modules/SoftwareStack/LUMI/.modulerc.lua <<EOF
module_version( "LUMI/$default_stack", "default" )
EOF

#
# Instructions for the MODULEPATH etc
#
cat <<EOF


To enable LUMI installation, make sure LMOD is the
active module system and then run
eval \$(\$HOME/LUMI-SoftwareStack/enable_prototype.sh)

EasyBuild works in ${EB_stacks[@]}

EOF
