# lumi-container-wrapper = tykky instructions

The lumi-container-wrappar, aka tykky, tool is developed at CSC
Finland by Henrik Nortamo. 

-   [tykky in the GitHub hpc-container-wrapper repository](https://github.com/CSCfi/hpc-container-wrapper)
    
    -   [GitHub releases via tags](https://github.com/CSCfi/hpc-container-wrapper/tags)

-   [tykky in the CSC documentation](https://docs.csc.fi/computing/containers/tykky/)


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


### Version 0.3.1

-   New version for LUMI after the March 2023 update, now using a base image based
    on SUSE 15 SP4.

-   The EasyConfigs are a trivial port of the ones developed before.

-   Note: The 0.3.2 distribution was meant for the Finnish national systems and lacks
    the proper configuration file for LUMI so was skipped.


### Version 0.3.3

-   Version for SUSE 15 SP5. Trivial update otherwise with some refinements.


### Version 0.4.2

-   Trivial update from 0.3.3.
 
