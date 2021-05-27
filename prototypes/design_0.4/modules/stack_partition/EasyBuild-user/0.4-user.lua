if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myModuleFullName() .. ': Entering' )
end

--
-- Some site configuration, but there may be more as there are more parts currently
-- tuned for the UAntwerp configuration
--

-- User configuration
local default_user_prefix = pathJoin( os.getenv( 'HOME' ), '/EasyBuild' )
-- System software and module install root
local system_prefix = myFileName():match( '(.*)/modules/InstallConfig/.*' )
-- System configuration: Derive from the path of the module
local EB_SystemRepo_prefix = pathJoin( system_prefix, 'SystemRepo/easybuild' )

-- Prefixes for environment variables
local site = 'LUMI' -- Site-specific prefix for the environment variable names set in the software stack modules.
local ebu =  'EBU'  -- Site-specific prefix for the environment variable names that are likely set either in the system profile or user profile.

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

whatis( 'Prepares EasyBuild for installation in a user or project directory.' )

--
-- Avoid loading together with EasyBuild-production
--

family( 'EasyBuildConfig' )

-- Make sure EasyBuild is loaded.
-- We don't care which version is loaded but will load the default one ourselves.
-- Contrary to the production module, we do require EasyBuild to be loaded as we don't need
-- bootstrapping here.
if not isloaded( 'EasyBuild' ) then
    load( 'EasyBuild' )
end

--
-- Compute the configuration
--

-- - Read the location for the user installation rather than imposing a location
--   so that a user can chose to install packages in a project directory.

local user_prefix = os.getenv( ebu .. '_USER_PREFIX' )
if ( user_prefix == nil ) then user_prefix = default_user_prefix end

-- - The software stack and oartition is determined from the location of the module in the
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
    LmoddError( 'Failed to determine the software stack version. It could be that this module does not support this stack.' )
end
if optarch[partition_name] == nil then
    LmodError( 'Detected partition ' .. partition_name .. ' but have no entry for it in optarch, so something is seriously wrong.' )
end

-- - Prepare some additional variables to reduce the length of some lines

local stack =                 stack_name  .. '-' .. stack_version
local partition =             'LUMI-' .. partition_name
local common_partition_name = 'common'
local common_partition =      'LUMI-' .. common_partition_name

-- - Compute the location of certain system directories and files
--   These should align with the EasyBuild-production module!

--    + Some easy ones that do not depend the software stack itself

local system_configdir =                pathJoin( EB_SystemRepo_prefix,  'config' )
local system_easyconfigdir =            pathJoin( EB_SystemRepo_prefix,  'easyconfigs' )
local system_easyblockdir =             pathJoin( EB_SystemRepo_prefix, 'easyblocks' )

local system_module_naming_scheme_dir = pathJoin( EB_SystemRepo_prefix, 'tools/module_naming_scheme/*.py' )
local system_module_naming_scheme =     'LUMI_FlatMNS'
local system_suffix_modules_path =       ''

local system_easyblocks =               pathJoin( system_easyblockdir, '*/*.py' )

--    + Directories that depend on the software stack

local system_repositorypath =           pathJoin( system_prefix, 'mgmt', 'ebrepo_files',  stack,                partition )

--    + The relevant config files
local system_configfile_generic = pathJoin( system_configdir, 'easybuild-production.cfg' )
local system_configfile_stack =   pathJoin( system_configdir, 'easybuild-production-' .. stack .. '.cfg' )

local system_external_modules =   pathJoin( system_configdir, 'external_modules_metadata-' .. stack .. '.cfg' )


-- - Compute the location of certain user directories and files

--    + Some easy ones that do not depend the software stack itself

local user_sourcepath =            pathJoin( user_prefix, 'sources' )
local user_containerpath =         pathJoin( user_prefix, 'containers' )
local user_packagepath =           pathJoin( user_prefix, 'packages' )
local user_configdir =             pathJoin( user_prefix, 'UserRepo', 'easybuild/config' )
local user_easyconfigdir =         pathJoin( user_prefix, 'UserRepo', 'easybuild/easyconfigs' )
local user_easyblockdir =          pathJoin( user_prefix, 'UserRepo', 'easybuild/easyblocks' )
local user_buildpath =             pathJoin( os.getenv( 'XDG_RUNTIME_DIR' ), 'easybuild', 'build' )
local user_tmpdir =                pathJoin( os.getenv( 'XDG_RUNTIME_DIR' ), 'easybuild', 'tmp' )
local user_installpath =           user_prefix

local user_easyblocks =            pathJoin( user_easyblockdir, '*/*.py' )

--    + Directories that depend on the software stack
--                                                        Root            Stack                  Partition                    Suffix

local user_installpath_software =  pathJoin( user_prefix, 'SW',           stack,                 partition_name,              'EB' )
local user_installpath_modules =   pathJoin( user_prefix, 'modules',      'LUMI', stack_version, 'partition', partition_name )
local user_repositorypath =        pathJoin( user_prefix, 'ebrepo_files', stack,                 partition )

--    + The relevant config files
local user_configfile_generic = pathJoin( user_configdir, 'easybuild-user.cfg' )
local user_configfile_stack =   pathJoin( user_configdir, 'easybuild-user-' .. stack .. '.cfg' )

-- - Build the robot path ROBOT_PATHS

--   + Always included: the user repository for the software stack
local robot_paths = {user_repositorypath}

--   + If the partition is not the common one, we need to add that user repository
--     directory also.
if partition_name ~=  'common' then
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
table.insert( robot_paths, user_easyconfigdir )

--   + And at the end, we include the system easyconfig directory.
table.insert( robot_paths, system_easyconfigdir )

-- - List of directories for eb -S

--   + Our user EasyConfig repository

local search_paths = { system_easyconfigdir }

--   + Our system EasyConfig repository

table.insert( search_paths, system_easyconfigdir )

--   + Possible future option: Include the CSCS repository

--   + EasyBuild default config files if we can find it (through EBROOTEASYBUILD that is)
local ebroot_easybuild = os.getenv( 'EBROOTEASYBUILD' )
table.insert( search_paths, pathJoin( ebroot_easybuild, 'easybuild/easyconfigs' ) )

-- - List of config files. Later in the list overwrites settings by files earlier in the list.
local configfiles = {}

if isFile( system_configfile_generic ) then table.insert( configfiles, system_configfile_generic ) end
if isFile( user_configfile_generic )   then table.insert( configfiles, user_configfile_generic )   end
if isFile( system_configfile_stack )   then table.insert( configfiles, system_configfile_stack )   end
if isFile( user_configfile_stack )     then table.insert( configfiles, user_configfile_stack )     end

--
-- Set the EasyBuild variables that point to paths or files
--

-- - Single component paths

setenv( 'EASYBUILD_PREFIX',                        user_prefix )
setenv( 'EASYBUILD_SOURCEPATH',                    user_sourcepath )
setenv( 'EASYBUILD_CONTAINERPATH',                 user_containerpath )
setenv( 'EASYBUILD_PACKAGEPATH',                   user_packagepath )
setenv( 'EASYBUILD_BUILDPATH',                     user_buildpath )
setenv( 'EASYBUILD_TMPDIR',                        user_tmpdir )
setenv( 'EASYBUILD_INSTALLPATH',                   user_installpath )
setenv( 'EASYBUILD_INSTALLPATH_SOFTWARE',          user_installpath_software )
setenv( 'EASYBUILD_INSTALLPATH_MODULES',           user_installpath_modules )
setenv( 'EASYBUILD_REPOSITORY',                    'FileRepository' )
setenv( 'EASYBUILD_REPOSITORYPATH',                user_repositorypath )

-- - Path variables
setenv( 'EASYBUILD_ROBOT_PATHS',                   table.concat( robot_paths, ':' ) )
setenv( 'EASYBUILD_SEARCH_PATHS',                  table.concat( search_paths, ':' ) )

-- - List of configfiles
if #configfiles > 0 then
    setenv( 'EASYBUILD_CONFIGFILES',               table.concat( configfiles, ',' ) )
end
setenv ( 'EASYBUILD_EXTERNAL_MODULES_METADATA',    system_external_modules )

-- - Custom EasyBlocks
setenv( 'EASYBUILD_INCLUDE_EASYBLOCKS',            system_easyblocks .. ',' .. user_easyblocks )

-- - Naming scheme
setenv( 'EASYBUILD_INCLUDE_MODULE_NAMING_SCHEMES', system_module_naming_scheme_dir )
setenv( 'EASYBUILD_MODULE_NAMING_SCHEME',          system_module_naming_scheme )
setenv( 'EASYBUILD_SUFFIX_MODULES_PATH',           system_suffix_modules_path )

--
-- Other EasyBuild settings that do not depend on paths
--

-- Let's all use python3 for EasyBuild, but this assumes at least EasyBuild version 4.
setenv( 'EB_PYTHON', 'python3' )

-- Set optarch.
setenv( 'EASYBUILD_OPTARCH', optarch[partition_name] )


-- -----------------------------------------------------------------------------
--
-- Create the directory structure
--
-- This isn't really needed as EasyBuild will create those that it needs on the
-- fly, but it does help to suggest to users right away where which files will
-- land.
--

if mode() == 'load' then

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

  * Directory for EasyConfig files:           ]] .. user_easyconfigdir .. '\n' .. [[
  * Software installation:                    ]] .. user_installpath_software .. '\n' .. [[
  * Module files:                             ]] .. user_installpath_modules .. '\n' .. [[
  * EasyBuild configuration files:            ]] .. user_configdir .. '\n' .. [[
     - Generic config file:                   ]] .. user_configfile_generic .. '\n' .. [[
     - Software stack-specific config file:   ]] .. user_configfile_stack .. '\n' .. [[
  * Sources of installed packages:            ]] .. user_sourcepath .. '\n' .. [[
  * Repository of installed EasyConfigs       ]] .. user_repositorypath .. '\n' .. [[
  * Builds are performed in:                  ]] .. user_buildpath .. '\n' .. [[
    Don\'t forget to clean if a build fails!

The following system directories and files are used (if present):
  * EasyBuild configuration files:            ]] .. system_configdir .. '\n' .. [[
     - Generic config file:                   ]] .. system_configfile_generic .. '\n' .. [[
     - Software stack-specific config file:   ]] .. system_configfile_stack .. '\n' .. [[
     - external modules definition:           ]] .. system_external_modules .. '\n' .. [[
  * Directory of EasyConfig files:            ]] .. system_easyconfigdir .. '\n' .. [[
  * Repository of installed EasyConfigs:      ]] .. system_repositorypath .. '\n' .. [[
  * Custom module naming schemes:             ]] .. system_module_naming_scheme_dir .. '\n' .. [[
    Using module naming scheme:               ]] .. system_module_naming_scheme .. '\n' .. [[
    with suffix-module-path:                  ]] .. '\'' .. system_suffix_modules_path .. '\'\n' .. [[

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

-- Some information for debugging

if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Exiting' )
end
