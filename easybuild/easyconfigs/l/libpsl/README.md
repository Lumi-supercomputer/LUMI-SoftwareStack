# libpsl instructions

-   [libpsl home page](https://rockdaboot.github.io/libpsl/) (looks ill-maintained)

-   [libpsl on GitHub](https://github.com/rockdaboot/libpsl)

    -   [libpsl GitHub releases](https://github.com/rockdaboot/libpsl/releases)

## EasyBuild

-   [Support for libpsl in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libpsl)

-   There is no support for libpsl in the CSCS repository

### Version 0.21.1 for CPE 22.06

-   The EasyConfig is a port of the standard EasyBuilders one.

-   We did improve the sanity check however.

-   For LUMI/23.12, license information was added to the installation.


### Version 0.21.5 from LUMI/24.03 on

-   Trivial port of the EasyConfig for version 0.21.1 for LUMI/23.12.

-   For 25.03: Needed to add libidn2 and libunistring as dependencies, causing a reorganisation
    in the EasyStack files. It picked up a libidn2 from the system but couldn't find a libunistring.
    The other solution would have been to explicitly turn the runtime off (which may still leave
    a sufficiently capable package).

-   The version for 24.03 has been reworked for the system update of January 2026 so that it would
    still rebuild and link correctly now that libidn2 seems missing on the system (at least, it was
    missing on the TDS).
