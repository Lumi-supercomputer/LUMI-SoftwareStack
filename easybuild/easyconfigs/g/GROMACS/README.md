# GROMACS

  * [GROMACS web site](http://www.gromacs.org/)

      * [Check versions via the manual](https://manual.gromacs.org/)


## EasyBuild

  * [GROMACS support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/main/easybuild/easyconfigs/g/GROMACS)

  * [GROMACS support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/g/GROMACS)

  * [GROMACS support in Spack](https://github.com/spack/spack/tree/develop/var/spack/repos/builtin/packages/gromacs)


### Version 2020.6 for CPE 21.08

  * The EasyConfig is a straightforward port of the CSCS one with some information
    added borrowed from the UAntwerpen EasyConfig.

  * We added a bash function, ``gromacs-completion``, that can be used to turn the
    command completion for GROMACS on.

  * Note that the EasyConfig does not run the GROMACS tests, presumably because they
    require an mpirun script and/or should be run in the context of a suitable compute
    job.

  * The AMD-version does not support cray-hugepages. Activating this causes the Cray
    wrapper to add an option to the linker that it does not like.


### Version 2021.3 for CPE 21.08

  * We started from our own EasyConfig for 2020.6 but had to omit ``GMX_PREFER_STATIC_LIBS``
    and add ``BUILD_SHARED_LIBS=ON`` to the CMake options to avoid an error message about
    building GMXAPI.

  * Note that the EasyConfig does not run the GROMACS tests, presumably because they
    require an mpirun script and/or should be run in the context of a suitable compute
    job.

  * The AMD-version does not support cray-hugepages. Activating this causes the Cray
    wrapper to add an option to the linker that it does not like.
