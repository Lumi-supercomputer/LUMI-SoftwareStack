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


### ROCm 5.4.6, 5.6.1 and 6.2.2

-   Unpacked from RPMs but with an additional step to set the RPATH of the
    libraries and avoid using the system rocm libraries if the module is not
    loaded.

-   The 5.4.6 and 6.2.2 modules were developed at a later time as the 5.6.1
    module and were made to work around some problems we observed with 5.6.1 at
    that time. The 6.2.2 version was chosen as this at that time was the latest
    version of ROCm officially supported on the driver on the system at that
    time. 
    
    One difference with the 5.6.1 version is that there is no equivalent `amd`
    module. Instead some additional environment variables are set in the
    `rocm/5.4.6` and `6.2.2` modules so that if you load it AFTER loading the
    `PrgEnv-amd` module, the compiler wrappers would still use the compilers
    from `rocm/5.4.6` or `6.2.2`.

-   The 6.2.2 version is not compatible with CCE 17.x due to a LLVM
    incompatibility. 

-   Documentation:
    
    -   [ROCm 5.4.6 documentation](https://rocm.docs.amd.com/en/docs-5.4.3/)
    -   [ROCm 5.6.1 documentation](https://rocm.docs.amd.com/en/docs-5.6.1/)
    -   [ROCm 6.2.2 documentation](https://rocm.docs.amd.com/en/docs-6.2.2/)


### 6.2.4 and 6.4.4

-   As previous ROCm Easyconfigs, but with support for the address sanitizer and 
    debug symbols also. However, the libraries for the address sanitizer and 
    debug symbols need to be activated with `LD_PRELOAD`.

-   6.4.4 version is made specifically for the Cray PE 25.09.

-   Documentation:

    -   [ROCm 6.2.4 documentation](https://rocm.docs.amd.com/en/docs-6.2.4/)
    -   [ROCm 6.3.4 documentation (6.3.3 as this is the closest available)](https://rocm.docs.amd.com/en/docs-6.3.3/)
    -   [ROCm 6.4.4 documentation (6.4.3 as this is the closest available)](https://rocm.docs.amd.com/en/docs-6.4.3/)


### 7.0.3

-   Made specifically for the Cray PE 26.03.

-   As previous ROCm Easyconfigs, but with support for the address sanitizer and 
    debug symbols also. However, the libraries for the address sanitizer and 
    debug symbols need to be activated with `LD_PRELOAD`.

-   Documentation: [ROCm 7.0.3 documentation (7.0.2 as this is the closest available)](https://rocm.docs.amd.com/en/docs-7.0.3/)

-   Versions **rocm-7.0.3-flang-clasic.eb** and **rocm-7.0.3-new-flang.eb** are specifically
    for installation with 26.03

    -   `rocm-7.0.3-flang-clasic.eb` actually installs `rocm/7.0.3` rather than `rocm/7.0.3-flang-classic`
        and was developed to have a ROCm(tm) module in the 26.03 container that is as similar as possible
        as what we expect to get after the system update that brings ROVm 7 and CPE 26.03 onto the system.

    -   `rocm/7.0.3-flang-classic` installs ROCm 7.0.3 as intended, with the new generation Flang compiler.
        But that compiler is not compatible with the Cray wrappers or LibSci for PrgEnv-amd in 26.03.

-   Development of `rocm-7.0.3-flang-clasic.eb`: All that is needed to get classic Flang, is to replace 3
    libraries in `llvm/lib`.  AMD provides a tar file with those libraries as
    [repo.radeon.com/rocm/misc/flang/7.0ClassicFlang.tar](https://repo.radeon.com/rocm/misc/flang/7.0ClassicFlang.tar).

    It was not possible to download these as sources as the ROCm EasyBlock builds the sources, so for now we
    do the download in the custom `postinstall_script` and do so at the beginning of that script to ensure
    that the other corrections that are done in that script, are also applied to the classic flang libraries.

    Finally, we also create a symbolic link `amdflang-classic` as that is what the compiler wrappers now expect.

