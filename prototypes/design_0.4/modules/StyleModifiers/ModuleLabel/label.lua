if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() .. ': Entering' )
end

add_property( 'lmod', 'sticky' )

whatis( 'Enforces showing descriptitve labels in the output of module avail rather than directories and collapses the Cray PE module hierarchy.' )

help( [[

Description
===========
Loading this module sets your environment to tell the module system to use
descriptitve labels rather than directories for the module categories, and
it will also collapse the Cray PE module hierarchy to take less space on
your screen.

With this module loaded, you can still show directories by using
$  module -s system avail
instead or get the labeled view with the hierarchy by using
$  module -s PEhierarchy avail

With no ]] .. myModuleName() .. [[ module loaded, you get the defailt behaviour of the
module tool as configured in the system.
]] )

if isloaded( 'ModuleStyle' ) then
    -- As the user tries to change the module style, it makes no sense to leave
    -- ModuleStyle/default or ModuleStyle/reset loaded.
    unload( 'ModuleStyle' )
end

-- Use pushenv to restore the value that a user may have set before when unloading
-- this module or to restore the value set by the system.
pushenv( 'LMOD_AVAIL_STYLE', '<label>:PEhierarchy:system' )

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() .. ': Exiting' )
end
