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
end

-- The following modules do not work with Cray LMOD 8.3.1
hide_version( 'ModuleExtensions/hide' )
hide_version( 'ModuleExtensions/show' )

hide_modulefile( '/opt/cray/pe/lmod/modulefiles/core/cpe/22.05.lua' )
