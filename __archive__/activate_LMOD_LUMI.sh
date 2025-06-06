#! /bin/bash

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd $(dirname $0)
reporoot="$(pwd)"

partition="L"

cat <<EOF
CHANGED ON 14 DECEMBER 2021!

Some changes have been made for a roll-out to the production environment
  - Software is now installed in partition/L and partition/C so all node
    types available at the start of the extended beta phase are supported.
  - There is now automatic detection of the node type based on the hostname
    so LUMI_OVERWRITE_PARTITION is only needed if you only want to use
    software for partition/L to keep things simple.
    Note that since the 21.05 and 21.08 compilers do not specifically
    optimise for the zen3 CPUs of most compute nodes, this does not yet
    matter, but it will matter with future updates.
  - We are rolling out LMOD. The procedure below should work for both
    Environment Modules and for LMOD.
    Once the system is fully transitioned you may use enable_LUMI_CPE.sh
    instead to ensure that you keep on track with whatever the Cray
    configuration files do, but in general the much simpler
    enable_LUMI.sh is sufficient.
  - LMOD initialisation is now done in the enable_LUMI scripts.

To enable the LMOD software stack (if it is not there by default), add
the following function to your bashrc.

function init-lumi-pilot {

    # Force partition L as this is the one in which we currently install stuff
    # See above, only needed if you want to force
    # export LUMI_OVERWRITE_PARTITION="$partition"

    # Initialise the software stack
    # It will clean up the environment which may cause an error messages or
    # other messages that usually can be ignored.
    eval \$($reporoot/scripts/enable_LUMI.sh)

}

You can then activate this LUMI stack at any time by calling
init-lumi-pilot
in the shell.

As an alternative, you can simply copy this line of code in the shell or your script to activate
the stack:

eval \$($reporoot/scripts/enable_LUMI.sh)
(and possible precede it with
export LUMI_OVERWRITE_PARTITION="$partition"
if you only want software for the login nodes everywhere).

Once the stack is intialised and activated, you can load
ml CrayEnv
or in the LUMI environment by using
ml LUMI/21.08

EOF

