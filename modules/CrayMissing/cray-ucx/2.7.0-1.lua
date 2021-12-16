help([==[

Description
===========
This cray-ucx module adds UCX 1.9.0 to the environment and replaces a missing
module from HPC-X 2.7.0.

LUMI recommends using OFI-based MPI implementations instead, and there is no
official support from HPE Cray for UCX on the Slingshot-11 adapters that will
be used in LUMI-C and LUMI-G after the network upgrade in February 2022.
Support may even disappear earlier.


More information
================
 - Homepage: https://developer.nvidia.com/networking/hpc-x
]==])

whatis([==[Description: This module adds UCX 1.9.0 to the environment and replaces a missing module from HPC-X 2.7.0]==])

local root = "/users/kurtlust/LUMI/SW/CrayEnv/EB/cray-ucx/2.7.0-1"

conflict("cray-ucx")

setenv("EBROOTCRAYMINUCX", root)
setenv("EBVERSIONCRAYMINUCX", "2.7.0-1")
setenv("EBDEVELCRAYMINUCX", pathJoin(root, "easybuild/cray-ucx-2.7.0-1-easybuild-devel"))

prepend_path("PATH", "/opt/cray/pe/cray-ucx/2.7.0-1/ucx/bin")
prepend_path("LD_LIBRARY_PATH", "/opt/cray/pe/cray-ucx/2.7.0-1/ucx/lib")
prepend_path("PKG_CONFIG_PATH", "/opt/cray/pe/cray-ucx/2.7.0-1/ucx/lib/pkgconfig")
-- Built with EasyBuild version 4.4.2
