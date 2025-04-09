# ESMF

  * [ESMF on SourceForge](https://sourceforge.net/projects/esmf/)

  * [ESMF on GitHub](https://github.com/esmf-org/esmf)

      * [GitHub releases](https://github.com/esmf-org/esmf/releases)


## General build instructions

ESMF does not use a configure script. The configure phase can be skipped (though this is not
done in the EasyConfig as the configure phase will still be used to set environment variables
through an EasyBlock).

Configuration is done through a large set of environment variables that are picked up by the
Makefile of the ESMF code. It does call CMake for 3rd party codes that are provided internally,
e.g., the PIO IO library. 

The combination of OS and compiler selected through `ESMF_` environment variables (though the
code does a good job at detecting the OS environment) determines which configuration subdirectory
of `build_config` will be used. That subdirectory contains a long file with definitions that will
be included in the Makefile and tries to set defaults, and some system-specific small include
files.

The `make info` command will show how the Makefile interprets those environment variables.
It is also called when doing a build, so if a ConfigureMake process would be used rather
than the custom EasyBlock, setting environment variables through `prebuildopts` and 
`preinstallopts`, one could skip the configure step alltogether.


## EasyBuild

  * [ESMF support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/e/ESMF)

  * [ESMF support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/e/ESMF)

Note that ESMF uses a custom EasyBlock which needs adaptations for Cray systems.


### ESMF 8.1.1 for CPE 21.08

  * The EasyConfig file is an adaptation from the CSCS one.

  * **TODO**: The EasyBuilders version uses a patch. Does this add functionality?

  * Building fails with cpeAMD, with very strange error messages.


### ESMF 8.2.0 for CPE 21.08

  * This version does not compile with gfortran unless the flag to allow argument
    mismatch is used. The problem is that the build procedure does not pick up
    `F90FLAGS` etc., so we've done some hand work with `preconfigopts` and
    `prebuildopts`.


### ESMF 8.3.0 for CPE 22.06

  * Near-trivial version bump, but the way the sources are distributed has changed.

  * Building with AOCC still fails.

  * Note that the build process does include some testing.


### Version 8.4.1 from CPE 22.12 on

  * Trivial version bump of the 8.3.0 EasyConfig

  * For LUMI/23.12, license information was added to the installation.


### Version 8.6.0 for LUMI/24.03

  * Trivial version bump of the 8.4.1 EasyConfig for LUMI/23.12.
  
  * Added buildtools.
  
  * It seems that on the GPU nodes, some code is compiled that is otherwise not compiled
    (as it caused a problem) so there may be some support for GPU acceleration.
    
    The cpeCray version does not yet build on LUMI-G.

  * Later on, we added an MPI version with heavily reworked EasyBlock that can still
    compile the older versions.

      * PIO required a more extensive configuration of netCDF then the default 
        EasyBlock (from which our custom block was derived) can give.
      
      * Note that the OS should be Unicos rather than Linux to enable the automatic 
        configuration of the compilers. The autodetect does this right, but be careful
        not to overwrite.
        
      * Somehow the behaviour for ESMF_OPTLEVEL changed with the updated EasyBlock, 
        but it is not clear why. We solved this by adding a parameter to set the optimisation
        level (and set it to 2 which is what the code did automatically before).
        
      * Also changed the easyblock to honour `preconfigopts`. `prebuildops` was honoured,
        but `preconfigopts` not and that lead to misleading information from `make info`
        which is what happens during the configure phase.

      