--
-- Synonyms for the partion modules that explain better what they do.
--
-- This is a manually maintained file.
--

module_version( 'partition/C', 'CPUcompute' )
module_version( 'partition/G', 'GPUcompute' )
-- module_version( 'partition/D', 'DataVisualisation' )
module_version( 'partition/L', 'login' )

--
-- Modules that should be hidden from regular users
--

if os.getenv( 'LUMI_LMOD_POWERUSER' ) == nil then
    hide_version( 'partition/common' )
    hide_version( 'partition/CrayEnv' )
    hide_version( 'partition/system' )
    -- hide_version( 'partition/D' )
    -- hide_version( 'partition/EAP' )
    -- hide_version( 'partition/G' )
    hide_version(   'EasyBuild-unlock/LUMI' )
    module_version( 'EasyBuild-unlock/LUMI', 'default' )
    hide_version(   'EasyBuild-production/LUMI' )
    module_version( 'EasyBuild-production/LUMI', 'default' )
    hide_version(   'EasyBuild-infrastructure/LUMI' )
    module_version( 'EasyBuild-infrastructure/LUMI', 'default' )
    -- hide_version( 'EasyBuild/4.6.0' ) -- Unfortunately only works with the version specified, so have to do it via the visibility hook.
end

--
--  Cray PE modules that we don't want to be seen in the LUMI stacks.
--
if os.getenv( 'LUMI_LMOD_POWERUSER' ) == nil then
    -- NVIDIA
    hide_version( 'craype-accel-nvidia70' )
    -- hide_version( 'craype-accel-nvidia80' )  -- May be usefull on the visualisation nodes
    hide_version( 'craype-accel-nvidia90' )
    -- Other AMD architectures
    hide_version( 'craype-accel-amd-gfx908' )
    hide_version( 'craype-accel-amd-gfx940' )
    hide_version( 'craype-accel-amd-gfx942' )
    -- Other CPU architecture
    hide_version( 'craype-arm-grace' )
    hide_version( 'craype-x86-broadwell' )
    hide_version( 'craype-x86-skylake' )
    hide_version( 'craype-x86-cascadelake' )
    hide_version( 'craype-x86-icelake' )
    hide_version( 'craype-x86-spr' )
    hide_version( 'craype-x86-spr-hbm' )
    hide_version( 'craype-x86-milan-x' )
    hide_version( 'craype-x86-genoa' )
    hide_version( 'craype-x86-genoa-x' )
    hide_version( 'craype-network-ucx' )
    -- Irrelevant hugepages
    hide_version( 'craype-hugepages4M' )
    hide_version( 'craype-hugepages8M' )
    hide_version( 'craype-hugepages16M' )
    hide_version( 'craype-hugepages32M' )
    hide_version( 'craype-hugepages64M' )
    hide_version( 'craype-hugepages128M' )
    hide_version( 'craype-hugepages256M' )
    hide_version( 'craype-hugepages512M' )
    hide_version( 'craype-hugepages2G' )
end
