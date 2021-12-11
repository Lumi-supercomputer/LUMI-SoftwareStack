add_property("lmod","sticky")

-- Find the root of the LUMI installation.
local LUMI_root = myFileName():match( '(.*)/modules/init%-.*/init%-lumi/.*' )
local repo =  myFileName():match( '.*/modules/init%-(.*)/init%-lumi/.*' )

-- Avoid unsetting the following environment variables as they might screw up LMOD.
if mode() == 'load' or mode() == 'show' then

    -- The place where SiteConfig.lua can be found; it remains to be seen if it is wise
    -- to change this through a module...
    setenv( 'LMOD_PACKAGE_PATH', pathJoin( LUMI_root, repo, 'LMOD' ) )

    -- The module properties file, it remains to be seen if it is wise to set this
    -- through a module...
    setenv( 'LMOD_RC',           pathJoin( LUMI_root, repo, 'LMOD', 'lmodrc.lua' ) )

    -- The LMOD admin list; it remains to be seen if it is wise to change this through
    -- a module...
    setenv( 'LMOD_ADMIN_FILE',   pathJoin( LUMI_root, repo, 'LMOD', 'admin.lst' ) )

end

-- Setting defaults and visibility, note that this is a PATH-style variable
prepend_path( 'LMOD_MODULERCFILE', pathJoin( LUMI_root, repo, 'LMOD', 'modulerc.lua' ) )

setenv( 'LMOD_AVAIL_STYLE', '<label>:PEhierarchy:system' )

-- load( 'CrayEnv' )
