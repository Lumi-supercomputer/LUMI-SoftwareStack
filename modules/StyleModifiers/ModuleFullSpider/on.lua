if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() .. ': Entering' )
end

add_property( 'lmod', 'sticky' )

whatis( 'Enables/disables a search through all installed modules with the module spider command.' )

help( [[

Description
===========
Loading this module enables a search through all installed modules with the module
spider command, also inclusing software installed through the spack modules and
some local software stacks.

Note that this will considerably slow down some module spider and module available
commands, which is why this is not turned on by default.
]] )

-- Use pushenv to restore the value that a user may have set before when unloading
-- this module.
pushenv( '_LUMI_FULL_SPIDER', 1 )

-- Clear the Lmod cache
if mode() == 'load' or mode() == 'unload' then
    execute{ cmd='/usr/bin/rm -rf ~/.cache/lmod', modeA={'load','unload'} } 
end

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() .. ': Exiting' )
end
