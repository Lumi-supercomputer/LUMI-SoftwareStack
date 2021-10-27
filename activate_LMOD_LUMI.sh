#! /bin/bash

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd $(dirname $0)
reporoot="$(pwd)"

partition='L'

cat <<EOF

Add the following function to your bashrc.

function init-lumi-pilot {

    module --force purge

    # What is set here doesn't really matter as it will be overwritten by the LUMI-specific settings anyway.
    export MODULEPATH=/opt/cray/pe/lmod/modulefiles/core:/opt/cray/pe/lmod/modulefiles/craype-targets/default:/opt/cray/modulefiles:/opt/modulefiles

    # Initialise LMOD
    source /usr/share/lmod/lmod/init/bash

    # Force partition L as this is the one in which we currently install stuff
    export LUMI_OVERWRITE_PARTITION="$partition"

    # Initialise the software stack
    eval \$($reporoot/scripts/enable_LUMI.sh)

}

You can then activate this LUMI stack at any time by calling
init-lumi
in the shell.

Note however that since LMOD is not yet the default module system on the cluster, you'll
need to do that in all job scripts also (and make sure the function is defined in the scripts
as bashrc may not be read).

As an alternative, you can simply copy these 5 lines of code in the shell or your script to activate
the stack:

module --force purge
export MODULEPATH=/opt/cray/pe/lmod/modulefiles/core:/opt/cray/pe/lmod/modulefiles/craype-targets/default:/opt/cray/modulefiles:/opt/modulefiles
source /usr/share/lmod/lmod/init/bash
export LUMI_OVERWRITE_PARTITION="$partition"
eval \$($reporoot/scripts/enable_LUMI.sh)


Once the stack is intialised and activated, you can load
ml CrayEnv
or in the LUMI environment by using
ml LUMI/21.08

EOF
