if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() .. ': Entering' )
end

add_property( 'lmod', 'sticky' )

whatis( 'Enables/disables a search through all installed modules with the module spider command.' )

help( [[

Description
===========
Loading this module disables a search through all installed modules with the module
spider command, excluding software installed through the spack modules and
local software stacks.

Loading this module, or not loading any ]] .. myModuleName() .. [[ module at all, may
significantly speed up module spider or module avail when it needs to rebuild the
module cache.
]] )

-- Use pushenv to restore the value that a user may have set before when unloading
-- this module.
pushenv( '_LUMI_FULL_SPIDER', 0 )

-- Clear the Lmod cache when loading or unloading the module
execute{ cmd='/usr/bin/rm -rf ~/.cache/lmod', modeA={'load','unload'} } 

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() .. ': Exiting' )
end
