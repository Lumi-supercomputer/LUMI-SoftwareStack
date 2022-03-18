# lumi-container-wrapper = tykky instructions

The lumi-container-wrappar, aka tykky, tool is developed at CSC
Finland by Henrik Nortamo. 

-   [tykky in the GitHub hpc-container-wrapper repository](https://github.com/CSCfi/hpc-container-wrapper)
    
    -   [GitHub releases via tags](https://github.com/CSCfi/hpc-container-wrapper/tags)
    
## EasyBuild

As this is an in-house developed tool, there is no support in the standard
EasyBuild repositories used on LUMI.

To ensure that users would be using the default cray-python version for
every LUMI stack, it was decided to install the tool separately in
CrayEnv and the common partition of every LUMI stack. For the versions
in the LUMI stacks the version of cray-python is hard-coded in the EasyConfig
and module file so that cray-python is force-reloaded in the right version.
The version for CrayEnv simply loads the default version or works with whatever
version of cray-python that is already loaded when the module is loaded.

    