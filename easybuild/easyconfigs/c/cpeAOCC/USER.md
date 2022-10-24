# ccpeAOCC user information

The `ccpeAOCC` modules are the interface between EasyBuild and the
HPE Cray Programming environment `amd` compiler module and other libraries.
These modules replace the HPE Cray `PrgEnv-aocc` module and load the precise
versions required by the LUMI software stack with the same version number
as the `ccpeAOCC` module.

When doing development on top of libraries already installed with EasyBuild
in the LUMI stack, users should use the `ccpeAOCC` module rather than the
`PrgEnv-aocc` module and the latter will be removed from the environment
anyway as soon as the `ccpeAOCC` module is loaded, e.g., as a dependency of
a library build with EasyBuild in the `ccpeAOCC` toolchain.

Note that the `ccpeAOCC` toolchain is for CPU programming only. For GPU programming
the AMD compilers are provided by the `cpeAMD` module as the CPU and GPU compilers
are currently distinct products in the AMD ecosystem.
