# What's new or different?

## Toolchain setup compared to the CSCS setup of June 2021

**TODO** Outdated!


  * The AOCC compiler definition file ``aocc.py`` has been re-implemented based
    on the compiler flags of the clang compiler from which the compiler is derived
    as the GCC-based options that were in there really make no sense.
  * Several modifications to the CPE compiler file ``cpe.py``:
      * The Cray compiler wrappers provide ``-openmp`` and ``-noopenmp`` flags to
        turn OpenMP on or off, and these should work with all supported compilers.
        These were implemented to solve the problem that for the CCE compilers
        with the Classic Cray Fortran compiler but new clang-based C compiler
        the options for enabling OpenMP are different which is something that
        is not appreciated by EasyBuild.
      * More options are picked up from the definition files of the compilers
        that are actually used rather than just the floating point precision
        options which should make the behaviour of the Cray toolchains more
        similar to their regular counterparts and hence EasyConfig files
        easier to port over if they use special settings via ``toolchainopts``.