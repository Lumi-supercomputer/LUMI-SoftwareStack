# ROCm user instructions

There is a **big disclaimer** with these modules.

**THIS IS ROCM INSTALLED IN A WAY IT IS NOT MEANT TO BE INSTALLED.**

The ROCm installations outside of the Cray PE modules 
(so the 5.1.4, 5.2.5 and 5.3.3 modules) 
come **without any warranty nor support** as they are not
installed in the proper directories suggested by AMD thus may break links
encoded in the RPMs from which these packages were installed and 
as they are are also
not guaranteed to be compatible with modules from the Cray PE
as only HPE Cray can give that warranty and as their inner working and
precise requirements is not public.

The ROCm 5.2.5 and 5.3.3 modules have some PDF documentation in 
`$EBROOTROCM/share/doc/rocgdb`, `$EBROOTROCM/share/doc/tracer` (5.3.3 only),
`$EBROOTROCM/share/doc/rocm_smi` and `$EBROOTROCM/share/doc/amd-dbgapi`.
The `EBROOTROCM` environment variable is defined after loading the module.

