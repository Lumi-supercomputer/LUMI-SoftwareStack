# ROCm

  * [ROCm home page](https://rocmdocs.amd.com/)

## Easybuild

### ROCm 4.5.2

The EasyConfig unpack the official RPMs and copy them to the installation 
directory. This is a temporary setup so that the user that have access to the 
Early Access Platform can compile their code from the login node.

### ROCm 5.2.5 and 5.3.3

Unpacked form RPMs like previous version but use an EasyBlock to easy the 
process of EasyConfigs creation

### ROCm 5.6.1

Unpacked form RPMs but with an additiianl step to set the RPATH of the libraries
and avoid using the system rocm libraries if the module is not loaded
