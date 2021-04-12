family( 'LUMI_SoftwareStack' )

local root = 'LUMITEST_ROOT'

whatis( 'CrayEnv restores the typical Cray Environment rather than using one of the LUMI software stacks.' )

help( [==[
CrayEnv gives you the original Cray environment as you get when you log in
to the compute nodes.

In the current implementation it will add the TCL modules to the MODULEPATH
rather than their LMOD equivalents as it is not clear yet how HPE-Cray
intends to use the latter.

The environment is not yet fully functional as it relies on a module restore
to load a particular PrgEnv and Lmod does not support the format used by
the TCL Environment Modules implementation to store those environments.
]==] )

-- prepend_path( 'MODULEPATH', '/usr/share/modulefiles' )
-- prepend_path( 'MODULEPATH', '/usr/share/Modules/modulefiles' )
prepend_path( 'MODULEPATH', '/opt/cray/pe/lmod/modulefiles/core' )
