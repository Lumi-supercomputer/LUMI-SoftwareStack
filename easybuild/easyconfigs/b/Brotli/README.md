# Brotlli

  * [Brotli on GitHub](https://github.com/google/brotli)

      * [ GitHub releases of Brotli](https://github.com/google/brotli/releases)


## EasyBuild

  * [Brotli in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/b/Brotli)

  * There is no support for Brotli in the CSCS repository


### Version 1.0.9 from CPE 21.06 on

  * The EasyConfig file is based on one from the University of Antwerpen which itself
    is based on a standard EasyBuilders recipe.


### Version 1.1.0 from 23.12 on

  * Reworked the EasyConfig to have two configure-build steps, one for shared and one 
    for static libraries, as the static library is no longer built automatically with 
    a different name.
    
  * And also needed to change the sanity check for that.
  
  * While we were at it, we also copied the LICENSE file to share/licenses
