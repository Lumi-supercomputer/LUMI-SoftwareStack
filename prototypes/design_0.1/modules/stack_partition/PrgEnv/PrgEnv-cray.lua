family( 'PrgEnv' )

whatis( 'PrgEnv-cray loads a collection of modules together defining the Cray Programming Environment with the Cray compilers.'  )

help( [==[
PrgEnv-cray loads a collection of modules together defining the Cray Programming
Environment with the Cray compilers.

This is an experimental module derived from the stored module set used by
HPE-Cray in their collection of TCL Environment Modules.

It does not yet take into account the righ target modules for every node
type on LUMI but sets those for the Grenoble test nodes.
]==] )

-- prepend_path( 'MODULEPATH', '/sw/com/modulefiles' )
-- prepend_path( 'MODULEPATH', '/usr/share/modulefiles' )
-- prepend_path( 'MODULEPATH', '/etc/modulefiles' )
-- prepend_path( 'MODULEPATH', '/usr/share/Modules/modulefiles' )
prepend_path( 'MODULEPATH', '/etc/scl/modulefiles' )
prepend_path( 'MODULEPATH', '/opt/cray/pe/cpe-prgenv/7.0.0/modules' )
prepend_path( 'MODULEPATH', '/opt/modulefiles' )
prepend_path( 'MODULEPATH', '/opt/cray/modulefiles' )
prepend_path( 'MODULEPATH', '/opt/cray/pe/modulefiles' )
prepend_path( 'MODULEPATH', '/opt/cray/pe/craype-targets/default/modulefiles' )
prepend_path( 'MODULEPATH', '/opt/cray/pe/craype/2.7.0/modulefiles' )

load( 'cpe-cray' )
load( 'cce' )
load( 'craype' )
load( 'craype-x86-rome' )
load( 'libfabric' )
load( 'craype-network-ofi' )
load( 'cray-mpich' )
load( 'cray-libsci' )
