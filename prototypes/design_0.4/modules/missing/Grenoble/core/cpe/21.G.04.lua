setenv("LMOD_MODULERCFILE","/opt/cray/pe/cpe/21.04/modulerc.lua")
-- Out-commented modules are not on the Grenoble system
modules = {}
-- modules["PrgEnv-aocc"] = "8.0.0"
modules["PrgEnv-cray"] = "8.0.0"
modules["PrgEnv-gnu"] = "8.0.0"
modules["PrgEnv-intel"] = "8.0.0"
-- modules["PrgEnv-nvidia"] = "8.0.0"
modules["aocc"] = "2.2.0.1"
modules["atp"] = "3.13.1"
modules["cce"] = "11.0.4"
modules["cray-R"] = "4.0.3.0"
modules["cray-ccdb"] = "4.11.1"
modules["cray-cti"] = "2.13.5"
modules["cray-dsmml"] = "0.1.1"
modules["cray-fftw"] = "3.3.8.8"
modules["cray-hdf5"] = "1.12.0.2"
modules["cray-hdf5-parallel"] = "1.12.0.2"
-- modules["cray-jemalloc"] = "5.1.0.4"
modules["cray-libsci"] = "21.04.1.1"
modules["cray-mpich"] = "8.1.4"
modules["cray-netcdf"] = "4.7.4.2"
modules["cray-netcdf-hdf5parallel"] = "4.7.4.2"
modules["cray-openshmemx"] = "11.1.0.beta"
modules["cray-parallel-netcdf"] = "1.12.1.1"
modules["cray-pmi"] = "6.0.10"
modules["cray-pmi-lib"] = "6.0.10"
-- modules["cray-python"] = "3.8.5.0"
modules["cray-stat"] = "4.7.1"
modules["craype"] = "2.7.6"
-- modules["craype-dl-plugin-py3"] = "21.04.1"
modules["craypkg-gen"] = "1.3.14"
modules["gcc"] = "9.3.0"
modules["gdb4hpc"] = "4.11.5"
-- modules["iobuf"] = "2.0.10"
modules["modules"] = "3.2.11.4"
-- modules["nvidia"] = "20.9"
modules["papi"] = "6.0.0.6"
modules["perftools-base"] = "21.02.0"
if (mode() == "unload") then
    LmodMessage("Unloading the cpe module is insufficient to restore the system defaults.")
    LmodMessage("Please run 'source /opt/cray/pe/cpe/21.04/restore_lmod_system_defaults.[csh|sh]'.")
elseif (mode() == "load" or mode() == "show") then
    for mod,ver in pairs(modules)
    do
        if (isloaded(mod)) then
            unload(mod)
            load(mod .. "/" .. ver)
        end
    end
end
