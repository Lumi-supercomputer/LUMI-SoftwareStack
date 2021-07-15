# cpeAMD toolchain

**TODO: The options are those from the GNU compilers instead of typical Clang options???**

Note: The options are for the ``aocc.py`` file included in this repository and are
not the same as those for the repository at CSCS.

## Note about the compilers

  * AOCC 2.1 is based on LLVM 9.0 release (llvm.org, 19th Sep 2019) with improved
    Flang Fortran frond-end added with F2008 features and bug fixes.
  * AOCC 2.2 is based on LLVM 10.0 release (llvm.org, 24th Mar 2020) with improved
    Flang Fortran front-end added with F2008 features and bug fixes.
  * AOCC 3.0 is based on LLVM 12 trunk (llvm.org, 22nd Oct 2020) with Flang as a Fortran front-end
    added with F2008, Real 128 features. AOCC 3.0 also includes the support for OpenMP Debugging
    Interface (OMPD) APIs.


## Available options

The cpeAMD toolchain supports the [common toolchain options](toolchain_common.md),
the additional AOCC flags and some additional Cray-specific flags, two of which are
really just redefinitions of standard compiler flags.


### AOCC-specific flags

AOCC supports a number of extensions that are similar to those of the GNU compiler.

| Option                | Categorie       | What?                                               |
|:----------------------|:----------------|:----------------------------------------------------|
| lto                   | code generation | Enable Link Time Optimization                       |
| loop-vectorize        | parallelism     | Explicitly enable/disable loop vectorization        |
| basic-block-vectorize | parallelism     | Explicitly enable/disable basic block vectorization |

### cpeGNU-specific flags

| Option   | Categorie       | What?                                                        |
|:---------|:----------------|:-------------------------------------------------------------|
| dynamic  | code generation | Generate dynamically linked executable (default: True)       |
| mpich-mt | parallelism     | Alternate Cray-MPICH library for MT support (default: False) |

mpich-mt: Directs the driver to link in an alternate version of the Cray-MPICH
library which provides fine-grained multi-threading support to applications that
perform MPI operations within threaded regions. (default: False)

Two further options trigger different compiler flags than in the GCC toolchain: ``verbose``
and ``optarch`` but have otherwise the same meaning.


## Mapping of options onto compiler flags

### Compiler optimization level

The [common options](toolchain_common.md) translate into:

| Option     | Flag                            |
|:-----------|:--------------------------------|
| noopt      | -O0                             |
| lowopt     | -O1                             |
| defaultopt | -O2 -fvectorize -fslp-vectorize |
| opt        | -O3                             |

Other optimization-related options (and see also parallelism below):

| Option  | Flag           |
|:--------|:---------------|
| unroll  | -funroll-loops |
| optarch | TODO           |


### Floating point precision

The decision of our mapping is based partly on information from Cray and partly on
looking through various manuals on Clang.

  * Level ``strict``: We simply stick to ``-ffp-model=strict``. This automatically disables
    all of the ``-ffast-math`` enablements so there is no need to add ``-fno-fast-math``.
    Note that at this level, fused multiply adds are disabled.
  * Level ``precise``: We stick to ``-ffp-model=precise`` and add ``-ffp-contract=fast-honor-pragmas``.
  * Default level: Currently the same as ``strict``.
  * Level ``loose``: Set to ``-ffp-model=fast`` but try to turn on again a few safeguards:
    ``-ffp-contract=fast-honor-pragmas``, ``-fhonor-infinities``, ``-fhonor-nans``,
    ``-fsigned-zeros``.
  * Level ``veryloose``: Set to ``-ffp-model=fast``

Note: Very recnet versions of clang add ``-ffp-contract=fast-honor-pragmas`` which
may be interesting to add to ``precise``, ``defaultprec`` and ``loose`` but is not
yet supported by AOCC 2.2.

| Option      | Flag                                                           |
|:------------|:---------------------------------------------------------------|
| strict      | -ffp-model=strict                                              |
| precise     | -ffp-model=precise                                             |
| defaultprec | -ffp-model=precise                                             |
| loose       | -ffp-model=fast -fhonor-infinities -fhonor-nans -fsigned-zeros |
| veryloose   | -ffp-model=fast                                                |

Other floating-point optimisation and accuracy-related flags:

| Option | What?                        |
|:-------|:-----------------------------|
| ieee   | Not supported in clang/flang |


## Common parallelism-related options

| Option    | Flag                                                                       |
|:----------|:---------------------------------------------------------------------------|
| vectorize | False: -fno-vectorize -fno-slp-vectorize                                                 |
|           | True: -fvectorize -fslp-vectorize                                                     |
| loop      | -ftree-switch-conversion -floop-interchange -floop-strip-mine -floop-block |
| openmp    | -fopenmp                                                                   |
| usempi    | No compiler flags                                                          |
| mpich-mt  | -craympich-mt                                                              |


## Code generation and linking options

| Option                | Flag                                                                                  |
|:----------------------|:--------------------------------------------------------------------------------------|
| dynamic               | No flag as this is currently the only mode supported                                  |
| lto                   | -flto
| 32bit                 | -m32                                                                                  |
| debug                 | -g                                                                                    |
| pic                   | -fPIC                                                                                 |
| packed-linker-options | Pack the linker options as comma separated list (default: False)                      |
| shared                | -shared                                                                               |
| static                | -static                                                                               |
| rpath                 | Use RPATH wrappers when --rpath is enabled in EasyBuild configuration (default: True) |


## Source-related options

| Option | Flag                |
|:-------|:--------------------|
| cstd   | -std=%(value)s      |
| i8     | -fdefault-integer-8 |
| r8     | -fdefault-real-8    |
| f2c    | -ff2c               |


## Miscellaneous options

| Option         | Flag            |
|:---------------|:----------------|
| verbose        | -craype-verbose |


