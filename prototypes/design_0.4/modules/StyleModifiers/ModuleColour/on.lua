if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() .. ': Entering' )
end

add_property( 'lmod', 'sticky' )

whatis( 'Enables the use of colour in the display of modules.' )

help( [[

Description
===========
Loading this module disables the use of colour in the display of modules.

With no ]] .. myModuleName() .. [[ module loaded, you get the defailt behaviour of the
module tool as configured in the system.
]] )

if isloaded( 'ModuleStyle' ) then
    -- As the user tries to change the module style, it makes no sense to leave
    -- ModuleStyle/default or ModuleStyle/reset loaded.
    unload( 'ModuleStyle' )
end

-- Use pushenv to restore the value that a user may have set before when unloading
-- this module.
pushenv( 'LMOD_COLORIZE', 'yes' )

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() .. ': Exiting' )
end
