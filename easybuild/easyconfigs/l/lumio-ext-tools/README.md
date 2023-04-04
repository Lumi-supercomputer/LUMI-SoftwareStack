# lumio-ext-tools technical documentation

This is a bundle of tools:

-   rclone:

    -   [rclone home page](https://rclone.org/)
    
        -   [Downloads on that site for version check](https://rclone.org/downloads/)
        
    -   [rclone on GitHub](https://github.com/rclone/rclone)
    
-   restic

    -   [restic home page](https://restic.net/)
    
    -   [restic on GitHub](https://github.com/restic/restic)
    
        -   [GitHub releases](https://github.com/restic/restic/releases)

-   s3cmd:

    -   [s3cmd web site](https://s3tools.org/s3cmd)
    
    -   [s3cmd on GitHub](https://github.com/s3tools/s3cmd)

    -   [s3cmd on PyPI](https://pypi.org/project/s3cmd/) 
    
    
## EasyBuild

-   rclone

    -   [rclone support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/r/rclone)
        This easyconfig compiles `rclone` from sources but requires Go to do so.
        
    -   There is no support for rclone in the CSCS repository
    
    -   [rclone support in Spack](https://spack.readthedocs.io/en/latest/package_list.html#rclone)
    
-   restic
    
    -    There is no support for restic in the EasyBuilders repository
    
    -    There is no support for restic in the CSCS repository
    
    -    [restic support in Spack](https://spack.readthedocs.io/en/latest/package_list.html#restic)
    
-   s3cmd

    -    There is no support for s3cmd in the EasyBuilders repository
    
    -    There is no support for s3cmd in the EasyBuilders repository
    
    -    [py-s3cmd support in Spack](https://spack.readthedocs.io/en/latest/package_list.html#py-s3cmd)



### Version 1.0.0

-   The EasyConfig is a development of CSC and LUST.

-   All binaries are installed from binary distributions.

-   s3cmd:

    -   Use the system Python
    
    -   Patched the s3cmd script so that the system Python is hard-code
        and PYTHONPATH doesn't need to be set so that the tool can work
        together with other tools on the system, also tools that would use
        a different Python version.

