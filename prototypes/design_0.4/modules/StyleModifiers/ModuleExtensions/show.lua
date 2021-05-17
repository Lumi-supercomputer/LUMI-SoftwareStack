add_property( 'lmod', 'sticky' )

whatis( 'Show module extensions in the output of module avail.' )

help( [[

Description
===========
Loading this module enables showing module extensions in the output of module
avail.

With no ]] .. myModuleName() .. [[ module loaded, you get the defailt behaviour of the
module tool as configured in the system.
]] )

setenv( 'LMOD_AVAIL_EXTENSIONS', 'yes' )
