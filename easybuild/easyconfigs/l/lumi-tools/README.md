# lumi-tools instructions

The lumi-tools module provides several in-house developed scripts and tools, depending on
the version:

-   `lumi-quota` to check your quota on the Lustre file systems
-   `lumi-allocations` to check your allocations
-   `lumi-workspaces` combines the output of both to show an overview for
    all projects of the user calling the script. A newer version of it (26.05
    module and later) is a redevelopment in LUA, presenting output in a 
    different format and with more information.
-   `lumi-check-quota` is an equivalent of the checks run at user login to
    print warnings when a user is running out of quota or billing units.
-   `pushover` is a tool to send notification via the pushover service.
-   `pushslack` is a tool to send notifications to Slack.

Sources:

-   [lumi-allocations GitHub repository](https://github.com/Lumi-supercomputer/lumi-allocations)

-   [lumi-tools GitHub repository](https://github.com/Lumi-supercomputer/lumi-tools)

-   [LUMI-notifications GitHub repository (`pushover` and `pushslack`)](https://github.com/klust/LUMI-notifications)

    -   [inih package used by LUMI-notifications](https://github.com/benhoyt/inih)


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


### Version 23.04

-   EasyConfig based on the 23.03 one. This version adds the `lumi-ldap-projectinfo` 
    and `lumi-ldap-userinfo` tools.
    
   
### Version 23.11

-   No new commands to check so a trivial port of 23.04.


### Version 24.05

-   Trivial port of 23.11


### Version 26.05

-   Switches to a lua version for `lumi-workspaces`, but the build process has not changed.


### Version 26.06

-   This is the first version adding LUMI-notifications

-   Installation of LUMI-notifications:

    -   It currently uses the `MakeCp` EasyBlock.

    -   Sources: Two packages are downloaded from GitHub and unpacked: The sources of 
        LUMI-notifications and the inih package.

    -   In `prebuildopts`, the two files needed from the inih package are copied to the
        `src` subdirectory of LUMI-notifications after which the Makefile can be used to
        compile the package with the system gcc.

    -   At the end, the binaries and manual pages are copied to the installation directory.
