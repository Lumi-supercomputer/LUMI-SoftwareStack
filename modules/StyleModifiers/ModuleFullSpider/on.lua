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

You can obtain the same effect by simply setting LUMI_FULL_SPIDER to a nonzero value:
export LUMI_FULL_SPIDER=1
which may be the best way if you always want module spider to index all
software. This prevents the re-generation of the cache files whenever
this module is loaded or unloaded. This environment varialble also overwrites
the effect of the ]] .. myModuleName() .. [[ modules and guarantees a more 
consistent behaviour across multiple shells.

Note that this will considerably slow down some module spider and module available
commands, which is why this is not turned on by default.
]] )

-- Use pushenv to restore the value that a user may have set before when unloading
-- this module.
pushenv( '_LUMI_FULL_SPIDER', 1 )

-- Clear the Lmod cache when loading or unloading the module
execute{ cmd='/usr/bin/rm -rf ~/.cache/lmod', modeA={'load','unload'} } 

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() .. ': Exiting' )
end
