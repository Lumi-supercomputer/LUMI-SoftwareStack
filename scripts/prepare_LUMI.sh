#! /bin/bash
#
# Script to initialize the LUMI module system.
#
# The script takes no arguments.
#
# The root of the installation is derived from the place where the script is found.
# The script should be in <installroot>/${repo}/scripts with <installroot> the
# root for the installation.
#

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd "$(dirname $0)"
cd ..
repo="${PWD##*/}"
cd ..
installroot="$(pwd)"

#
# Functions used in this script
#

create_link () {

#  echo "Linking from: $1"
#  echo "Linking to: $2"
#  test -s "$2" && echo "File $2 found."
#  test -s "$2" || echo "File $2 not found."
  test -s "$2" || ln -s "$1" "$2"

}

#
# Create some of the directory structure
# We use more commands than strictly necessary, which can give more precise
# error messages.
#
mkdir -p "$installroot/modules"
mkdir -p "$installroot/modules/CrayOverwrite"
mkdir -p "$installroot/modules/CrayOverwrite/core"
mkdir -p "$installroot/modules/CrayOverwrite/core/cpe"
mkdir -p "$installroot/modules/SoftwareStack"
mkdir -p "$installroot/modules/SoftwareStack/LUMI"     # For the LUMI/yy.mm module files
mkdir -p "$installroot/modules/SystemPartition"
mkdir -p "$installroot/modules/SystemPartition/LUMI"   # For LUMI/yy.mm subdirectories
mkdir -p "$installroot/modules/easybuild"
mkdir -p "$installroot/modules/easybuild/LUMI"
mkdir -p "$installroot/modules/spack"
mkdir -p "$installroot/modules/spack/LUMI"
mkdir -p "$installroot/modules/manual"
mkdir -p "$installroot/modules/manual/LUMI"
mkdir -p "$installroot/modules/Infrastructure"
mkdir -p "$installroot/modules/Infrastructure/LUMI"

mkdir -p "$installroot/SW"

mkdir -p "$installroot/mgmt"
mkdir -p "$installroot/mgmt/ebrepo_files"
mkdir -p "$installroot/mgmt/LMOD"
mkdir -p "$installroot/mgmt/LMOD/VisibilityHookData"
mkdir -p "$installroot/mgmt/LMOD/ModuleRC"

mkdir -p "$installroot/sources"
mkdir -p "$installroot/sources/easybuild"
mkdir -p "$installroot/sources/easybuild/e"
mkdir -p "$installroot/sources/easybuild/e/EasyBuild"

#
# Link the cpe/restore-defaults module
#
create_link "$installroot/$repo/modules/CrayOverwrite/core/cpe/restore-defaults.lua" \
            "$installroot/modules/CrayOverwrite/core/cpe/restore-defaults.lua"
#
# If the system has a cpe module directory, we must ensure we use the same default
# version or LMOD may still load from the wrong directory. So we simply link to the
# Cray .version file but name it .modulerc (it is Tcl) to have a higher priority.
#
cpe_version_file='/opt/cray/pe/lmod/modulefiles/core/cpe/.version'
if [ -f "$cpe_version_file" ]
then
    create_link "$cpe_version_file" "$installroot/modules/CrayOverwrite/core/cpe/.modulerc"
fi

#
# Link the CrayEnv module
#
create_link "$installroot/$repo/modules/CrayEnv.lua"  "$installroot/modules/SoftwareStack/CrayEnv.lua"

#
# Link the style modules
#
# We simply link the directory. The defaults are set in LMOD/modulerc.lua
#
create_link "$installroot/$repo/modules/StyleModifiers" "$installroot/modules/StyleModifiers"

#
# Create a modulerc file in the SoftwareStack subdirectory to mark the default software stack.
# Initialy the default is set to a non-existing module, but we want to create the file.
#
cat >"$installroot/modules/SoftwareStack/LUMI/.modulerc.lua" <<EOF
module_version( "00.00", "default" )
EOF
