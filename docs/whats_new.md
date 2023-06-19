# What's new or different?

  * 2023-06-19: `module avail` now also shows the hugepages modules
    and the relevant target modules for the partition.

  * 2023-06-16: EasyBuild now clears the user cache to force a 
    regeneration of the cache.

  * 2023-04-11: Various improvements to the generation of the files
    that contain information for Lmod about the CPE and the visibility
    hook.
  
  * Several updates missing...

  * 2022-04-22: Corrections to the EasyBuild-config modules to avoid
    having twice the same directory in the output of searches.

  * 2022-03-01: Not every non-development stack should be marked as a
    LTS stack as it turns out to be very difficult to guarantee longevity
    of the software stack. Hence there is now a table at the top of
    SitePackage.lua to mark which stacks are LTS.

  * 2022-03-01: Option to turn off the tip in the message-of-the-day or
    even the whole message-of-the-day.

  * 2022-02-24: Hiding cpe-cuda modules via LMOD/modulerc.lua as they don't
    make sense on LUMI.

  * 2022-02-23: Added support for a system partition with software that is
    available everywhere, EasyBuild-CrayEnv has been replaced with
    EasyBuild-production.

  * 2021-12-15: Moved the list of default modules to load out of CrayEnv to
    SitePackage.lua so and now also load target modules in the LUMIpartition
    module so that users who want to use PrgEnv instead of cpeGNU/cpeCray/cpeAMD
    get the right target modules.

  * 2021-12-14: Added init-lumi, a module to finish the initialisation that is
    called from the Cray PE initialisation process. The module also adds to
    the message-of-the-day and adds a fortune-like tip about using LUMI.

  * 2021-12-14: Removed adding the overwrite CPE modules to the MODULEPATH in
    CrayEnv and LUMI (actually the partition modules) as at system rollout it
    seemed they created as much problems as they solved.

  * 2021-10-26: Implemented a dummy partition ``CrayEnv`` in the LUMI software
    stack to cross-install to CrayEnv to offer a simple way to install additional
    tools using the SYSTEM toolchain only.

  * 2021-10-19: Removed the ``EB`` level in the directory hierarchy for binaries
    in the EasyBuild-user installation as the whole tree is only meant for
    EasyBuild-installed software.

  * 2021-09-21: Added a new toolchain option to cpeGNU: ``gfortran9-compat`` that
    adds compatibility flags to ``FFLAGS``, ``FCFLAGS`` and ``F90FLAGS`` to improve
    compatibility with gfortran 9. Currently this is only
    ``-fallow-argument-mismatch``.

  * 2021-09-14: Loading a LUMI software stack module now also sets the environment
    variable LUMI_STACK_CPE_VERSION which can be used to know which version of the
    CPE the software stack is for (useful if stack is a development stack with
    name ending on .dev)

  * 2021-09-14: Added the ``tools`` subdirectory with scripts that we want to make
    available in the PATH and that are useful for any user, not just for a one-time
    setup of the repository or adding a new software stack to the repository (the
    latter remain in the ``scripts`` subdirectory and are not put in the PATH when
    loading one of our EasyBuild configuration modules).

  * 2021-08-11: Added the [LUMI-EasyBuild-contrib](https://github.com/Lumi-supercomputer/LUMI-EasyBuild-contrib)
    repository and made it part of the search path (but not of the robot path)
    of the EasyBuild-* modules.

  * 2021-08-03: Changed the SitePackage.lua function that detects the LUMI partition,
    and this has influence on how the repository should be used for testing.

      * The environment variable LUMI_OVERWRITE_PARTITION is now used to overwrite
        any automatic selection of the partition.

      * A demo selection process based on the hostname was implemented:

          * On eiger uan01 and uan02 the partition is set to L

          * On eiger uan03 the partition is set to common

          * On all other hosts we first check for the environment variable
            LUMI_PARTITION and use that one and otherwise we set the partition
            to L.

    The ``enable_LUMI.sh`` script now sets ``LUMI_OVERWRITE_PARTITION`` rather than
    ``LUMI_PARTITION`` so if you use that script to set the environment, you shouldn't
    note anything.


## Toolchain setup compared to the CSCS setup of June 2021

  * The CSCS definition for ``cpeAMD`` relied on a definition of the
    ``aocc`` compilers that used GNU compiler options that likely did not always work
    and couldn't be found in the AOCC manuals. They have been replaced with Clang-based
    options.

  * The single implementation for all ``cpe*`` compilers in ``compilers/cpe.py`` has
    been replaced by a different implementation for each compiler. The reasons are
    that

      * Not all data that should be copied from the non-Cray versions of the compiler
        to configure the compiler was actually copied.

      * We found bugs in the implementation of the GNU compilers in EasyBuild and by
        using a separate file could work around them until we now for sure they are
        bugs and what the original intent was.

      * Some compiler options may not map onto a flag but may need further processing,
        and having separate files makes that a bit easier until we have enough insight
        in all problems that may occur to bundle them again in a single implementation.

  * Improvements to the Cray compiler file:

      * The Cray compiler wrappers provide ``-openmp`` and ``-noopenmp`` flags to
        turn OpenMP on or off, and these should work with all supported compilers.
        These were implemented to solve the problem that for the CCE compilers
        with the Classic Cray Fortran compiler but new clang-based C compiler
        the options for enabling OpenMP are different which is something that
        is not appreciated by EasyBuild.
