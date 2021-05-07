whatis( 'Hide module extensions in the output of module avail.' )

help( [[

Description
===========
Loading this module disables showing module extensions in the output of module
avail.

With no ]] .. myModuleName() .. [[ module loaded, you get the defailt behaviour of the
module tool as configured in the system.
]] )

setenv( 'LMOD_AVAIL_EXTENSIONS', 'no' )
