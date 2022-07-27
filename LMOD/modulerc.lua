--
-- Settings for the Style Modifier modules
--
-- This is a manually maintained file
--
module_version( 'ModuleColour/on', 'default' )
module_version( 'ModuleExtensions/show', 'default' )
module_version( 'ModuleLabel/label', 'default' )

if os.getenv( 'LUMI_LMOD_POWERUSER' ) == nil then
    hide_version( 'cpe-cuda/21.08' )
    hide_version( 'cpe-cuda/21.12' )
end

if os.getenv( 'LUMI_STACK_NAME' ) ~= nil then
hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/21.05.lua' )
hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/21.08.lua' )
hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/21.09.lua' )
hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/21.10.lua' )
hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/21.11.lua' )
hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/21.12.lua' )
hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/22.06.lua' )
end

-- The following modules do not work with Cray LMOD 8.3.1
hide_version( 'ModuleExtensions/hide' )
hide_version( 'ModuleExtensions/show' )

-- Send 21.08 modules to different versions as 21.08 is not currently installed on LUMI.
module_version( 'PrgEnv-gnu/8.2.0', '8.1.0' )
module_version( 'PrgEnv-cray/8.2.0', '8.1.0' )
module_version( 'atp/3.14.8', '3.14.3' )
module_version( 'cce/13.0.0', '12.0.2' )
module_version( 'cray-R/4.1.1.1', '4.0.5.1' )
module_version( 'cray-mpich-abi/8.1.12', '8.1.8' )
module_version( 'cray-mpich/8.1.12', '8.1.8' )
module_version( 'cray-openshmemx/11.5.0', '11.3.2' )
module_version( 'cray-fftw/3.3.8.12', '3.3.8.11' )
module_version( 'cray-ccdb/4.12.7', '4.12.2' )
module_version( 'cray-cti/2.15.8', '2.15.4' )
module_version( 'cray-dsmml/0.2.2', '0.2.0' )
-- module_version( 'cray-dyninst/10.1.0', '10.1.0' )
module_version( 'cray-dyninst/12.1.0', '12.0.0' )
module_version( 'cray-libpals/1.1.3', '1.0.14' )
-- module_version( 'cray-libsci/21.08.1.2', '21.08.1.2' )
-- module_version( 'cray-mrnet/5.0.2', '5.0.2' )
module_version( 'cray-pals/1.1.3', '1.0.14' )
module_version( 'cray-pmi-lib/6.0.16', '6.0.13' )
module_version( 'cray-pmi/6.0.16', '6.0.13' )
module_version( 'cray-python/3.9.4.2', '3.8.5.1' )
module_version( 'cray-stat/4.11.8', '4.11.3' )
module_version( 'craype/2.7.13', '2.7.9' )
module_version( 'craypkg-gen/1.3.21', '1.3.17' )
module_version( 'gdb4hpc/4.13.8', '4.13.4' )
-- module_version( 'iobuf/2.0.10', '2.0.10' )
module_version( 'papi/6.0.0.12', '6.0.0.7' )
module_version( 'perftools-base/21.12.0', '21.05.0' )
module_version( 'valgrind4hpc/2.12.6', '2.12.2' )
module_version( 'cray-hdf5/1.12.0.7', '1.12.0.6' )
module_version( 'cray-hdf5-parallel/1.12.0.7', '1.12.0.6' )
module_version( 'cray-netcdf/4.7.4.7', '4.7.4.6' )
module_version( 'cray-netcdf-hdf5parallel/4.7.4.7', '4.7.4.6' )
module_version( 'cray-parallel-netcdf/1.12.1.7', '1.12.1.6' )

