if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
  LmodMessage( 'DEBUG: In ' .. myModuleFullName () .. ' (linked to stack_partition/LUMI/stack.lua), the LMOD mode is ' .. mode() )
end

family( 'LUMI_SoftwareStack' )

local stack_version = 'LUMI_STACK_VERSION'
local partition =     'LUMI_PARTITION'
local root =          'LUMITEST_ROOT'

whatis( 'Enables the LUMI-' .. stack_version .. ' software stack for the current partition.' )

local helpmssg = [==[
This module enables the LUMI-VERSION software stack for the current partition.

By swapping the partition module it is possible to load software compiled for
a different partition instead, but be careful as that software may not run as
expected.
]==]
helpmssg = helpmssg:gsub( 'VERSION', stack_version )
help( helpmssg )

local stack = 'LUMI-' .. stack_version
prepend_path( 'MODULEPATH', pathJoin( root, 'modules', stack, 'LUMIpartition' ) )

setenv( 'LUMI_STACK_NAME',         'LUMI')
setenv( 'LUMI_STACK_VERSION',      stack_version )
setenv( 'LUMI_STACK_NAME_VERSION', 'LUMI/' .. stack_version )

load( partition )
