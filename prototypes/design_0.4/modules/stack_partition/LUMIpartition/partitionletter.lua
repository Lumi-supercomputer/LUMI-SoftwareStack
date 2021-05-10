if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Entering' )
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

local module_root = os.getenv( 'LMOD_MODULE_ROOT')
if module_root == nil then
    LmodError( 'The environment variable LMOD_MODULE_ROOT is not found but needed to find the components of the LUMI prototype.' )
end

local hierarchy = hierarchyA( myModuleFullName(), 1 )
if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Detected the ' .. hierarchy[1] .. ' Software stack' )
end
local stack_name_version = hierarchy[1]

local partition = myModuleVersion()
if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Detected partition ' .. partition )
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

setenv( 'LUMI_OVERWRITE_PARTITION', partition )

if ( partition ~= 'common' ) or ( mode() ~= 'spider' ) then
    -- This is a block of code that we do not want to be visible in partition/common
    -- when the mode is "spider" to avoid showing partition/common as a mode to reach
    -- software activated by the lines below.
    -- The Cray modules, may be possible to only activate them once PrgEnv-* is loaded
    prepend_path( 'MODULEPATH', '/opt/cray/pe/lmod/modulefiles/craype-targets/default' )
    prepend_path( 'MODULEPATH', '/opt/cray/pe/lmod/modulefiles/core' )
    -- The modules of application software. Make sure to also add the common ones.
    if partition ~= 'common' then
        prepend_path( 'MODULEPATH', pathJoin( module_root, 'modules', 'manual',    stack_name_version, 'partition', 'common' ) )
    end
    prepend_path(     'MODULEPATH', pathJoin( module_root, 'modules', 'manual',    stack_name_version, 'partition', partition ) )
    if partition ~= 'common' then
        prepend_path( 'MODULEPATH', pathJoin( module_root, 'modules', 'spack',     stack_name_version, 'partition', 'common' ) )
    end
    prepend_path(     'MODULEPATH', pathJoin( module_root, 'modules', 'spack',     stack_name_version, 'partition', partition ) )
    if partition ~= 'common' then
        prepend_path( 'MODULEPATH', pathJoin( module_root, 'modules', 'easybuild', stack_name_version, 'partition', 'common' ) )
    end
    prepend_path(     'MODULEPATH', pathJoin( module_root, 'modules', 'easybuild', stack_name_version, 'partition', partition ) )
end

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    local modulepath = os.getenv( 'MODULEPATH' ):gsub( ':', '\n' )
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': The MODULEPATH before exiting ' .. myModuleFullName() .. ' (mode ' .. mode() .. ') is:\n' .. modulepath .. '\n' )
end
