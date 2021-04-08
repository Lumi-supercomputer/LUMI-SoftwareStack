if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
  LmodMessage( 'DEBUG: In ' .. myModuleFullName () .. ' (linked to stack.MOD.lua), the LMOD mode is ' .. mode() )
end

family( 'LUMI_SoftwareStack' )

local stack_version = myModuleVersion()

local root = os.getenv( 'LUMITEST_ROOT' )
if root == nil then
  LmodError( 'The environment variable LUMITEST_ROOT is not found but needed to find the components of the LUMI prototype.' )
end

-- We do need to take into account that there are scenarios when this module will be
-- unloaded while LUMI_OVERWRITE_PARTITION has already been changed since the load
-- due to the strange order in which Lmod does some operations. Hence we need to
-- save the value of the partition that was used to prevent leftovers after an unload.
local partition
if mode() == load then
  -- Here we should ensure that LUMI_OVERWRITE_PARTITION is set or something is seriously wrong.
  partition = os.getenv( 'LUMI_OVERWRITE_PARTITION' )
  if partition == nil then
    LmodError( 'The environment variable LUMI_OVERWRITE_PARTITION is not found. ' ..
               'Either you unset a crucial environment variable or some unforeseen scenatio deployed.' ..
               'Contact user support if you can reproduce the scenario and did not accidentally mesh up your environment.' )
  end
else
  -- Here we first check the stored state.
  partition = os.getenv( '_LUMI_SoftwareStack_STATE_PARTITION' )
  if partition == nil then
    partition = os.getenv( 'LUMI_OVERWRITE_PARTITION' )
    if partition == nil then
      LmodError( 'The environment variable LUMI_OVERWRITE_PARTITION is not found. Maybe there is no LUMI partition module loaded. ' ..
                 'If you are trying to change the partition without unloading LUMI/' .. stack_version .. ', this may be the cause of this error message.' )
    end
  end
end

whatis( 'Enables the LUMI-' .. stack_version .. ' software stack for the ' .. partition .. ' partition.' )

local helpmssg = [==[
This module enables the LUMI-VERSION software stack for the PARTITION partition.

By swapping the PARTITION partition module it is possible to load software compiled for
a different partition instead, but be careful as that software may not run as
expected. In any case, replacing the PARTITION partition module can also have
unexpected results on the list of loaded modules due to the way Lmod works and
inactivates modules rather than unloading them when they disappear from the
module path.
]==]
helpmssg = helpmssg:gsub( 'VERSION',   stack_version )
helpmssg = helpmssg:gsub( 'PARTITION', partition )
help( helpmssg )

local stack = 'LUMI-' .. stack_version
setenv( 'LUMI_STACK_NAME',         'LUMI')
setenv( 'LUMI_STACK_VERSION',      stack_version )
setenv( 'LUMI_STACK_NAME_VERSION', 'LUMI/' .. stack_version )

-- Remember the current internal state (basically only the partition) as
-- the module code may be executed without LUMI_OVERWRITE_PARTITION begin set,
-- in particular in some cases where Lmod does a dependency check.
setenv( '_LUMI_SoftwareStack_STATE_PARTITION', partition )

prepend_path( 'MODULEPATH', pathJoin( root, 'modules', 'common', stack, 'Cray' ) )
prepend_path( 'MODULEPATH', pathJoin( root, 'modules', 'common', stack, 'Cray-targets' ) )

prepend_path( 'MODULEPATH', pathJoin( root, 'stack', partition, stack, 'easybuild/modules' ) )
-- prepend_path( 'MODULEPATH', pathJoin( root, 'stack', partition, stack, 'spack/modules' ) )
prepend_path( 'MODULEPATH', pathJoin( root, 'stack', partition, stack, 'manual/modules' ) )

