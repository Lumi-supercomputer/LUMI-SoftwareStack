if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. myModuleFullName() .. ', mode ' .. mode() )
end

-- -----------------------------------------------------------------------------
--
-- Initialisations
--

family( 'LUMI_SoftwareStack' )
add_property("lmod","sticky")

-- Detect the module root from the position of this module in the module tree
local install_root = myFileName():match( '(.*)/modules/SoftwareStack/.*' )

-- Detect the directory of LMOD configuration files from LMOD_PACKAGE_PATH
-- as that variable has to be set anyway for the LUMI module system to work
-- as we rely on SitePackage.lua, and this file does rely on the
-- detect_LUMI_partition function defined in SitePackage.lua.
-- NOTE: Change this code if the LMOD configuration would be stored elsewhere!
local LMOD_root = os.getenv( 'LMOD_PACKAGE_PATH' )
if LMOD_root == nil then
    LmodError( 'Failed to get the value of LMOD_PACKAGE_PATH' )
end

-- Detect the software stack from the name and version of the module
local stack_name    = myModuleName()
local stack_version = myModuleVersion()
local CPE_version   = stack_version:gsub( '.dev', '')

-- Detect the partition that we are on using the function defined in SitePackage.lua
local partition     = detect_LUMI_partition()
if partition == nil then
    LmodError( 'Failed to detect the LUMI partition, something must be messed up pretty badly.' )
end

-- Mark the stack as either a development version of a long-term supported stack depending on its name.
if stack_version:find( '%.dev$' ) then
    add_property( 'state', 'development_stack' )
else
    add_property( 'state', 'LTS_stack' )
end

-- -----------------------------------------------------------------------------
--
-- Help information
--

whatis( 'Enables the LUMI-' .. stack_version .. ' software stack for the current partition.' )

help( [[

Description
===========
This module enables the LUMI/]] .. stack_version .. [[ software stack for the current partition.

By swapping the partition module it is possible to load software compiled for
a different partition instead, but be careful as that software may not run as
expected.
]] )

-- -----------------------------------------------------------------------------
--
-- Main module logic
--

prepend_path( 'MODULEPATH', pathJoin( install_root, 'modules/SystemPartition', stack_name, stack_version ) )

-- The following variables may be used by various modules and LUA configuration files.
-- However, take care as those variables may not be defined anymore when your module
-- gets unloaded.
setenv( 'LUMI_MODULEPATH_ROOT',    pathJoin( install_root, 'modules' ) )
setenv( 'LUMI_STACK_NAME',         stack_name )
setenv( 'LUMI_STACK_VERSION',      stack_version )
setenv( 'LUMI_STACK_NAME_VERSION', stack_name .. '/' .. stack_version )

--
-- Enable LUMIstack_modulerc.lua and a (CPE) version-specific one (if present)
--
prepend_path( 'LMOD_MODULERCFILE', pathJoin( LMOD_root, 'LUMIstack_modulerc.lua' ) )
local modulerc_stack = pathJoin( install_root, 'mgmt/LMOD/ModuleRC', 'LUMIstack_' .. CPE_version .. '_modulerc.lua' )
if isFile( modulerc_stack ) then
    prepend_path( 'LMOD_MODULERCFILE', modulerc_stack )
end

--
-- Set the LUA file with a table defining the toolchain modules for quick reading by
-- SitePackage.lua
--
local CPEmodules_dir = pathJoin( install_root, 'mgmt/LMOD/VisibilityHookData' )
local CPEmodules_file = 'CPEmodules_' .. CPE_version:gsub( '%.', '_') -- Omit the .lua extension so that we do not have to remove it in SitePackage.lua
if isFile( pathJoin( CPEmodules_dir, CPEmodules_file .. '.lua' ) ) then
    setenv( 'LUMI_VISIBILITYHOOKDATAPATH', pathJoin( CPEmodules_dir, '?.lua' ) )
    setenv( 'LUMI_VISIBILITYHOOKDATAFILE', CPEmodules_file )
end

--
-- Load the partition module
--

load( 'partition/' .. partition )

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    local modulepath = os.getenv( 'MODULEPATH' ):gsub( ':', '\n' )
    LmodMessage( 'DEBUG: The MODULEPATH before exiting ' .. myModuleFullName() .. ' (mode ' .. mode() .. ') is:\n' .. modulepath .. '\n' )
end
