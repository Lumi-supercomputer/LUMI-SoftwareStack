if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
  LmodMessage( 'DEBUG: In ' .. myModuleFullName () .. ' (generated from stack_partition/LUMI-partition.MOD.tmpl.lua), the LMOD mode is ' .. mode() )
end

family( 'LUMI_partition' )

local partition ='LUMI_PARTITION'

local stack_name =         'LUMI'
local stack_version =      'LUMI_STACK_VERSION'
local stack_name_version = 'LUMI/LUMI_STACK_VERSION'

local root = os.getenv( 'LUMITEST_ROOT')
if root == nil then
  LmodError( 'The environment variable LUMITEST_ROOT is not found but needed to find the components of the LUMI prototype.' )
end

whatis( 'Description: Enables the LUMI_PARTITION binaries for the LUMI/LUMI_STACK_VERSION software stack.' )

help( [[
Enables the LUMI_PARTITION-specific binaries for the LUMI/LUMI_STACK_VERSION software stack.

This module is loaded automatically when loading a software stack based on the
hardware on which the module load is executed. Replace with a different version
at your own risk as not all software compiled for one LUMI partition will also
run on another partition.

]] )

setenv( 'LUMI_OVERWRITE_PARTITION', partition )

local stack = stack_name .. '-' .. stack_version
-- The Cray modules, may be possible to only activate them once PrgEnv-* is loaded
prepend_path( 'MODULEPATH', '/opt/cray/pe/lmod/modulefiles/core' )
-- The modules of application software
prepend_path( 'MODULEPATH', pathJoin( root, 'modules', stack, partition, 'manual' ) )
-- prepend_path( 'MODULEPATH', pathJoin( root, 'modules', stack, partition, 'spack' ) )
prepend_path( 'MODULEPATH', pathJoin( root, 'modules', stack, partition, 'easybuild' ) )
