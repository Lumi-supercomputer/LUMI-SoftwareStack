add_property( 'lmod', 'sticky' )

whatis( 'Enable power user mode which shows a number of modules that would be hidden otherwise.' )

help( [[

Description
===========
Loading this module enables power user mode for module avail. It will enable
the display of some modules that might be hidden otherwise.

The working of these modules is often not documented in the LUMI documentation
and hence they are not covered by the LUMI User Support Team. Most of these
modules are really meant for power users who understand very well what they
are doing and who have a thorough knowledge of the LUMI system.

Disable power user mode again by unloading this module.
]] )

setenv( 'LUMI_LMOD_POWERUSER', 1 )
