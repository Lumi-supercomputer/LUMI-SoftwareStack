# cpeAMD user information

The `cpeAMD` modules are the interface between EasyBuild and the
HPE Cray Programming environment `amd` compiler module and other libraries.
These modules replace the HPE Cray `PrgEnv-amd` module and load the precise
versions required by the LUMI software stack with the same version number
as the `cpeAMD` module.

When doing development on top of libraries already installed with EasyBuild
in the LUMI stack, users should use the `cpeAMD` module rather than the
`PrgEnv-amd` module and the latter will be removed from the environment
anyway as soon as the `cpeAMD` module is loaded, e.g., as a dependency of
a library build with EasyBuild in the `cpeAMD` toolchain.

Note that the `cpeAMD` toolchain is for GPU programming only. For CPU programming
the AMD compilers are provided by the `cpeAOCC` module as the CPU and GPU compilers
are currently distinct products in the AMD ecosystem.

Contrary to the `cpeCray` and `cpeGNU` environments, the `rocm` module should not
be loaded to do GPU programming. Its functionality is included in the `amd` module.
