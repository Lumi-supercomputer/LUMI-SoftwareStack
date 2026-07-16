# amd

## Easybuild

### amd 5.6.1

The EasyConfig is used to create a pkgconfig file and a module to mimic the 
official HPE Cray `amd` compiler module.


### amd 6.4.4 for 25.09

-   EasyConfig to set some environment variables needed by the compiler wrappers and
    as such replacing a Cray one as one was missing for this ROCm version after the
    January 2026 system update (as the default version of ROCm was 6.3.4 at that time
    while 25.09 is made for ROCm 6.4).


### amd 7.0.3 for 26.03

-   EasyConfig to set some environment variables needed by the compiler wrappers and
    as such replacing a Cray one as one was missing for this ROCm version after the
    January 2026 system update (as the default version of ROCm was 6.3.4 at that time
    while 26.03 is made for ROCm 7.0).

-   A direct port of the one for 6.4.4 for 25.09.
