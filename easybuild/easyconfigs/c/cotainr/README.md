# cotainr technical documentation.

-   [cotainr on GitHub](https://github.com/DeiC-HPC/cotainr)

    -   [GitHub releases](https://github.com/DeiC-HPC/cotainr/releases)

-   [cotainr documentation on ReadTheDocs](https://cotainr.readthedocs.io/en/latest/)


## EasyBuild

The cotainr tool is an internal development of DeiC and currently not in the EasyBuilders
or CSCS repositories.

A sample EasyConfig is provided in the 
[README file in the cotainer GitHub](https://github.com/DeiC-HPC/cotainr/blob/main/README.md).

### Version 2023.01.0 for CrayEnv

-   The EasyConfig is a development of DeiC and the LUMI User Support Team.

-   The specific version of cray-python is left open in this version of the module.


### Version 2023.01.0-cray-python-3.9.12.1 for LUMI/22.08

-   The EasyConfig is a development of DeiC and the LUMI User Support Team.

-   In accordance to practices for the LUMI software stacks, a specific version of 
    cray-python is loaded (corresponding to the one used in this version of the
    software stack).

### Version 2023.11.0-cray-python-3.9.13.1 for LUMI/22.12

-   Trivial port of the EasyConfig for 2023.01.0-cray-python-3.9.12.1


### Version 2023.11.0-20240529-AIcourse for CrayEnv

-   Port of the EasyConfig for 2023.01.0 for CrayEnv, updating to a newer
    version of `cotainr` and changing the base image for `lumi-g` (keeping the old one
    available as `lumi-g-classic` for users who want to reproduce previous builds).


### Version 2023.11.0-20240529-AIcourse-cray-python-3.10.10 for LUMI/23.09

-   Modification of 2023.11.0-cray-python-3.9.13.1 for the Cray Python version of 23.09,
    and with the base images used in the AI course of May 2024 in Copenhagen.

### Version 2023.11.0-20240909 for CrayEnv

-   Port of the EasyConfig for 2023.11.0-20240529-AIcourse for CrayEnv, updating the base
    image for `lumi-g` to rocm-6.0.3. The previous `lumi-g` and `lumi-g-classic` are
    removed due to lack of official support for the ROCm 5.x based environments.