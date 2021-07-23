if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Entering' )
    local lmod_modulercfile = os.getenv( 'LMOD_MODULERCFILE' ) or ''
    LmodMessage( 'DEBUG: Found LMOD_MODULERC = ' .. lmod_modulercfile )
end

local data_root = myFileName():match( '(.*/modules/CrayOverwrite)/.*' )

whatis( "Description: Enables the " .. myModuleVersion() .. " version of the CPE" )

help( [[
Description
===========
Loading this module enables the ]] .. myModuleVersion() .. [[ version of the CPE. It will
switch all already loaded CPE modules_version to the version from the ]]  .. myModuleVersion() .. [[ release
and ensure that all further CPE modules_version that are loaded without specifying a
version will be loaded in the version from the ]] .. myModuleVersion() .. [[ release.

]] )

-- Note that this construction with the shadow modulerc files is a leftover needed
-- to be able to test on the Grenoble test system. We only need the native one on
-- properly installed Cray systems.
--
-- Just as the regular cpe/yuy.mm modules, we do put the modulerc.lua file in the
-- path but we use append_path so that when used with the LUMI software stacks, the
-- one corresponding to the LUMI software stack takes precedence.
local native_modulerc = pathJoin( '/opt/cray/pe/cpe', myModuleVersion(), 'modulerc.lua' )
local shadow_modulerc = pathJoin( data_root, 'data-cpe', myModuleVersion(), 'modulerc.lua' )
if isFile( native_modulerc ) then
    append_path( 'LMOD_MODULERCFILE', native_modulerc )
else
    append_path( 'LMOD_MODULERCFILE', shadow_modulerc )
end

--
-- Get the package versions
--

local table_package_version = {}
get_CPE_versions( myModuleVersion(), table_package_version )

--
-- Array: Order in which the modules should be loaded
--
modules = {
    "PrgEnv-aocc",
    "PrgEnv-cray",
    "PrgEnv-gnu",
    "PrgEnv-intel",
    "PrgEnv-nvidia",
    "cce",
    "gcc",
    "aocc",
    "nvidia",
    "craype",
    "cray-fftw",
    "cray-hdf5",
    "cray-netcdf",
    "cray-mpich",
    "cray-parallel-netcdf",
    "cray-hdf5-parallel",
    "cray-netcdf-hdf5parallel",
    "cray-openshmemx",
    "atp",
    "cray-R",
    "cray-ccdb",
    "cray-cti",
    "cray-dsmml",
    "cray-jemalloc",
    "cray-libsci",
    "cray-pmi",
    "cray-pmi-lib",
    "cray-python",
    "cray-stat",
    "craype-dl-plugin-py3",
    "craypkg-gen",
    "gdb4hpc",
    "iobuf",
    "modules",
    "papi",
    "perftools-base",
}

--
-- Table: Version of each module
--
-- Out-commented modules_version are not on the Grenoble system
modules_version = {}
modules_version["PrgEnv-aocc"] =              table_package_version['cpe-prgenv']
modules_version["PrgEnv-cray"] =              table_package_version['cpe-prgenv']
modules_version["PrgEnv-gnu"] =               table_package_version['cpe-prgenv']
modules_version["PrgEnv-intel"] =             table_package_version['cpe-prgenv']
modules_version["PrgEnv-nvidia"] =            table_package_version['cpe-prgenv']
modules_version["aocc"] =                     table_package_version['AOCC']
modules_version["atp"] =                      table_package_version['ATP']
modules_version["cce"] =                      table_package_version['CCE']
modules_version["cray-R"] =                   table_package_version['cray-R']
modules_version["cray-ccdb"] =                table_package_version['CCDB']
modules_version["cray-cti"] =                 table_package_version['CTI']
modules_version["cray-dsmml"] =               table_package_version['DSMML']
modules_version["cray-fftw"] =                table_package_version['FFTW']
modules_version["cray-hdf5"] =                table_package_version['HDF5']
modules_version["cray-hdf5-parallel"] =       table_package_version['HDF5']
modules_version["cray-jemalloc"] =            table_package_version['jemalloc']
modules_version["cray-libsci"] =              table_package_version['LibSci']
modules_version["cray-libsci_acc"] =          table_package_version['LibSci_acc']
modules_version["cray-mpich"] =               table_package_version['MPICH']
modules_version["cray-netcdf"] =              table_package_version['NetCDF']
modules_version["cray-netcdf-hdf5parallel"] = table_package_version['NetCDF']
modules_version["cray-openshmemx"] =          table_package_version['OpenSMEMX']
modules_version["cray-parallel-netcdf"] =     table_package_version['parallel-netcdf']
modules_version["cray-pmi"] =                 table_package_version['PMI']
modules_version["cray-pmi-lib"] =             table_package_version['PMI']
modules_version["cray-python"] =              table_package_version['cray-python']
modules_version["cray-stat"] =                table_package_version['STAT']
modules_version["craype"] =                   table_package_version['craype']
modules_version["craype-dl-plugin-py3"] =     table_package_version['craype-dl-plugin-py3']
modules_version["craypkg-gen"] =              table_package_version['craypkg-gen']
modules_version["gcc"] =                      table_package_version['GCC']
modules_version["gdb4hpc"] =                  table_package_version['gdb4hpc']
modules_version["iobuf"] =                    table_package_version['iobuf']
modules_version["nvidia"] =                   table_package_version['NVIDIA']
modules_version["papi"] =                     table_package_version['PAPI']
modules_version["perftools-base"] =           table_package_version['perftools']

local warning = [[
Unloading the cpe module is insufficient to restore the system defaults.
Please load the cpe/restore-defaults module after unloading this module
to complete the restoration of the system defaults.
If you arrived at this message by loading cpe/restore-defaults, you'll need
to execute load cpe/restore-defaults a second time. This is the result of
some design decisions in the LMOD software.
]]

if (mode() == "unload") then
    LmodMessage( warning )
elseif (mode() == "load" or mode() == "show") then
    for _,mod in pairs(modules)
    do
        if modules_version[mod] ~= nil then
            if (isloaded(mod)) then
                if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
                    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Switching ' .. mod .. ' to ' .. mod .. '/' .. modules_version[mod] )
                end
                unload(mod)
                load(mod .. "/" .. modules_version[mod])
            end
        end
    end
end

-- Some information for debugging

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Exiting' )
end
