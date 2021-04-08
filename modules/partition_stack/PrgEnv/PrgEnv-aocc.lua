if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
  LmodMessage( 'DEBUG: In ' .. myModuleFullName () .. ' (linked to partition_stack/PrgEnv/PrgEnv-aocc.lua), the LMOD mode is ' .. mode() )
end

family( 'LUMI_PrgEnv' )

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
  partition = os.getenv( '_LUMI_PrgEnv_aocc_STATE_PARTITION' )
  if partition == nil then
    partition = os.getenv( 'LUMI_OVERWRITE_PARTITION' )
    if partition == nil then
      LmodError( 'The environment variable LUMI_OVERWRITE_PARTITION is not found. Maybe there is no LUMI partition module loaded. ' ..
                 'If you are trying to change the partition without unloading LUMI/' .. stack_version .. ', this may be the cause of this error message.' )
    end
  end
end

whatis( 'PrgEnv-aocc loads a collection of modules together defining the Cray Programming Environment with the AMD compilers.'  )

help( [==[
PrgEnv-aocc loads a collection of modules together defining the Cray Programming
Environment with the AMD compilers.

This is an experimental module derived from the stored module set used by
HPE-Cray in their collection of TCL Environment Modules.

It does not yet take into account the righ target modules for every node
type on LUMI but sets those for the Grenoble test nodes.
]==] )

prepend_path( 'MODULEPATH', '/etc/scl/modulefiles' )
prepend_path( 'MODULEPATH', '/opt/cray/pe/cpe-prgenv/7.0.0/modules' )
prepend_path( 'MODULEPATH', '/opt/modulefiles' )
prepend_path( 'MODULEPATH', '/opt/cray/modulefiles' )
prepend_path( 'MODULEPATH', '/opt/cray/pe/modulefiles' )
prepend_path( 'MODULEPATH', '/opt/cray/pe/craype-targets/default/modulefiles' )
prepend_path( 'MODULEPATH', '/opt/cray/pe/craype/2.7.0/modulefiles' )

load( 'cpe-aocc' )
load( 'aocc' )
load( 'craype' )
if partition == 'LUMI-C' then
  load( 'craype-x86-milan' )
elseif partition == 'LUMI-G' then
  load( 'craype-x86-milan' )
  load( 'craype-accel-amd-gfx908' )
elseif partition == 'LUMI-D' then
  load( 'craype-x86-rome' )
elseif partition == 'LUMI-L' then
  load( 'craype-x86-rome' )
  load( 'craype-accel-amd-gfx908' )
end
load( 'libfabric' )
load( 'craype-network-ofi' )
load( 'cray-mpich' )
load( 'cray-libsci' )

-- Remember the current internal state (basically only the partition) as
-- the module code may be executed without LUMI_OVERWRITE_PARTITION begin set,
-- in particular in some cases where Lmod does a dependency check.
setenv( '_LUMI_PrgEnv_aocc_STATE_PARTITION', partition )
