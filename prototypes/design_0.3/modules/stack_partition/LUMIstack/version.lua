if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
  LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() )
end

family( 'LUMI_SoftwareStack' )
-- add_property("lmod","sticky")

local module_root = os.getenv( 'LMOD_MODULE_ROOT')
if module_root == nil then
  LmodError( 'The environment variable LMOD_MODULE_ROOT is not found but needed to find the components of the LUMI prototype.' )
end

local stack_name    = myModuleName()
local stack_version = myModuleVersion()

local partition     = os.getenv( 'LUMI_PARTITION' )
if partition == nil then
  LmodError( 'The environment variable LUMI_PARTITION which should be set by the default login environment is not found.' )
end
partition = partition:gsub( 'LUMI%-', '')

whatis( 'Enables the LUMI-' .. stack_version .. ' software stack for the current partition.' )

help( [[

Description
===========
This module enables the LUMI/]] .. stack_version .. [[ software stack for the current partition.

By swapping the partition module it is possible to load software compiled for
a different partition instead, but be careful as that software may not run as
expected.
]] )

local stack = 'LUMI-' .. stack_version
prepend_path( 'MODULEPATH', pathJoin( module_root, 'modules', 'SystemPartition', stack_name, stack_version ) )

setenv( 'LUMI_STACK_NAME',         stack_name )
setenv( 'LUMI_STACK_VERSION',      stack_version )
setenv( 'LUMI_STACK_NAME_VERSION', stack_name .. '/' .. stack_version )

-- load( 'partition/' .. partition )
