# amd user instructions

The `amd/X.Y.Z` modules are provided by the LUMI User Support Team to enable users
who need a more recent version of ROCm that the official HPE Cray module. As 
this is not a vendor-supplied module, it might not work as expected all the
time.

To use this module, use the following commands:

```
module load PrgEnv-amd
module load amd/X.Y.Z
```

After loading these two modules, the Cray compiler wrapper (`cc`, `CC` and
`ftn`) will use `amdclang`, `amdclang++` and `amdflang` from ROCm X.Y.Z as the
backend compilers.

To compile HIP code, you can use `hipcc` or `CC` with the `-xhip` compilation
flag. Note that in the latter case, in order to have the HIP runtime library
automatically linked, you need to load the corresponding `rocm` module.

```
module load rocm/X.Y.Z
```

The 6.4.4 module is specifically meant to be used in 25.09 and the 7.0.3 one 
in 26.03 and provide full compatibility with the `PrgEnv-amd` modules in those
stacks, as they really want to load an `amd` module and not just a `rocm` module.

For some `rocm` modules, there is no matching `amd` module. Those are meant to
be used as a replacement for the regular `rocm` module for a toolchains.
For those, it is sufficient to
load the `rocm/X.Y.Z` module after loading the `PrgEnv-amd` module (or `cpeAMD` in
the LUMI stacks). The necessary environment variables for the compiler wrappers
are already defined in the `rocm/X.Y.Z` module.
