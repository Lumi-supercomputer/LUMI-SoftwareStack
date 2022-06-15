# Some known potential issues in the 22.05 LUMI stack

  * **ELPA**: So far this library fails to compile with the Cray and AMD
    Fortran compilers.

  * **Perl**

      * AMD compiler: DBD::SQLite 1.70 does not build, extremeling long error message.

  * **ncurses**: When loaded it interfers with several of the system tools in `/bin`
    etc. and causes them to fail because those tools expect a very old version.
    The problem is that it even involves some pretty important commands such as
    `gdb`...

  * **MPFR**: Two tests are skipped when compiled with the Clang-based cpeCray and
    cpeAMD toolchains while all tests are executed and passed with cpeGNU.

  * **libsndfile**: MPEG support not functional as MPG123 is also needed for that
    and LAME alone turned out not be enough.

  * **zstd**: The log file contains messages indicating that some libraries from
    the system are picked up that might be incompatible with some EasyBuild libraries.
    Hence it is not clear if `zstd` will work. A simple version check does work however,
    indicating that at runtime linking works.

  * **x265**: x265 has an optional dependency on numactl which is currently not
   included in the build but does have the potential to improve performance.
