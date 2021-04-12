family( 'LUMI_SoftwareStack' )

local partition = os.getenv( 'LUMI_PARTITION' )
local stack_version = myModuleVersion()

local root = os.getenv( 'LUMITEST_ROOT')
if root == nil then
  LmodError( 'The environment variable LUMITEST_ROOT is not found but needed to find the components of the LUMI prototype.' )
end

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
