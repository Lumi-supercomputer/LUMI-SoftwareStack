-- LUMI Lmod customizations

require("strict")
local os = require("os")
local dbg  = require("Dbg"):dbg()
local hook = require("Hook")
require("sandbox")

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    io.stderr:write( 'DEBUG: Executing SitePackage.lua from ' .. ( os.getenv( 'LMOD_PACKAGE_PATH' ) or '') .. '\n' )
end


-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
--
-- Tables providing information about the system
--
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------

--
-- Default targeting modules
--
local init_module_list = {
    C   = { 'craype-x86-milan',  'craype-accel-host',       'craype-network-ofi', 'xpmem' },
--    D   = { 'craype-x86-rome',   'craype-accel-nvidia80',   'craype-network-ofi', 'xpmem' },
    D   = { 'craype-x86-rome',   'craype-accel-host',       'craype-network-ofi', 'xpmem' }, -- craype-accel-nvidia does not yet work
    G   = { 'craype-x86-milan',  'craype-accel-amd-gfx90a', 'craype-network-ofi', 'xpmem' },
    L   = { 'craype-x86-rome',   'craype-accel-host',       'craype-network-ofi', 'xpmem' },
    EAP = { 'craype-x86-rome',   'craype-accel-amd-gfx908', 'craype-network-ofi', 'xpmem' },
}

--
-- Default Cray Programming Environment.
--
local init_PrgEnv = 'PrgEnv-cray'

--
-- Stacks with long-term support
--
-- Currently there are none but some commented versions are left to indicate
-- how the table should be filled.
--
local LTS_LUMI_stacks = {
    -- ['21.08'] = true,
    -- ['21.12'] = true,
}


-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
--
-- LMOD additional functions
--
-- These are put first so that they can be used in the hooks also.
--
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------

--
-- function get_hostname
--
-- Gets the hostname from the system.
--
-- In the implementation, we call /bin/hostname rather than relying on environment
-- variables so that this is guaranteed to work, also on systems with the default
-- SLURM setup that copies the environment from the node where the job was
-- submitted and may not reset the HOSTNAME variable if no login shell is
-- used.
--
function get_hostname()

    local f = io.popen ("/bin/hostname")
    local hostname = f:read("*a") or ""
    f:close()

    -- Clean up: Remove new line at the end
    hostname =string.gsub(hostname, "\n$", "")

    return hostname

end

--
-- Function get_user_prefix_EasyBuild
--
-- Returns the user prefix for the EasyBuild installation.
--
-- The value is taken from EBU_USER_PREFIX or if that one is not defined,
-- computed from the location of the home directory.
--
-- There is no trailing dash in the output.
--
function get_user_prefix_EasyBuild()

    local home_prefix = os.getenv( 'HOME' ) .. '/EasyBuild'
    home_prefix = home_prefix:gsub( '//', '/' ):gsub( '/$', '' )

    local ebu_user_prefix = os.getenv( 'EBU_USER_PREFIX' )

    if ebu_user_prefix == '' then
        -- EBU_USER_PREFIX is empty which indicates that there is no user
        -- installation, also not the default one.
        return nil
    else
        -- If EBU_USER_PREFIX is set, return that one and otherwise the
        -- default directory.
        return ( ebu_user_prefix or home_prefix )
    end

end

--
-- function detect_LUMI_partition
--
-- Code to detect on which partition of LUMI we are.
--
-- Current algorithm:
--  * The environment variable LUMI_OVERWRITE_PARTITION overwrites any
--    setting the algorithm may chose.
--  * The current algorithm checks for the hostnames on LUMI.
--    It will currently not work on other systems except for the
--    login nodes of eiger (and any other Cray system that uses
--    the standard Cray names).
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

    local partition
    local overwrite_partition = os.getenv( 'LUMI_OVERWRITE_PARTITION' )

    if overwrite_partition ~= nil and overwrite_partition ~= '' then

        -- Overwrite the default detection of the LUMI partition
        partition = overwrite_partition

    else

        -- We'll try matching hostnames to decided on the partition
        local hostname = get_hostname()

        if hostname:find( 'uan' ) then
            -- This is a login node

            partition = 'L'

        elseif hostname:find( 'nid%d%d%d%d%d%d' ) then
            -- This is some type of compute node

            local tmp1, tmp2, tmp3, nodenum

            -- Replacing unneeded variables with an underscore doesn't always seem
            -- to work. After a module purge it produces errors when reloading the modules.
            tmp1, tmp2, tmp3 = hostname:find( 'nid(%d%d%d%d%d%d)' )
            nodenum = tonumber( tmp3 ) -- Convert to number

            -- Find the partition based on the node number
            if ( nodenum >= 1000 ) and ( nodenum <= 2535 ) then
                partition = 'C'
            elseif ( nodenum >= 101 ) and ( nodenum <= 108 ) then
                -- LUMI-D nodes without a GPU (largemem nodes)
                partition = 'L'
            elseif ( nodenum >= 16 ) and ( nodenum <= 23 ) then
                -- LUMI-D nodes with GPU
                partition = 'D'
            elseif ( nodenum >= 2 ) and ( nodenum <= 15 ) then
                -- EAP nodes with GPU
                partition = 'EAP'
            else
                partition = 'L'
            end

        else -- Don't recognize the form of the host name unfortunately.

            partition = 'L'

        end

    end

    return partition

end


--
-- function get_init_module_list( partition, PrgEnv )
--
-- Input argument:
--  * partition: The partition to return the modules for (L, C, G or D)
--  * PrgEnv: Add the default programming environment to the list.
--
-- Returns a list of modules to load.
--
function get_init_module_list( partition, PrgEnv )

    local modulelist

    if init_module_list[partition] == nil then
        -- Invalid partition, return nil
        modulelist = nil
    elseif PrgEnv then
        modulelist = init_module_list[partition]
        table.insert( modulelist, init_PrgEnv )
    else
        modulelist = init_module_list[partition]
    end

    return modulelist

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
    local pattern = '^' .. pattern_prefix .. '.+' .. pattern_suffix .. '$'

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


--
-- function get_motd
--
-- Returns the message-of-the-day in the etc subdirectory of this repository,
-- or nil if the file is empty or not found.
--
function get_motd()

    local LMOD_root = os.getenv( 'LMOD_PACKAGE_PATH' )
    local motd_file = pathJoin( LMOD_root, '../etc/motd.txt' )

    -- Read the file in a single read statement
    local fp = io.open( motd_file, 'r' )
    if fp == nil then return nil end
    local motd = fp:read( '*all' )
    fp:close()

    -- Delete trailing white space.
    motd = motd:gsub( '%s*$', '' )

    -- Return nil if we had an empty file and otherwise return the motd
    if  #(motd) == 0 then
        return nil
    else
        return motd
    end

end


--
-- function get_fortune
--
-- Returns a "fortune text" readt from etc/lumi_fortune.txt
--
function get_fortune()

    local LMOD_root = os.getenv( 'LMOD_PACKAGE_PATH' )
    local fortune_file = pathJoin( LMOD_root, '../etc/lumi_fortune.txt' )

    -- Read the file in a single read statement
    local fp = io.open( fortune_file, 'r' )
    if fp == nil then return nil end
    local fortune = fp:read( '*all' )
    fp:close()

    -- Now split up in the blocks of text and delete leading and
    -- trailing whitespace in each block
    local separator = '====='
    local fortune_table = {}
    for str in string.gmatch( fortune, "([^" .. separator .. "]+)" ) do
        str = str:gsub( '^%s*', ''  ):gsub( '%s*$', '' )
        table.insert( fortune_table, str )
    end

    -- Select a text block (based on the time)
    -- Indices in LUA arrays start at 1.
    local fortune_number = os.time() % #(fortune_table) + 1

    return fortune_table[fortune_number] .. '\n'

end


--
-- function get_num_motd
--
-- Gets the number of times the message-of-the-day has been shown today.
--
function get_num_motd()

    -- Read .motd-day-counter if present. If not, return 0.
    local filename = pathJoin( os.getenv( 'HOME' ) or '', '.motd-day-counter' )
    if not isFile( filename ) then return 0 end
    local fp = io.open( filename, 'r' )
    if fp == nil then return 0 end
    local buffer = fp:read( '*all' )
    fp:close()

    local date, num
    date, num = buffer:match( '(%d+):(%d+)' )
    if date == nil or num == nil then return 0 end
    num = tonumber( num )
    
    -- Now compare the date value to the current date.
    local cur_date = os.date( '%Y%m%d', os.time() )
    if date ~= cur_date then
        num = 0 -- Data in the file was for a different date.
    end

    return num

end


--
-- function set_num_motd
--
-- Increments the number of times the message-of-the-day has been shown today.
--
function set_num_motd( num ) 

    local cur_date = os.date( '%Y%m%d', os.time() )
    local buffer = cur_date .. ':' .. num
 
    -- Write .motd-day-counter. Fail silently if the file cannot be created.
    local filename = pathJoin( os.getenv( 'HOME' ) or '', '.motd-day-counter' )
    local fp = io.open( filename, 'w' )
    if fp == nil then return end
    fp:write( buffer )
    fp:close()

end


--
-- function is_interactive()
--
-- Input arguments: None
-- Output: True for an interactive shell, otherwise false.
--
-- NOTE: It uses os.execute to run tty. It looks like the first return
-- argument is true for a shell with attached tty and nil for one without
-- one. The third output argument is 0 for a shell with tty and nonzero
-- if no tty is attached to the shell.
--
function is_interactive()

    if os.execute( '/usr/bin/tty -s' ) then
        return true
    else
        return false
    end

end


--
-- function is_LTS_LUMI_stack()
--
-- Input arguments: Version of the LUMI stack
-- Output: True it it is a LTS stack, otherwise false.
--
function is_LTS_LUMI_stack( stack_version )

    return ( LTS_LUMI_stacks[stack_version] or false )

end



sandbox_registration{
    ['get_hostname']              = get_hostname,
    ['get_user_prefix_EasyBuild'] = get_user_prefix_EasyBuild,
    ['detect_LUMI_partition']     = detect_LUMI_partition,
    ['get_init_module_list']      = get_init_module_list,
    ['get_CPE_component']         = get_CPE_component,
    ['get_CPE_versions']          = get_CPE_versions,
    ['get_versionedfile']         = get_versionedfile,
    ['get_motd']                  = get_motd,
    ['get_fortune']               = get_fortune,
    ['get_num_motd']              = get_num_motd,
    ['set_num_motd']              = set_num_motd,
    ['is_interactive']            = is_interactive,
    ['is_LTS_LUMI_stack']         = is_LTS_LUMI_stack,
}



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

-- We need to avoid that EB_prefix is nil so give it some meaningless value if it would
-- be nil.
local EB_prefix = string.gsub( get_user_prefix_EasyBuild() or '/NONE', '%-', '%%-' )

local mapT =
{
    label = {
--        ['/testview$']                      = 'Activate environments',
        ['modules/init-.*']                 = 'System initialisation',
        ['modules/StyleModifiers']          = 'Modify the module display style',
        ['modules/SoftwareStack$']          = 'Software stacks',
        ['modules/SystemPartition/']        = 'LUMI partitions for the software stack _STACK_',
        ['modules/Infrastructure/.*/partition/CrayEnv'] = 'Infrastructure modules for cross-installing from the software stack _STACK_ to CrayEnv',
        ['modules/Infrastructure/']         = 'Infrastructure modules for the software stack _STACK_ on _PARTITION_',
        ['modules/easybuild/CrayEnv']       = 'EasyBuild managed software for CrayEnv',
        ['modules/easybuild/system']        = 'EasyBuild managed systemwide software',
        ['modules/easybuild/']              = 'EasyBuild managed software for software stack _STACK_ on _PARTITION_',
        ['modules/spack/']                  = 'Spack managed software for software stack _STACK_ on _PARTITION_',
        ['modules/manual/system']           = 'Manually installed system-wide software',
        ['modules/manual/']                 = 'Manually installed software for software stack _STACK_ on _PARTITION_',
        ['cray/pe/.*/craype%-targets']      = 'HPE-Cray PE target modules',
        ['cray/pe/.*/core']                 = 'HPE-Cray PE modules',
        ['modules/CrayOverwrite/core']      = 'HPE-Cray PE modules',
        ['cray/pe/.*/mix_compilers']        = 'HPE-Cray PE modules',
        ['cray/pe/.*/perftools']            = 'HPE-Cray PE modules',
        ['cray/pe/.*/cpu']                  = 'HPE-Cray PE modules',
        ['cray/pe/.*/compiler/crayclang']   = 'HPE-Cray PE modules',
        ['cray/pe/.*/compiler/gnu']         = 'HPE-Cray PE modules',
        ['cray/pe/.*/compiler/aocc']        = 'HPE-Cray PE modules',
        ['cray/pe/.*/hdf5/']                = 'HPE-Cray PE modules',
        ['cray/pe/.*/hdf5%-parallel/']      = 'HPE-Cray PE modules',
        ['cray/pe/.*/comnet']               = 'HPE-Cray PE modules',
        ['cray/pe/.*/mpi']                  = 'HPE-Cray PE modules',
        ['cray/pe/.*/net/ofi']              = 'HPE-Cray PE modules',
        ['cray/pe/.*/net/ucx']              = 'HPE-Cray PE modules',
        -- The next one doesn't seem to be implemented on the Grenoble nodes
        ['cray/pe/craype']                  = 'HPE-Cray PE modules',
        -- One that I've only seen on LUMI
        ['usr/share/lmod/lmod/modulefiles'] = 'HPE-Cray PE modules',
        -- Likely only on the Grenoble system?
        ['/opt/cray/modulefiles']           = 'Non-PE HPE-Cray modules',
        ['/opt/modulefiles']                = 'Non-PE HPE-Cray modules',
        ['/usr/share/Modules/modulefiles']  = 'Non-PE HPE-Cray modules',
        ['/usr/share/modulefiles']          = 'Non-PE HPE-Cray modules',
        -- User-installed software
        [ EB_prefix .. '/modules']          = 'EasyBuild managed user software for software stack _STACK_ on _PARTITION_',
     },
    PEhierarchy = {
--        ['/testview$']                      = 'Activate environments',
        ['modules/init-.*']                 = 'System initialisation',
        ['modules/StyleModifiers']          = 'Modify the module display style',
        ['modules/SoftwareStack$']          = 'Software stacks',
        ['modules/SystemPartition/']        = 'LUMI partitions for the software stack _STACK_',
        ['modules/Infrastructure/.*/partition/CrayEnv'] = 'Infrastructure modules for cross-installing from the software stack _STACK_ to CrayEnv',
        ['modules/Infrastructure/']         = 'Infrastructure modules for the software stack _STACK_ on _PARTITION_',
        ['modules/easybuild/CrayEnv']       = 'EasyBuild managed software for CrayEnv',
        ['modules/easybuild/system']        = 'EasyBuild managed systemwide software',
        ['modules/easybuild/']              = 'EasyBuild managed software for software stack _STACK_ on _PARTITION_',
        ['modules/spack/']                  = 'Spack managed software for software stack _STACK_ on _PARTITION_',
        ['modules/manual/system']           = 'Manually installed system-wide software',
        ['modules/manual/']                 = 'Manually installed software for software stack _STACK_ on _PARTITION_',
        ['cray/pe/.*/craype%-targets']      = 'HPE-Cray PE target modules',
        ['cray/pe/.*/core']                 = 'HPE-Cray PE core modules',
        ['modules/CrayOverwrite/core']      = 'HPE-Cray PE core modules',
        ['cray/pe/.*/mix_compilers']        = 'HPE-Cray PE modules to load an additional compiler',
        ['cray/pe/.*/perftools']            = 'HPE-Cray PE performance analysis tools',
        ['cray/pe/.*/cpu']                  = 'HPE-Cray PE compiler-independent libraries',
        ['cray/pe/.*/compiler/crayclang']   = 'HPE-Cray PE libraries for Cray clang (cce)',
        ['cray/pe/.*/compiler/gnu']         = 'HPE-Cray PE libraries for GNU compilers',
        ['cray/pe/.*/compiler/aocc']        = 'HPE-Cray PE libraries for AMD AOCC compilers',
        ['cray/pe/.*/hdf5/']                = 'HPE-Cray PE libraries that use cray-hdf5',
        ['cray/pe/.*/hdf5%-parallel/']      = 'HPE-Cray PE libraries that use cray-hdf5-parallel',
        ['cray/pe/.*/comnet']               = 'HPE-Cray PE MPI libraries',
        ['cray/pe/.*/mpi']                  = 'HPE-Cray PE MPI-dependent libraries',
        ['cray/pe/.*/net/ofi']              = 'HPE-Cray PE OFI-based libraries',
        ['cray/pe/.*/net/ucx']              = 'HPE-Cray PE UCX-based libraries',
        -- The next one doesn't seem to be implemented on the Grenoble nodes
        ['cray/pe/craype']                  = 'HPE-Cray PE compiler wrappers',
        -- One that I've only seen on LUMI
        ['usr/share/lmod/lmod/modulefiles'] = 'HPE-Cray PE core modules',
        -- Likely only on the Grenoble system?
        ['/opt/cray/modulefiles']           = 'Non-PE HPE-Cray modules',
        ['/opt/modulefiles']                = 'Non-PE HPE-Cray modules',
        ['/usr/share/Modules/modulefiles']  = 'Non-PE HPE-Cray modules',
        ['/usr/share/modulefiles']          = 'Non-PE HPE-Cray modules',
        -- User-installed software
        [ EB_prefix .. '/modules']          = 'EasyBuild managed user software for software stack _STACK_ on _PARTITION_',
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

    for directory, dirlabel in pairs(t) do
        for pattern, label in pairs(styleT) do
            if (directory:find(pattern)) then
                t[directory] = label:gsub( '_PARTITION_', partition ):gsub( '_STACK_', stack )
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
        local spiderdoc_url = 'https://docs.lumi-supercomputer.eu/computing/Lmod_modules/'
        local request_url   = 'https://lumi-supercomputer.eu/user-support/need-help/'
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

    -- Do nothing if LUMI_LMOD_POWERUSER is set.
    if os.getenv( 'LUMI_LMOD_POWERUSER' ) ~=  nil then return end

    -- First tests: Hide the Cray PE modules that are not part of the CPE
    -- corresponding to the loaded LUMI module (if a LUMI module is loaded)
    -- LUMI_VISIBILITYHOODDATA* environment variables are set in the LUMI module.

    local CPEmodules_path = os.getenv( 'LUMI_VISIBILITYHOOKDATAPATH' )
    local CPEmodules_file = os.getenv( 'LUMI_VISIBILITYHOOKDATAFILE' )

    if CPEmodules_path ~= nil and CPEmodules_file ~= nil then

        local CPEmodules
        local saved_path = package.path
        package.path = CPEmodules_path .. ';' .. package.path
        CPEmodules = require( CPEmodules_file )
        package.path = saved_path

        if modT.fn:find( 'cray/pe/lmod/modulefiles' ) or modT.fn:find( 'modules/CrayOverwrite' ) then
            if CPEmodules[modT.sn] ~= nil then
                local module_version = modT.sn .. '/' .. CPEmodules[modT.sn]
                if modT.fullName ~= module_version and not visibility_exceptions[ modT.fullName] then
                    modT.isVisible = false
                end
            end
        end

    end  -- Conditional part first tests

end


--
-- Register the hooks
--

hook.register( "SiteName",     site_name_hook )
hook.register( "avail",        avail_hook )
hook.register( "msgHook",      msg_hook )
hook.register("isVisibleHook", is_visible_hook)


