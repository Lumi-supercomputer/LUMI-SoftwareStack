if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Entering' )
end

--
-- Some site configuration, but there may be more as there are more parts currently
-- tuned for the UAntwerp configuration
--

-- Prefixes for environment variables
local site = 'LUMI' -- Site-specific prefix for the environment variable names set in the software stack modules.
local ebu =  'EBU'  -- Site-specific prefix for the environment variable names that are likely set either in the system profile or user profile.

-- User configuration
-- local user_prefix = ( os.getenv( ebu .. '_USER_PREFIX' ) or pathJoin( os.getenv( 'HOME' ), '/EasyBuild' ) )
local user_prefix = get_user_prefix_EasyBuild()
-- System software and module install root, extract from the module path.
local system_prefix = myFileName():match( '(.*)/modules/Infrastructure/.*' )
-- System configuration: Derive from LMOD_PACKAGE_PATH
-- The gsub that we use works with and without end trailing slash in the value of LMOD_PACKAGE_PATH.
local LMOD_root = os.getenv( 'LMOD_PACKAGE_PATH' )
if LMOD_root == nil then
    LmodError( 'Failed to get the value of LMOD_PACKAGE_PATH' )
end
local SystemRepo_prefix = LMOD_root:gsub( '/LMOD/*', '' )

-- -----------------------------------------------------------------------------
--
-- Constants: Architecture for optimization.
--
-- The keys of this table can also be used to test if the partition detected is
-- valid.
--

local optarch = {
    common =  'x86-rome',
    L =       'x86-rome',
    C =       'x86-milan',
    G =       'x86-milan',
    D =       'x86-rome',
    CrayEnv = 'x86-rome', -- This is really a dummy as we do not want ot use the Cray PE here.
    }

-- -----------------------------------------------------------------------------
--
-- Actual module code
--

--
-- Check if I am replacing another module.
-- If so, no message will be shown at the end. This eliminates a double message
-- as loading another module of the same family will load the module twice. The
-- first time the message will not be shown.
--
local show_message = true
if myModuleName() ~= 'EasyBuild-user'           and isloaded( 'EasyBuild-user' )           then show_message = false end
if myModuleName() ~= 'EasyBuild-production'     and isloaded( 'EasyBuild-production' )     then show_message = false end
if myModuleName() ~= 'EasyBuild-infrastructure' and isloaded( 'EasyBuild-infrastructure' ) then show_message = false end
if myModuleName() ~= 'EasyBuild-CrayEnv'        and isloaded( 'EasyBuild-CrayEnv' )        then show_message = false end

--
-- Avoid loading together with EasyBuild-production
--

family( 'EasyBuildConfig' )

--
-- Detect the mode
--
local detail_mode = myModuleName():gsub( 'EasyBuild%-', '')
local mod_mode
local mod_prefix
if detail_mode == 'user' then
    mod_mode =   'user'
    mod_prefix = 'easybuild'
elseif detail_mode == 'production' then
    mod_mode =   'system'
    mod_prefix = 'easybuild'
elseif detail_mode == 'infrastructure' then
    mod_mode =   'system'
    mod_prefix = 'Infrastructure'
elseif detail_mode == 'CrayEnv' then
    mod_mode =   'system'
    mod_prefix = 'easybuild'
else
    LmodError( 'Unrecongnized module name' )
end

-- Make sure that when in system mode, the unlock module is loaded.
if mode() == 'load' and mod_mode == 'system' and not isloaded( 'EasyBuild-unlock' ) then
    LmodError( 'This module requires EasyBuild-unlock to be loaded first as an additional precaution to avoid damaging the system installation.' )
end

-- Produce an error message when loading in user mode and user_prefix == '' which implies that
-- EBU_USER_PREFIX was set but empty. This value of EBU_USER_PREFIX can be used if we really
-- do not want a user installation, also not the default one.
-- Also make sure that user prefix is some kind of absolute path, starting either with a slash or with
-- a ~, though we don't do a full test for a valid directory. Relative directories should not be
-- used as this may lead to installing in the wrong directories.
if mode() == 'load' and mod_mode == 'user' then
    if user_prefix == nil then
        LmodError( 'User installation is impossible as it was explicitly turned off by means of EBU_USER_PREFIX.' )
    elseif user_prefix:match('^[~/]') == nil then
        LmodError( 'Detected an invalid user installation directory. When using EBU_PREFIX_USER, an absolute path should be used.' )
    end
end

-- Make sure EasyBuild is loaded when in user mode. In any of the system modes
-- we assume the user is clever enough and want to support using an eb version
-- which is not in the module tree, e.g., to bootstrap.
if not isloaded( 'EasyBuild' ) then
    if mod_mode == 'system' then
        try_load( 'EasyBuild' )
    else
        load( 'EasyBuild' )
    end
end


--
-- Compute the configuration
--

-- - The software stack and partition is determined from the location of the module in the
--   module tree and not from the environment variables set in the software stack and partition
--   modules as the latter may lead to errors if these variables would be used to compute values
--   for prepend_path etc.

local stack_name
local stack_version
local lumi_stack_version
local partition_name

stack_version, partition_name = myFileName():match( '/LUMI/([^/]+)/partition/([^/]+)/' )

if stack_version ~= nil then
    stack_name = 'LUMI'
else
    LmodError( 'Failed to determine the software stack version. It could be that this module does not support this stack.' )
end
if optarch[partition_name] == nil then
    LmodError( 'Detected partition ' .. partition_name .. ' but have no entry for it in optarch, so something is seriously wrong.' )
end

lumi_stack_version = stack_version

-- For CrayEnv, we overwrite the stack_name etc. for installation,
-- but we had to preserve the version of the LUMI stack to find the right
-- hooks file.
if detail_mode == 'CrayEnv' then

    stack_name =     'CrayEnv'
    stack_version =  ''
    partition_name = 'common'

end

-- - Prepare some additional variables to reduce the length of some lines

local stack =                 stack_version == ''  and stack_name or stack_name  .. '-' .. stack_version
local partition =             'LUMI-' .. partition_name
local common_partition_name = 'common'
local common_partition =      'LUMI-' .. common_partition_name
local CPE_version =           lumi_stack_version:gsub( '.dev', '' )  -- Drop .dev from the stack version to get the version of the CPE.

-- - Find a suitable directory to create some temporary build space for EasyBuild
--   We set the work directory based on where we are running, not based on for which partition
--   we are compiling.

local workdir
if ( get_hostname():find( 'uan' ) ) then

    -- We are running on the login nodes so we can use XDG_RUNTIME_DIR
    -- which is cleaned automatically at the end of the session

    workdir = os.getenv( 'XDG_RUNTIME_DIR' )

else

    -- Not a login node, so it must be a compute node.

    local jobid = os.getenv( 'SLURM_JOB_ID' )
    local user =  os.getenv( 'USER' )

    if jobid ~= nil then

        -- Running in a Slurm job, use that to build a file name
        workdir = pathJoin( '/dev/shm', jobid )

    else

        -- This may happen in the future if there would be non-jobcontrolled interactive
        -- sessions on other parts of the system?
        workdir = pathJoin( '/dev/shm', user )

    end

end

-- - Compute the location of certain directories and files

--    + Some easy ones that do not depend the software stack itself

local system_configdir =           pathJoin( SystemRepo_prefix, 'easybuild/config' )
local system_easyconfigdir =       pathJoin( SystemRepo_prefix, 'easybuild/easyconfigs' )
local system_easyblockdir =        pathJoin( SystemRepo_prefix, 'easybuild/easyblocks' )
local system_toolchaindir =        pathJoin( SystemRepo_prefix, 'easybuild/toolchains' )
local system_hookdir =             pathJoin( SystemRepo_prefix, 'easybuild/hooks' )
local system_installpath =         system_prefix

local user_configdir =             pathJoin( user_prefix, 'UserRepo', 'easybuild/config' )
local user_easyconfigdir =         pathJoin( user_prefix, 'UserRepo', 'easybuild/easyconfigs' )
local user_easyblockdir =          pathJoin( user_prefix, 'UserRepo', 'easybuild/easyblocks' )
local user_installpath =           user_prefix

local configdir =     mod_mode == 'user' and user_configdir     or system_configdir
local easyconfigdir = mod_mode == 'user' and user_easyconfigdir or system_easyconfigdir
local easyblockdir =  mod_mode == 'user' and user_easyblockdir  or system_easyblockdir
local installpath =   mod_mode == 'user' and user_installpath   or system_installpath

local system_sourcepath =          pathJoin( system_prefix, 'sources/easybuild' )
local system_containerpath =       pathJoin( system_prefix, 'containers' )
local system_packagepath =         pathJoin( system_prefix, 'packages' )

local user_sourcepath =            pathJoin( user_prefix,    'sources' )
local user_containerpath =         pathJoin( user_prefix,    'containers' )
local user_packagepath =           pathJoin( user_prefix,    'packages' )

local containerpath = mod_mode == 'user' and user_containerpath or system_containerpath
local packagepath =   mod_mode == 'user' and user_packagepath   or system_packagepath

local module_naming_scheme_dir =   pathJoin( SystemRepo_prefix, 'easybuild/tools/module_naming_scheme/*.py' )

local buildpath =                  pathJoin( workdir, 'easybuild', 'build' )
local tmpdir =                     pathJoin( workdir, 'easybuild', 'tmp' )

--    + Directories that depend on the software stack
--                                                            Root                       Stack                  Partition                    Suffix

local system_installpath_software =  pathJoin( system_prefix, 'SW',                      stack,                 partition_name,              'EB' )
local system_installpath_modules =   pathJoin( system_prefix, 'modules', mod_prefix,     'LUMI', stack_version, 'partition', partition_name )
local system_repositorypath =        pathJoin( system_prefix, 'mgmt',    'ebrepo_files', stack,                partition )

local user_installpath_software =    pathJoin( user_prefix,   'SW',                      stack,                 partition_name )
local user_installpath_modules =     pathJoin( user_prefix,   'modules',                 'LUMI', stack_version, 'partition', partition_name )
local user_repositorypath =          pathJoin( user_prefix,   'ebrepo_files',            stack,                 partition )

local CrayEnv_installpath_software = pathJoin( system_prefix, 'SW',                      stack,                                              'EB' )
local CrayEnv_installpath_modules =  pathJoin( system_prefix, 'modules', mod_prefix,     'CrayEnv' )
local CrayEnv_repositorypath =       pathJoin( system_prefix, 'mgmt',    'ebrepo_files', stack )

local installpath_software = mod_mode == 'user' and user_installpath_software or system_installpath_software
local installpath_modules =  mod_mode == 'user' and user_installpath_modules  or system_installpath_modules
local repositorypath =       mod_mode == 'user' and user_repositorypath       or system_repositorypath

local installpath_software, installpath_modules, repositorypath
if mod_mode == 'user' then
    installpath_software = user_installpath_software
    installpath_modules  = user_installpath_modules
    repositorypath       = user_repositorypath
elseif detail_mode == 'CrayEnv' then
    installpath_software = CrayEnv_installpath_software
    installpath_modules  = CrayEnv_installpath_modules
    repositorypath       = CrayEnv_repositorypath
else
    installpath_software = system_installpath_software
    installpath_modules  = system_installpath_modules
    repositorypath       = system_repositorypath
end

--    + The relevant config files

local system_configfile_generic = pathJoin( system_configdir, 'easybuild-production.cfg' )
local system_configfile_stack =   pathJoin( system_configdir, 'easybuild-production-' .. stack .. '.cfg' )

local user_configfile_generic =   pathJoin( user_configdir,   'easybuild-user.cfg' )
local user_configfile_stack =     pathJoin( user_configdir,   'easybuild-user-' .. stack .. '.cfg' )

local system_external_modules =   pathJoin( system_configdir, 'external_modules_metadata-CPE-' .. CPE_version .. '.cfg' )

-- - Settings for the module naming scheme

local module_naming_scheme =     'LUMI_FlatMNS'
local suffix_modules_path =       ''

-- - Settings for the custom EasyBlocks

local easyblocks = { pathJoin( system_easyblockdir, '*/*.py' ) }
if mod_mode == 'user' then
    table.insert( easyblocks, pathJoin( user_easyblockdir, '*/*.py' ) )
end

-- - Settings for the custom toolchains

local toolchains = {
    pathJoin( system_toolchaindir, '*.py' ),
    pathJoin( system_toolchaindir, 'compiler', '*.py' )
}

-- - Settings for the hooks

local hooks = get_versionedfile( lumi_stack_version, system_hookdir, 'LUMI_site_hooks-', '.py' )
if hooks == nil then
    LmodWarning( 'Failed to determine the hooks file, so running EasyBuild without using hooks.' )
end
-- LmodMessage( 'Identified hooks file ' .. hooks )

-- - Build the source paths

local source_paths = {}

--   + In usermode: The user source path comes first as that is where we want to write.
if mod_mode == 'user' then
    table.insert( source_paths, user_sourcepath )
end

--   + The system source path is always included so that user installations that make small modifications
--     to a config don't need to download again
table.insert( source_paths, system_sourcepath )

-- - Build the robot path ROBOT_PATHS

local robot_paths = {}

--   + Always included in usermode: the current directory so that we can even just give the user
--     a couple of EasyConfig files that they put in a directory and run with eb -r.
if mod_mode == 'user' then
    table.insert( robot_paths, '.' )
end

--   + Always included in usermode: the user repository for the software stack
if mod_mode == 'user' then
    table.insert( robot_paths, user_repositorypath )
end

--   + If the partition is not the common one, we need to add that user repository
--     directory also.
if mod_mode == 'user' and partition_name ~=  'common' then
    table.insert( robot_paths, pathJoin( user_prefix, 'ebrepo_files', stack, common_partition ) )
end

--   + Always included: the system repository for the software stack, but be careful
--     for CrayEnv as that has a different structure.
if detail_mode == 'CrayEnv' then
    table.insert( robot_paths, CrayEnv_repositorypath )
else
    table.insert( robot_paths, system_repositorypath )
end

--   + If the partition is not the common one, we need to add that repository
--     directory also.
if partition_name ~=  'common' then
    table.insert( robot_paths, pathJoin( system_prefix, 'mgmt', 'ebrepo_files', stack, common_partition ) )
end

--   + Now add the user easyconfig directory
if mod_mode == 'user' then
    table.insert( robot_paths, user_easyconfigdir )
end

--   + And at the end, we include the system easyconfig directory.
table.insert( robot_paths, system_easyconfigdir )

-- - List of directories for eb -S

local search_paths = {}

--   + Our user EasyConfig repository in user mode

if mod_mode == 'user' then
    table.insert( search_paths, user_easyconfigdir )
end

--   + Always include our system EasyConfig repository

table.insert( search_paths, system_easyconfigdir )

--   + Include LUMI-EasyBuild-contrib if we can find and are in user mode
--     These EasyConfigs are not meant to be used in production mode, but this
--     is only a search and they may be the starting basis for new production
--     recipes.

local system_easybuild_contrib = pathJoin( system_prefix, 'LUMI-EasyBuild-contrib/easybuild/easyconfigs' )
local user_easybuild_contrib =   pathJoin( user_prefix,   'LUMI-EasyBuild-contrib/easybuild/easyconfigs' )

--     - First look in the user directory if we are in user mode
if mod_mode == 'user' and isDir( user_easybuild_contrib ) then

    table.insert( search_paths, user_easybuild_contrib )

--     - Then look in the system directory.
elseif isDir( system_easybuild_contrib ) then

    table.insert( search_paths, system_easybuild_contrib )

end

--   + Possible future option: Include the CSCS repository

--   + EasyBuild default config files if we can find it (through EBROOTEASYBUILD that is)
local ebroot_easybuild = os.getenv( 'EBROOTEASYBUILD' )
if ebroot_easybuild ~= nil then
    table.insert( search_paths, pathJoin( ebroot_easybuild, 'easybuild/easyconfigs' ) )
end

-- - List of config files. Later in the list overwrites settings by files earlier in the list.
local configfiles = {}

if isFile( system_configfile_generic )                      then table.insert( configfiles, system_configfile_generic ) end
if mod_mode == 'user' and isFile( user_configfile_generic ) then table.insert( configfiles, user_configfile_generic )   end
if isFile( system_configfile_stack )                        then table.insert( configfiles, system_configfile_stack )   end
if mod_mode == 'user' and isFile( user_configfile_stack )   then table.insert( configfiles, user_configfile_stack )     end

--
-- Set the EasyBuild variables that point to paths or files
--

-- - Single component paths

setenv( 'EASYBUILD_PREFIX',                        ( mod_mode == 'user' and user_prefix or system_prefix ) )
setenv( 'EASYBUILD_SOURCEPATH',                    table.concat( source_paths, ':' ) )
setenv( 'EASYBUILD_CONTAINERPATH',                 containerpath )
setenv( 'EASYBUILD_PACKAGEPATH',                   packagepath )
setenv( 'EASYBUILD_INSTALLPATH',                   installpath )
setenv( 'EASYBUILD_INSTALLPATH_SOFTWARE',          installpath_software )
setenv( 'EASYBUILD_INSTALLPATH_MODULES',           installpath_modules )

setenv( 'EASYBUILD_REPOSITORY',                    'FileRepository' )
setenv( 'EASYBUILD_REPOSITORYPATH',                repositorypath )

setenv( 'EASYBUILD_BUILDPATH',                     buildpath )
setenv( 'EASYBUILD_TMPDIR',                        tmpdir )

-- - Path variables
setenv( 'EASYBUILD_ROBOT_PATHS',                   table.concat( robot_paths, ':' ) )
setenv( 'EASYBUILD_SEARCH_PATHS',                  table.concat( search_paths, ':' ) )

-- - List of configfiles
if #configfiles > 0 then
    setenv( 'EASYBUILD_CONFIGFILES',               table.concat( configfiles, ',' ) )
end
setenv ( 'EASYBUILD_EXTERNAL_MODULES_METADATA',    system_external_modules )

-- - Custom EasyBlocks
setenv( 'EASYBUILD_INCLUDE_EASYBLOCKS',            table.concat( easyblocks, ',' ) )

-- - Custom toolchains
setenv( 'EASYBUILD_INCLUDE_TOOLCHAINS',            table.concat( toolchains, ',' ) )

-- - Hooks
if hooks ~= nil then
    setenv( 'EASYBUILD_HOOKS',                     hooks )
end

-- - Naming scheme
setenv( 'EASYBUILD_INCLUDE_MODULE_NAMING_SCHEMES', module_naming_scheme_dir )
setenv( 'EASYBUILD_MODULE_NAMING_SCHEME',          module_naming_scheme )
setenv( 'EASYBUILD_SUFFIX_MODULES_PATH',           suffix_modules_path )

--
-- Other EasyBuild settings that do not depend on paths
--

-- Let's all use python3 for EasyBuild, but this assumes at least EasyBuild version 4.
setenv( 'EB_PYTHON', 'python3' )

-- Set optarch.
setenv( 'EASYBUILD_OPTARCH', optarch[partition_name] )

-- Set LUMI_EASYBUILD_MODE to be used in hooks to only execute certain hooks in production mode.
setenv( 'LUMI_EASYBUILD_MODE', myModuleName():gsub( 'EasyBuild%-', '' ) )

--
-- Add the tools to the search path for executables
--
prepend_path( 'PATH', pathJoin( SystemRepo_prefix, 'tools' ) )


-- -----------------------------------------------------------------------------
--
-- Define a bash function to clear temporary files.
--

local bash_clear_eb = '/bin/rm -r ' .. pathJoin( workdir, 'easybuild' ) .. '; ' ..
                      '[ $(/bin/ls -A ' .. workdir .. ') ] || /bin/rm -r ' .. workdir
local csh_clear_eb =  '/bin/rm -r ' .. pathJoin( workdir, 'easybuild' ) .. '; ' ..
                      'find ' .. workdir .. ' -empty -exec \'{}\' \\; >& /dev/null'
set_shell_function( 'clear-eb', bash_clear_eb, csh_clear_eb )


-- -----------------------------------------------------------------------------
--
-- Create the user directory structure (in user mode only)
--
-- This isn't really needed as EasyBuild will create those that it needs on the
-- fly, but it does help to suggest to users right away where which files will
-- land.
--

if ( mode() == 'load' or mode() == 'show' ) and mod_mode == 'user' then

  if not isDir( user_repositorypath )       then execute{ cmd='/usr/bin/mkdir -p ' .. user_repositorypath,       modeA={'load'} } end
  if not isDir( user_sourcepath )           then execute{ cmd='/usr/bin/mkdir -p ' .. user_sourcepath,           modeA={'load'} } end
  if not isDir( user_easyconfigdir )        then execute{ cmd='/usr/bin/mkdir -p ' .. user_easyconfigdir,        modeA={'load'} } end
  if not isDir( user_easyblockdir )         then
      execute{ cmd='/usr/bin/mkdir -p ' .. user_easyblockdir, modeA={'load'} }
      -- Need to copy a dummy file here or eb --show-config will complain.
      execute{ cmd='/usr/bin/cp -r ' .. pathJoin( system_easyblockdir, '00') .. ' ' .. user_easyblockdir, modeA={'load'} }
  end
  if not isDir( user_configdir )            then execute{ cmd='/usr/bin/mkdir -p ' .. user_configdir,            modeA={'load'} } end
  if not isDir( user_installpath_software ) then execute{ cmd='/usr/bin/mkdir -p ' .. user_installpath_software, modeA={'load'} } end
  if not isDir( user_installpath_modules )  then
    execute{ cmd='/usr/bin/mkdir -p ' .. user_installpath_modules,  modeA={'load'} }
    -- We've just created the directory so it was not yet in the MODULEPATH.
    -- Add it and leave it to the software stack module which will find it when
    -- it does an unload to remove the directory from the MODULEPATH.
    prepend_path( 'MODULEPATH', user_installpath_modules )
  end

end

-- -----------------------------------------------------------------------------
--
-- Make an adaptive help block: If the module is loaded, different information
-- will be shown.
--

if detail_mode == 'user' then
    whatis( 'Prepares EasyBuild for installation in a user or project directory.' )
elseif detail_mode == 'production' then
    whatis( 'Prepares EasyBuild for production installation in the system directories. Appropriate rights required.' )
elseif detail_mode == 'infrastructure' then
    whatis( 'Prepares EasyBuild for production installation in the system infrastructure directories. Appropriate rights required.' )
elseif detail_mode == 'CrayEnv' then
    whatis( 'Prepares EasyBuild for production cross-installation in the CrayEnv directories. Appropriate rights required.' )
else
    LmodError( 'Unrecongnized module name' )
end

if detail_mode == 'user' then

help( [[
Description
===========
The EasyBuild-user module configures EasyBuild through environment variables
for installation of software in a user directory.

The module works together with the software stack modules. Hence it is needed to first
load an appropriate software stack and only then load EasyBuild-user. After changing
the software stack it is needed to re-load this module (if it is not done automatically).

After loading the module, it is possible to simply use the eb command without further
need for long command line arguments to specify the configuration.

The module assumes the following environment variables:
  * EBU_USER_PREFIX: Prefix for the EasyBuild user installation. The default
    is $HOME/EasyBuild.

The following user-specific directories and files are used by this module:
  * Directory for user EasyConfig files:      ]] .. user_easyconfigdir .. '\n' .. [[
  * EasyBuild user configuration files:       ]] .. user_configdir .. '\n' .. [[
     - Generic config file:                   ]] .. user_configfile_generic .. '\n' .. [[
     - Software stack-specific config file:   ]] .. user_configfile_stack .. '\n' .. [[

The following system directories and files are used (if present):
  * Custom module naming schemes:             ]] .. module_naming_scheme_dir .. '\n' .. [[
    Using module naming scheme:               ]] .. module_naming_scheme .. '\n' .. [[
    with suffix-module-path:                  ]] .. '\'' .. suffix_modules_path .. '\'\n' .. [[
  * EasyBuild configuration files:            ]] .. system_configdir .. '\n' .. [[
     - Generic config file:                   ]] .. system_configfile_generic .. '\n' .. [[
     - Software stack-specific config file:   ]] .. system_configfile_stack .. '\n' .. [[
     - external modules definition:           ]] .. system_external_modules .. '\n' .. [[
  * Directory of system EasyConfig files:     ]] .. system_easyconfigdir .. '\n' .. [[
  * Repository of installed EasyConfigs:      ]] .. system_repositorypath .. '\n' .. [[

Based on this information, the following settings are used:
  * Software installation directory:          ]] .. installpath_software .. '\n' .. [[
  * Module files installation directory:      ]] .. installpath_modules .. '\n' .. [[
  * Repository of installed EasyConfigs       ]] .. repositorypath .. '\n' .. [[
  * Sources of installed packages:            ]] .. table.concat( source_paths, ':' ) .. '\n' .. [[
  * Containers installed in:                  ]] .. containerpath .. '\n' .. [[
  * Packages installed in:                    ]] .. packagepath .. '\n' .. [[
  * Custom EasyBlocks:                        ]] .. table.concat( easyblocks, ',' ) .. '\n' .. [[
  * Custom module naming schemes:             ]] .. module_naming_scheme_dir .. '\n' .. [[
    Using module naming scheme:               ]] .. module_naming_scheme .. '\n' .. [[
    with suffix-module-path:                  ]] .. '\'' .. suffix_modules_path .. '\'\n' .. [[
  * Robot search path:                        ]] .. table.concat( robot_paths, ':' ) .. '\n' .. [[
  * Search path for eb -S/--search:           ]] .. table.concat( search_paths, ':' ) .. '\n' .. [[
  * Builds are performed in:                  ]] .. buildpath .. '\n' .. [[
  * EasyBuild temporary files in:             ]] .. tmpdir .. '\n' .. [[

If multiple configuration files are given, they are read in the following order:
  1. System generic configuration file
  2. User generic configuration file
  3. System stack-specific configuration file
  4. User stack-specific configuration file
Options that are redefined overwrite the old value. However, environment variables set by
this module do take precedence over the values computed from the configuration files.

To check the actual configuration used by EasyBuild, run ``eb --show-config``. This is
also a good syntax check for the configuration files.

First use for a software stack
==============================
The module will also take care of creating most of the subdirectories that it
sets, even though EasyBuild would do so anyway when you use it. It does however
give you a clear picture of the directory structure just after loading the
module, and it also ensures that the software stack modules can add your user
modules to the front of the module search path.
]] )

else -- Help text for system mode

-- Help system mode: Title
local helptext = [[
Description
===========
]]

if detail_mode == 'production' then

-- Help system mode: First block for EasyBuild-production
helptext = helptext .. [[
The EasyBuild-production module configures EasyBuild through environment variables
for installation of software in the system directories. Appropriate rights are required
for a successful install.

The module works together with the software stack modules. Hence it is needed to first
load an appropriate software stack and only then load EasyBuild-production. After changing
the software stack it is needed to re-load this module (if it is not done automatically).

After loading the module, it is possible to simply use the eb command without further
need for long command line arguments to specify the configuration.

]]

else

-- First block for EasyBuild-infrastructure
helptext = helptext .. [[
The EasyBuild-infrastructure module configures EasyBuild through environment variables
for installation of software in the system infrastructure directories. Appropriate rights
are required for a successful install.

The module works together with the software stack modules. Hence it is needed to first
load an appropriate software stack and only then load EasyBuild-infrastructure. After changing
the software stack it is needed to re-load this module (if it is not done automatically).

It should only be used to install the Cray cpe* toolchains, EasyBuild configuration
modules (if they would be ported to EasyBuild), etc. as the Infrastructure
module tree should only be used for modules that need to be available for all
4 LUMI partitions and the hidden common pseudo-partition, where the modules in
common should not be visible or available in the other partitions, i.e., a
number of modules that are needed to make a hierarchy work and to reload
correctly when switching modules.

The EasyBuild configuration generated by this module is exactly the same
as the one generated by EasyBuild-production except for the location where
the modules are stored.

After loading the module, it is possible to simply use the eb command without further
need for long command line arguments to specify the configuration.

]]

end -- Of adding the first block of the help text in system mode

-- Help system mode: Middle block of the help text
helptext = helptext .. [[
The following directories and files are used by this module:

  * Directory for EasyConfig files:           ]] .. system_easyconfigdir .. '\n' .. [[
  * Software installed in:                    ]] .. system_installpath_software .. '\n' .. [[
  * Module files installed in:                ]] .. system_installpath_modules .. '\n' .. [[
  * Repository of installed EasyConfigs:      ]] .. system_repositorypath .. '\n' .. [[
  * Sources of installed packages:            ]] .. system_sourcepath .. '\n' .. [[
  * Containers installed in:                  ]] .. system_containerpath .. '\n' .. [[
  * Packages installed in:                    ]] .. system_packagepath .. '\n' .. [[
  * Custom EasyBlocks:                        ]] .. table.concat( easyblocks, ',' ) .. '\n' .. [[
  * Custom module naming schemes:             ]] .. module_naming_scheme_dir .. '\n' .. [[
    Using module naming scheme:               ]] .. module_naming_scheme .. '\n' .. [[
    with suffix-module-path:                  ]] .. '\'' .. suffix_modules_path .. '\'\n' .. [[
  * EasyBuild configuration files:            ]] .. system_configdir .. '\n' .. [[
     - Generic config file:                   ]] .. system_configfile_generic .. '\n' .. [[
     - Software stack-specific config file:   ]] .. system_configfile_stack .. '\n' .. [[
     - external modules definition:           ]] .. system_external_modules .. '\n' .. [[
  * Robot search path:                        ]] .. table.concat( robot_paths, ':' ) .. '\n' .. [[
  * Search path for eb -S/--search:           ]] .. table.concat( search_paths, ':' ) .. '\n' .. [[
  * Builds are performed in:                  ]] .. buildpath .. '\n' .. [[
  * EasyBuild temporary files in:             ]] .. tmpdir .. '\n' .. [[

If multiple configuration files are given, they are read in the following order:
  1. System generic configuration file
  2. System stack-specific configuration file
Options that are redefined overwrite the old value. However, environment variables set by
this module do take precedence over the values computed from the configuration files.

To check the actual configuration used by EasyBuild, run ``eb --show-config`` or
``eb --show-full-config``. This is also a good syntax check for the configuration files.

]]


if detail_mode == 'production' then

-- Help system mode: Final block for EasyBuild-production only
helptext = helptext .. [[
First use for a software stack
==============================
This module can actually be used when bootstrapping EasyBuild. It is possible to
do a temporary installation of EasyBuild outside the regular installation directories
and then load this module to install EasyBuild in its final location from an EasyConfig
file for EasyBuild and the temporary installation.

No directories are created or added to the MODULEPATH by this modules as modules are
installed in the directory where this module is found and as directories are created
by EasyBuild as needed.

]]

end -- End of adding final block to the help text

help( helptext )

end -- Of the help block

-- -----------------------------------------------------------------------------
--
-- Print an informative message so that the user knows that EasyBuild is
-- configured properly.
--

if mode() == 'load' and show_message then

    local stack_message
    if detail_mode == 'CrayEnv' then
        stack_message = '\nEasyBuild configured to install software'
    elseif partition_name == common then
        stack_message = '\nEasyBuild configured to install software from the ' ..
            stack_name .. '/'.. stack_version ..
            ' software stack common to all partitions'
    else
        stack_message = '\nEasyBuild configured to install software from the ' ..
            stack_name .. '/'.. stack_version ..
            ' software stack for the LUMI/' .. partition_name .. ' partition'
    end

    if detail_mode == 'user' then
        stack_message = stack_message ..
            ' in the user tree at ' .. user_prefix .. '.\n'
    elseif detail_mode == 'production' then
        stack_message = stack_message ..
            ' in the system application directories.\n'
    elseif detail_mode == 'infrastructure' then
        stack_message = stack_message ..
            ' in the system infrastructure directories.\n'
    elseif detail_mode == 'CrayEnv' then
        stack_message = stack_message ..
            ' in the CrayEnv directories.\n'
    else
        LmodError( 'Unrecongnized module name' )
    end

    -- Unfortunately it looks like LmodMessage reformats the string and deletes the spaces?
    stack_message = stack_message ..
        '  * Software installation directory:    ' .. installpath_software             .. '\n' ..
        '  * Modules installation directory:     ' .. installpath_modules              .. '\n' ..
        '  * Repository:                         ' .. repositorypath                   .. '\n' ..
        '  * Work directory for builds and logs: ' .. pathJoin( workdir, 'easybuild' ) .. '\n' ..
        '    Clear work directory with clear-eb\n'

    LmodMessage( stack_message )

    --
    -- Check if we are installing in /appl/lumi and print an extra warning.
    --
    if myFileName():match('^/appl/lumi/') ~= nil then
        LmodMessage( '*** WARNING: YOU RISK DAMAGING THE CENTRAL SOFTWARE INSTALLATION IN /appl, BE CAREFUL! ***\n\n' )
    end


end

-- Some information for debugging

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Exiting' )
end
