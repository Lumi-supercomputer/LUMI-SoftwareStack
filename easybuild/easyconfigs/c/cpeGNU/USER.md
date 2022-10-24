# cpeGNU user information

The `cpeGNU` modules are the interface between EasyBuild and the
HPE Cray Programming environment `amd` compiler module and other libraries.
These modules replace the HPE Cray `PrgEnv-gnu` module and load the precise
versions required by the LUMI software stack with the same version number
as the `cpeGNU` module.

When doing development on top of libraries already installed with EasyBuild
in the LUMI stack, users should use the `cpeGNU` module rather than the
`PrgEnv-gnu` module and the latter will be removed from the environment
anyway as soon as the `cpeGNU` module is loaded, e.g., as a dependency of
a library build with EasyBuild in the `cpeGNU` toolchain.

Note that the `cpeGNU` toolchain is for CPU and GPU programming. For GPU
programming, the `rocm` module also needs to be loaded. Programming with
openACC directives is currently not supported. It is also not clear to
what extent OpenMP offload performs properly with the GNU compilers.
Users are advised to use `cpeCray` or `cpeAMD` for OpenMP offload.
