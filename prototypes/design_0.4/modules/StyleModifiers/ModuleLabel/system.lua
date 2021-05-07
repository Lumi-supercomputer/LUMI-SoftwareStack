whatis( 'Enforces showing module directories in the output of module avail rather than descriptitve labels.' )

help( [[

Description
===========
Loading this module sets your environment to tell the module system to use
module directories rather than descriptive labels for the module categories.

With this module loaded, you can still show descriptive labels by using
$  module -s label avail
instead.

With no ]] .. myModuleName() .. [[ module loaded, you get the defailt behaviour of the
module tool as configured in the system.
]] )

pushenv( 'LMOD_AVAIL_STYLE', 'system,label' )
