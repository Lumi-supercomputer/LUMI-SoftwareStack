# The CrayPEToolchain EasyBlock and cpeCray/cpeGNU/cpeAMD modules

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

  * ''PrgEnv'': Sets the ``PrgEnv-*`` module to load or emulate.
      * The default is to derive the value from the name of the module to generate:
          * ``PrgEnv = 'cray'`` for ``cpeCray``
          * ``PrgEnv = 'gnu'`` for ``cpeGNU``
          * ``PrgEnv = 'aocc'`` for ``cpeAMD``
          * ``PrgEnv = 'intel'`` for ``cpeIntel``
          * ``PrgEnv = 'pgi'`` for ``cpeNVIDIA`` (not tested as we have no access to
            a machine with this environment)
      * It is also possible to specify any of these values, or even a different value for a
        ``PrgEnv-*`` module that is not yet recognized by the EasyBlock.

  * ``CPE_compiler`` specifies the (versionless) compiler to load. Possible values are:

      * ``auto`` (default): Derive the name of the compiler module from the name of the
        module to generate. This does not yet work for ``cpeNVIDIA`` as it is not clear
        what the name of the compiler module will be.

        If will not add an additional load if that compiler module is already specified
        in the dependencies.

        Note that this will load the module without specifying the version, so it only
        makes sense to rely on the autodetect feature if the ``cpe`` module is loaded
        (and if the bugs with that one are fixed).

      * ''None'': Do not load the compiler module, rely on the list of dependencies instead
        to load the compiler module.

      * Any other value will be considered the name of the compiler module to load.
        The module should be versionless. If you want to specify a version, you can
        do so via ``dependencies``.

        No separate load will be generated if the compiler module is also found in
        the list of dependencies.

  * ``CPE_version``: Version of the cpe module to use (if it is used). Possible values:

      * ''None''(default): Determine the version from the version of the module to generate,
        i.e., the ``version`` parameter in the EasyConfig.

      * Any other value is interpreted as the value to load.

  * ``PrgEnv_load``: Boolean value, indicate if the ``PrgEnv`` module should be loaded
    explicitly (if True) or not (if False).

    Default is ``True``.

  * ``PrgEnv_family``:

      * If False, the module will start with unload commands for all ``PrgEnv-`` modules
        recognized by the EasyBlock. We do not unload the module that would be loaded
        by the cpe* module and hence.

      * If True, the module will declare itself a member of the ''PrgEnv-``
        family. This will generate an error if ``PrgEnv_load`` is also True as one
        cannot load two modules of the same family.

      * The default is ``False``.

    If you want to hard-code a version, you can do so by specifying the module with
    the version in the dependencies.

  * ``PrgEnv_version``: Specify the version of the PrgEnv module to load (if one is
    loaded). This may be great for optimal reproducibility, but is rarely really needed,
    and not needed if the cpe modules work correctly.

  * ``CPE_load``:  Possible values:

      * ``first``: Load as the very first module. This does not make sense until the LMOD
        problems with ``LMOD_MODULERCFILE`` are fixed.

      * ``last``(default): Load as the last module. Currently this does not make sense until
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

 2. The ``PrgEnv-<PrgEnv>`` module, if ``PrgEnv_load`` is True.

 3. The targeting modules specified by ``cray_targets``

 4. The ``CPE_compiler`` module (or autodected one), unless both
    PrgEnv-* is loaded explicitly and the module is not in the list
    of dependencies.

 5. The craype module (compiler wrappers), unless both PrgEnv-* is
    loaded explicitly and the module is not in the list of dependencies.

 6. The specified dependencies

 7. The ``cpe/<CPE_version>`` module, if ``CPE_load`` is ``last``.

