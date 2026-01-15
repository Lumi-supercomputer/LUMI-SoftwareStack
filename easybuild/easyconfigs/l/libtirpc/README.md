# libtirpc instructions

-   [libtirpc on SourceForge](https://sourceforge.net/projects/libtirpc/)

-   [Development on linux-nfs.org](https://git.linux-nfs.org/?p=steved/libtirpc.git)


## EasyBuild

-   [libtirpc support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libtirpc)

-   There is no support for libtirpc in the CSCS repository


### Version 1.3.2 for CPE 21.08

-   The EasyConfig is a straightforward adaptation of the EasyBuilders one.

  
### Version 1.3.3 from CPE 22.12 on

-   The EasyConfig is a straightforward port of the 1.3.2. one.

-   For LUMI/23.12, license information was added to the installation and the
    sanity checks were improved.
    
    For clang-based compilers we used `--disable-symvers` as using that causes
    a failure with CCE when linking.

    
### Version 1.3.4 from LUMI/24.03 on

-   Trivial port of the EasyConfig for version 1.3.3 in LUMI/23.12.


### Version 1.3.6 from 25.03 on

-   Started as a trivial port of the EasyConfig for version 1.3.4 on 24.03/24.11.

-   However, we found out that the clang based compiles break `hostname` and likely
    other commands on LUMI as the library lacks the versioned symbol information
    that is present in the system libraries.
    
    The solution is to configure with `--enable-symvers` which in turn required to
    expliclty use `--disable-gssapi`. GSS-API is not found in the cpeGNU build either,
    but in combination with `--enable-symvers`, `configure` explicitly complains.
    
    This then in turn causes issues when linking as the symbol file `src/libtirpc.map`
    also contains routines that are only built with GSS-API enabled. So we also need 
    to massage the linker flags.
    
    For cpeCray, this worked:
    
    ```
    preconfigopts += 'LDFLAGS="$LDFLAGS -Wl,--noinhibit-exec"'
    ```

-   We then also added an additional sanity check to ensure that `hostname` does not produce
    the warnings about missing version information.


### Version 1.3.7 from 25.09 on

-   Trivial port of the EasyConfig for 1.3.6 in 25.09.
   