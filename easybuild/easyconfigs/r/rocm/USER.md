# ROCm user instructions

There is a **big disclaimer** with these modules.

**THIS IS ROCM INSTALLED IN A WAY IT IS NOT MEANT TO BE INSTALLED.**

The ROCm installations outside of the Cray PE modules (so the 5.2.5, 5.3.3,
5.4.6, 5.6.1 and 6.2.2 modules) come **without any warranty nor support** as
they are not installed in the proper directories suggested by AMD thus may break
links encoded in the RPMs from which these packages were installed and as they
are also not guaranteed to be compatible with modules from the Cray PE as
only HPE Cray can give that warranty and as their inner working and precise
requirements is not public. 

-   The only modules officially supported by the current AMD GPU driver at the
    time of writing (October 2024) are the `5.6.1` and `6.2.2` modules. Using
    the `5.6.1` module is recommended only if a performance regression is
    observed with the `6.0.3` or `6.2.2` modules. The use of the other modules
    (`5.2.5`, `5.3.3` and `5.4.6`) is strongly discouraged and no longer
    supported by the LUMI User Support Team.

-   The ROCm modules have some PDF documentation in
    `$EBROOTROCM/share/doc/rocgdb`, `$EBROOTROCM/share/doc/tracer`,
    `$EBROOTROCM/share/doc/rocm_smi` and `$EBROOTROCM/share/doc/amd-dbgapi`. The
    `EBROOTROCM` environment variable is defined after loading the module.
    
-   The `6.2.2` modules can be used with `PrgEnv-amd` but comes without matching
    `amd/6.2.2` module. It is sufficient to load the `rocm/6.2.2` module after
    the `PrgEnv-amd` module (or `cpeAMD` module) to enable this ROCm version
    also for the compiler wrappers in that programming environment.

-   The `6.2.2` modules **is not compatible with the CCE 17.0.0 and 17.0.1
    compilers** due to an incompatibility between LLVM 17 on which the CCE is
    based and LLVM 18 from ROCm 6.2. The only supported programming environments
    are PrgEnv-gnu (or cpeGNU) and PrgEnv-amd (or cpeAMD).

-   Since ROCm 6.2, hipSolver depends on SuiteSparse. If an application depends
    on hipSolver, it is the user responsibility to load the SuiteSparse module
    which corresponds to the CPE they wish to use (cpeAMD or cpeGNU). Note that
    the SuiteSparse module needs to be **loaded before** the `rocm/6.2.2` module
    or `rocm/6.0.3` will be used.

-   In the `CrayEnv` environment, omniperf dependencies have been installed for
    all `cray-python` versions available at the time of the module installation
    (October 2024, Python 3.9, 3.10 and 3.11) but the `cray-python` module is
    not loaded as a dependency to let the choice of the Python version to the
    user. Therefore, if you want to use omniperf, you need to load a
    `cray-python` module yourself. In the `LUMI` environment, the only supported
    version of Python is the one coming from the corresponding release of the
    CPE. For example, for `LUMI/24.03` omniperf dependencies have been installed
    for version 3.11. **Omniperf is not compatible with the system Python
    (version 3.6)**.

Note that using ROCm in containers is still subject to the same driver
compatibility problems. Though containers will solve the problem of ROCm being
installed in a non-standard path (which was needed for the modules as the
standard path is already occupied by a different ROCm version), it will not
solve any problem caused by running a newer version of ROCm on a too old driver
(and there may be problems running an old version of ROCm on a too new driver
also).
