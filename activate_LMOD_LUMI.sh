#! /bin/bash

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd $(dirname $0)
reporoot="$(pwd)"

partition='L'

cat <<EOF

Add the following function to your bashrc.

function init-lumi-pilot {

    # Force partition L as this is the one in which we currently install stuff
    export LUMI_OVERWRITE_PARTITION="$partition"

    # Initialise the software stack
    # It will clean up the environment which may cause an error message in a subshell if
    # LMOD variables are imported into the subshell while the Tcl Modules Environment is
    # loaded again as both implementations use the LOADED_MODULES environment variable,
    # so the Tcl modules may try to unload Lmod modules which does not work.
    eval \$($reporoot/scripts/enable_LUMI.sh)

    # Initialise LMOD
    source /usr/share/lmod/lmod/init/bash

}

You can then activate this LUMI stack at any time by calling
init-lumi-pilot
in the shell.

Note however that since LMOD is not yet the default module system on the cluster, you'll
need to do that in all job scripts also (and make sure the function is defined in the scripts
as bashrc may not be read).

As an alternative, you can simply copy these 3 lines of code in the shell or your script to activate
the stack:

export LUMI_OVERWRITE_PARTITION="$partition"
eval \$($reporoot/scripts/enable_LUMI.sh)
source /usr/share/lmod/lmod/init/bash

which again may cause an error message if Tcl Modules Environment is loaded in a subshell
again on top of Lmod variables imported from the parent shell. This is because both the Tcl
Environment Modules and Lmod use the environment variable LOADED_MODULES, causing the Tcl
Environment Modules package to try and unload Lmod modules.

Once the stack is intialised and activated, you can load
ml CrayEnv
or in the LUMI environment by using
ml LUMI/21.08

EOF
