# lumi-tools instructions

The lumi-tools module provides two in-house developed scripts:

-   lumi-workspaces to check your quota
-   lumi-allocations to check your allocations

Sources:

-   [lumi-allocations GitHub repository](https://github.com/Lumi-supercomputer/lumi-allocations)
    

## Easy/build

### Version 0.1

-   In-house developed EasyConfig, type `Bundle`

    -  `lumi-quota` and `lumi-workspaces` are currently contained in the EasyConfig itself and 
        copied to a file in the `postinstallcommands` of the EasyConfig.
        
    -   `lumi-allocations` is installed from its GitHub repository using
        the `Tarball` generic EasyBlock, as a component of the Bundle.
