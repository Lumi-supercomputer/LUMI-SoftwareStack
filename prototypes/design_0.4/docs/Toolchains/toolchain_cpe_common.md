# EasyBuild CPE toolchains

## General principles

The toolchains for the CPE in this repository have been developed from those of CSCS.
Several changes have been made though.

  * The AMD AOCC toolchain was very incomplete: It relied on a definition for the AOCC
    compiler that was derived from GCC rather than from the Clang one, so most of the
    options didn't really work.

    We also changed the floating point accuracy options compared to those used in the
    Clang compiler definition as they produced warnings about combinations that don't
    make sense.

  * Some corrections were made to the Cray CCE compiler definition. In particular we
    added the correct options to support the ``-i8`` and ``-r8`` toolchain options
    for Fortran data types.

    We also had a look at better options for the floating point accuracy but there
    we ran into the problem that the options for the Cray compiler are different for
    the Fortran and C/C++ compilers, something that the option mapping mechanism in
    EasyBuild cannot deal with.

    For OpenMP there was an easy solution as it turns out that the Fortran compiler
    now does support ``-fopenmp`` as an alternative for ``-homp`` so there a single
    option that works for both the Fortran and new Clang-based C/C++ compilers is
    available.

  * The code for processing ``--optarch``/``EASYBUILD_OPTARCH`` was extended to be more
    in line with how other toolchain definitions process that code, and to prepare for
    the GPUs where we may want to load multiple targeting modules (one for the CPU and
    one for the GPU, or even one for the network). It is now possible to specify the
    argument to ``optarch`` for multiple compilers. For the Cray toolchains, the name
    ``CPE`` is used. This makes it possible to also support more traditional EasyBuild
    toolchains simultaneously from the same setup should the need arrise.

    We did stick to the approach of loading the targeting modules rather than using
    the compiler flags ``-target-cpu``, ``-target-accel`` and ``-target-network`` as
    now the implementation doesn't need to figure out which module is of which type
    (though that is very easy to do).

The CSCS implementation used a common setup to all CPE compilers. For LUMI, this path
is left for now as it turned out the code was incomplete and it was difficult to
complete the code and to get it working in all circumstances. Not all default options
of the regular GNU and AOCC compilers were picked up by their corresponding CPE compiler
definitions. Moreover, the generic approach does not work with toolchain options that
do not simply map onto compiler options. This may change in a future edition again
when it becomes clearer which code is really common to all Cray compiler definitions
and which code is specialised for a particular compiler.

In the process we also ran into several bugs in the EasyBuild toolchain definitions
that define toolchain options that are never picked up and translated into compiler
flags because the compiler definition fails to add them to
``COMPILER_C_UNIQUE_FLAGS``/``COMPILER_F_UNIQUE_FLAGS`` (likely the recommended way)
or to push them onto the list ``COMPILER_FLAGS`` defined in the ``compiler.py`` generic
compiler definition from which all other compiler definitions inherit.

## Specifying the targets through --optarch/EASYBULD_OPTARCH

The actual architecture arguments are specified through the names of the corresponding
targeting modules but dropping the ``craype-`` prefix from their name. Multiple options
can be specified by using a ``+``-sign between two options. However, only one CPT target,
one accelerator target and one network target should be specified as otherwise the
second will overwrite the first one anyway. If you want to specify options for multiple
compilers, you can use the regular EasyBuild syntax for that, labeling the options
for the Cray toolchains with ``CPE:``.

The ``GENERIC`` target is currently not supported for the Cray compilers because it is not
clear how to do that in a system-independent way on Cray systems. There may be modules that
define a generic architecture, but if they exist they are certainly not installed on all
Cray systems.

Some examples are

  * ''EASYBUILD_OPTARCH=x86-rome``: Defines only an architecture for the Cray compilers,
    in this case it tells EasyBuild to optimize for the AMD Rome processor.
  * ``EASYBUILD_OPTARCH=x86-milan+accel-AMD-gfx90A+network-ofi``: Tells EasyBuild to
    target for the AMD Milan CPU, AMD gfx90A GPU (which is the likely module name for
    the MI 200) and OFI network stack.
  * ``EASYBULD_OPTARCH=CPE:x86-rome;Intel:march=core-avx2 -mtune=core-avx2;GCC:march=znver2 -mtune=znver2"``
    would set a compiler target for the Cray toolchains, the Intel compilers used through the
    regular EasyBuild common toolchains and the GNU compilers, again used through
    the regular EasyBuild common toolchains, in each case specifying options suitable
    for the AMD Rome CPU.

