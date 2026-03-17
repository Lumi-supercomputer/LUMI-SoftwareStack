-- A module to make the LAIF modules available on LUMI, but without
-- making them findable for the module spider command if the module
-- is not loaded to avoid interfering with the LUST software stack.

-- We make the module sticky just as other stacks, but do not unload
-- other stacks as the LAIF stack also depends on the PRoot command.
-- family( 'LUMI_SoftwareStack' )
add_property("lmod","sticky")

whatis( 'Description: Makes the LUMI AI Factory modules available, see https://docs.lumi-supercomputer.eu/laif/software/ai-environment/' )

help( [[

Description
===========
This module makes modules available provided by the LUMI AI Factory to ease
the use of the containers they provide.

There is no guarantee that any module provided by them works together well 
with other modules provided by the CrayEnv, LUMI or spack software stacks on 
LUMI, though those modules will not be automatically unloaded. Try the 
combination at your own risk..

The LUMI User Support Team (LUST) is not managing the software made available by
this module, nor can LUST make any changes or corrections. All support requests 
will be forwarded LUST to the LUMI AI Factory and handled at their discretion. 
Though they are committed to supporting their software collection, the level of 
support may depend on how your project came onto LUMI as their focus is in the 
first place on AI Factory customers.

The software provided by this module is not discoverable with module spider
unless this module is loaded or ModuleFullSpider/on is loaded.


More information
================
 - Overview: https://docs.lumi-supercomputer.eu/laif/software/ai-environment/
 - Site contact: Help requests for the software made available by this module 
   will be forwarded by LUST to the LUMI AI Factory. Please specify in your 
   request that you are using containers provided by the LUMI AI Factory so 
   that we can make sure that you are helped promptly.

]] )

--
-- Only make the MODULEPATH change visible to LMOD when loading, unloading or 
-- showing a module to avoid interfering with, e.g., module spider.
-- With the exception that it can always be make visible to LMOD if 
-- specifically requested through criteria coded in SitePackage.lua.
--

if mode() == 'load' or mode() == 'unload' or mode() == 'show' or is_full_spider() then
    prepend_path( 'MODULEPATH', '/appl/local/laifs/modules' )
end

--
-- Print a message.
--

if mode() == 'load' then
    LmodMessage( 'This software collection is provided and supported by the LUMI AI Factory.\n' ..
                 'Run `module help ' .. myModuleName() .. '` for more information about support.\n' ..
                 'Not all software may be compatible with software in other stacks,\n' ..
                 'so mix at your own risk.' )
end
