# Score-P

  * [Score-P home page](https://www.vi-hps.org/projects/score-p/)


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

