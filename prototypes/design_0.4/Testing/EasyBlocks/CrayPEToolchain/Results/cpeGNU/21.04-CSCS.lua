help([==[

Description
===========
This module is the EasyBuild toolchain that uses the Cray compiler wrapper with
the gcc compiler activated. The components loaded are those of the Cray Programming
Environment (CPE) version 21.04.

The result of this example is a modulefile which:
  * Unloads all PrgEnv modules except PrgEnv-gnu
  * Loads the PrgEnv-gnu module
  * Loads the targeting modules craype-x86-rome and craype-network-ofi
  * Loads the gcc module, even though PRgEnv-gnu is already loaded, because it is
    part of the dependencies
  * Loads the craype module, even though PRgEnv-gnu is already loaded, because it is
    part of the dependencies
  * Loads the dependencies in the order specified except for those three modules that
    have already been loaded.
  * Loads the cpe/21.04 module


More information
================
 - Homepage: https://pubs.cray.com
]==])

whatis([==[Desription: EasyBuild toolchain using the Cray compiler wrapper with gcc module (CPE release 21.04)]==])

local root = "/run/user/27155/EBtesting/software/cpeGNU/21.04-CSCS"

conflict("cpeGNU")

unload("PrgEnv-aocc")
unload("PrgEnv-cray")
unload("PrgEnv-intel")
unload("PrgEnv-pgi")

if not ( isloaded("PrgEnv-gnu") ) then
    load("PrgEnv-gnu")
end

if not ( isloaded("craype-x86-rome") ) then
    load("craype-x86-rome")
end

if not ( isloaded("craype-network-ofi") ) then
    load("craype-network-ofi")
end

if not ( isloaded("gcc") ) then
    load("gcc")
end

if not ( isloaded("craype") ) then
    load("craype")
end

if not ( isloaded("cray-dsmml") ) then
    load("cray-dsmml")
end

if not ( isloaded("cray-libsci") ) then
    load("cray-libsci")
end

if not ( isloaded("cray-mpich") ) then
    load("cray-mpich")
end

if not ( isloaded("libfabric") ) then
    load("libfabric")
end

if not ( isloaded("perftools-base") ) then
    load("perftools-base")
end

if not ( isloaded("xpmem") ) then
    load("xpmem")
end

if not ( isloaded("cpe/21.04") ) then
    load("cpe/21.04")
end

setenv("EBROOTCPEGNU", root)
setenv("EBVERSIONCPEGNU", "21.04")
setenv("EBDEVELCPEGNU", pathJoin(root, "easybuild/cpeGNU-21.04-CSCS-easybuild-devel"))

-- Built with EasyBuild version 4.4.0

prepend_path("MODULEPATH",root:gsub("software","modules/all/Toolchain"))

