if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() )
end

family( 'LUMI_SoftwareStack' )
add_property("lmod","sticky")

local module_root = os.getenv( 'LMOD_MODULE_ROOT')
if module_root == nil then
    LmodError( 'The environment variable LMOD_MODULE_ROOT is not found but needed to find the components of the LUMI prototype.' )
end

local stack_name    = myModuleName()
local stack_version = myModuleVersion()

local partition     = detect_LUMI_partition()
if partition == nil then
    LmodError( 'Failed to detect the LUMI partition, something must be messed up pretty badly.' )
end

if stack_version:find( '%.dev$' ) then
    add_property( 'state', 'development_stack' )
else
    add_property( 'state', 'LTS_stack' )
end

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

load( 'partition/' .. partition )

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    local modulepath = os.getenv( 'MODULEPATH' ):gsub( ':', '\n' )
    LmodMessage( 'DEBUG: The MODULEPATH before exiting ' .. myModuleFullName() .. ' (mode ' .. mode() .. ') is:\n' .. modulepath .. '\n' )
end
