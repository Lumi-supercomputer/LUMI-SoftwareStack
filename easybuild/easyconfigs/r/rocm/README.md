# ROCm

  * [ROCm product page](https://www.amd.com/en/products/software/rocm.html)
  
  * [ROCm developer hub](https://www.amd.com/en/developer/resources/rocm-hub.html)
  
  * [ROCm documentation home page](https://rocmdocs.amd.com/)


## Easybuild

### ROCm 4.5.2

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

-   [ROCm 5.4.6 documentation](https://rocm.docs.amd.com/en/docs-5.4.3/)
-   [ROCm 5.6.1 documentation](https://rocm.docs.amd.com/en/docs-5.6.1/)
