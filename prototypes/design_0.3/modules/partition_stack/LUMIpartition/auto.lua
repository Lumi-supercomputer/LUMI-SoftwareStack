-- This module will automatically make the right versions of the software stack
-- available for the current partition.
--
-- Note that for this to work also with, e.g., module reload at the start of a
-- Slurm job, where we may be in a different partition, we need to be very careful
-- when unloading the module to ensure that the right paths get removed as we
-- cannot rely on the position of this module in the hierarchy nor on the
-- value of LUMI_PARTITION or any other way to detect in which partition the module
-- command was executed. We know however that the module when loading will
-- add a subdirectory of moduleroot ..'/modules/SoftwareStack/partition to the
-- MODULEPATH so we look for that string instead to detect the partition that was
-- used when loading the module.
--

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() )
end

family( 'LUMI_partition' )
add_property("lmod","sticky")

local node_description = {
    C = 'CPU compute',
    G = 'GPU compute',
    D = 'data and visualisation',
    L = 'login',
}

local module_root = os.getenv( 'LMOD_MODULE_ROOT' )
if module_root == nil then
    LmodError( 'The environment variable LMOD_MODULE_ROOT is not found but needed to find the components of the LUMI prototype.' )
end

--
-- Now we must be very careful to determine the partition when unloading the module.
-- We should not derive it from LUMI_PARTITION as that may have changed, but from a
-- variable which is set when loading this module and should not be changed by the
-- user.
--
local partition
if mode() == "unload" then

    if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
        LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', unloading and detecting the partition from the MODULEPATH' )
    end

    local moduledir = pathJoin( module_root, 'modules', 'SoftwareStack', 'partition' )
    partition = os.getenv( 'MODULEPATH' ):match( moduledir .. '/(.)' )
    if partition == nil then
        -- Just use something, it doesn't matter as the directory we want to remove from the
        -- MODULEPATH isn't in it anyway.
        partition = 'X'
    end

    if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
        LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', unloading for partition ' .. partition )
    end

elseif mode() == "load" then

    if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
        LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', loading and detecting partition from dtect_LUMI_partition' )
    end

    partition = detect_LUMI_partition()
    if partition == nil then
        LmodError( 'Failed to detect the correct LUMI partition.' )
    end

else

    -- Set to an unexisting partition so that module spider doesn't return results for it.
    partition = 'X'

end

whatis( 'Description: ' .. myModuleFullName() .. ' enables the software stacks for the detected LUMI partition.' )

help( [[

Description
===========
Enables the software stacks for the detected LUMI partition.

This module will be loaded automatically when logging in to the node based
on the hardware of the node. Replace with a different version at your own
risk as not all software that may be enabled directly or indirectly through
this module may work on this partition.
]] )

setenv( 'LUMI_OVERWRITE_PARTITION', partition )

prepend_path( 'MODULEPATH', pathJoin( module_root, 'modules', 'SoftwareStack', 'partition', partition ) )

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    local modulepath = os.getenv( 'MODULEPATH' ):gsub( ':', '\n' )
    LmodMessage( 'DEBUG: The MODULEPATH before exiting ' .. myModuleFullName() .. ' (mode ' .. mode() .. ') is:\n' .. modulepath .. '\n' )
end
