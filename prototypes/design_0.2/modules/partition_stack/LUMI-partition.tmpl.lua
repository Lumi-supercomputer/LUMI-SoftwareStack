if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
  LmodMessage( 'DEBUG: In ' .. myModuleName() .. ' (linked to LUMI-partition.lua), the LMOD mode is ' .. mode() )
end

family( 'LUMI_partition' )
add_property("lmod","sticky")

local partition = 'LUMI_PARTITION'
local root =      'LUMITEST_ROOT'

whatis( 'Description: Enables the software stacks for the LUMI_PARTITION partition.' )

help( [[
Enables the software stacks for the LUMI_PARTITION partition.

This module will be loaded automatically when logging in to the node based
on the hardware of the node. Replace with a different version at your own
risk as not all software that may be enabled directly or indirectly through
this module may work on this partition.
This module is loaded automatically when loading a software stack based on the
]] )

setenv( 'LUMI_OVERWRITE_PARTITION', partition )

prepend_path( 'MODULEPATH', pathJoin( root, 'modules', partition, 'SoftwareStack' ) )
