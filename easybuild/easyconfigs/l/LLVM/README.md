# LLVM technical information

Use of the LLVM module:

-   Currently only for the OpenGL software renderer.
    
Where to find?

-   [LLVM website](https://llvm.org/)

-   [LLVM GitHub](https://github.com/llvm/llvm-project)

    -   [GitHub releases](https://github.com/llvm/llvm-project/releases)

    
## EasyBuild

-   [LLVM in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/LLVM)

-   [LLVM in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/l/LLVM)

-   [llvm support in Spack](https://packages.spack.io/package.html?name=llvm)


### 17.0.6 for LUMI/24.03

-   Version alligned with the version used by Cray and ROCm 6.0.

-   The EasyConfig is largely a LUST development, but based on the EasyBuilders EasyBlock 
    for LLVM.


### LLVM 18.1.8 for LUMI/25.03

-   This version was chosen as we could base on an already existing EasyConfig in the 
    EasyBuilders repository and as this version is closest to the one used in ROCm 6.3.4.
    
    Note that Cray uses version 19 in this version of the PE and that it is not aligned
    with the LLVM version in ROCm.

-   The EasyConfig is a direct port of the 17.0.6 one and also follows the one included 
    with EasyBuild 4.9.4. Note that a later version for EasyBuild 5.1 contains some
    patches, but it is not clear if this is due to bugs or because of changes in the 
    EasyBlock.
    