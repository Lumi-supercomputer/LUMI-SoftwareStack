# lumi-tools instructions

The lumi-tools module provides three in-house developed scripts:

-   `lumi-quota` to check your quota on the Lustre file systems
-   `lumi-allocations` to check your allocations
-   `lumi-workspaces` combines the output of both to show an overview for
    all projects of the user calling the script.

Sources:

-   [lumi-allocations GitHub repository](https://github.com/Lumi-supercomputer/lumi-allocations)
    

## Easy/build

### Version 0.1

-   In-house developed EasyConfig, type `Bundle`

    -  `lumi-quota` and `lumi-workspaces` are currently contained in the EasyConfig itself and 
        copied to a file in the `postinstallcommands` of the EasyConfig.
        
    -   `lumi-allocations` is installed from its GitHub repository using
        the `Tarball` generic EasyBlock, as a component of the Bundle.

### Version 0.2

-   `lumi-allocations` now fully supports its `-p` argument and the hidden LUST options.

-   Added a version of the `lumi-check-quota` script.

