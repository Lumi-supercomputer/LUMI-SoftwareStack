if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
  LmodMessage( 'DEBUG: In ' .. myModuleFullName () .. ' (linked to partition_stack/CrayEnv.lua), the LMOD mode is ' .. mode() )
end

family( 'LUMI_SoftwareStack' )

local root = os.getenv( 'LUMITEST_ROOT' )

local partition = os.getenv( 'LUMI_OVERWRITE_PARTITION' )

whatis( 'CrayEnv restores the typical Cray Environment rather than using one of the LUMI software stacks.' )

help( [==[
CrayEnv gives you the original Cray environment as you get when you log in
to the compute nodes.

In the current implementation it will add the TCL modules to the MODULEPATH
rather than their LMOD equivalents as it is not clear yet how HPE-Cray
intends to use the latter.

The various compilers are made available through PrgEnv-* modules that
also adjust targets for the selected LUMI partition.
]==] )

prepend_path( 'MODULEPATH', pathJoin( root, 'modules', partition, 'PrgEnv' ) )
prepend_path( 'MODULEPATH', '/usr/share/modulefiles' )
prepend_path( 'MODULEPATH', '/usr/share/Modules/modulefiles' )
