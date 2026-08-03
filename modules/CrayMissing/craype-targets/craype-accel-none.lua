--[[

    Module craype-accel-none

    LUMI consortium trick to unload any accelerator module.

]]--

-- reasons to keep module from continuing --


family("craype_accel")


-- standard Lmod functions --


help ([[

++++++++++++++++++++++++++++++++++++++++++++++++++++++++
The modulefile, ]] .. myModuleName() .. [[, removes all
other accelerator modules and is a clean way to unload
any accelerator module without knowing which one 
exactly is loaded.

This is not an official HPE Cray PE module, but a LUMI
extension made by the LUMI User Support Team.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++

]])

