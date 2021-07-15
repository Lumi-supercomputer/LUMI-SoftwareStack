# cpeGNU toolchain

## Available options

The cpeGNU toolchain supports the [common toolchain options](toolchain_common.md),
the additionsl GCC flags and some additions Cray-specific flags, two of which are
really just redefinitions of standard compiler flags.


### GCC-specific flags

| Option | Categorie       | What?                                     |
|:-------|:----------------|:------------------------------------------|
| loop   | parallelism     | Automatic loop parallellisation           |
| f2c    | source          | Generate code compatible with f2c and f77 |
| lto    | code generation | Enable Link Time Optimization             |


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

| Option     | Flag |
|:-----------|:-----|
| noopt      | -O0  |
| lowopt     | -O1  |
| defaultopt | -O2  |
| opt        | -O3  |

Other optimization-related options (and see also parallelism below):

| Option  | Flag           |
|:--------|:---------------|
| unroll  | -funroll-loops |
| optarch | TODO           |


### Floating point precision

| Option      | Flag                                     |
|:------------|:-----------------------------------------|
| strict      | -mieee-fp -mno-recip                     |
| precise     | -mno-recip                               |
| defaultprec | -fno-math-errno                          |
| loose       | -fno-math-errno -mrecip -mno-ieee-fp     |
| veryloose   | -fno-math-errno -mrecip=all -mno-ieee-fp |

Other floating-point optimisation and accuracy-related flags:

| Option | What?                        |
|:-------|:-----------------------------|
| ieee   | -mieee-fp -fno-trapping-math |


## Common parallelism-related options

| Option    | Flag                                                                       |
|:----------|:---------------------------------------------------------------------------|
| vectorize | False: -fno-tree-vectorize                                                 |
|           | True: -ftree-vectorize                                                     |
| loop      | -ftree-switch-conversion -floop-interchange -floop-strip-mine -floop-block |
| openmp    | -ffopenmp                                                                  |
| usempi    | No compiler flags                                                          |
| mpich-mt  | -craympich-mt                                                              |


## Code generation and linking options

| Option                | Flag                                                                                 |
|:----------------------|:--------------------------------------------------------------------------------------|
| 32bit                 | -m32                                         |
| debug                 | -g               |
| pic                   | -fPIC                  |
| packed-linker-options | Pack the linker options as comma separated list (default: False)                      |
| shared                | -shared                 |
| static                | -static                 |
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


