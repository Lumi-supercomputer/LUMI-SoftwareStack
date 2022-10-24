# cpeCray user information

The `cpeCray` modules are the interface between EasyBuild and the
HPE Cray Programming environment `amd` compiler module and other libraries.
These modules replace the HPE Cray `PrgEnv-cray` module and load the precise
versions required by the LUMI software stack with the same version number
as the `cpeCray` module.

When doing development on top of libraries already installed with EasyBuild
in the LUMI stack, users should use the `cpeCray` module rather than the
`PrgEnv-cray` module and the latter will be removed from the environment
anyway as soon as the `cpeCray` module is loaded, e.g., as a dependency of
a library build with EasyBuild in the `cpeCray` toolchain.

Note that the `cpeCray` toolchain is for CPU and GPU programming. For GPU
programming, the `rocm` module also needs to be loaded.
