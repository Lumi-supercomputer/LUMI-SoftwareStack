# Some known potential issues in the 21.08 LUMI stack

  * Many issues with the AMD 3.0.0 compilers:

      * **Tcl**: Frontend failure

          * Because of this, all packages that depend on it also cannot be
            compiled for cpeAMD: SQLite, PROJ, and several packages in the
            contributed repository.

  * **ELPA**: So far this library fails to compile with the Cray and AMD
    Fortran compilers.

  * **MPFR**: Two tests are skipped when compiled with the Clang-based cpeCray and
    cpeAMD toolchains while all tests are executed and passed with cpeGNU.

  * **Perl**

      * Cray compiler: Set::IntervalTree 0.12 does not build, cannot find the header
        file in #include<string>

        The problem is that MakeMaker (used internally the Perl module installation
        process) decides for some reason that the C++-compiler is called "clang++"
        rather than the Cray wrapper "CC". And while "CC" does actually find the include
        files, "clang++" does not. The problem is likely due to ExtUtils::CppGuess
        not knowing about the Cray compiler wrappers.

      * AMD compiler: DBD::SQLite 1.70 does not build, extremeling long error message.

  * **snappy**: Version 1.1.9 does not install. It needs additional GNU tools and
    also complains that a CMakeLists.txt file is missing in one of the subdirectories.

  * **util-linux**: It fails to find the symbol ``cur_term`` while linking which comes
    from ``libtinfo``, a system library, so for now we use ``--without-tinfo``. It
    is not clear why the configurations in the CSCS and EasyBuilders repositories don't
    need this. There might be something different about our ncurses module.

  * **x265**: x265 has an optional dependency on numactl which is currently not
   included in the build but does have the potential to improve performance.

