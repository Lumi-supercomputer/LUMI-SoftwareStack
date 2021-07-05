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
local user_prefix = ( os.getenv( ebu .. '_USER_PREFIX' ) or pathJoin( os.getenv( 'HOME' ), '/EasyBuild' ) )
-- System software and module install root, extract from the module path.
local system_prefix = myFileName():match( '(.*)/modules/Infrastructure/.*' )
-- System configuration: Derive from LMOD_PACKAGE_PATH
-- The gsub that we use works with and without end trailing slash in the value of LMOD_PACKAGE_PATH.
local LMOD_root = os.getenv( 'LMOD_PACKAGE_PATH' )
if LMOD_root == nil then
    LmodError( 'Failed to get the value of LMOD_PACKAGE_PATH' )
end
local EB_SystemRepo_prefix = pathJoin( LMOD_root:gsub( '/LMOD/*', '' ), 'easybuild' )

-- -----------------------------------------------------------------------------
--
-- Constants: Architecture for optimization.
--
-- The keys of this table can also be used to test if the partition detected is
-- valid.
--

local optarch = {
    common = 'x86-rome',
    L =      'x86-rome',
    C =      'x86-milan',
    G =      'x86-milan',
    D =      'x86-rome',
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
if myModuleName() ~= 'EasyBuild-user'           and isloaded( 'EasyBuild-user' ) then show_message = false end
if myModuleName() ~= 'EasyBuild-production'     and isloaded( 'EasyBuild-production' ) then show_message = false end
if myModuleName() ~= 'EasyBuild-infrastructure' and isloaded( 'EasyBuild-infrastructure' ) then show_message = false end

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
else
    LmodError( 'Unrecongnized module name' )
end

-- Make sure EasyBuild is loaded when in user mode. In any of the system modes
-- we assume the user is clever enough and want to support using an eb version
-- which is not in the module tree, e.g., to bootstrap.
if not isloaded( 'EasyBuild' ) then
    if detail_mode == 'production' then
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
local partition_name

local stack_version, partition_name = myFileName():match( '/LUMI/([^/]+)/partition/([^/]+)/' )

if stack_version ~= nil then
    stack_name = 'LUMI'
else
    LmodError( 'Failed to determine the software stack version. It could be that this module does not support this stack.' )
end
if optarch[partition_name] == nil then
    LmodError( 'Detected partition ' .. partition_name .. ' but have no entry for it in optarch, so something is seriously wrong.' )
end

-- - Prepare some additional variables to reduce the length of some lines

local stack =                 stack_name  .. '-' .. stack_version
local partition =             'LUMI-' .. partition_name
local common_partition_name = 'common'
local common_partition =      'LUMI-' .. common_partition_name
local CPE_version =stack_version:gsub( '.dev', '' )  -- Drop .dev from the stack version to get the version of the CPE.

-- - Compute the location of certain directories and files

--    + Some easy ones that do not depend the software stack itself

local system_configdir =           pathJoin( EB_SystemRepo_prefix, 'config' )
local system_easyconfigdir =       pathJoin( EB_SystemRepo_prefix, 'easyconfigs' )
local system_easyblockdir =        pathJoin( EB_SystemRepo_prefix, 'easyblocks' )
local system_toolchaindir =        pathJoin( EB_SystemRepo_prefix, 'toolchains' )
local system_hookdir =             pathJoin( EB_SystemRepo_prefix, 'hooks' )
local system_installpath =         system_prefix

local user_configdir =             pathJoin( user_prefix, 'UserRepo', 'easybuild/config' )
local user_easyconfigdir =         pathJoin( user_prefix, 'UserRepo', 'easybuild/easyconfigs' )
local user_easyblockdir =          pathJoin( user_prefix, 'UserRepo', 'easybuild/easyblocks' )
local user_installpath =           user_prefix

local configdir =     mod_mode == 'user' and user_configdir     or system_configdir
local easyconfigdir = mod_mode == 'user' and user_easyconfigdir or system_easyconfigdir
local easyblockdir =  mod_mode == 'user' and user_easyblockdir  or system_easyblockdir
local installpath =   mod_mode == 'user' and user_installpath   or system_installpath

local system_sourcepath =          pathJoin( system_prefix,        'sources/easybuild' )
local system_containerpath =       pathJoin( system_prefix,        'containers' )
local system_packagepath =         pathJoin( system_prefix,        'packages' )

local user_sourcepath =            pathJoin( user_prefix, 'sources' )
local user_containerpath =         pathJoin( user_prefix, 'containers' )
local user_packagepath =           pathJoin( user_prefix, 'packages' )

local sourcepath =    mod_mode == 'user' and user_sourcepath    or system_sourcepath
local containerpath = mod_mode == 'user' and user_containerpath or system_containerpath
local packagepath =   mod_mode == 'user' and user_packagepath   or system_packagepath

local module_naming_scheme_dir =   pathJoin( EB_SystemRepo_prefix, 'tools/module_naming_scheme/*.py' )

local buildpath =                  pathJoin( os.getenv( 'XDG_RUNTIME_DIR' ), 'easybuild', 'build' )
local tmpdir =                     pathJoin( os.getenv( 'XDG_RUNTIME_DIR' ), 'easybuild', 'tmp' )

--    + Directories that depend on the software stack
--                                                           Root                       Stack                  Partition                    Suffix

local system_installpath_software = pathJoin( system_prefix, 'SW',                      stack,                 partition_name,              'EB' )
local system_installpath_modules =  pathJoin( system_prefix, 'modules', mod_prefix,     'LUMI', stack_version, 'partition', partition_name )
local system_repositorypath =       pathJoin( system_prefix, 'mgmt',    'ebrepo_files', stack,                partition )

local user_installpath_software =   pathJoin( user_prefix,   'SW',                      stack,                 partition_name,              'EB' )
local user_installpath_modules =    pathJoin( user_prefix,   'modules',                 'LUMI', stack_version, 'partition', partition_name )
local user_repositorypath =         pathJoin( user_prefix,   'ebrepo_files',            stack,                 partition )

local installpath_software = mod_mode == 'user' and user_installpath_software or system_installpath_software
local installpath_modules =  mod_mode == 'user' and user_installpath_modules  or system_installpath_modules
local repositorypath =       mod_mode == 'user' and user_crepositorypath      or system_repositorypath

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

local hooks = pathJoin( system_hookdir, 'LUMI_site_hooks-21.04.py' )

-- - Build the robot path ROBOT_PATHS

local robot_paths = {}

--   + Always included in user rmode: the user repository for the software stack
if mod_mode == 'user' then
    table.insert( robot_paths, local_repositorypath )
end

--   + If the partition is not the common one, we need to add that user repository
--     directory also.
if mod_mode == 'user' and partition_name ~=  'common' then
    table.insert( robot_paths, pathJoin( user_prefix, 'ebrepo_files', stack, common_partition ) )
end

--   + Always included: the system repository for the software stack
table.insert( robot_paths, system_repositorypath )

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
setenv( 'EASYBUILD_SOURCEPATH',                    sourcepath )
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
setenv( 'EASYBUILD_HOOKS',                         hooks )

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


-- -----------------------------------------------------------------------------
--
-- Create the user directory structure (in user mode only)
--
-- This isn't really needed as EasyBuild will create those that it needs on the
-- fly, but it does help to suggest to users right away where which files will
-- land.
--

if mode() == 'load' and mod_mode == 'user' then

  if not isDir( user_repositorypath )       then execute{ cmd='mkdir -p ' .. user_repositorypath,       modeA={'load'} } end
  if not isDir( user_sourcepath )           then execute{ cmd='mkdir -p ' .. user_sourcepath,           modeA={'load'} } end
  if not isDir( user_easyconfigdir )        then execute{ cmd='mkdir -p ' .. user_easyconfigdir,        modeA={'load'} } end
  if not isDir( user_easyblockdir )         then
      execute{ cmd='mkdir -p ' .. user_easyblockdir, modeA={'load'} }
      -- Need to copy a dummy file here or eb --show-config will complain.
      execute{ cmd='cp -r ' .. pathJoin( system_easyblockdir, '00') .. ' ' .. user_easyblockdir, modeA={'load'} }
  end
  if not isDir( user_configdir )            then execute{ cmd='mkdir -p ' .. user_configdir,            modeA={'load'} } end
  if not isDir( user_installpath_software ) then execute{ cmd='mkdir -p ' .. user_installpath_software, modeA={'load'} } end
  if not isDir( user_installpath_modules )  then
    execute{ cmd='mkdir -p ' .. user_installpath_modules,  modeA={'load'} }
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
  * Sources of installed packages:            ]] .. sourcepath .. '\n' .. [[
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
    if partition_name == common then
        stack_message = '\nEasyBuild configured to install software from the ' ..
            stack_name .. '/'.. stack_version ..
            ' software stack common to all partitions'
    else
        stack_message = '\nEasyBuild configured to install software from the ' ..
            stack_name .. '/'.. stack_version ..
            ' software stack for the LUMI/' .. partition_name .. ' partition'
    end

    if detail_mode == 'user' then
        LmodMessage( stack_message ..
            ' in the user tree at ' .. user_prefix .. '.\n' )
    elseif detail_mode == 'production' then
        LmodMessage( stack_message ..
            ' in the system application directories.\n' )
    elseif detail_mode == 'infrastructure' then
        LmodMessage( stack_message ..
            ' in the system infrastructure directories.\n' )
    else
        LmodError( 'Unrecongnized module name' )
    end

end

-- Some information for debugging

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Exiting' )
end
