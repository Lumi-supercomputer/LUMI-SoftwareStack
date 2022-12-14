# Score-P

  * [Score-P home page](https://www.vi-hps.org/projects/score-p/)

  * [Score-P read-only GitLab](https://gitlab.com/score-p/scorep)


## EasyBuild

  * [Score-P support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/s/Score-P)

  * [Score-P support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/s/Score-P)


### Version 7.1 for CPE 21.08

The EasyConfig is a bundle that includes Score-P as well as some of its
dependencies: CubeLib, CubeWriter, OPARI2 and OTF2.

### Version 7.1 for CPE 21.12

The cpeCray version requires to disable Cray specific optimization to avoid
a compiler crash.

With cpeAOCC/21.12 there is also a compiler crash for which we have no solution yet.

### Version 7.1 for CPE 22.06

- Toolchain version bump to use CPE 22.06
- Cray specific optimization no longer produces a compiler crash and have been
  re-enabled for cpeCray
- Usage with the Cray Fortran compiler can be tricky: missing OpenMP
  instrumentation as well as "Invalid pointer" error. Workaround are provided in
  the usage section of the easyconfig. See `module help Score-P/7.1-cpeCray-22.06`
