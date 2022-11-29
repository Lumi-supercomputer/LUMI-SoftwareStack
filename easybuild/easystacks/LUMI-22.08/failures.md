  * GMP: Some tests fail because they cannot find libsci_amd_mpi.
    Note that this may point to problems with other versions on other
    partitions also because this program doesn't need MPI, so maybe
    one should unload the M{I module? Or would that then create problems
    when linking with a program that uses MPI?
    
    The problem is actually that /opt/cray/pe/lib64 does not contain 
    symbolic links to those libraries, while the module sets them in
    CRAY_LD_LIBRARY_PATH which the routines in EasyBuild cannot deal
    with.
  * GSL fail also with libsci problems
  * MPFR and MPC cannot be compiled as long as there is no solution for 
    GMP.

  
STATUS: Done with gzip in list lib2 for cpeAMD.
  
# Known problems from partial re-installation on M28 November 2022

  * buildtools: Sources for doxygen not found
  * syslibs: Sources for zlib and expat not found.
  * Perl package: Variable-Magic-0.62.tar.gz
  