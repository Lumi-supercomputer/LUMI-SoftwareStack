-- LUMI Lmod customizations

require("strict")
local os = require("os")
local dbg  = require("Dbg"):dbg()
local hook = require("Hook")
require("sandbox")

-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
--
-- LMOD hooks
--
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------

--
-- SiteName hook, used by Lmod in variable names.
-- We don't chose LUMI but take LUMI_LMOD to avoid conflicts as there
-- will likely be more LUMI_ environment variables on the system.
--

local function site_name_hook()
    -- set the SiteName
    return "LUMI_LMOD"
end


--
-- Code to rename directories in module avail
-- Based on "Providing Custom Labels for Avail" in the Lmod manual
-- Note that this requires the use of LMOD_AVAIL_STYLE, and in this case,
-- LMOD_AVAIL_STYLE=labeled:system to make the labeled style the default.
--

local mapT =
{
    label = {
--        ['/testview$']                     = 'Activate environments',
        ['modules/StyleModifiers']         = 'Modify the module display style',
        ['modules/SoftwareStack$']         = 'Software stacks',
        ['modules/SystemPartition/']       = 'LUMI partitions for the software stack _STACK_',
        ['modules/Infrastructure/']        = 'Infrastructure modules for the software stack _STACK_ on _PARTITION_',
        ['modules/easybuild/']             = 'EasyBuild managed software for software stack _STACK_ on _PARTITION_',
        ['modules/spack/']                 = 'Spack managed software for software stack _STACK_ on _PARTITION_',
        ['modules/manual/']                = 'Manually installed software for software stack _STACK_ on _PARTITION_',
        ['cray/pe/.*/craype%-targets']     = 'HPE-Cray PE target modules',
        ['cray/pe/.*/core']                = 'HPE-Cray PE modules',
        ['modules/CrayOverwrite/core']     = 'HPE-Cray PE modules',
        ['cray/pe/.*/perftools']           = 'HPE-Cray PE modules',
        ['cray/pe/.*/cpu']                 = 'HPE-Cray PE modules',
        ['cray/pe/.*/compiler/crayclang']  = 'HPE-Cray PE modules',
        ['cray/pe/.*/compiler/gnu']        = 'HPE-Cray PE modules',
        ['cray/pe/.*/hdf5/']               = 'HPE-Cray PE modules',
        ['cray/pe/.*/hdf5-parallel/']      = 'HPE-Cray PE modules',
        ['cray/pe/.*/comnet']              = 'HPE-Cray PE modules',
        ['cray/pe/.*/mpi']                 = 'HPE-Cray PE modules',
        ['cray/pe/.*/net/ofi']             = 'HPE-Cray PE modules',
        -- The next one doesn't seem to be implemented on the Grenoble nodes
        ['cray/pe/craype']                 = 'HPE-Cray PE modules',
        -- Likely only on the Grenoble system?
        ['/opt/cray/modulefiles']          = 'Non-PE HPE-Cray modules',
        ['/opt/modulefiles']               = 'Non-PE HPE-Cray modules',
        ['/usr/share/Modules/modulefiles'] = 'Non-PE HPE-Cray modules',
        ['/usr/share/modulefiles']         = 'Non-PE HPE-Cray modules',
     },
    PEhierarchy = {
--        ['/testview$']                     = 'Activate environments',
        ['modules/StyleModifiers']         = 'Modify the module display style',
        ['modules/SoftwareStack$']         = 'Software stacks',
        ['modules/SystemPartition/']       = 'LUMI partitions for the software stack _STACK_',
        ['modules/Infrastructure/']        = 'Infrastructure modules for the software stack _STACK_ on _PARTITION_',
        ['modules/easybuild/']             = 'EasyBuild managed software for software stack _STACK_ on _PARTITION_',
        ['modules/spack/']                 = 'Spack managed software for software stack _STACK_ on _PARTITION_',
        ['modules/manual/']                = 'Manually installed software for software stack _STACK_ on _PARTITION_',
        ['cray/pe/.*/craype%-targets']     = 'HPE-Cray PE target modules',
        ['cray/pe/.*/core']                = 'HPE-Cray PE core modules',
        ['modules/CrayOverwrite/core']     = 'HPE-Cray PE core modules',
        ['cray/pe/.*/perftools']           = 'HPE-Cray PE performance analysis tools',
        ['cray/pe/.*/cpu']                 = 'HPE-Cray PE compiler-independent libraries',
        ['cray/pe/.*/compiler/crayclang']  = 'HPE-Cray PE libraries for Cray clang (cce)',
        ['cray/pe/.*/compiler/gnu']        = 'HPE-Cray PE libraries for GNU compilers',
        ['cray/pe/.*/hdf5/']               = 'HPE-Cray PE libraries that use cray-hdf5',
        ['cray/pe/.*/hdf5-parallel/']      = 'HPE-Cray PE libraries that use cray-hdf5-parallel',
        ['cray/pe/.*/comnet']              = 'HPE-Cray PE MPI libraries',
        ['cray/pe/.*/mpi']                 = 'HPE-Cray PE MPI-dependent libraries',
        ['cray/pe/.*/net/ofi']             = 'HPE-Cray PE OFI-based libraries',
        -- The next one doesn't seem to be implemented on the Grenoble nodes
        ['cray/pe/craype']                 = 'HPE-Cray PE compiler wrappers',
        -- Likely only on the Grenoble system?
        ['/opt/cray/modulefiles']          = 'Non-PE HPE-Cray modules',
        ['/opt/modulefiles']               = 'Non-PE HPE-Cray modules',
        ['/usr/share/Modules/modulefiles'] = 'Non-PE HPE-Cray modules',
        ['/usr/share/modulefiles']         = 'Non-PE HPE-Cray modules',
     },
}


local function avail_hook(t)

    dbg.start( 'avail_hook' )

    --
    -- Use labels instead of directories (if selected)
    --

    local availStyle = masterTbl().availStyle
    local styleT     = mapT[availStyle]
    if (not availStyle or availStyle == "system" or styleT == nil) then
        io.stderr:write('Avail hook: style not found\n')
        return
    end

    local stack = os.getenv( 'LUMI_STACK_NAME_VERSION' ) or 'unknown'
    local partition = 'LUMI-' .. ( os.getenv( 'LUMI_STACK_PARTITION' ) or 'X' )

    for k,v in pairs(t) do
        for pat,label in pairs(styleT) do
            if (k:find(pat)) then
                t[k] = label:gsub( '_PARTITION_', partition ):gsub( '_STACK_', stack )
                break
            end
        end
    end

    dbg.fini()

end

--
-- Message hook
-- - Adds a reference to LUMI support at the end of the module avail output
--

local function msg_hook(mode, output)
    -- mode is avail, list or spider
    -- output is a table with the current output

    dbg.start{"msg_hook"}

    dbg.print{"Mode is ", mode, "\n"}

    if mode == "avail" then
        local spiderdoc_url = 'https://docs.lumi-supercomputer.eu/LMOD_TODO'
        local request_url   = 'https://lumi-supercomputer.eu/support'
        output[#output+1]   = '\nAdditional ways to search for software:\n'
        output[#output+1]   = '* Use "module spider" to find all possible modules and extensions.\n'
        output[#output+1]   = '* Use "module keyword key1 key2 ..." to search for all possible modules matching any of the "keys".\n'
        output[#output+1]   = 'See the LUMI documentation at ' .. spiderdoc_url .. ' for more information on searching modules.\n'
        output[#output+1]   = "If then you still miss software, contact LUMI User Support via "..request_url..".\n\n"
    end

    dbg.fini()

    return output
end


--
-- Visibility hook
-- - Used to hide some Cray modules in the LUMI software stacks
--

--
-- List the modules that should always be visibile even though they
-- have the name of a Cray PE component.
--
local visibility_exceptions = {
    ['cpe/restore-defaults'] = true,
}

local function is_visible_hook( modT )

    -- modT is a table with: fullName, sn, fn and isVisible
    -- The latter is a boolean to determine if a module is visible or not

    local CPEmodules_path = os.getenv( 'LUMI_VISIBILITYHOOKDATAPATH' )
    local CPEmodules_file = os.getenv( 'LUMI_VISIBILITYHOOKDATAFILE' )
    if CPEmodules_path == nil or CPEmodules_file == nil then return end

    local CPEmodules
    local saved_path = package.path
    package.path = CPEmodules_path .. ';' .. package.path
    CPEmodules = require( CPEmodules_file )
    package.path = saved_path

    if os.getenv( 'LUMI_LMOD_POWERUSER' ) ==  nil then
        if modT.fn:find( 'cray/pe/lmod/modulefiles' ) or modT.fn:find( 'modules/CrayOverwrite' ) then
            if CPEmodules[modT.sn] ~= nil then
                local module_version = modT.sn .. '/' .. CPEmodules[modT.sn]
                if modT.fullName ~= module_version and not visibility_exceptions[ modT.fullName] then
                    modT.isVisible = false
                end
            end
        end
    end

end


--
-- Register the hooks
--

hook.register( "SiteName",     site_name_hook )
hook.register( "avail",        avail_hook )
hook.register( "msgHook",      msg_hook )
hook.register("isVisibleHook", is_visible_hook)


-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
--
-- LMOD additional functions
--
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------

--
-- function detect_LUMI_partition
--
-- Code to detect on which partition of LUMI we are.
-- Currently this is done through the LUMI_PARTITION environment variable
-- but this function makes it easy to adapt that code and use a different
-- detection technique, e.g., based on the hostname, and implement the
-- change in all module files that use this function.
--
-- This code is meant to be used to detect the partition before it can be
-- derived from the position of the module in the module hierarchy.
--
-- Input arguments: none
--
-- Returns the partition (as a single letter) or nil if it fails to detect
-- the partition.
--
function detect_LUMI_partition()

    local partition = os.getenv( 'LUMI_PARTITION' )

    return partition

end

--
-- function get_CPE_component
--
-- Get the version of a CPE component for a particular CPE release based on
-- information kept in a .csv file.
--
-- Input arguments
--   * package: Name of the package
--   * CPE_version: Release of the Cray Programming Environment
--
function get_CPE_component( package, CPE_version )

    -- Get the location of the SitePackage.lua file; we assume that it is in the
    -- LUMI repository.
    local LMOD_root = os.getenv( 'LMOD_PACKAGE_PATH' )

    -- Compute the name of the file containing the CPE information.
    local CPE_file = LMOD_root .. '/../CrayPE/CPEpackages_' .. CPE_version .. '.csv'
    CPE_file =  CPE_file:gsub( '//+', '/' )

    -- Read the CPE file
    local fp = io.open( CPE_file, 'r' )
    if fp == nil then
        return nil;
    end
    local CPE_components = fp:read('*a')
    fp:close()

    -- Search for the line containing the name of the package
    --  -  First treat the dashes in the package name as they have a special meaning in a LUA regexp
    local search_string = package:gsub(  '%-', '%%-' )
    --  - And now do the search until the first control character (so any kind of newline should do)
    local start, finish = CPE_components:find( search_string .. ',[^%c]*' )

    -- If we have found a line, extract the result
    if start ~= nil then
        local package_version = CPE_components:sub( start, finish ):gsub( '%s', '' ):gsub( search_string .. ',', '' )
        return package_version
    else
        return nil
    end

end


--
-- function get_CPE_versions
--
-- Get the version of all CPE component for a particular CPE release based on
-- information kept in a .csv file.
--
-- Input arguments
--   * CPE_version: Release of the Cray Programming Environment
--   * table_package_version: Table to which the results will be added, i.e.,
--     table_package_version[package] = version
--
-- Return value: Tne number of packages read.
--
function get_CPE_versions( CPE_version, table_package_version )

    -- Get the location of the SitePackage.lua file; we assume that it is in the
    -- LUMI repository.
    local LMOD_root = os.getenv( 'LMOD_PACKAGE_PATH' )

    -- Compute the name of the file containing the CPE information.
    local CPE_file = LMOD_root .. '/../CrayPE/CPEpackages_' .. CPE_version .. '.csv'
    CPE_file =  CPE_file:gsub( '//+', '/' )

    -- Read the CPE file
    local fp = io.open( CPE_file, 'r' )
    if fp == nil then
        return nil;
    end
    local first = true
    local n_read = 0
    for line in fp:lines() do
        if first then
            first = false
        else
            -- Clean the line
            local cleaned_line = line:gsub( '"', '' ):gsub( '\'', '' ):gsub( '%s', '' )
            -- Split in module and version
            local module, version = cleaned_line:match( '([^,]*),(.*)' )
            -- Add to the table
            table_package_version[module] = version
            n_read = n_read + 1
        end
    end
    fp:close()

    -- Return the number of items read
    return n_read

end


--
-- function get_versionedfile
--
-- Find the package with the most recent version not newer than the given LUMI stack
-- version.
--
-- Input arguments:
--  * matching: The LUMI stack version to match (e.g., 21.06, 21.05.dev, ...)
--  * directory: Directory in which the matching package/file should be found.
--  * filenameprefix: The part of the file name before the version.
--  * filennamesuffix: The part of the file name after the suffix,
--
--  Return value: The full name of the file, or nil if no file is found.
--
function get_versionedfile( matching, directory, filenameprefix, filenamesuffix )

    matching = matching:gsub( '%.dev', '' ):gsub( '%..%.', '.' )

    local versions = {}
    local pattern_prefix = filenameprefix:gsub( '%-', '%%-'):gsub( '%.', '%%.' )
    local pattern_suffix = filenamesuffix:gsub( '%-', '%%-'):gsub( '%.', '%%.' )
    local pattern = pattern_prefix .. '.+' .. pattern_suffix

    local status = pcall( lfs.dir, directory )
    if not status then
        return nil
    end

    for file in lfs.dir( directory ) do
        if file:match( pattern ) ~= nil then
            local versionstring = file:gsub( pattern_prefix, '' ):gsub( pattern_suffix, '' )
            table.insert( versions, versionstring )
        end
    end

    versions[#versions+1] = '00.00'
    table.sort( versions )

    local index = #versions
    while versions[index] > matching
    do
        index = index - 1
    end

    local returnvalue
    if index == 1 then
        returnvalue = nil
    else
        returnvalue = string.gsub( directory .. '/' .. filenameprefix .. versions[index] .. filenamesuffix, '//', '/' )
    end

    return returnvalue

end




sandbox_registration{
    ['detect_LUMI_partition'] = detect_LUMI_partition,
    ['get_CPE_component']     = get_CPE_component,
    ['get_CPE_versions']      = get_CPE_versions,
    ['get_versionedfile']     = get_versionedfile,
}
