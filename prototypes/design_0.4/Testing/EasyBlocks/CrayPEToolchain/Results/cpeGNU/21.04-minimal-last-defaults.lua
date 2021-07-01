help([==[

Description
===========
This module is the EasyBuild toolchain that uses the Cray compiler wrapper with
the gcc compiler activated. The components loaded are those of the Cray Programming
Environment (CPE) version 21.04.

Expected outcome: a LUA module that
  * Unloads the other PrgEnv-* and cpe* modules
  * Loads PrgEnv-gnu
  * Loads cpe/21.04

This module will only work correctly once the ordering problem in the cpe module that
exists in version 21.04 is solved.


More information
================
 - Homepage: https://pubs.cray.com
]==])

whatis([==[Desription: EasyBuild toolchain using the Cray compiler wrapper with gcc module (CPE release 21.04)]==])

local root = "/users/klust/appltest/design_0.4/SW/LUMI-21.04/L/EB/cpeGNU/21.04-minimal-last-defaults"

conflict("cpeGNU")

unload("PrgEnv-aocc")
unload("PrgEnv-cray")
unload("PrgEnv-intel")
unload("PrgEnv-pgi")

unload("cpeAMD")
unload("cpeCray")
unload("cpeIntel")
unload("cpeNVIDIA")

if not ( isloaded("PrgEnv-gnu") ) then
    load("PrgEnv-gnu")
end

if not ( isloaded("cpe/21.04") ) then
    load("cpe/21.04")
end

setenv("EBROOTCPEGNU", root)
setenv("EBVERSIONCPEGNU", "21.04")
setenv("EBDEVELCPEGNU", pathJoin(root, "easybuild/cpeGNU-21.04-minimal-last-defaults-easybuild-devel"))

-- Built with EasyBuild version 4.4.0
