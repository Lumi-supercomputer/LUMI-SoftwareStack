if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Entering' )
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Entering' )
end

family( 'LUMI_partition' )
add_property("lmod","sticky")

local node_description = {
    C      = 'CPU compute',
    G      = 'GPU compute',
    D      = 'data and visualisation',
    L      = 'login',
    common = 'common binaries for all partitions'
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
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': stack name: ' .. stack_name .. ', stack version: '.. stack_version, ', CPE version: '.. CPE_version )
end

-- Determine the partition that we want to load software for from the version of the module
local partition = myModuleVersion()
if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Detected partition ' .. partition )
end

-- Detect if there is a user installation that we need to take into account.
local user_easybuild_modules = os.getenv( 'EBU_USER_PREFIX' )
if user_easybuild_modules == nil then
    user_easybuild_modules = pathJoin( os.getenv( 'HOME'), 'EasyBuild' )
end
user_easybuild_modules = pathJoin( user_easybuild_modules, 'modules')
if not isDir( user_easybuild_modules ) then
    user_easybuild_modules = nil
end
if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil and user_easybuild_modules ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Detected user module tree at ' .. user_easybuild_modules )
end

-- Find the version of crape-targets matching the current PE version
local targets_version = get_CPE_component( 'craype-targets', CPE_version )
if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Found craype-targets version ' .. targets_version )
end


whatis( 'Description: ' .. myModuleFullName() .. ' enables the ' .. stack_name_version .. ' software stack for the LUMI-' .. partition .. ' (' .. node_description[partition] .. ') partition.' )

help( [[

Description
===========
Enables the ]] .. stack_name_version .. [[ software stack for the LUMI-]] .. partition .. [[ (]] .. node_description[partition] .. [[) partition.

The partition modules will be loaded automatically when logging in to the node
based on the hardware of the node. Replace with a different version at your own
risk as not all software that may be enabled directly or indirectly through
a partition module may work on other on other partitions.
]] )

setenv( 'LUMI_STACK_PARTITION', partition )

if ( partition ~= 'common' ) or ( mode() ~= 'spider' ) then
    -- This is a block of code that we do not want to be visible in partition/common
    -- when the mode is "spider" to avoid showing partition/common as a mode to reach
    -- software activated by the lines below.
    -- The Cray modules, may be possible to only activate them once cpe* is loaded
    if isDir( '/usr/share/modulefiles' ) then
        prepend_path( 'MODULEPATH', '/usr/share/modulefiles' )
    end
    if isDir( '/usr/share/Modules/modulefiles' ) then
        prepend_path( 'MODULEPATH', '/usr/share/Modules/modulefiles' )
    end
    prepend_path(     'MODULEPATH', '/opt/modulefiles' )
    prepend_path(     'MODULEPATH', '/opt/cray/modulefiles' )
    if targets_version == nil then
        prepend_path(     'MODULEPATH', '/opt/cray/pe/lmod/modulefiles/craype-targets/default' )
    else
        prepend_path(     'MODULEPATH', pathJoin( '/opt/cray/pe/lmod/modulefiles/craype-targets', targets_version ) )
    end
    prepend_path(     'MODULEPATH', '/opt/cray/pe/lmod/modulefiles/core' )
    local missing_core = pathJoin( module_root, 'missing', 'core' )
    if isDir( missing_core ) then
        prepend_path( 'MODULEPATH', missing_core )
    end
    -- Configuration for EasyBuild to install in the requested partition (and maybe later for Spack)
    prepend_path(     'MODULEPATH', pathJoin( module_root, 'Infrastructure', stack_name_version, 'partition', partition ) )
    -- The modules of application software installed in the system. Make sure to also add the common ones.
    if partition ~= 'common' then
        prepend_path( 'MODULEPATH', pathJoin( module_root, 'manual',        stack_name_version, 'partition', 'common' ) )
    end
    prepend_path(     'MODULEPATH', pathJoin( module_root, 'manual',        stack_name_version, 'partition', partition ) )
    if partition ~= 'common' then
        prepend_path( 'MODULEPATH', pathJoin( module_root, 'spack',         stack_name_version, 'partition', 'common' ) )
    end
    prepend_path(     'MODULEPATH', pathJoin( module_root, 'spack',         stack_name_version, 'partition', partition ) )
    if partition ~= 'common' then
        prepend_path( 'MODULEPATH', pathJoin( module_root, 'easybuild',     stack_name_version, 'partition', 'common' ) )
    end
    prepend_path(     'MODULEPATH', pathJoin( module_root, 'easybuild',     stack_name_version, 'partition', partition ) )
    -- Software installed by the user using EasyBuild.
    if user_easybuild_modules ~= nil then
        local user_common_dir = pathJoin( user_easybuild_modules, stack_name_version, 'partition', 'common' )
        if partition ~= common and isDir( user_common_dir ) then
            prepend_path( 'MODULEPATH', user_common_dir )
        end
        local user_partition_dir = pathJoin( user_easybuild_modules, stack_name_version, 'partition', partition )
        if isDir( user_partition_dir) then
            prepend_path( 'MODULEPATH', user_partition_dir )
        end
    end
end

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    local modulepath = os.getenv( 'MODULEPATH' ):gsub( ':', '\n' )
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': The MODULEPATH before exiting ' .. myModuleFullName() .. ' (mode ' .. mode() .. ') is:\n' .. modulepath .. '\n' )
end
