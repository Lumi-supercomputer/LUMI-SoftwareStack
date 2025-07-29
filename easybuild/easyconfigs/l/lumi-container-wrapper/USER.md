# lumi-conmtainer-wrapper

The lumi-container-wrapper module provides a port of the CSC Tykky tool.

Documentation:

-   The [documentation in the LUMI documentation](https://docs.lumi-supercomputer.eu/software/installing/container-wrapper/)
    is the first source of documentation as it is specifically for LUMI.

-   The [CSC Tykky documentation page](https://docs.csc.fi/computing/containers/tykky/)
    may also containe useful information, but not everything has been tested on LUMI.

!!! Warning "Anaconda License Restrictions"

    The lumi-container-wrapper commands themselves in version 0.4.2 and later use 
    `miniconda-forge` whitch is licensed under the
    [BSD 3-Clause license](https://github.com/conda-forge/conda-forge.github.io/blob/main/LICENSE).
    
    If however you use lumi-container-wrapper to install software from the regular 
    Anaconda repositories (not `conda-forge` which is OK), the Anaconda license applies,
    consists of one or two documents, depending on the type of user your are.
    The ["Terms of Service"](https://www.anaconda.com/legal/terms/terms-of-service)
    apply to all users. Don't however assume that since 1.a.(2) makes an exception 
    that as an academic user you can use Anaconda on LUMI. Then the 
    ["Academic Policy"](https://www.anaconda.com/legal/terms/academic) applies also,
    and on LUMI, 4.1 does not apply as LUMI is not in an academic domain, so you must
    either do all downloads from a server in the academic domain (and hence cannot 
    use lumi-container-wrapper) or you need to follow 4.2 and your insitution needs
    to take an institution-wide license for Anaconda.
    
    Other specific packages, even packages on conda-forge, may also have a more restrictive 
    license than the `miniconda-forge` tools.
    
    Note that LUMI users themselves are responsible for verifying that they are 
    correctly licensed for all software they use on LUMI! Please don't install packages
    blindly assuming you have the right to use them!

