# file

  * [file home page](http://www.darwinsys.com/file/)

  * [file downloads](https://www.astron.com/pub/file/)

  * [GitHub mirror of the CVS](https://github.com/file/file)


## EasyBuild

  * [file support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/f/file)

  * There is no support for file in the CSCS repository


### Version 5.40 from CPE 21.06 on

  * The EasyConfig is a mix of the EasyBuilders and University of Antwerpen ones
    with additional documentation.


### Version 5.41 from CPE 21.12 on

  * Trivial port of the EasyConfig


### Version 5.42 from CPE 22.06 on

  * Did a check for additional dependencies and found that it can also use bzip2
    and XZ, so moved it further down in the build chain.

  * Otherwise a simple port of the EasyConfig file of 5.41.

  
### Version 5.43 from CPE 22.12 on

  * Trivial version update of the EasyConfig.


### Version 5.45 from CPE 23.12 on

  * Started from a port of the 5.43 one.
  
  * But added a static library.
  
  * And copied license information to the installation directories.
