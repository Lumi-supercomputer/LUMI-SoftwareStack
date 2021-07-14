# The CrayPEToolchain EasyBlock and cpeCray/cpeGNU/cpeAMD modules

TODO: Scenarios for cpe* modules:

* Cray way module load cpe/* PrgEnv-* and then correct
* Cray way reversed module load PrgEnv-* cpe/* and then correct
* Mimic PrgEnv-* but do load cpe/*.
    * First: Use set versions for all modules to avoid the problems of the cpe module
    * Last: Makes sense when loading versionless modules and relying on cpe to correct
      (which does not work in 21.06)

## Introduction

Our CrayPEToolchain EasyBlock allows for many different scenarios to generate the
cpeCray/cpeGNU/cpeAMD modules:

  * The ``cpe`` module can be loaded first, last or not at all. Note that if the
    module is not loaded at all, it may be wise to have a different way of setting
    the default versions for the Cray PE modules.

    On LUMI, in the LUMI software stacks, these default versions are already set by
    the ``LUMIstack_<yy.mm>_modulerc.lua`` files.

    In version 21.04 of the CPE, the ``cpe`` modules still have several problems,
    partly due to an LMOD restriction and partly due to bugs in those modules:

      * The ``cpe`` modules set ``LMOD_MODULERCFILE`` through ``setenv`` rather than
        ``prepend_path`` or ``append_path`` so they overwrite any file that sets
        system-wide defaults and visibility from other sources, which is not desirable.

      * A change to ``LMOD_MODULERCFILE`` has only effect the next time a module command
        is executed. This is a restriction not only of LMOD version ``8.3.x`` used in the
        21.04 CPE, but also of versions in the 8.4 and 8.5 series. Hence loading the
        ``cpe/yy.mm`` module before loading other versionless modules for the CPE components
        will not have the desired effect of loading the versions for that specific version of
        the CPE.

      * The ``cpe`` modules do contain code to reload already loaded modules from the CPE in
        the correct version, but that code is also broken in the ``21.04`` version as the
        modules may be loaded in an order in which a module that has already been reloaded
        in the correct version, gets reloaded once more with a versionless load, which may
        reload the wrong version. This is because the LUA loop with ``pairs`` doesn't have
        a fixed order of going over the entries in the LUA table. The order should be such
        that no module reloads an other module that has already been reloaded in the correct
        version.

  * The matching ``PrgEnv-*`` module can either be loaded, or its loading can just be emulated
    by only setting the environment variable that this module sets, but relying on the ``cray_targets``
    variable and dependencies list to load all Cray PE components.

    The reason to avoid loading the ``PrgEnv-*`` module is reproducibility. That module
    depends on a file in ``/etc`` to define the components that will be loaded, and
    that file cannot distinguish between versions of the CPE. Hence if changes to that
    file would be made, it has an effect on the working of all ``cpe*`` modules that
    EasyBuild may already have generated.

  * It is possible to specify target modules via ``cray_targets``.  This is a list just as the
    dependencies. They will be loaded after the ``PrgEnv-*`` module (if the latter is loaded) but
    before other dependencies specified by ``dependencies``. They do not need to be defined in
    the EasyBuild external modules file. We chose to load them after the ``PrgEnv-*``
    module (if the latter is loaded) to be able to overwrite Cray targeting modules
    loaded by the latter.

  * Dependencies in this case will be external modules. It is possible to specify versions by using,
    e.g.,
    ```python
    ( 'gcc/9.3.0', EXTERNAL_MODULE)
    ```
    Versions should be specified if the ``cpe`` module is not loaded, even on LUMI, as if
    a user would execute
    ```bash
    module load LUMI/21.04 cpeGNU/21.04
    ```
    the wrong versions of CPE components might be loaded because of the same LMOD restriction
    that causes the problems with the Cray ``cpe/yy.mm`` modules: The ``LUMI/yy.mm``
    module will add a file that sets the default versions of CPE compoments for the
    requested LUMI software stack and matching CPE version, but those changes only
    take effect at the following ``module`` command, so the ``cpeGNU/21.04`` module
    which is loaded in the above example will not yet see the correct default versions
    of the modules.

    Note also that if versions are specified but the ``cpe`` module is loaded at the
    end, modules might be reloaded in a different version.

  * The default value for various parameters is chosen to generate module files that
    are as similar as possible to those used ast CSCS (or at least those used for their
    20.04 environment), but are not the defaults initially used on LUMI.


## Supported extra parameters for the EasyConfig files

The ``CrayPEToolchain`` EasyBlock supports the following parameters:

  * ``PrgEnv``: Sets the ``PrgEnv-*`` module to load or emulate.
      * The default is to derive the value from the name of the module to generate:
          * ``PrgEnv = 'cray'`` for ``cpeCray``
          * ``PrgEnv = 'gnu'`` for ``cpeGNU``
          * ``PrgEnv = 'aocc'`` for ``cpeAMD``
          * ``PrgEnv = 'intel'`` for ``cpeIntel``
          * ``PrgEnv = 'nvidia'`` for ``cpeNVIDIA`` (not tested as we have no access to
            a machine with a fully working version of this environment)
      * It is also possible to specify any of these values, or even a different value for a
        ``PrgEnv-*`` module that is not yet recognized by the EasyBlock.

  * ``PrgEnv_load``: Boolean value, indicate if the ``PrgEnv`` module should be loaded
    explicitly (if True) or not (if False).

    Default is ``True``.

    If you want to hard-code a version, you can do so by specifying the module with
    the version in the dependencies.

    It is important that all ``cpe*`` modules available in the system at the same time
    are also generated with the same setting for ``PrgEnv_load`` as otherwise the
    conflict resolution between those modules would not work correctly.

  * ``PrgEnv_family``:

      * If ``cpeToolchain``, the module will declare itself a member of the ``cpeToolchain``
        family. If all ``cpe*`` modules are generated that way, this will ensure that no two
        different ``cpe*`` modules will be loaded simulataneously, which wouldn't work correctly
        anyway with the Cray compiler wrappers.

        If ``PrgEnv_load`` is false, it will also force unload all ``PrgEnv-*`` modules
        to ensure that none is loaded. Otherwise it relies on the  family-mechanism
        used in the LMOD ``PrgEnv-*`` modules to do the job.

        This is the most robust option when explicitly loading a ``PrgEnv-*`` module
        and using LMOD as LMOD will then ensure that no two ``cpe*`` modules will be
        loaded simultaneously and the family mechanism used in the Cray ``PrgEnv-*``
        modules will do the same for those modules.

      * If ``PrgEnv``, the module will declare itself a member of the ``PrgEnv-``
        family. This will generate an error if ``PrgEnv_load`` is True as one
        cannot load two modules of the same family but is the most robust ootion when
        using LMOD and emulating the ``PrgEnv-*`` module.

        The LMOD family feature will take care of unloading all other ``PrgEnv-*``
        or ``cpe*`` modules as they would conflict with the current module.

      * If ``None`` (default), which is the only setting that works when TCL-based modules are
        used and is therefore the default, the module will start with unload commands
        for all known ``PrgEnv-*`` and all ``cpe*`` modules except itself and the ``PrgEnv-*``
        module that it uses (if it uses one).

    It is important that all ``cpe*`` modules available in the system at the same time
    are also generated with the same setting for ``PrgEnv_family`` as otherwise the
    conflict resolution between those modules would not work correctly.

  * ``CPE_compiler`` specifies the (versionless) compiler to load. Possible values are:

      * ``None`` (default): Derive the name of the compiler module from the name of the
        module to generate. This may not yet work for ``cpeNVIDIA`` as it is not clear
        what the name of the compiler module will be.

        If will not add an additional load if that compiler module is already specified
        in the dependencies.

        Note that this will load the module without specifying the version, so it only
        makes sense to rely on the autodetect feature if the ``cpe`` module is loaded
        (and if the bugs with that one are fixed).

      * Any other value will be considered the name of the compiler module to load.
        The module should be versionless. If you want to specify a version, you can
        do so via ``dependencies``.

        No separate load will be generated if the compiler module is also found in
        the list of dependencies.

  * ``CPE_version``: Version of the cpe module to use (if it is used). Possible values:

      * ``None`` (default): Determine the version from the version of the module to generate,
        i.e., the ``version`` parameter in the EasyConfig.

      * Any other value is interpreted as the value to load.

  * ``CPE_load``:  Possible values:

      * ``first`` (default): Load as the very first module. This does not make sense until the LMOD
        problems with ``LMOD_MODULERCFILE`` are fixed.

      * ``after``: Load immediately after loading ``PrgEnv-*`` but before loading any
        other module. This does not make too much sense until the LMOD problems with
        ``LMOD_MODULERCFILE`` are fixed, but it could be a way to first load modules
        the Cray way and then correct by manually loading correct versions via the
        ``cray_targets`` and ``dependencies`` parameters.

        This value will produce an error message when ``PrgEnv_load`` is set to ``False``.

      * ``last``: Load as the last module. Currently this does not make sense until
        the problems with the ``cpe`` module are fully fixed, and on LUMI, until the problem
        with overwriting ``LMOD_MODIULERCFILE`` is fixed.

      * ``None``: Do not load the ``cpe`` module but rely on explicit dependencies specified in
        the list of dependencies instead.

  * ``cray_targets``: A list of Cray targetting modules to load.

  * ``dependencies``:  This is a standard EasyConfig parameter. The versions of the
    selected PrgEnv, compiler and ``craype`` module can be specified through dependencies
    but those modules will still be loaded according to the scheme below. Any redifinition
    of the ``cpe`` module is discarded.


## Order of loads generated by the EasyBlock

 1. The ``cpe/<CPE_version>`` module, if ``CPE_load`` is ``first``.

    If LMOD would be modified to honour changes to ``LMOD_MODULERCFILE`` immediately
    as it does with changes to ``MODULEPATH``, this would be the best moment to load
    the ``cpe`` module as it ensures that all other packages would be loaded with the
    correct version number immediately.

 2. The ``PrgEnv-<PrgEnv>`` module, if ``PrgEnv_load`` is True.

 3. The targeting modules specified by ``cray_targets``. Hence they can overwrite the
    targets set by the ``PrgEnv-*`` module which may be usefull on a heterogeneous
    system should there only be a single configuration for the ``PrgEnv-*`` modules
    for all hardware partitions in the system, or to build a ``cpe*`` module for cross-compiling.

    Note that changes to the targeting modules may trigger reloads of other modules
    loaded by the ``PrgEnv-*`` module.

 4. The ``CPE_compiler`` module (or autodected one), unless both
    PrgEnv-* is loaded explicitly and the module is not in the list
    of dependencies (in which case we rely on the ``PrgEnv-*`` module to do the proper
    job).

 5. The craype module (compiler wrappers), unless both PrgEnv-* is
    loaded explicitly and the module is not in the list of dependencies (in which case
    we rely on the ``PrgEnv-*`` module to do the proper job).

 6. The specified dependencies, minus the ``cpe/*``, ``PrgEnv-*`` and ``craype/*``
    modules.

 7. The ``cpe/<CPE_version>`` module, if ``CPE_load`` is ``last``.

    In principle this should reload any module loaded before in a version that does
    not match the selected Cray PE version, and hence will also overwrite versions
    set in the dependencies. However, in the Cray PE 21.04 release (which was used
    for testing) the module did not always do the reloads in the proper order to always
    ensure the right version, and one might even end up with a version that is neither
    the one specified in the dependencies nor the one specified by the ``cpe/*`` module.


## Some examples


### Non-working: Load cpe and PrgEnv-gnu

This is the default configuration for this EasyBlock.
A minimal EasyConfig (omitting some mandatory parts such the ``homepage`` and ``description``
parameters) is

```python
easyblock = 'CrayPEToolchain'

name = 'cpeGNU'
version = "21.04"

toolchain = SYSTEM

moduleclass = 'toolchain'

```
This generates a module file that activates the toolchain by only loading the
``cpe/21.04`` and ``PrgEnv-gnu``-modules (in that order). Unfortunately, this scheme
does not work with LMOD 8.3.x as is part of the Cray PE stack when the 21.04-21.06 releases
were made, nor with version from the 8.4 and 8.5 branches, as LMOD_MODULERCFILE is only
honoured at the next ``module`` call. If the effect of ``LMOD_MODULERCFILE`` would
be immediate, this would probably be the most efficient way of activating a particular
release of a particular PrgEnv. The module does not belong to any family. Instead it
explicitly unloads other ``cpe*`` modules.

### Non-working: Load PrgEnv-gnu and then cpe

Now we first load a ``PrgEnv-*`` module and only subsequently the ``cpe/yy.mm`` module
that fixes versions for the modules.
```python
easyblock = 'CrayPEToolchain'

name = 'cpeGNU'
version = "21.04"

toolchain = SYSTEM

PrgEnv_family = 'cpeToolchain'
CPE_load = 'after'

moduleclass = 'toolchain'

```
This generates a module file that activates the toolchain by first loading the ``PrgEnv-gnu``
module and then correcting the versions by loading ``cpe/21.04``. This doesn't work
reliably either due to the current design of the module reloading process in the ``cpe/21.04``
module combined with the delayed impact of changes to ``LMOD_MODULERCFILE``.

The module will belong to the ``cpeToolchain`` family. That family will take care of
unloading any other ``cpe*`` module that would be loaded (provided the ``PrgEnv_family``
parameter was set the same way in their EasyConfigs), while the ``PrgEnv-gnu`` module
will take care of unloading other ``PrgEnv-*`` modules through the ``PrgEnv`` family.

### A setup without PrgEnv- or cpe module

On LUMI, due to the problems with LMOD and the cpe modules, we currently use a setup
without ``PrgEnv-*`` or ``cpe`` module. One of the functions of the ``cpe`` module,
setting the default versions of the Cray PE components, is already done by the ``LUMI``
module that loads the software stack. The other is replaced by hard-coding the necessary
versions in the EasyConfig. One of the functions of the ``PrgEnv-*`` modules, setting
and environment variable that tells the compiler wrappers which PE is selected, is
taken over by the EasyBlock which sets the variable in the module file that it generates.
The other, loading the correct targets and other PE modules, is taken over by the ``craype_targets``
parameter and the dependency list. This is the most reproducible setup as it only depends
on versioned components (the ``partition`` module already ensures that a particular version
of the Cray targeting modules is made available).
```python
easyblock = 'CrayPEToolchain'

name = 'cpeGNU'
version = "21.04"

toolchain = SYSTEM

PrgEnv_load = False
PrgEnv_family = 'PrgEnv'
CPE_load = None

cray_targets = [
    'craype-x86-rome',
    'craype-accel-host',
    'craype-network-ofi'
]

dependencies = [
   ('gcc/9.3.0',              EXTERNAL_MODULE),
   ('craype/2.7.6',           EXTERNAL_MODULE),
   ('cray-mpich/8.1.4',       EXTERNAL_MODULE),
   ('cray-libsci/21.04.1.1',  EXTERNAL_MODULE),
   ('cray-dsmml/0.1.4',       EXTERNAL_MODULE),
   ('perftools-base/21.02.0', EXTERNAL_MODULE),
   ('xpmem',                  EXTERNAL_MODULE),
]

moduleclass = 'toolchain'
```
The ``cpeGNU`` module generated by this EasyConfig will be unloaded if the user would
load a ``PrgEnv-*`` module as it is also a member of the ``PrgEnv`` family. As such
it is a full replacement of the Cray ``PrgEnv-gnu`` module.


### Loading the cpe and PrgEnv modules first, then reloading packages just to be sure

A compromise solution that will work around the problems with LMOD and the ``cpe``
modules yet retain much of the spirit of the Cray PE, and that also can correct the
targeting modules should the ``PrgEnv-*`` module not take the ones that you want
(or ensure that at least certain other modules are loaded, even if they would be
removed from the list of modules loaded by ``PrgEnv-gnu`` in an update of the system), is
the following setup:
```python
easyblock = 'CrayPEToolchain'

name = 'cpeGNU'
version = '21.04'

toolchain = SYSTEM

CPE_load = 'first'
PrgEnv_load = True
PrgEnv_family = 'cpeToolchain'

cray_targets = [
    'craype-x86-rome',
    'craype-accel-host',
    'craype-network-ofi'
]

dependencies = [
   ('PrgEnv-gnu/8.0.0',       EXTERNAL_MODULE),
   ('gcc/9.3.0',              EXTERNAL_MODULE),
   ('craype/2.7.6',           EXTERNAL_MODULE),
   ('cray-mpich/8.1.4',       EXTERNAL_MODULE),
   ('cray-libsci/21.04.1.1',  EXTERNAL_MODULE),
   ('cray-dsmml/0.1.4',       EXTERNAL_MODULE),
   ('perftools-base/21.02.0', EXTERNAL_MODULE),
   ('xpmem',                  EXTERNAL_MODULE),
]

moduleclass = 'toolchain'
```
This setup will first load the ``cpe/21.04`` and ``PrgEnv-gnu/8.0.0`` modules to stay in
the Cray PE spirit. Next the indicated targeting modules will be loaded, one for the
CPU, one for the accelerator architecture and one for the network. This may trigger
reloads of some other modules and will overwrite targeting modules of the same type
loaded by ``PrgEnv-gnu``. Finally, the gcc compiler module, the craype module and all
other modules from the dependency list are loaded with the versions specified.

This setup is a compromise that on one hand stays close to the Cray PE spirit by using
the ``cpe`` and ``PrgEnv-gnu`` modules, yet works around some problems, namely:
  * Setting ``LMOD_MODULERCFILE`` does not work immediately.
  * Any corrective action when loading ``cpe`` after ``PrgEnv-gnu`` does not work
  * On a heterogeneous cluster, the targeting modules loaded by ``PrgEnv-gnu`` may
    not be the ones you want when cross-compiling or when the system would use the same
    file defining the modules for the whole system.
  * The list of modules loaded by ``PrgEnv-gnu`` may change as it is determined by
    a single file on the system that does not depend on the version of the Cray PE.
    In this case, you can always be sure that at least the modules mentioned in the
    dependency list and ``cray_targets`` parameter will be loaded.

A variant of this would set ``CPE_load = 'after'`` which would load the ``cpe/21.04``
module immediately after loading ``PrgEnv-gnu`` rather than just before, but with the
current flaws of the ``cpe/21.04`` module this still does not solve all problems.
