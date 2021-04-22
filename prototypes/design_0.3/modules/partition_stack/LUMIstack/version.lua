if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
  LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() )
end

family( 'LUMI_SoftwareStack' )
-- add_property("lmod","sticky")

local module_root = os.getenv( 'LMOD_MODULE_ROOT' )
if module_root == nil then
  LmodError( 'The environment variable LMOD_MODULE_ROOT is not found but needed to find the components of the LUMI prototype.' )
end

local stack_name    = myModuleName()
local stack_version = myModuleVersion()

-- Detect the partition from the hierarchy.
local hierarchy = hierarchyA( myModuleFullName(), 1 )
if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
  LmodMessage( 'DEBUG: hierarchy[1]: ' .. hierarchy[1] )
end
local partition = hierarchy[1]:gsub( 'partition%/', '' )
if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
  LmodMessage( 'DEBUG: Running in partition LUMI-' .. partition )
end

whatis( 'Enables the LUMI/' .. stack_version .. ' software stack for the LUMI-' .. partition .. ' partition.' )

help( [[
This module enables the LUMI/]] .. stack_version .. [[ software stack for the LUMI-]] .. partition .. [[ partition.

By swapping the LUMI-]] .. partition .. [[ partition module it is possible to load software compiled for
a different partition instead, but be careful as that software may not run as
expected. In any case, replacing the LUMI-]] .. partition .. [[ partition module can also have
unexpected results on the list of loaded modules due to the way Lmod works and
inactivates modules rather than unloading them when they disappear from the
module path.
]] )

setenv( 'LUMI_STACK_NAME',         stack_name )
setenv( 'LUMI_STACK_VERSION',      stack_version )
setenv( 'LUMI_STACK_NAME_VERSION', stack_name .. '/' .. stack_version )

prepend_path( 'MODULEPATH', '/opt/cray/pe/lmod/modulefiles/core' )

prepend_path( 'MODULEPATH', pathJoin( module_root, 'modules', 'easybuild', 'partition', partition, stack_name, stack_version ) )
prepend_path( 'MODULEPATH', pathJoin( module_root, 'modules', 'spack',     'partition', partition, stack_name, stack_version ) )
prepend_path( 'MODULEPATH', pathJoin( module_root, 'modules', 'manual',    'partition', partition, stack_name, stack_version ) )

local modulepath = os.getenv( 'MODULEPATH' ):gsub( ':', '\n' )
LmodMessage( 'DEBUG: The MODULEPATH before exiting ' .. myModuleFullName() .. ' (mode ' .. mode() .. ') is:\n' .. modulepath .. '\n' )
