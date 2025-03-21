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
--  Cray PE modules that we don't want to be seen in the LUMI stacks.
--
-- No need to do that here actually as there is code in SitePackage.lua
-- that takes care of this in the LUMI stacks and actually adapts which
-- target modules will be shown depending on the partition.
--
-- if os.getenv( 'LUMI_LMOD_POWERUSER' ) == nil then
--     -- NVIDIA
--     hide_version( 'craype-accel-nvidia70' )
--     -- hide_version( 'craype-accel-nvidia80' )  -- May be usefull on the visualisation nodes
--     hide_version( 'craype-accel-nvidia90' )
--     -- Other AMD architectures
--     hide_version( 'craype-accel-amd-gfx908' )
--     hide_version( 'craype-accel-amd-gfx940' )
--     hide_version( 'craype-accel-amd-gfx942' )
--     -- Other CPU architecture
--     hide_version( 'craype-arm-grace' )
--     hide_version( 'craype-x86-broadwell' )
--     hide_version( 'craype-x86-skylake' )
--     hide_version( 'craype-x86-cascadelake' )
--     hide_version( 'craype-x86-icelake' )
--     hide_version( 'craype-x86-spr' )
--     hide_version( 'craype-x86-spr-hbm' )
--     hide_version( 'craype-x86-milan-x' )
--     hide_version( 'craype-x86-genoa' )
--     hide_version( 'craype-x86-genoa-x' )
--     hide_version( 'craype-network-ucx' )
--     -- Irrelevant hugepages
--     hide_version( 'craype-hugepages4M' )
--     hide_version( 'craype-hugepages8M' )
--     hide_version( 'craype-hugepages16M' )
--     hide_version( 'craype-hugepages32M' )
--     hide_version( 'craype-hugepages64M' )
--     hide_version( 'craype-hugepages128M' )
--     hide_version( 'craype-hugepages256M' )
--     hide_version( 'craype-hugepages512M' )
--     hide_version( 'craype-hugepages2G' )
-- end
