# Some failed experiments

These failed experiments are documented to avoid making the same mistake twice.

## Overwriting a module by putting one with the same name and version earlier in the path may not work

During the development of the LUMI software stack prototype using the 21.04 CPE release
on eiger it turned out that the ``cpe/21.04`` module had one nasty habbit: By setting
``LMOD_MODULERCFILE`` with the ``setenv`` LMOD function rather than by prepending or
appending to it using ``prependpath``/``append_path``, it cleared the ``modulerc.lua``
file that the LUMI software setup relies upon.

We tried to cure that by putting a modified copy of the file in a directory earlier
in the MODULEPATH and hiding the original Cray module with a
``` lua
hide_modulefile ( '/opt/cray/pe/lmod/modulefiles/core/cpe/21.04.lua' )
```
line in the system ``modulerc.lua`` file. Though the module was indeed hidden as
``module avail`` confirmed, and though there was a ``cpe/21.04.lua`` file earlier in
the MODULEPATH, ``module load cpe/21.04`` still loaded the wrong version, even with
``LMOD_IGNORE_CACHE=1``.

A clue to what is happening is that  when the line that hides the module in ``modulerc.lua``
is removed, you will notice that LMOD marks the one in the Cray ``core/cpe`` subdirectory
as the default and not the one with the same name earlier in the MODULEPATH.

The problem is that

 1. When a full name is used, LMOD can still load a hidden module and does so when
    that module is marked as the default.

 2. The CPE does mark one of the cpe modules as the default using a ``.version`` file
    in the ``core/cpe`` subdirectory.

**Luckily HPE-Cray uses a ``.version`` file which has the lowest priority. The solution
is to mark a module in the overwrite directory as the default using either the symlink
method or a ``.modulerc.lua`` file in that directory.**

## A change of visibility of modules is only detected when the module command exits

The idea was to write a module ``cpe/restore-defaults`` to restore the defaults rather
than calling a script. This didn't entirely work as expected, likely because LMOD only
assesses visibility at the start of the execution. Whereas changing ``MODULEPATH`` triggers
LMOD to reassess the module tree, making changes to ``LMOD_MODULERCFILE`` doesn't trigger
reassessing the visibility.

To recreate the experiment, take any standard ``cpe`` modulefile that doesn't only use those modules
with the highest version number, e.g., one that uses an older version of gcc, ( and
with the ``setenv`` replaced with ``append_path`` or ``prepend_path`` see the issues with the CPE),
and the following ``cpe/restore-defaults.lua`` file:
``` lua
modules = {
    "PrgEnv-aocc",
    "PrgEnv-cray",
    "PrgEnv-gnu",
    "PrgEnv-intel",
    "PrgEnv-nvidia",
    "aocc",
    "atp",
    "cce",
    "cray-R",
    "cray-ccdb",
    "cray-cti",
    "cray-dsmml",
    "cray-fftw",
    "cray-hdf5",
    "cray-hdf5-parallel",
    "cray-jemalloc",
    "cray-libsci",
    "cray-mpich",
    "cray-netcdf",
    "cray-netcdf-hdf5parallel",
    "cray-openshmemx",
    "cray-parallel-netcdf",
    "cray-pmi",
    "cray-pmi-lib",
    "cray-python",
    "cray-stat",
    "craype",
    "craype-dl-plugin-py3",
    "craypkg-gen",
    "gcc",
    "gdb4hpc",
    "iobuf",
    "modules",
    "nvidia",
    "papi",
    "perftools-base",
}

if (mode() == "load" or mode() == "show") then
    for _,mod in pairs(modules)
    do
        if (isloaded(mod)) then
            unload(mod)
            load(mod)
        end
    end
end
```
Then observe that
``` bash
module load cpe/21.04
module load cpe/restore-defaults
```
doesn't produce the same state as
``` bash
module load cpe/21.04
module unload cpe/21.04
module load cpe/restore-defaults
```
even though loading ``cpe/restore-defaults`` triggers the unloading of ``cpe/21.04``.
In the former, lower versions of modules will remain loaded. However, loading
``cpe/restore-defaults`` a second time to correct the situation, i.e.,
``` bash
module load cpe/21.04
module load cpe/restore-defaults
module load cpe/restore-defaults
```
produces the expected result.




