if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Entering' )
    local lmod_modulercfile = os.getenv( 'LMOD_MODULERCFILE' ) or ''
    LmodMessage( 'DEBUG: Found LMOD_MODULERCFILE = ' .. lmod_modulercfile )
end

whatis( "Description: Enables the " .. myModuleVersion() .. " version of the CPE" )

help( [[
Description
===========
Loading this module enables the ]] .. myModuleVersion() .. [[ version of the CPE. It will
switch all already loaded CPE modules_version to the version from the ]]  .. myModuleVersion() .. [[ release
and ensure that all further CPE modules_version that are loaded without specifying a
version will be loaded in the version from the ]] .. myModuleVersion() .. [[ release.

]] )


append_path("LMOD_MODULERCFILE","/opt/cray/pe/cpe/21.04/modulerc.lua")

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
modules_version = {}
modules_version["PrgEnv-aocc"] = "8.0.0"
modules_version["PrgEnv-cray"] = "8.0.0"
modules_version["PrgEnv-gnu"] = "8.0.0"
modules_version["PrgEnv-intel"] = "8.0.0"
modules_version["PrgEnv-nvidia"] = "8.0.0"
modules_version["aocc"] = "2.2.0.1"
modules_version["atp"] = "3.13.1"
modules_version["cce"] = "11.0.4"
modules_version["cray-R"] = "4.0.3.0"
modules_version["cray-ccdb"] = "4.11.1"
modules_version["cray-cti"] = "2.13.6"
modules_version["cray-dsmml"] = "0.1.4"
modules_version["cray-fftw"] = "3.3.8.9"
modules_version["cray-hdf5"] = "1.12.0.3"
modules_version["cray-hdf5-parallel"] = "1.12.0.3"
modules_version["cray-jemalloc"] = "5.1.0.4"
modules_version["cray-libsci"] = "21.04.1.1"
modules_version["cray-mpich"] = "8.1.4"
modules_version["cray-netcdf"] = "4.7.4.3"
modules_version["cray-netcdf-hdf5parallel"] = "4.7.4.3"
modules_version["cray-openshmemx"] = "11.2.0"
modules_version["cray-parallel-netcdf"] = "1.12.1.3"
modules_version["cray-pmi"] = "6.0.10"
modules_version["cray-pmi-lib"] = "6.0.10"
modules_version["cray-python"] = "3.8.5.0"
modules_version["cray-stat"] = "4.10.1"
modules_version["craype"] = "2.7.6"
modules_version["craype-dl-plugin-py3"] = "21.04.1"
modules_version["craypkg-gen"] = "1.3.14"
modules_version["gcc"] = "9.3.0"
modules_version["gdb4hpc"] = "4.12.5"
modules_version["iobuf"] = "2.0.10"
modules_version["modules_version"] = "3.2.11.4"
modules_version["nvidia"] = "20.9"
modules_version["papi"] = "6.0.0.6"
modules_version["perftools-base"] = "21.02.0"

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
        if (isloaded(mod)) then
            if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
                LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Swtiching ' .. mod .. ' to ' .. mod .. '/' .. modules_version[mod] )
            end
            unload(mod)
            load(mod .. "/" .. modules_version[mod])
        end
    end
end

-- Some information for debugging

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Exiting' )
end
