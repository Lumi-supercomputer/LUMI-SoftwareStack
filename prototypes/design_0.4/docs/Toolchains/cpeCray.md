# cpeGNU toolchain

**NOTE: Stuff in italics has to be checked: Do these options really work?**

## Available options

The cpeCray toolchain supports the [common toolchain options](toolchain_common.md),
and some additional Cray-specific flags, two of which are
really just redefinitions of standard compiler flags.


### cpeCray-specific flags

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

| Option   | Flag       |
|:---------|:-----------|
| *unroll* | *-funroll* |
| optarch  | TODO       |


### Floating point precision

**These flags are currently not correctly honoured.**

| Option        | Flag |
|:--------------|:-----|
| *strict *     | /    |
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
| openmp      | -homp             |
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
| *i8*   | /              |
| *r8*   | /              |


## Miscellaneous options

| Option         | Flag            |
|:---------------|:----------------|
| verbose        | -craype-verbose |


