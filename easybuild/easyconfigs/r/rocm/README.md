# ROCm

  * [ROCm product page](https://www.amd.com/en/products/software/rocm.html)
  
  * [ROCm developer hub](https://www.amd.com/en/developer/resources/rocm-hub.html)
  
  * [ROCm documentation home page](https://rocmdocs.amd.com/)


## Easybuild

### ROCm 4.5.2 (archived)

The EasyConfig unpacks the official RPMs and copies them to the installation 
directory. This is a temporary setup so that the users that have access to the 
Early Access Platform can compile their code from the login node.


### ROCm 5.2.5 and 5.3.3

-   Unpacked form RPMs like previous version but use an EasyBlock to easy the 
    process of EasyConfigs creation.

-   [ROCm 5.3.3 documentation](https://rocm.docs.amd.com/en/docs-5.3.3/)


### ROCm 5.4.6 and 5.6.1

-   Unpacked from RPMs but with an additional step to set the RPATH of the libraries
    and avoid using the system rocm libraries if the module is not loaded.

-   The 5.4.6 module was developed at a later time as the 5.6.1 module and was made
    to work around some problems we observed with 5.6.1 at that time. The 5.4.6 version
    was chosen as this at that time was the latest version of ROCm officially supported
    on the driver on the system at that time. 
    
    One difference with the 5.6.1 version is
    that there is no equivalent `amd` module. Instead some additional environment modules
    are set in the `rocm/5.4.6` module so that if you load it AFTER loading the
    `PrgEnv-amd` module, the compiler wrappers would still use the compilers from
    `rocm/5.4.6`.

-   Documentation:
    
		-   [ROCm 5.4.6 documentation](https://rocm.docs.amd.com/en/docs-5.4.3/)
		-   [ROCm 5.6.1 documentation](https://rocm.docs.amd.com/en/docs-5.6.1/)
