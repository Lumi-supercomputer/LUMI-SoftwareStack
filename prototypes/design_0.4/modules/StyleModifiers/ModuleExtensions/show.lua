if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() .. ': Entering' )
end

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

if isloaded( 'ModuleStyle' ) then
    -- As the user tries to change the module style, it makes no sense to leave
    -- ModuleStyle/default or ModuleStyle/reset loaded.
    unload( 'ModuleStyle' )
end

-- Use pushenv to restore the value that a user may have set before when unloading
-- this module.
pushenv( 'LMOD_AVAIL_EXTENSIONS', 'yes' )

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() .. ': Exiting' )
end
