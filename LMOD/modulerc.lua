--
-- Settings for the Style Modifier modules
--
-- This is a manually maintained file
--
module_version( 'ModuleColour/on', 'default' )
module_version( 'ModuleExtensions/show', 'default' )
module_version( 'ModuleLabel/label', 'default' )

-- Hide the TCL version of the rocm/6.0.3 module that is loaded by default
-- rather than the one in /opt/cray/pe/lmod/modulefiles/core
-- hide_modulefile( '/opt/modulefiles/rocm/6.0.3' )
-- hide_modulefile( '/opt/modulefiles/amd/6.0.3' )
-- hide_modulefile( '/opt/modulefiles/aocc/3.2.0' )
-- hide_modulefile( '/opt/modulefiles/aocc/4.1.0' )
hide_modulefile( '/opt/cray/modulefiles/rocm/5.7.0' )

if os.getenv( 'LUMI_LMOD_POWERUSER' ) == nil then
    -- Some CPE modules that should be hidden from unexperienced users
    hide_version( 'cpe-cuda/22.08' )
    hide_version( 'cpe-cuda/22.12' )
    hide_version( 'cpe-cuda/23.03' )
    hide_version( 'cpe-cuda/23.09' )
    hide_version( 'cpe-cuda/23.12' )
    hide_version( 'cpe-cuda/24.03' )
    hide_version( 'PrgEnv-nvhpc/8.3.3' )
    hide_version( 'PrgEnv-nvidia/8.3.3' )
    hide_version( 'PrgEnv-nvhpc/8.4.0' )
    hide_version( 'PrgEnv-nvidia/8.4.0' )
    -- Tool modules in CrayEnv and LUMI that should be hidden from unexperienced users
    hide_version( 'buildtools/22.08-minimal' )
    hide_version( 'buildtools/22.12-bootstrap' )
    hide_version( 'buildtools/23.03-bootstrap' )
    hide_version( 'buildtools/23.09-bootstrap' )
    hide_version( 'buildtools/23.12-bootstrap' )
    hide_version( 'buildtools/24.03-bootstrap' )
    -- Some cpe* modules for which we have no software yet
    hide_version( 'cpeGNU/23.03' )
    hide_version( 'cpeAOCC/23.03' )
    hide_version( 'cpeAMD/23.03' )
    -- Empty rocm module that actually just loads 6.0.3
    hide_version( 'rocm/5.7.0' )
end

if os.getenv( 'LUMI_STACK_NAME' ) ~= nil then
    hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/22.08.lua' )
    hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/22.12.lua' )
    hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/23.03.lua' )
    hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/23.05.lua' )
    hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/23.09.lua' )
    hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/23.12.lua' )
    hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/24.03.lua' )
end

-- Solve a problem for users who were previously using ROCm 5.0.2
module_version( 'rocm/6.0.3', '5.0.2' )
module_version( 'amd/6.0.3',  '5.0.2' )

-- Solve a potential problem with the Cray PE cpe modules.
module_version( 'rocm/6.0.3', '5.2.0' )
module_version( 'amd/6.0.3',  '5.2.0' )
module_version( 'rocm/6.0.3', '5.2.3' )
module_version( 'amd/6.0.3',  '5.2.3' )

-- Fix for the missing cray-mpich modules.
module_version( 'cray-mpich/8.1.27', '8.1.18' )
module_version( 'cray-mpich/8.1.27', '8.1.23' )
module_version( 'cray-mpich/8.1.27', '8.1.25' )

