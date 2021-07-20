help([==[

Description
===========
This module is the EasyBuild toolchain that uses the Cray compiler wrapper with
the gcc compiler activated. The components loaded are those of the Cray Programming
Environment (CPE) version 21.04.

Expected outcome: a LUA module that
  * Unloads the other PrgEnv-* and cpe* modules
  * Loads cpe/21.04
  * Loads PrgEnv-gnu

This module will only work correctly once LMOD immediately honours changes to
LMOD_MODULERCFILE.


More information
================
 - Homepage: https://pubs.cray.com
]==])

whatis([==[Desription: EasyBuild toolchain using the Cray compiler wrapper with gcc module (CPE release 21.04)]==])

local root = "/run/user/27155/EBtesting/software/cpeGNU/21.04-minimal-first-defaults"

conflict("cpeGNU")

unload("PrgEnv-aocc")
unload("PrgEnv-cray")
unload("PrgEnv-intel")
unload("PrgEnv-nvidia")

unload("cpeAMD")
unload("cpeCray")
unload("cpeIntel")
unload("cpeNVIDIA")

if not ( isloaded("cpe/21.04") ) then
    load("cpe/21.04")
end

if not ( isloaded("PrgEnv-gnu") ) then
    load("PrgEnv-gnu")
end

setenv("EBROOTCPEGNU", root)
setenv("EBVERSIONCPEGNU", "21.04")
setenv("EBDEVELCPEGNU", pathJoin(root, "easybuild/cpeGNU-21.04-minimal-first-defaults-easybuild-devel"))

-- Built with EasyBuild version 4.4.1
