# What's new or different?

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
