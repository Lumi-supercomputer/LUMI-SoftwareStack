if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
  LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() )
end

family( 'LUMI_partition' )
add_property("lmod","sticky")

local module_root = os.getenv( 'LMOD_MODULE_ROOT' )
if module_root == nil then
  LmodError( 'The environment variable LMOD_MODULE_ROOT is not found but needed to find the components of the LUMI prototype.' )
end

local partition = myModuleVersion()

whatis( 'Description: Enables the software stacks for the LUMI-' .. partition .. ' partition.' )

help( [[

Description
===========
Enables the software stacks for the LUMI-]] .. partition .. [[ partition.

This module will be loaded automatically when logging in to the node based
on the hardware of the node. Replace with a different version at your own
risk as not all software that may be enabled directly or indirectly through
this module may work on this partition.
This module is loaded automatically when loading a software stack based on the
]] )

setenv( 'LUMI_OVERWRITE_PARTITION', 'LUMI-' .. partition )

prepend_path( 'MODULEPATH', pathJoin( module_root, 'modules', 'SoftwareStack', 'partition', partition ) )

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
  local modulepath = os.getenv( 'MODULEPATH' ):gsub( ':', '\n' )
  LmodMessage( 'DEBUG: The MODULEPATH before exiting ' .. myModuleFullName() .. ' (mode ' .. mode() .. ') is:\n' .. modulepath .. '\n' )
end
