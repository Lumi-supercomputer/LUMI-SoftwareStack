# Overview of test cases

## Cray way: Load cpe/yy.mm and PrgEnv-*

Note that due to problems with LMOD this does not work as one would expect in the programming
environment releases 21.04 to 21.06 and possibly others that we could not test.

  * ``cpeGNU-21.04-minimal-first-defaults.eb``: Relying maximally on the default values
    of paramters, and with manual unloading of other ``cpe*`` and ``PrgEnv-*`` modules.
  * ``cpeGNU-21.04-minimal-first-fullpar.eb``: With specifying all parameters, even
    if the default values are used, and manual unloading of other ``cpe*`` and ``PrgEnv-*``
    modules.
  * ``cpeGNU-21.04-minimal-first-cpeToolchain.eb``: Relying maximally on default parameters
    and creating a module of the ``cpeToolchain`` family rather than explicitly unloading
    other ``cpe*`` and ``PrgEnv*`` modules.

## Cray way: Load PrgEnv-* and then cpe/yy.mm

Note that due to problems with LMOD and with the cpe/yy.mm module files, this does not work as
one would expect in the programming environment releases 21.04 to 21.06 and possibly others
that we could not test.

  * ``cpeGNU-21.04-minimal-last-defaults.eb``: Relying maximally on the default values
    of paramters, and with manual unloading of other ``cpe*`` and ``PrgEnv-*`` modules.
  * ``cpeGNU-21.04-minimal-last-fullpar.eb``: With specifying all parameters, even
    if the default values are used, and manual unloading of other ``cpe*`` and ``PrgEnv-*``
    modules.
  * ``cpeGNU-21.04-minimal-last-cpeToolchain.eb``: Relying maximally on default parameters
    and creating a module of the ``cpeToolchain`` family rather than explicitly unloading
    other cpe* and PrgEnv* modules.
  * ``cpeGNU-21.04-minimal-after-defaults.eb``: Relying maximally on the default values
    of paramters, and with manual unloading of other ``cpe*`` and ``PrgEnv-*`` modules.
  * ``cpeGNU-21.04-minimal-after-fullpar.eb``: With specifying all parameters, even
    if the default values are used, and manual unloading of other ``cpe*`` and ``PrgEnv-*``
    modules.
  * ``cpeGNU-21.04-minimal-after-cpeToolchain.eb``: Relying maximally on default parameters
    and creating a module of the ``cpeToolchain`` family rather than explicitly unloading
    other cpe* and PrgEnv* modules.

## The Cray way, but then correct with hard-coded versions

  * ``cpeGNU-21.04-cpe-PrgEnv-overwrite.eb``: Module of the ``cpeToolchain`` family, loads
    a ``cpe/yy.mm`` module first and then a ``PrgEnv-*`` module, and then explicitly overwrites
    the target modules and other modules to be sure that at least a number of modules
    are loaded in the correct version. This also uses the modules very much in the
    Cray way while still reproducing reasonable reproducibility and avoiding the problems
    that currently exist with the ``cpe/yy.mm`` modules.
  * ``cpeGNU-21.04-PrgEnv-cpe-overwrite.eb``: Same as the previous case, but first
    loading ``PrgEnv-*`` and then ``cpe/yy.mm``.

## Fully manual, without cpe/yy.mm and PrgEnv-*

The idea is to get the same effect as loading a ``cpe/yy.mm`` and ``PrgEnv-*`` module, but
without using any of these to

 1. avoid the problems that plague the ``cpe/yy.mm`` modules (at least in their LMOD
    version up to and including at least the 21.06 release),
 2. avoid the problem that the what PrgEnv-* does, may evolve over time as it is
    determined by a single file on the system that is common to all releases.

  * ``cpeGNU-21.04-noPrgEnv-nocpe.eb``: All modules are loaded via ``cray_targets`` and
    ``dependencies`` for optimal reproducibility, module of family ``PrgEnvb``.

## Some combinations that may make less sense but are useful tests.

  * ``cpeGNU-21.04-hardcodedVersions.eb``: Manually unload other cpe* and PrgEnv-*
    modules, load a PrgEnv-* module, then overwrite with explicit versions, yet
    still load a cpe/yy.mm module at the end. This doesn't make much sense as the
    hard-coded versions may be overwritten again when loading the ``cpe/yy.mm`` module.
  * ``cpeGNU-21.04-CSCS.eb``: Emulates module that is used at CSCS, including a
    ``modluafooter`` field to add additional code to the module.
  * ``cpeGNU-21.G.04-minimal-first-versionChange-cpeToolchain.eb``: This is mainly
    a test for the ``CPE_version`` parameter, to see if we can load a different version
    of the ``cpe/yy.mm`` module than indicated by the version of the EasyConfig file.


