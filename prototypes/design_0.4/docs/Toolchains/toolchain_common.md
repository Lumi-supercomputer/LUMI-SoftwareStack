# Common toolchain options

## Optimization level

EasyBuild distinguishes between four optimization levels. Rather than having a single
toolchain option that takes the level as a number, ``toolchainopts`` uses four boolean
parameters where one takes precedence over others. Lower optimization takes precedence
over higher optimization. All have as default value ``False`` yet ``defaultopt`` is
the one that will be used if nothing is specified.

| Option     | What?                          |
|:-----------|:-------------------------------|
| noopt      | Disable compiler optimizations |
| lowopt     | Low compiler optimizations     |
| defaultopt | Default compiler optimizations |
| opt        | High compiler optimizations    |

Other optimization-related options (and see also parallelism below):

| Option  | What?                                              |
|:--------|:---------------------------------------------------|
| unroll  | Unroll loops (default: False)                      |
| optarch | Enable architecture optimizations (default: False) |


## Floating point accuracy

There are five flags that set the floating point precision. All are ``False`` by default
but ``defaultprec`` is taken if none of the options is set to ``True``. Again, the
first one that is set to ``True`` in the table below is used:

| Option      | What?                      |
|:------------|:---------------------------|
| strict      | Strict (highest) precision |
| precise     | High precision             |
| defaultprec | Default precision          |
| loose       | Loose precision            |
| veryloose   | Very loose precision       |

Other floating-point optimisation and accuracy-related flags:

| Option | What?                                     |
|:-------|:------------------------------------------|
| ieee   | Adhere to IEEE-754 rules (default: False) |


## Common parallelism-related options

| Option    | What?                                                                   |
|:----------|:------------------------------------------------------------------------|
| vectorize | Enable compiler auto-vectorization, default except for noopt and lowopt |
| openmp    | Enable OpenMP (default: False)                                          |
| usempi    | Use MPI compiler as default compiler (default: False)                   |

The ``usempi`` option is only supported by toolchains that also include an MPI component.

## Code generation and linking options

| Option                | What?                                 |
|:----------------------|:--------------------------------------|
| 32bit                 | Compile 32bit target (default: False) |
| debug                 | Enable debug (default: False)         |
| pic                   | Use PIC (default: False)              |
| packed-linker-options | No flag, internal to EasyBuild        |
| shared                | Build shared library (default: False) |
| static                | Build static library (default: False) |
| rpath                 | No flag, internal to EasyBuild        |


## Source-related options

| Option | What?                                                        |
|:-------|:-------------------------------------------------------------|
| cstd   | Specify C standard (C/C++ only - default: None)              |
| i8     | Integers are 8 byte integers (Fortran only - default: False) |
| r8     | Real is 8 byte real (Fortran only - default: False)          |


## Miscellaneous options

| Option         | What?                                           |
|:---------------|:------------------------------------------------|
| verbose        | Verbose output (default: False)                 |
| cciscxx        | Use CC as CXX (default: False)                  |
| extra_cflags   | Specify extra CFLAGS options. (default: None)   |
| extra_cxxflags | Specify extra CXXFLAGS options. (default: None) |
| extra_f90flags | Specify extra F90FLAGS options. (default: None) |
| extra_fcflags  | Specify extra FCFLAGS options. (default: None)  |
| extra_fflags   | Specify extra FFLAGS options. (default: None)   |

Most of these options do not directly transform into compiler flags. Instead, they influence
the way EasyBuild sets variables (``cciscxx``)  or directly add additional flags to
the indicated environment variables.
