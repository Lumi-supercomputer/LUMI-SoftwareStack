# ROCm user instructions

There is a **big disclaimer** with these modules.

**THIS IS ROCM INSTALLED IN A WAY IT IS NOT MEANT TO BE INSTALLED.**

The ROCm installations outside of the Cray PE modules 
(so the 5.2.5, 5.3.3, 5.4.6 and 5.6.1 modules) 
come **without any warranty nor support** as they are not
installed in the proper directories suggested by AMD thus may break links
encoded in the RPMs from which these packages were installed and 
as they are are also
not guaranteed to be compatible with modules from the Cray PE
as only HPE Cray can give that warranty and as their inner working and
precise requirements is not public.

-   The ROCm 5.2.5 and 5.3.3 modules have some PDF documentation in 
    `$EBROOTROCM/share/doc/rocgdb`, `$EBROOTROCM/share/doc/tracer` (5.3.3 only),
    `$EBROOTROCM/share/doc/rocm_smi` and `$EBROOTROCM/share/doc/amd-dbgapi`.
    The `EBROOTROCM` environment variable is defined after loading the module.
    
-   The `rocm/5.4.6` module can be used with `PrgEnv-amd` but comes without
    matching `amd/5.4.6` module. It is sufficient to load the `rocm/5.4.6` module
    after the `PrgEnv-amd` module (or `cpeAMD` module) to enable this ROCm version
    also for the compiler wrappers in that programming environment.
    
    The `5.4.6` module is created because the driver that is on the system 
    at the time of writing (March 2024) is still the ROCm 5.2.3 driver which
    only officially supports ROCm versions up to 5.4.x and as we noted too many
    problems with ROCm 5.6.1 with that driver. Though supported by the driver, this
    is still not an official ROCm installation done by HPE so even though we have
    run some test suites, we cannot fully exclude problems in combination with the
    HPE Cray PE (including its MPI libraries).
    
    The module is available in `CrayEnv` and in `LUMI/23.09 partition/G` and has
    been tested in combination with the 23.09 release of the programming environment.
    
-   `rocm/5.6.1` module: This module comes with a matching `amd/5.6.1` module for use
    with `PrgEnv-amd` or `cpeAMD`. 
    
    The `rocm/5.6.1` module is not officially supported by the ROCm 5.2.3 driver on 
    the system at the time of writing (March 2024). Some software runs well, some 
    software doesn't, and there is nothing the LUMI User Support Team can do
    about this until the system is upgraded. 
    
    Known problems included:
    
    -   Memory reporting is broken so programs that rely on ROCm calls, e.g., to determine
        how much memory they can use, may not function correctly.
        
    -   We have observed very slow performance of GPU-aware MPI.
    
    -   The "xnack" feature is also broken.

Note that using ROCm in containers is still subject to the same driver compatibility
problems. Though containers will solve the problem of ROCm being installed in a non-standard
path (which was needed for the modules as the standard path is already occupied by a different ROCm version), 
it will not solve any
problem caused by running a newer version of ROCm on a too old driver (and there may be 
problems running an old version of ROCm on a too new driver also).
