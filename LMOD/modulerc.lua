--
-- Settings for the Style Modifier modules
--
-- This is a manually maintained file
--
module_version( 'ModuleColour/on', 'default' )
module_version( 'ModuleExtensions/show', 'default' )
module_version( 'ModuleLabel/label', 'default' )

if os.getenv( 'LUMI_LMOD_POWERUSER' ) == nil then
    -- Some CPE modules that should be hidden from unexperienced users
    hide_version( 'cpe-cuda/22.08' )
    hide_version( 'cpe-cuda/22.12' )
    hide_version( 'cpe-cuda/23.03' )
    hide_version( 'PrgEnv-nvhpc/8.3.3' )
    hide_version( 'PrgEnv-nvidia/8.3.3' )
    -- Tool modules in CrayEnv and LUMI that should be hidden from unexperienced users
    hide_version( 'buildtools/22.08-minimal' )
end

if os.getenv( 'LUMI_STACK_NAME' ) ~= nil then
hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/21.05.lua' )
hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/21.08.lua' )
hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/21.09.lua' )
hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/21.10.lua' )
hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/21.11.lua' )
hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/21.12.lua' )
hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/22.06.lua' )
hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/22.08.lua' )
hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/22.09.lua' )
end

-- The following modules do not work with Cray LMOD 8.3.1
hide_version( 'ModuleExtensions/hide' )
hide_version( 'ModuleExtensions/show' )

-- Solve a problem for users who were previously using ROCm 5.0.2
module_version( 'rocm/5.2.3', '5.0.2' )
module_version( 'amd/5.2.3',  '5.0.2' )

-- Solve a potential problem with the Cray PE cpe modules.
module_version( 'rocm/5.2.3', '5.2.0' )
module_version( 'amd/5.2.3',  '5.2.0' )
