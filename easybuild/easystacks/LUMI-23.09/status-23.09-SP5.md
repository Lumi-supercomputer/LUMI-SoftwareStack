# Status recompiling LUMI/23.09

-   Status L/C
    -   cpeGNU: OK with some changes to packages:
        -   Added googletest to compile PROJ on the TDS.
        -   Problems with FFmpeg 6.0
    -   cpeCray: OK on L except:
    		-   One set of tests of GMP fails. Unfortunately, with the default EasyBuild 
    		    options, it is not easy to see what is the issue.
    		    This implies MPFR and MPC also can't be built, but has no further consequences
    		    for the centrally installed software.
    		-   Added googletest to compile PROJ on the TDS
    -   cpeAOCC:

-   Status G
    -   cpeGNU: OK with some changes to packages
        -   Same changes as for LC
        -   In addition, but this does not affect compiling for LC, need to unload 
            rocm for some packages.
    -   cpeCray:
    		-   Rebuild stuck at the compilation of cURL...
    -   cpeAMD OK, except
        -   Harfbuzz and hence Pango and gnuplot do not compile
        -   lumi-CPEtools: gpu_check does not compile.


        
Analysis of problems:

-   Problems compiling LibTIFF with cpeGNU
    when rocm/6.0.3 is loaded:
    tiffinfo: Relink `/opt/rocm-6.0.3/lib/libamd_comgr.so.2' with `/lib64/libm.so.6' for IFUNC symbol `sin'
    so need to unload the rocm module.
    
-   Compiling cURL without unloading rocm leads to an error in the configure phase,
    claiming that the compiler cannot generate executables.
    
    The test in the configure script returns:
    
    ```
    clang: /opt/cray/pe/gcc/10.3.0/snos/lib64/libstdc++.so.6: version `GLIBCXX_3.4.30' not found (required by /opt/rocm-6.0.3/lib/libamd_comgr.so.2)
    clang: /opt/cray/pe/gcc/10.3.0/snos/lib64/libstdc++.so.6: version `GLIBCXX_3.4.30' not found (required by /opt/rocm-6.0.3/lib/libhsa-runtime64.so.1)
    ```
