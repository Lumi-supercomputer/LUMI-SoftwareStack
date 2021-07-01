help([==[

Description
===========
This module is the EasyBuild toolchain that uses the Cray compiler wrapper with
the gcc compiler activated. The components loaded are those of the Cray Programming
Environment (CPE) version 21.04.

The module has the same effect as loading PrgEnv-gnu and cpe/21.04 should have, but
does not use either of those modules. The use of PrgEnv-gnu is avoided since the
modules that it loads may change over time, reducing reproducibilty, while loading
cpe/21.04 is avoided as this module is buggy and conflicts with the way the LUMI
software stack currently works. Instead, the module declares itself a member of
the PrgEnv family and sets an PE_ENV which would otherwise be set by PrgEnv-gnu,
ensuring that the Cray PE will work as if those modules are loaded.

The effect of loading this module is:
  * All PrgEnv or other cpe* modules will be unloaded as they are part of
    the PrgEnv family (at least if they are generated in a consistent way).
  * PE_ENV is set to GNU
  * The three targeting modules are loaded:
      * craype-x86-rome
      * craype-accel-host
      * craype-network-ofi
  * The other modules are loaded in the order and version specified:
      * gcc/9.3.0
      * craype/2.7.6
      * cray-mpich/8.1.4
      * cray-libsci/21.04.1.1
      * cray-dsmml/0.1.4
      * perftools-base/21.02.0
      * xpmem


More information
================
 - Homepage: https://pubs.cray.com
]==])

whatis([==[Desription: EasyBuild toolchain using the Cray compiler wrapper with gcc module (CPE release 21.04)]==])

local root = "/users/klust/appltest/design_0.4/SW/LUMI-21.04/L/EB/cpeGNU/21.04-noPrgEnv-nocpe"

conflict("cpeGNU")
family('PrgEnv')

setenv("PE_ENV", "GNU")

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
setenv("EBDEVELCPEGNU", pathJoin(root, "easybuild/cpeGNU-21.04-noPrgEnv-nocpe-easybuild-devel"))

-- Built with EasyBuild version 4.4.0
