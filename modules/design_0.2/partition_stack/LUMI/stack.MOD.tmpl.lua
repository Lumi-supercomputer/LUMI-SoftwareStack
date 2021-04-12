if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
  LmodMessage( 'DEBUG: In ' .. myModuleFullName () .. ' (linked to stack.MOD.lua), the LMOD mode is ' .. mode() )
end

family( 'LUMI_SoftwareStack' )

local stack_version = 'LUMI_STACK_VERSION'
local partition =     'LUMI_PARTITION'
local root =          'LUMITEST_ROOT'

whatis( 'Enables the LUMI/LUMI_STACK_VERSION software stack for the ' .. partition .. ' partition.' )

help( [[
This module enables the LUMI/LUMI_STACK_VERSION software stack for the LUMI_PARTITION partition.

By swapping the LUMI_PARTITION partition module it is possible to load software compiled for
a different partition instead, but be careful as that software may not run as
expected. In any case, replacing the LUMI_PARTITION partition module can also have
unexpected results on the list of loaded modules due to the way Lmod works and
inactivates modules rather than unloading them when they disappear from the
module path.
]] )

local stack = 'LUMI-' .. stack_version
setenv( 'LUMI_STACK_NAME',         'LUMI')
setenv( 'LUMI_STACK_VERSION',      stack_version )
setenv( 'LUMI_STACK_NAME_VERSION', 'LUMI/' .. stack_version )

prepend_path( 'MODULEPATH', '/opt/cray/pe/lmod/modulefiles/core' )

prepend_path( 'MODULEPATH', pathJoin( root, 'modules', partition, stack, 'easybuild' ) )
-- prepend_path( 'MODULEPATH', pathJoin( root, 'modules', partition, stack, 'spack' ) )
prepend_path( 'MODULEPATH', pathJoin( root, 'modules', partition, stack, 'manual' ) )

