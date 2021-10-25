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

local init_module_list = {
    C = { 'craype-x86-milan',  'craype-accel-host',       'craype-network-ofi', 'xpmem' },
    D = { 'craype-x86-rome',   'craype-accel-nvidia80',   'craype-network-ofi', 'xpmem' },
    G = { 'craype-x86-milan',  'craype-accel-amd-gfx908', 'craype-network-ofi', 'xpmem' },
    L = { 'craype-x86-rome',   'craype-accel-host',       'craype-network-ofi', 'xpmem' },
}

-- -------------------------------------------------------------------------
--
-- Build the MODULEPATH
--

if isDir( '/usr/share/modulefiles' ) then prepend_path( 'MODULEPATH', '/usr/share/modulefiles' ) end
if isDir( '/usr/share/Modules/modulefiles' ) then prepend_path( 'MODULEPATH', '/usr/share/Modules/modulefiles' ) end
prepend_path( 'MODULEPATH', '/opt/modulefiles' )
prepend_path( 'MODULEPATH', '/opt/cray/modulefiles' )
prepend_path( 'MODULEPATH', '/opt/cray/pe/lmod/modulefiles/craype-targets/default' )
prepend_path( 'MODULEPATH', '/opt/cray/pe/lmod/modulefiles/core' )

--
-- Code needed to fix problems with the Cray PE
--
-- Detect the module root from the position of this module in the module tree
local module_root = myFileName():match( '(.*/modules)/SoftwareStack/.*' )
local cray_overwrite_core = pathJoin( module_root, 'CrayOverwrite', 'core' )
if isDir( cray_overwrite_core ) then
    prepend_path( 'MODULEPATH', cray_overwrite_core )
end

-- Prepend path with EasyBuild cross-installed tools
prepend_path( 'MODULEPATH', pathJoin( module_root, 'easybuild/CrayEnv' ) )

-- -------------------------------------------------------------------------
--
-- Load a set of modules that are always needed, similarly to what the system
-- initialisation script /etc/cray-pe.d/cray-pe-configuration.sh would do.
--

-- Detect the partition that we are on using the function defined in SitePackage.lua
local partition = detect_LUMI_partition()
if partition == nil then
    LmodError( 'Failed to detect the LUMI partition, something must be messed up pretty badly.' )
end

if mode() == 'load' then
    if init_module_list[partition] ~= nil then
        for i, module in ipairs( init_module_list[partition] ) do
            load( module )
        end
    end
elseif mode() == 'unload' then
    for partition, modulelist in pairs( init_module_list ) do
        for i, module in pairs( modulelist ) do
            -- Not the most efficient code but it ensures that everything that ever got loaded by this
            -- module gets unloaded also, even if the user screwed up the partition selection scheme.
            -- It also avoids a problem that in case of a partition change, module purge may still reload
            -- the wrong target module.
            unload( module )
        end
    end
end

