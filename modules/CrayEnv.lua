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

-- -------------------------------------------------------------------------
--
-- Build the MODULEPATH
--

--
-- Get the root of the module system
--
local module_root = myFileName():match( '(.*/modules)/SoftwareStack/.*' )

--
-- Code needed to fix problems with the Cray PE
--
-- Detect the module root from the position of this module in the module tree
-- local cray_overwrite_core = pathJoin( module_root, 'CrayOverwrite', 'core' )
-- if isDir( cray_overwrite_core ) then
--     prepend_path( 'MODULEPATH', cray_overwrite_core )
-- end

-- Prepend path with EasyBuild cross-installed tools
prepend_path( 'MODULEPATH', pathJoin( module_root, 'easybuild/CrayEnv' ) )
prepend_path( 'MODULEPATH', pathJoin( module_root, 'easybuild/container' ) )

-- Detect if there is a user installation that we need to take into account, 
-- and if so, enable user-installed container and CrayEnv modules.
user_easybuild_modules = get_user_prefix_EasyBuild()
if user_easybuild_modules ~= nil then
    user_easybuild_modules = pathJoin( user_easybuild_modules, 'modules')
    if isDir( user_easybuild_modules ) then
        prepend_path( 'MODULEPATH', pathJoin( user_easybuild_modules, 'CrayEnv' ) )
        prepend_path( 'MODULEPATH', pathJoin( user_easybuild_modules, 'container' ) )
    else -- still set user_easybuild_modules to nil in case we would ever use it later in this file
        user_easybuild_modules = nil
    end
end
if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil and user_easybuild_modules ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Detected user module tree at ' .. user_easybuild_modules )
end


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

if mode() == 'load' or mode() == 'show' then
    local init_module_list = get_init_module_list( partition, false )
    if init_module_list ~= nil then
        for i, module in ipairs( init_module_list ) do
            -- We do force a reload of the module even if it is loaded already
            -- This is less efficient but may undo accidental damage done by
            -- users. e.g., by unsetting certain variables that are used by the
            -- HPE Cray PE.
            if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
                LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Loading ' .. module )
            end
            load( module )
        end
    end
end

