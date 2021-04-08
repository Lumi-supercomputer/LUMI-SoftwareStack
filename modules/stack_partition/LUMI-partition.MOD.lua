family( 'LUMI_partition' )

local partition = myModuleName()

local stack_name =         os.getenv( 'LUMI_STACK_NAME' )
local stack_version =      os.getenv( 'LUMI_STACK_VERSION' )
local stack_name_version = os.getenv( 'LUMI_STACK_NAME_VERSION' )

local root = os.getenv( 'LUMITEST_ROOT')
if root == nil then
  LmodError( 'The environment variable LUMITEST_ROOT is not found but needed to find the components of the LUMI prototype.' )
end

whatis( 'Description: Enables the ' .. partition .. ' binaries for the ' .. stack_name_version .. ' software stack.' )

helpmssg = [==[
Enables the PARTITION-specific binaries for the STACK software stack.

This module is loaded automatically when loading a software stack based on the
hardware on which the module load is executed. Replace with a different version
at your own risk as not all software compiled for one LUMI partition will also
run on another partition.
]==]
helpmssg = helpmssg:gsub( 'PARTITION', partition )
helpmssg = helpmssg:gsub( 'STACK', stack_name_version )
help( helpmssg )

setenv( 'LUMI_OVERWRITE_PARTITION', partition )

local stack = stack_name .. '-' .. stack_version
prepend_path( 'MODULEPATH', pathJoin( root, 'modules', stack, 'Cray' ) )
prepend_path( 'MODULEPATH', pathJoin( root, 'modules', stack, 'Cray-targets' ) )
prepend_path( 'MODULEPATH', pathJoin( root, 'modules', stack, partition, 'manual' ) )
prepend_path( 'MODULEPATH', pathJoin( root, 'modules', stack, partition, 'spack' ) )
prepend_path( 'MODULEPATH', pathJoin( root, 'modules', stack, partition, 'easybuild' ) )
