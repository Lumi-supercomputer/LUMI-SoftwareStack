if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Entering' )
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Entering' )
end

family( 'LUMI_partition' )
add_property("lmod","sticky")

local node_description = {
    C         = 'CPU compute',
    G         = 'GPU compute',
    D         = 'data visualisation',
    L         = 'login and largemem (4TB)',
    -- EAP    = 'early access platform',
    common    = 'common binaries for all partitions',
    container = 'EasyBuild installation singularity wrapper modules', 
    CrayEnv   = 'EasyBuild cross-installation in CrayEnv',
    system    = 'EasyBuild system-wide cross-installation',
}

local node_spack_arch = {
    C         = 'cray-sles15-zen3',
    G         = 'cray-sles15-zen3',
    D         = 'cray-sles15-zen2',
    L         = 'cray-sles15-zen2',
    -- EAP    = 'cray-sles15-zen2',
    common    = 'cray-sles15-zen2',
    container = 'cray-sles15-zen2',
    CrayEnv   = 'cray-sles15-zen2',
    system    = 'cray-sles15-zen2',
}

-- Special partitions are those that are created to install
-- software in abnormal places and have no equivalent for
-- user installations.
local special_partition = {
    C         = false,
    G         = false,
    D         = false,
    L         = false,
    -- EAP    = false,
    common    = false,
    container = true,
    CrayEnv   = true,
    system    = true,
}

-- Detect the root of the module tree from the position of this module
local install_root = myFileName():match( '(.*)/modules/SystemPartition/.*' )
local module_root = pathJoin( install_root, 'modules' )

-- Determine the software stack from the position of this module in the hierarchy
local hierarchy = hierarchyA( myModuleFullName(), 1 )
if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Detected the ' .. hierarchy[1] .. ' Software stack' )
end
local stack_name_version = hierarchy[1]
local stack_name =    stack_name_version:match('([^/]+)/.*')
local stack_version = stack_name_version:match('.*/([^/]+)')
local CPE_version =   stack_version:gsub( '.dev', '')
if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Stack name: ' .. stack_name .. ', stack version: '.. stack_version, ', CPE version: '.. CPE_version )
end

-- Determine the partition that we want to load software for from the version of the module
local partition = myModuleVersion()
if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Detected partition ' .. partition )
end

-- Detect if there is a user installation that we need to take into account.
user_easybuild_modules = get_user_prefix_EasyBuild()
if user_easybuild_modules ~= nil then
    user_easybuild_modules = pathJoin( user_easybuild_modules, 'modules')
    if not isDir( user_easybuild_modules ) then
        user_easybuild_modules = nil
    end
end
if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil and user_easybuild_modules ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Detected user module tree at ' .. user_easybuild_modules )
end

-- Find the version of craype-targets matching the current PE version
local targets_version = get_CPE_component( 'craype-targets', CPE_version )
if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    if targets_version == nil then
        LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Failed to determine craype-targets version, using default.' )
    else
        LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Found craype-targets version ' .. targets_version )
    end
end


whatis( 'Description: ' .. myModuleFullName() .. ' enables the ' .. stack_name_version .. ' software stack for the LUMI-' .. partition .. ' (' .. node_description[partition] .. ') partition.' )

if special_partition[partition] then

help( [[

Description
===========
Enables installing software via EasyBuild from a LUMI partition that is available outside
of the LUMI software stacks. This module is in particular for ]] .. node_description[partition] .. [[.

This partition module is never loaded automatically and also not needed when running
the software installed through it.
]] )

else

help( [[

Description
===========
Enables the ]] .. stack_name_version .. [[ software stack for the LUMI-]] .. partition .. [[ (]] .. node_description[partition] .. [[) partition.

The partition modules will be loaded automatically when logging in to the node
based on the hardware of the node. Replace with a different version at your own
risk as not all software that may be enabled directly or indirectly through
a partition module may work on other on other partitions.
]] )

end -- if special_partition else

setenv( 'LUMI_STACK_PARTITION', partition )

-- Do not execute the following code if partition == 'common' or 'CrayEnv' or 'system' and mode() == 'spider'
-- as we doe not want partition/common to show up in the output of ``module spider``.
if ( ( partition ~= 'common' ) and not special_partition[partition] ) or ( mode() ~= 'spider' ) then

    -- System modulefiles, or third-party components

    if isDir( '/usr/share/modulefiles' ) then
        prepend_path( 'MODULEPATH', '/usr/share/modulefiles' )
    end
    if isDir( '/usr/share/Modules/modulefiles' ) then
        prepend_path( 'MODULEPATH', '/usr/share/Modules/modulefiles' )
    end

    -- The Cray-specific modulefiles, may be possible to only activate them once cpe* is loaded

    if isDir( '/opt/modulefiles' ) then -- Contains the amd and aocc modules for the PE, if installed
        prepend_path(     'MODULEPATH', '/opt/modulefiles' )
    end
    prepend_path(     'MODULEPATH', '/opt/cray/modulefiles' )
    if targets_version == nil then
        prepend_path(     'MODULEPATH', '/opt/cray/pe/lmod/modulefiles/craype-targets/default' )
    else -- Until we find a solution for double target modules directories: Always use the default version.
        -- prepend_path(     'MODULEPATH', pathJoin( '/opt/cray/pe/lmod/modulefiles/craype-targets', targets_version ) )
        prepend_path(     'MODULEPATH', '/opt/cray/pe/lmod/modulefiles/craype-targets/default' )
    end
    prepend_path(     'MODULEPATH', '/opt/cray/pe/lmod/modulefiles/core' )

    -- Cray overwrite directories

    -- local cray_overwrite_core = pathJoin( module_root, 'CrayOverwrite', 'core' )
    -- if isDir( cray_overwrite_core ) then
    --     prepend_path( 'MODULEPATH', cray_overwrite_core )
    -- end

    -- Configuration for EasyBuild to install in the requested partition

    prepend_path(     'MODULEPATH', pathJoin( module_root, 'Infrastructure', stack_name_version, 'partition', partition ) )
    -- The modules of application software installed in the system. Make sure to also add the common ones.
    if partition == 'CrayEnv' then
        -- CrayEnv partition: The system generic modules, the CrayEnv modules, and container modules.
        prepend_path( 'MODULEPATH', pathJoin( module_root, 'easybuild', 'container' ) )  -- Centrally installed container modules
        prepend_path( 'MODULEPATH', pathJoin( module_root, 'easybuild', 'system' ) )     -- Centrally installed system modules (e.g., lumi-tools)
        prepend_path( 'MODULEPATH', pathJoin( module_root, 'easybuild', 'CrayEnv' ) )    -- Centrally installed CrayEnv modules
    elseif special_partition[partition] then
        -- This should currently only be the system partition in which case we only want that
        -- software in the MODULEPATH, but we keep open the option to add further special partitions
        -- with default behaviour this way.
        prepend_path( 'MODULEPATH', pathJoin( module_root, 'easybuild', partition ) )
    else
        prepend_path( 'MODULEPATH', pathJoin( module_root, 'easybuild', 'container' ) )  -- Centrally installed container modules
        prepend_path( 'MODULEPATH', pathJoin( module_root, 'easybuild', 'system' ) )     -- Centrally installed system modules (e.g., lumi-tools)
        -- if partition ~= 'common' then
        --     prepend_path( 'MODULEPATH', pathJoin( module_root, 'manual',        stack_name_version, 'partition', 'common' ) )
        -- end
        -- prepend_path(     'MODULEPATH', pathJoin( module_root, 'manual',        stack_name_version, 'partition', partition ) )
        -- if partition ~= 'common' then
        --     prepend_path( 'MODULEPATH', pathJoin( module_root, 'spack',         stack_name_version, 'partition', 'common',  node_spack_arch['common'] ) )
        -- end
        -- prepend_path(     'MODULEPATH', pathJoin( module_root, 'spack',         stack_name_version, 'partition', partition, node_spack_arch[partition] ) )
        if partition ~= 'common' then
            prepend_path( 'MODULEPATH', pathJoin( module_root, 'easybuild',     stack_name_version, 'partition', 'common' ) )
        end
        prepend_path(     'MODULEPATH', pathJoin( module_root, 'easybuild',     stack_name_version, 'partition', partition ) )
    end

    -- Software installed by the user using EasyBuild.
    -- For the special partitions user_easybuild_modules will always be nil so no need to test for those partitions specifically.
    if user_easybuild_modules ~= nil then
        if partition == 'CrayEnv' then

            prepend_path( 'MODULEPATH', pathJoin( user_easybuild_modules, 'container' ) ) -- User containers visible in CrayEnv also
            prepend_path( 'MODULEPATH', pathJoin( user_easybuild_modules, 'CrayEnv' ) )   -- We do support a user CrayEnv do we keep this silent in the docs

        elseif partition == 'container' then

            prepend_path( 'MODULEPATH', pathJoin( user_easybuild_modules, 'container' ) )  -- User containers of course visible when installing containers

        elseif not special_partition[partition] then

            -- Note that we may be adding non-existent directories but Lmod does not have problems with that.
            -- It is better to add them right away so that software installed with EasyBuild will appear right
            -- away without first having to reload the partition module.
            prepend_path( 'MODULEPATH', pathJoin( user_easybuild_modules, 'container' ) )  -- User containers always available in partition/{common|L|C|G}
            if partition ~= common then
                prepend_path( 'MODULEPATH', pathJoin( user_easybuild_modules, stack_name_version, 'partition', 'common' ) ) -- We shouldn't add common twice.
            end
            prepend_path( 'MODULEPATH', pathJoin( user_easybuild_modules, stack_name_version, 'partition', partition ) )

        end
    end

end

-- For the regular partitions (not common or CrayEnv or system or container) we preload some suitable target modules
-- for those users that would use the PrgEnv modules rather than the cpeGNU/cpeCray/cpeAMD
-- modules to compile code.
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

-- Final debug information
if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    local modulepath = os.getenv( 'MODULEPATH' ):gsub( ':', '\n' )
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': The MODULEPATH before exiting ' .. myModuleFullName() .. ' (mode ' .. mode() .. ') is:\n' .. modulepath .. '\n' )
end
