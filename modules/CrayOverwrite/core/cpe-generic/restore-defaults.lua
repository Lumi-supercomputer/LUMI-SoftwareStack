if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Entering' )
    local lmod_modulercfile = os.getenv( 'LMOD_MODULERCFILE' ) or ''
    LmodMessage( 'DEBUG: Found LMOD_MODULERC = ' .. lmod_modulercfile )
end

whatis( "Description: Restores the default versions of loaded CPE modules" )

help( [[
Description
===========
Loading the cpe/restore-defaults module restores default versions for all loaded
CPE modules. It does not necessarily return to the environment that you had at
login as the system administrator may have chosen to load a different version by
default, or as you may have switched to a different PrgEnv-* module.

]] )

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

if (mode() == "load" or mode() == "show") then
    for _,mod in ipairs(modules)
    do
        if (isloaded(mod)) then
            if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
                LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Unloading and loading ' .. mod .. ' again' )
            end
            unload(mod)
            load(mod)
        end
    end
end

-- Some information for debugging

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Exiting' )
end
