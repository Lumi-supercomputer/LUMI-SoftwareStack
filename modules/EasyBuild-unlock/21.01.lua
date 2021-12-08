if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Entering' )
end

--
-- Some site configuration, but there may be more as there are more parts currently
-- tuned for the UAntwerp configuration
--

help( [[
This is a dummy module that should be loaded before EasyBuild-production,
EasyBuild-infrastructure or EasyBuild-CrayEnv can be loaded to reduce the
chance of accidentally overwriting the system installation.

The module has no other purpose.
]] )

whatis( 'EasyBuild-unlock: Must be loaded when using EasyBuild to install in the system directories.' )

-- Make this a sticky module unless it is installed in /appl.

if myFileName():match('^/appl/lumi/') == nil then
    add_property(  'lmod', 'sticky' )
end

-- Some information for debugging

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Exiting' )
end
