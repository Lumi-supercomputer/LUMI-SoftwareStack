family( 'LUMI_SoftwareStack' )
add_property("lmod","sticky")

whatis( 'CrayEnv restores the typical Cray Environment rather than using one of the LUMI software stacks.' )

help( [==[

Description
===========
CrayEnv gives you the original Cray environment as you get when you log in
to the compute nodes.

In the current implementation it will add the TCL modules to the MODULEPATH
rather than their LMOD equivalents as it is not clear yet how HPE-Cray
intends to use the latter.

The environment is not yet fully functional as it relies on a module restore
to load a particular PrgEnv and Lmod does not support the format used by
the TCL Environment Modules implementation to store those environments.
]==] )

if isDir( '/usr/share/modulefiles' ) then prepend_path( 'MODULEPATH', '/usr/share/modulefiles' ) end
if isDir( '/usr/share/Modules/modulefiles' ) then prepend_path( 'MODULEPATH', '/usr/share/Modules/modulefiles' ) end
prepend_path( 'MODULEPATH', '/opt/modulefiles' )
prepend_path( 'MODULEPATH', '/opt/cray/modulefiles' )
prepend_path( 'MODULEPATH', '/opt/cray/pe/lmod/modulefiles/craype-targets/default' )
prepend_path( 'MODULEPATH', '/opt/cray/pe/lmod/modulefiles/core' )

-- Temporary code only needed because the Grenoble system has an incomplete
-- HPE-Cray programming environment

-- Detect the module root from the position of this module in the module tree
local module_root = myFileName():match( '(.*/modules)/SoftwareStack/.*' )
local missing_core = pathJoin( module_root, 'missing', 'core' )
if isDir( missing_core ) then
    prepend_path( 'MODULEPATH', missing_core )
end
