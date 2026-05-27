# ROCm user instructions

**This is ROCm(tm) installed in a non-standard location which may have
consequences for some programs that may rely on the standard location
for ROCm(tm).**

Neither can we guarantee that these modules are always compatible with 
the HPE Cray Programming Environment as each version of the CPE is developed
for particular ROCm(tm) versions.

-   The only modules officially supported by the current AMD GPU driver at the
    time of writing (February 2026) are the `6.2.2`, `6.2.4`, `6.3.4` and `6.4.4` modules. 
    Older modules may still be present on the system as a full clean-up is
    nearly impossible, but modules older than ROCm(tm) 6.1 will likely not 
    be fully functional and there is nothing the LUMI User Support Team can
    do about that.

    The `6.2.2` module is only there for historical reasons as it was installed
    before `6.2.4` became available.

-   The ROCm modules have some PDF documentation in some subdirectories of
    `$EBROOTROCM/share/doc`. The
    `EBROOTROCM` environment variable is defined after loading the module.
    
-   The `6.2.2` and `6.2.4` modules can be used with `PrgEnv-amd` but come without matching
    `amd/6.2.2` or `amd/6.2.4` module. It is sufficient to load the 
    `rocm/6.2.2` or `rocm/6.2.4` module after
    the `PrgEnv-amd` module (or `cpeAMD` module) to enable this ROCm version
    also for the compiler wrappers in that programming environment.

-   The `6.2.2`  and `6.2.4` modules **are not compatible with the CCE 17.0.1
    compilers** (in the 23.09 version of the programming environment)
    due to an incompatibility between LLVM 17 on which the CCE is
    based and LLVM 18 from ROCm(tm) 6.2. The only supported programming environments
    are PrgEnv-gnu (or cpeGNU) and PrgEnv-amd (or cpeAMD).

-   Since ROCm(tm) 6.2, hipSolver depends on SuiteSparse. If an application depends
    on hipSolver, it is the user's responsibility to load the SuiteSparse module
    which corresponds to the CPE they wish to use (cpeAMD or cpeGNU). Note that
    the SuiteSparse module needs to be **loaded before** the `rocm` module
    or the regular `rocm` module for the toolchain will be used.

Note that using ROCm(tm) in containers is still subject to the same driver
compatibility problems as when using these modules. 
Though containers will solve the problem of ROCm(tm) being
installed in a non-standard path (which was needed for the modules as the
standard path is already occupied by a different ROCm(tm) version), it will not
solve any problem caused by running a newer version of ROCm(tm) on a too old driver
(and there may be problems running an old version of ROCm(tm) on a too new driver
also).

## Modules with extra debugging and performance profiling tools installed

The `rocm\6.2.4`, `rocm\6.3.4-extras`, `rocm\6.4.4` modules come with extra debugging and performance profiler tools installed.
However, to make sure that in the runtime the libraries are correctly loaded from this module
and not from `/opt/rocm`, we have hardcoded the correct paths in the module libraries and executables.
If you need to use the asan or debug versions of the libraries you will have to `LD_PRELOAD`
them instead of just prepending `LD_LIBRARY_PATH`.

To use the provided `rocprof-compute`, the user need to install the python dependencies
required by the application itself.
As many user have their own python environment, we decided not to offer a central 
rocm-python installation that may conflict with all other custom environments.
So to enable `rocprof-compute`, you will need to install the following python
packages either in your already existing environment or in a small virtual environment.
The list of packages may also depend on the version of ROCm(tm). You can find the list
after loading the module in `$EBROOTROCM/libexec/rocprofiler-compute/requirements.txt`.
For ROCm(tm) versions older than 6.3 where the profiler is still called OmniPerf,
the list of packages is in `$EBROOTROCM/libexec/omniperf/requirements.txt`.
