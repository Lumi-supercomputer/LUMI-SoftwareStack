--
-- Synonyms for the partion modules that explain better what they do.
--

module_version( 'partition/C', 'CPUcompute' )
module_version( 'partition/G', 'GPUcompute' )
module_version( 'partition/D', 'DataVisualisation' )
module_version( 'partition/L', 'login' )

--
-- Modules that should be hidden from regular users
--

if os.getenv( 'LUMI_LMOD_POWERUSER' ) == nil then
    hide_version( 'partition/common' )
    hide_version( 'EasyBuild-production/LUMI' )
    hide_version( 'EasyBuild-infrastructure/LUMI' )
end
