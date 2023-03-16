# lumi-tools instructions

The lumi-tools module provides several in-house developed scripts, depending on
the version:

-   `lumi-quota` to check your quota on the Lustre file systems
-   `lumi-allocations` to check your allocations
-   `lumi-workspaces` combines the output of both to show an overview for
    all projects of the user calling the script.
-   `lumni-check-quota` is an equivalent of the checks run at user login to
    print warnings when a user is running out of quota or billing units.

Sources:

-   [lumi-allocations GitHub repository](https://github.com/Lumi-supercomputer/lumi-allocations)

-   [lumi-tools GitHub repository](https://github.com/Lumi-supercomputer/lumi-tools)
    

## EasyBuild

### Version 23.01

-   In-house developed EasyConfig, type `Bundle`

    -  `lumi-quota` and `lumi-workspaces` are currently contained in the EasyConfig itself and 
        copied to a file in the `postinstallcommands` of the EasyConfig.
        
    -   `lumi-allocations` is installed from its GitHub repository using
        the `Tarball` generic EasyBlock, as a component of the Bundle.


### Version 23.02

-   `lumi-allocations` now fully supports its `-p` argument and the hidden LUST options.

-   Added a version of the `lumi-check-quota` script.


### Version 23.03

-   Improved version of `lumi-quota` and hence `lumi-workspaces` now also showing for the
    home directory and each project dir on which file system the directories are located.
    
-   Manual pages added for all the tools.
    
-   Completely revised EasyConfig: The shell scripts have been removed from the EasyConfig and
    moved to their own repository which makes it a lot easier to test.
