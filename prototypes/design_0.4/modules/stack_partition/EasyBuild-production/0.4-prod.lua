if os.getenv( '_LUMI_LMOD_DEBUG' ) ~= nil then
    LmodMessage( 'DEBUG: ' .. mode() .. ' ' .. myFileName() .. ': Entering' )
end

--
-- Some site configuration, but there may be more as there are more parts currently
-- tuned for the UAntwerp configuration
--

-- System software and module install root
local install_prefix = myFileName():match( '(.*)/modules/easybuild..*' )
-- System configuration
local system_prefix = pathJoin( install_prefix, 'github/easybuild' )

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

whatis( 'Prepares EasyBuild for production installation in the system directories. Appropirate rights required.' )

--
-- Avoid loading together with EasyBuild-production
--

family( 'EasyBuildConfig' )

-- Make sure EasyBuild is loaded.
-- We don't care which version is loaded but will load the default one ourselves.
if not isloaded( 'EasyBuild' ) then
    try_load( 'EasyBuild' )
    if not isloaded( 'EasyBuild' ) then
        LmodMessage( 'Warning: No EasyBuild module loaded, but this module will produce a valid configuration for an eb command provided in another way.' )
    end
end

--
-- Compute the configuration
--

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
local stack =            stack_name  .. '-' .. stack_version
local partition =        'LUMI-' .. partition_name
local common_partition = 'LUMI-common'

-- - Compute a number of system-related paths and file names.
--   Some of those should align with the EasyBuild-production module!

--    + Some easy ones that do not depend the software stack itself
local system_sourcepath =               pathJoin( install_prefix, 'sources' )
local system_containerpath =            pathJoin( install_prefix, 'containers' )
local system_packagepath =              pathJoin( install_prefix, 'packages' )
local system_configdir =                pathJoin( system_prefix,  'config' )
local system_easyconfigdir =            pathJoin( system_prefix,  'easyconfigs' )
local system_buildpath =                pathJoin( os.getenv( 'XDG_RUNTIME_DIR' ), 'easybuild', 'build' )
local system_tmpdir =                   pathJoin( os.getenv( 'XDG_RUNTIME_DIR' ), 'easybuild', 'tmp' )
local system_installpath =              install_prefix

local system_module_naming_scheme_dir = pathJoin( system_prefix, 'tools/module_naming_scheme/*.py' )
local system_module_naming_scheme =     'LUMI_FlatMNS'
local system_suffix_modules_path =       ''

local system_easyblocks =               pathJoin( system_prefix, 'easyblocks/*/*.py' )

--    + Directories that depend on the software stack
local system_installpath_software = pathJoin( install_prefix, 'software',             stack,                 partition,                 'easybuild' )
local system_installpath_modules =  pathJoin( install_prefix, 'modules', 'easybuild', 'LUMI', stack_version, 'partition', partition_name )
local system_repositorypath =       pathJoin( install_prefix, 'mgmt', 'ebrepo_files',  stack,                partition )

-- - The relevant config files
local system_configfile_generic = pathJoin( system_configdir, 'easybuild-production.cfg' )
local system_configfile_stack =   pathJoin( system_configdir, 'easybuild-production-' .. stack .. '.cfg' )

local system_external_modules =   pathJoin( system_configdir, 'external_modules_metadata-' .. stack .. '.cfg' )

-- - ROBOT_PATHS

--   + Always included: the system repository for the software stack
local robot_paths = {system_repositorypath}

--   + If the partition is not the common one, we need to add that repository
--     directory also.
if partition_name ~=  'common' then
    table.insert( robot_paths, pathJoin( install_prefix, 'mgmt', 'ebrepo_files', stack, common_partition ) )
end

--   + And at the end, we include the system easyconfig directory.
table.insert( robot_paths, system_easyconfigdir )

-- - List of directories for eb -S

--   + Our own EasyConfig repository

local search_paths = { system_easyconfigdir }

--   + Possible future option: Include the CSCS repository

--   + EasyBuild default config files if EasyBuild is loaded
if isloaded( 'EasyBuild' ) then
    local ebroot_easybuild = os.getenv( 'EBROOTEASYBUILD' )
    if ebroot_easybuild == nil then
        LmodError( 'Error: Detected that EasyBuild is loaded but failed to locate it. This points to an error in the modules.' )
    end
    table.insert( search_paths, pathJoin( ebroot_easybuild, 'easybuild/easyconfigs' ) )
end

-- - List of config files
local configfiles = {}

if isFile( system_configfile_generic )  then table.insert( configfiles, system_configfile_generic ) end
if isFile( system_configfile_stack )    then table.insert( configfiles, system_configfile_stack )   end

--
-- Set the EasyBuild variables that point to paths or files
--

-- - Single component paths

setenv( 'EASYBUILD_PREFIX',                        system_prefix )
setenv( 'EASYBUILD_SOURCEPATH',                    system_sourcepath )
setenv( 'EASYBUILD_CONTAINERPATH',                 system_containerpath )
setenv( 'EASYBUILD_PACKAGEPATH',                   system_packagepath )
setenv( 'EASYBUILD_BUILDPATH',                     system_buildpath )
setenv( 'EASYBUILD_TMPDIR',                        system_tmpdir )
setenv( 'EASYBUILD_INSTALLPATH',                   system_installpath )
setenv( 'EASYBUILD_INSTALLPATH_SOFTWARE',          system_installpath_software )
setenv( 'EASYBUILD_INSTALLPATH_MODULES',           system_installpath_modules )
setenv( 'EASYBUILD_REPOSITORY',                    'FileRepository' )
setenv( 'EASYBUILD_REPOSITORYPATH',                system_repositorypath )

-- - Path variables
setenv( 'EASYBUILD_ROBOT_PATHS',                   table.concat( robot_paths, ':' ) )
setenv( 'EASYBUILD_SEARCH_PATHS',                  table.concat( search_paths, ':' ) )

-- - List of configfiles
if #configfiles > 0 then
    setenv( 'EASYBUILD_CONFIGFILES',               table.concat( configfiles, ',' ) )
end
setenv ( 'EASYBUILD_EXTERNAL_MODULES_METADATA',    system_external_modules )

-- - Custom EasyBlocks
setenv( 'EASYBUILD_INCLUDE_EASYBLOCKS',            system_easyblocks )

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
-- Make an adaptive help block: If the module is loaded, different information
-- will be shown.
--

help( [[
Description
===========
The EasyBuild-production module configures EasyBuild through environment variables
for installation of software in the system directories. Appropriate rights are required
for a successful install.

The module works together with the software stack modules. Hence it is needed to first
load an appropriate software stack and only then load EasyBuild-production. After changing
the software stack it is needed to re-load this module (if it is not done automatically).

After loading the module, it is possible to simply use the eb command without further
need for aliases.

The following directories and files are used by this module:

  * Directory for EasyConfig files:           ]] .. system_easyconfigdir .. '\n' .. [[
  * Software installation:                    ]] .. system_installpath_software .. '\n' .. [[
  * Module files:                             ]] .. system_installpath_modules .. '\n' .. [[
  * Custom EasyBlocks:                        ]] .. system_easyblocks .. '\n' .. [[
  * Custom module naming schemes:             ]] .. system_module_naming_scheme_dir .. '\n' .. [[
    Using module naming scheme:               ]] .. system_module_naming_scheme .. '\n' .. [[
    with suffix-module-path:                  ]] .. '\'' .. system_suffix_modules_path .. '\'\n' .. [[
  * EasyBuild configuration files:            ]] .. system_configdir .. '\n' .. [[
     - Generic config file:                   ]] .. system_configfile_generic .. '\n' .. [[
     - Software stack-specific config file:   ]] .. system_configfile_stack .. '\n' .. [[
     - external modules definition:           ]] .. system_external_modules .. '\n' .. [[
  * Sources of installed packages:            ]] .. system_sourcepath .. '\n' .. [[
  * Repository of installed EasyConfigs:      ]] .. system_repositorypath .. '\n' .. [[
  * Robot search path:                        ]] .. table.concat( robot_paths, ':' ) .. '\n' .. [[
  * Search path for eb -S/--search:           ]] .. table.concat( search_paths, ':' ) .. '\n' .. [[
  * Builds are performed in:                  ]] .. system_buildpath .. '\n' .. [[
  * EasyBuild temporary files in:             ]] .. system_buildpath .. '\n' .. [[
  * Path for containers:                      ]] .. system_containerpath .. '\n' .. [[
  * Path for packages:                        ]] .. system_packagepath .. '\n' .. [[

If multiple configuration files are given, they are read in the following order:
  1. System generic configuration file
  2. System stack-specific configuration file
Options that are redefined overwrite the old value. However, environment variables set by
this module do take precedence over the values computed from the configuration files.

To check the actual configuration used by EasyBuild, run ``eb --show-config`` or
``eb --show-full-config``. This is also a good syntax check for the configuration files.

First use for a software stack
==============================
This module can actually be used when bootstrapping EasyBuild. It is possible to
do a temporary installation of EasyBuild outside the regular installation directories
and then load this module to install EasyBuild in its final location from an EasyConfig
file for EasyBuild and the temporary installation.

No directories are created or added to the MODULEPATH by this modules as modules are
installed in the directory where this module is found and as directories are created
by EasyBuild as needed.

]] )
