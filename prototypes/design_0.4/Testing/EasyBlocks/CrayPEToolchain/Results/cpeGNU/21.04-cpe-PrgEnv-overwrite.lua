help([==[

Description
===========
This module is the EasyBuild toolchain that uses the Cray compiler wrapper with
the gcc compiler activated. The components loaded are those of the Cray Programming
Environment (CPE) version 21.04.

The result of this example is a modulefile which:
  * Declares itself a member of the cpeToolchain family
    (but doesn't do any explicit unloads)
  * Loads the cpe/21.04 module
  * Loads the PRgEnv-gnu module
  * Loads the targeting modules craype-x86-rome, craype-accel-host and craype-network-ofi,
    which may trigger the reload of already loaded modules if it replaces a different target
    module.
  * Loads the gcc/9.3.0 module, even though PrgEnv-gnu is already loaded, because it is
    part of the dependencies
  * Loads the craype/2.7.6 module, even though PrgEnv-gnu is already loaded, because it is
    part of the dependencies
  * Loads the dependencies in the order specified except for those three modules that
    have already been loaded:
      * cray-mpich/8.1.4
      * cray-libsci/21.04.1.1
      * cray-dsmml/0.1.4
      * perftools-base/21.02.0
      * xpmem
    The cpe line is simply ignored but no warning is printed


More information
================
 - Homepage: https://pubs.cray.com
]==])

whatis([==[Desription: EasyBuild toolchain using the Cray compiler wrapper with gcc module (CPE release 21.04)]==])

local root = "/users/klust/appltest/design_0.4/SW/LUMI-21.04/L/EB/cpeGNU/21.04-cpe-PrgEnv-overwrite"

conflict("cpeGNU")

family('cpeToolchain')

if not ( isloaded("cpe/21.04") ) then
    load("cpe/21.04")
end

if not ( isloaded("PrgEnv-gnu/8.0.0") ) then
    load("PrgEnv-gnu/8.0.0")
end

if not ( isloaded("craype-x86-rome") ) then
    load("craype-x86-rome")
end

if not ( isloaded("craype-accel-host") ) then
    load("craype-accel-host")
end

if not ( isloaded("craype-network-ofi") ) then
    load("craype-network-ofi")
end

if not ( isloaded("gcc/9.3.0") ) then
    load("gcc/9.3.0")
end

if not ( isloaded("craype/2.7.6") ) then
    load("craype/2.7.6")
end

if not ( isloaded("cray-mpich/8.1.4") ) then
    load("cray-mpich/8.1.4")
end

if not ( isloaded("cray-libsci/21.04.1.1") ) then
    load("cray-libsci/21.04.1.1")
end

if not ( isloaded("cray-dsmml/0.1.4") ) then
    load("cray-dsmml/0.1.4")
end

if not ( isloaded("perftools-base/21.02.0") ) then
    load("perftools-base/21.02.0")
end

if not ( isloaded("xpmem") ) then
    load("xpmem")
end

setenv("EBROOTCPEGNU", root)
setenv("EBVERSIONCPEGNU", "21.04")
setenv("EBDEVELCPEGNU", pathJoin(root, "easybuild/cpeGNU-21.04-cpe-PrgEnv-overwrite-easybuild-devel"))

-- Built with EasyBuild version 4.4.0
