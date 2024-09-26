-- A module to make the CSC modules available on LUMI, but without
-- making them findable for the module spider command if the module
-- is not loaded to avoid interfering with the LUST software stack.

whatis( 'Description: Makes the CSC-managed local software collection available, see https://docs.csc.fi/apps/by_system/#lumi' )

help( [[

Description
===========
This module makes a software collection available managed and supported by CSC.

There is no guarantee that this software works together with software provided
by the CrayEnv, LUMI or spack software stacks on LUMI, though those modules will
not be automatically unloaded. Try the combination at your own risk.

The LUMI User Support Team (LUST) is not managing the software made available by
this module, nor can LUST make any changes or corrections. All support requests 
will be forwarded LUST to CSC and handled at their discretion. Though they are 
committed to supporting their software collection, the level of support may depend  
on how your project came onto LUMI as they receive no EuroHPC funding for
supporting this collection.

The software provided by this module is not discoverable with module spider
unless this module is loaded or ModuleFullSpider/on is loaded.


More information
================
 - Overview: https://docs.csc.fi/apps/by_system/#lumi
 - Site contact: Help requests for the software made available by this module 
   will be forwarded by LUST to CSC. Please specify in your request that you
   are using software from the CSC software collection.

]] )

--
-- Only make the MODULEPATH change visible to LMOD when loading, unloading or 
-- showing a module to avoid interfereing with, e.g., module spider.
-- With the exception that it can always be make visible to LMOD if 
-- specifically requested through criteria coded in SitePackage.lua.
--

if mode() == 'load' or mode() == 'unload' or mode() == 'show' or is_full_spider() then
    prepend_path( 'MODULEPATH', '/appl/local/csc/modulefiles' )
end

--
-- Print a message.
--

if mode() == 'load' then
    LmodMessage( 'This software collection is provided and supported by CSC.\n' ..
                 'Run `module help ' .. myModuleName() .. '` for more information about support.' )
end
