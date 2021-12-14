if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Entering' )
end

--
-- Some initialisation
--
add_property("lmod","sticky")

-- Find the root of the LUMI installation.
local LUMI_root = myFileName():match( '(.*)/modules/init%-.*/init%-lumi/.*' )
local repo =  myFileName():match( '.*/modules/init%-(.*)/init%-lumi/.*' )

--
-- The actual work
--

-- Avoid unsetting the following environment variables as they might screw up LMOD.
-- -- This is not needed if the work is done elsewhere during the initialisation.
-- if mode() == 'aload' or mode() == 'ashow' then
--
--     -- The place where SiteConfig.lua can be found; it remains to be seen if it is wise
--     -- to change this through a module...
--     setenv( 'LMOD_PACKAGE_PATH', pathJoin( LUMI_root, repo, 'LMOD' ) )
--
--     -- The module properties file, it remains to be seen if it is wise to set this
--     -- through a module...
--     setenv( 'LMOD_RC',           pathJoin( LUMI_root, repo, 'LMOD', 'lmodrc.lua' ) )
--
--     -- The LMOD admin list; it remains to be seen if it is wise to change this through
--     -- a module...
--     setenv( 'LMOD_ADMIN_FILE',   pathJoin( LUMI_root, repo, 'LMOD', 'admin.lst' ) )
--
-- end

-- Setting defaults and visibility, note that this is a PATH-style variable
prepend_path( 'LMOD_MODULERCFILE', pathJoin( LUMI_root, repo, 'LMOD', 'modulerc.lua' ) )

setenv( 'LMOD_AVAIL_STYLE', '<label>:PEhierarchy:system' )



-- -----------------------------------------------------------------------------
--
-- Modules loaded by default
--
-- This will only work if the part of code that sets LMOD_PACKAGE_PATH, LMOD_RC
-- and LMOD_ADMIN_FILE is not needed here but already set during system
-- initialisation
--
-- Note that preloading one of the stacks has side effects when a user does a
-- module purge as module purge reloads the sticky module also, hence the
-- environment will switch again to the default which was not meant to be the
-- case.
--
-- Hence for now the module loads are outcommented (and either CrayEnv, or LUMI
-- with cpeCray should be used, not all of them).
--

-- load( 'CrayEnv' )
-- load( 'LUMI' )
-- load( 'cpeCray' )


-- -----------------------------------------------------------------------------
--
-- Enhanced message-of-the-day
--

if mode() == 'load' or mode() == 'show' then

    if os.getenv( '_LUMI_INIT_FIRST_LOAD' ) == nil then

        -- Get the MOTD and print.
        --
        -- The problem with LmodMessage is that it does some undesired
        -- formatting to the output string, replacing multiple spaces
        -- with single spaces after the initial non-space character.
        -- Note that LmodMessage itself also writes the result with
        -- io.stderr:write.
        local motd = get_motd()
        if mode() == 'load' and motd ~= nil then
            io.stderr:write( motd .. '\n\n' )
        end

        -- Get a fortune text.
        local fortune = get_fortune()
         if mode() == 'load' and fortune ~= nil then
            io.stderr:write( 'Did you know?\n' ..
                             '*************\n' ..
                             fortune .. '\n' )
        end


        -- Make sure this block of code is not executed anymore.
        -- This statement is not reached during an unload of the module
        -- so _LUMI_INIT_FIRST_LOAD will not be unset anymore.
        setenv( '_LUMI_INIT_FIRST_LOAD', '1' )

    end

end



-- -----------------------------------------------------------------------------
--
-- Help information
--

help( [[
Description
===========
The init-lumi module performs most of the initialisations needed to use the
CrayEnv and LUMI software stacks.

You can load the CrayEnv module to have an enriched Cray programming environment
or the LUMI module to get the full managed software stack that can be easily
extended using EasyBuild.

Force-unloading this module will return you to the almost bare Cray LMOD environment
which you can use without support from LUST at your own risk.


More information
================
  - See https://docs.lumi-supercomputer.eu/computing/softwarestacks/ for the
    basics on LUMI software stack.
  - See https://docs.lumi-supercomputer.eu/computing/Lmod_modules/ for the
    basics on the Lmod modules in use since December 15 on LUMI
  - See https://docs.lumi-supercomputer.eu/software/installing/easybuild/ for
    more information on how to extend the software stack offered by the LUMI
    module.
]] )

whatis( 'init-lumi: Initialisation module for the software stacks. Remove at your own risk.' )
