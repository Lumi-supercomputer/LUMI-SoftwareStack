-- A module to make the /appl/lumi/quantum modules available on LUMI, but 
-- without making them findable for the module spider command if the module
-- is not loaded to avoid interfering with the LUST software stack.

-- We make the module sticky just as other stacks, but for now do not yet
-- make it part of the LUMI_SoftwareStack family as that would cause trouble
-- if software in the Local-quantum collection would in turn try to load
-- software from the LUMI modules.
-- family( 'LUMI_SoftwareStack' )
add_property("lmod","sticky")

whatis( 'Description: Makes the local software collection managed by the quantum computing team of CSC available' )
whatis( 'Keyword: Helmi' )

help( [[
Description
===========
This module makes a software collection available managed and supported by the
quantum computing team of CSC for users experimenting on Helmi.

Note that Helmi is not a EuroHPC JU resource, but a resource for users from 
Finnish higher-education institutions and research institutes only. As some
of the software is only meant to access Helmi, not all software in this
stack is relevant for all LUMI users.

Note that the LUMI User Support Team does not handle access to Helmi nor 
can it provide any information about this. Please consult https://fiqci.fi/.

There is no guarantee that this software works together with software provided
by the CrayEnv, LUMI or spack software stacks on LUMI, though those modules will
not be automatically unloaded. Try combinations at your own risk.

The LUMI User Support Team (LUST) is not managing the software made available by
this module, nor can LUST make any changes or corrections. Support for these
packages is provided by the CSC service desk, see https://docs.csc.fi/support/contact/.
Please mention to them that you are using software for Helmi so that they can pass
on the request to the right support people.

The software provided by this module is not discoverable with module spider
unless the module is loaded or ModuleFullSpider/on is loaded.


More information
================
 - Web pages: https://docs.csc.fi/computing/quantum-computing/helmi/running-on-helmi/
 - Site contact: Help for the software made available by this module is provided
   by the CSC service desk (https://docs.csc.fi/support/contact/) and not by
   the LUMI User Support Team. Please mention to them that you are using software
   for Helmi.
   
]] )

--
-- Only make the MODULEPATH change visible to LMOD when loading, unloading or 
-- showing a module to avoid interfereing with, e.g., module spider.
-- With the exception that it can always be make visible to LMOD if 
-- specifically requested through criteria coded in SitePackage.lua.
--

if mode() == 'load' or mode() == 'unload' or mode() == 'show' or is_full_spider() then
    prepend_path( 'MODULEPATH', '/appl/local/quantum/modulefiles' )
end

--
-- Print a message.
--

if mode() == 'load' then
    LmodMessage( 'This software collection is provided and supported by Quantum Computing team of CSC.\n' ..
                 'Run `module help ' .. myModuleName() .. '` for more information about support.\n' ..
                 'Not all software may be compatible with software in other stacks,\n' ..
                 'so mix at your own risk.' )
end
