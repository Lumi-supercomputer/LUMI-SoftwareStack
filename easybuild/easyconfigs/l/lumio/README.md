# lumio technical documentation.

This module is part of the modules that provide support for the LUMI-O
object storage system. This module contains the configuration script where
currently we expect that changes may be needed more often, while the
[lumio-ext-tools](../lumio-ext-tools) module provides some basic commands
that don't need frequent updates.

-   [GitHub repository](https://github.com/Lumi-supercomputer/LUMI-O-tools)


## EasyBuild

### Version 1.0.0

-   This EasyConfig is a development by CSC and LUST. All it needs to
    do is download the repository and copy the files it needs.

    
### Version 2.0.0

-   This is for the first release of the official GO version of lumio-conf which
    was labeled version 1.0.0. We still combine with the same older versions of
    rclone, s3cmd and restic as there is no time to test a lot.
    
-   The EasyConfig needed a big rework. For this version, a precompiled executable
    is distributed via GitHub, as are the sources. We currently download both
    so that we also have the LICENSE file.
    
-   Otherwise it is just a MakeCp EasyConfig file. During the unpacking, we 
    ensure that the executable is actually in the directory that also contains
    the sources.
    