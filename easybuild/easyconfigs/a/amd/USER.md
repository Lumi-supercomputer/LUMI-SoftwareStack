# amd user instructions

The `amd/5.6.1` module is provided by the LUMI User Support Team to enable users
who need a more recent version of ROCm that the official HPE Cray module. As 
this is not a vendor-supplied module, it might not work as expected all the
time.

To use this module, use the following commands:

```
module load PrgEnv-amd
module load amd/5.6.1
```

After loading these two modules, the Cray compiler wrapper (`cc`, `CC` and
`ftn`) will use `amdclang`, `amdclang++` and `amdflang` from ROCm 5.6.1 as the
backend compilers.

To compile HIP code, you can use `hipcc` or `CC` with the `-xhip` compilation
flag. Note that in the latter case, in order to have the HIP runtime library
automatically linked, you need to load the corresponding `rocm` module.

```
module load rocm/5.6.1
```