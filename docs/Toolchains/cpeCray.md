# cpeGNU toolchain

**NOTE: Stuff in italics has to be checked: Do these options really work?**

## Available options

The cpeCray toolchain supports the [common toolchain options](toolchain_common.md),
and some additional Cray-specific flags, two of which are
really just redefinitions of standard compiler flags.


### cpeCray-specific flags

| Option   | Categorie       | What?                                                                     |
|:---------|:----------------|:--------------------------------------------------------------------------|
| dynamic  | code generation | Generate dynamically linked executable (default: True)                    |
| mpich-mt | parallelism     | Alternate Cray-MPICH library for MT support (default: False)              |

mpich-mt: Directs the driver to link in an alternate version of the Cray-MPICH
library which provides fine-grained multi-threading support to applications that
perform MPI operations within threaded regions. (default: False)

Note that 'i8' and 'r8' do not work for the cpeCray toolchain as the compiler only
has an option to promote both types.

Two further options trigger different compiler flags than in the GCC toolchain: ``verbose``
and ``optarch`` but have otherwise the same meaning.


## Mapping of options onto compiler flags

### Some Cray-specific remarks

  * A number of options are different for the clang-based C/C++ compilers and Fortran
    compiler, something that EasyBuild cannot easily deal with. This is, e.g., the
    case for the options that set the floating point computation model, so for now
    these are left blank.

      * Fortran floating point optimisation and accuracy options: ``-hfp0`` to ``-hfp4``,
        with ``-hfp2`` the default according to the manual.

        *The manual only claims ``-hfp0`` to ``-hfp3``.*

      * For OpenMP the manual also claims a different option for the Fortran compiler,
        but it turns out that recent versions also support ``-fopenmp`` so no changes
        are needed with respect to the standard EasyBuild behaviour.

        *The manual claims that there is also a ``-fnoopenmp`` but that turns out to
        be wrong in cce 12.*

  * The situation about promoting integer and real in Fortran to 8 bytes is very confusing.
    Those options are not properly documented in the manuals. The Cray driver manual
    only mentions ``-default64`` which according to the documentation is then converted
    to ``-sdefault64``. In the documentation, there is mention of ``-sreal64`` (or
    ``-s real64`), but this option is nowhere to be found in the list of compiler options.
    However, it turns out that ``-sinteger64``(or ``-s integer64``) and ``-sreal64``
    (or ``-s real64``) both exist and do what is expected from them.

*TODO: Check if -flto exist in Fortran and C and if so, add to the options.*


### Compiler optimization level

The [common options](toolchain_common.md) translate into:

| Option     | Flag |
|:-----------|:-----|
| noopt      | -O0  |
| lowopt     | -O1  |
| defaultopt | -O2  |
| opt        | -O3  |

Other optimization-related options (and see also parallelism below):

| Option   | Flag       |
|:---------|:-----------|
| *unroll* | *-funroll* |
| optarch  | TODO       |


### Floating point precision

**These flags are currently not correctly honoured.**

| Option        | Flag |
|:--------------|:-----|
| *strict*      | /    |
| *precise*     | /    |
| *defaultprec* | /    |
| *loose*       | /    |
| *veryloose*   | /    |

Other floating-point optimisation and accuracy-related flags:

| Option   | What? |
|:---------|:------|
| *ieee*   | /     |


## Common parallelism-related options

| Option      | Flag              |
|:------------|:------------------|
| *vectorize* | /                 |
| openmp      | -fopenmp          |
| usempi      | No compiler flags |
| mpich-mt    | -craympich-mt     |


## Code generation and linking options

| Option                | Flag                                                                                  |
|:----------------------|:--------------------------------------------------------------------------------------|
| dynamic               | No flag as this is currently the only mode supported                                  |
| 32bit                 | -m32                                                                                  |
| debug                 | -g                                                                                    |
| pic                   | -fPIC                                                                                 |
| packed-linker-options | Pack the linker options as comma separated list (default: False)                      |
| shared                | -shared                                                                               |
| static                | -static                                                                               |
| rpath                 | Use RPATH wrappers when --rpath is enabled in EasyBuild configuration (default: True) |


## Source-related options

| Option | Flag           |
|:-------|:---------------|
| cstd   | -std=%(value)s |
| i8     | -sinteger64    |
| r8     | -sreal64       |


## Miscellaneous options

| Option         | Flag            |
|:---------------|:----------------|
| verbose        | -craype-verbose |


