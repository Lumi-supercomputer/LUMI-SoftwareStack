if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Entering' )
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

--
-- Add additionsl directories to the MODULEPATH
-- (could be moved to /etc/cray-pe.d/cray-pe-configuration.sh)
--
prepend_path( 'MODULEPATH', pathJoin( LUMI_root, 'modules/easybuild/system' ) )

-- Setting defaults and visibility, note that this is a PATH-style variable
prepend_path( 'LMOD_MODULERCFILE', pathJoin( LUMI_root, repo, 'LMOD', 'modulerc.lua' ) )

-- Set the display style of the modules by loading one of the ModuleLable modules
-- instead. The problem is that in cpe 21.05, due to a configuration error on LUMI,
-- loading one of the PrgEnv modules triggers a reload of lumi (as the wrong list
-- of modules is reloaded). We don't want the settings of the user to be reset.
if not isloaded( 'ModuleLabel' ) then
    if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
        LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Loading ModuleLabel/label' )
    end
    load( 'ModuleLabel/label' )
end
-- Once only CPE 21.08 or later is in use, we can use the next line instead:
-- setenv( 'LMOD_AVAIL_STYLE', '<label>:PEhierarchy:system' )



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

    local show_motd = not isFile( pathJoin( os.getenv( 'HOME' ) or '', '.nomotd' ) )
    local show_tip  = not isFile( pathJoin( os.getenv( 'HOME' ) or '', '.nomotdtip' ) ) and show_motd

    if os.getenv( '_LUMI_INIT_FIRST_LOAD' ) == nil and is_interactive() then

        -- Get the general info MOTD and print.
        --
        -- The problem with LmodMessage is that it does some undesired
        -- formatting to the output string, replacing multiple spaces
        -- with single spaces after the initial non-space character.
        -- Note that LmodMessage itself also writes the result with
        -- io.stderr:write.
        local motd = get_motd()
        if mode() == 'load' and motd ~= nil and show_motd then
            io.stderr:write( motd .. '\n\n' )
        end

        -- Get a fortune text with LUMI tip.
        local fortune = get_fortune()
        if mode() == 'load' and fortune ~= nil and show_tip then
            io.stderr:write( 'Did you know?\n' ..
                             '*************\n' ..
                             fortune .. '\n' )
        end

        -- Flush
        io.stderr:flush()

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


Usage
=====
You can disable the display of the tip at the end of the message-of-the-day by creating
a file .nomotdtip in your home directory, e.g.,

$ touch ~/.nomotdtip

You can disable the complete message-of-the-day except for some header by creating a file
.nomotd in your home directory, e.g.,

$ touch ~/.nomotd

Note that it is still your responsability to be aware of the information that is spread
via the message-of-the-day, so do not blame the LUMI User Support Team nor CSC if you
miss information because you hide the message-of-the-day. If you are new on the system
you may have missed information that is in the message-of-the-day and spread by email.


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

-- Debug message
if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Exiting' )
end


