# Some known potential issues in the 21.06 LUMI stack

  * **ELPA**: So far this library fails to compile with the Cray and AMD
    Fortran compilers.

  * **MPFR**: Two tests are skipped when compiled with the Clang-based cpeCray and
    cpeAMD toolchains while all tests are executed and passed with cpeGNU.

  * **snappy**: Version 1.1.9 does not install. It needs additional GNU tools and
    also complains that a CMakeLists.txt file is missing in one of the subdirectories.

  * **util-linux**: It fails to find the symbol ``cur_term`` while linking which comes
    from ``libtinfo``, a system library, so for now we use ``--without-tinfo``. It
    is not clear why the configurations in the CSCS and EasyBuilders repositories don't
    need this. There might be something different about our ncurses module.

  * **x265**: x265 has an optional dependency on numactl which is currently not
   included in the build but does have the potential to improve performance.

