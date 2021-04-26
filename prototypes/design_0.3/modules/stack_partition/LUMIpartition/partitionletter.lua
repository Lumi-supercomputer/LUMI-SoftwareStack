if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
  LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() )
end

family( 'LUMI_partition' )
add_property("lmod","sticky")

local node_description = {
    C = 'CPU compute',
    G = 'GPU compute',
    D = 'data and visualisation',
    L = 'login',
}

local module_root = os.getenv( 'LMOD_MODULE_ROOT')
if module_root == nil then
  LmodError( 'The environment variable LMOD_MODULE_ROOT is not found but needed to find the components of the LUMI prototype.' )
end

local hierarchy = hierarchyA( myModuleFullName(), 1 )
if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
  LmodMessage( 'DEBUG: Detected the ' .. hierarchy[1] .. ' Software stack' )
end
local stack_name_version = hierarchy[1]

local partition = myModuleVersion()

whatis( 'Description: ' .. myModuleFullName() .. ' enables the ' .. stack_name_version .. ' software stack for the LUMI-' .. partition .. ' (' .. node_description[partition] .. ') partition.' )

help( [[

Description
===========
Enables the ]] .. stack_name_version .. [[ software stack for the LUMI-]] .. partition .. [[ (]] .. node_description[partition] .. [[) partition.

This module will be loaded automatically when logging in to the node based
on the hardware of the node. Replace with a different version at your own
risk as not all software that may be enabled directly or indirectly through
this module may work on this partition.
This module is loaded automatically when loading a software stack based on the
]] )

setenv( 'LUMI_OVERWRITE_PARTITION', 'LUMI-' .. partition )

-- The Cray modules, may be possible to only activate them once PrgEnv-* is loaded
prepend_path( 'MODULEPATH', '/opt/cray/pe/lmod/modulefiles/core' )
-- The modules of application software
prepend_path( 'MODULEPATH', pathJoin( module_root, 'modules', 'manual',    stack_name_version, 'partition', partition ) )
prepend_path( 'MODULEPATH', pathJoin( module_root, 'modules', 'spack',     stack_name_version, 'partition', partition ) )
prepend_path( 'MODULEPATH', pathJoin( module_root, 'modules', 'easybuild', stack_name_version, 'partition', partition ) )

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
  local modulepath = os.getenv( 'MODULEPATH' ):gsub( ':', '\n' )
  LmodMessage( 'DEBUG: The MODULEPATH before exiting ' .. myModuleFullName() .. ' (mode ' .. mode() .. ') is:\n' .. modulepath .. '\n' )
end
