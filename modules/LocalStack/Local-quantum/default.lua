-- A module to make the /appl/lumi/quantum modules available on LUMI, but 
-- without making them findable for the module spider command if the module
-- is not loaded to avoid interfering with the LUST software stack.

whatis( 'Description: Makes the local software collection managed by the quantum computing team of CSC available' )
whatis( 'Keyword: Helmi' )

help( [[
Description
===========
This module makes a software collection available managed and supported by the
quantum computing team of CSC for users experimenting on Helmi.

Note that Helmi is not a EuroHPC JU resource, so being eligible for access to
LUMI does not mean that you are also eligible for access to Helmi. The
LUST does not handle access to Helmi not can it provide any information about
this.

There is no guarantee that this software works together with software provided
by the CrayEnv, LUMI or spack software stacks on LUMI, though those modules will
not be automatically unloaded. Try at your own risk.

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
-- Check the spider mode
--
local full_spider = os.getenv( '_LUMI_FULL_SPIDER' ) or 0

--
-- Only make the MODULEPATH change visible to LMOD when loading, unloading or 
-- showing a module to avoid interfereing with, e.g., module spider.
-- With the exception that it can always be make visible to LMOD if 
-- _LUMI_FULL_SPIDER is set to a value different than 0.
--

if mode() == 'load' or mode() == 'unload' or mode() == 'show' or tonumber(full_spider) ~= 0 then
    prepend_path( 'MODULEPATH', '/appl/local/quantum/modulefiles' )
end

--
-- Print a message.
--

if mode() == 'load' then
    LmodMessage( 'This software collection is provided and supported by Quantum Computing team of CSC.\n' ..
                 'Run `module help LocalStack/quantum` for more information about support.' )
end
