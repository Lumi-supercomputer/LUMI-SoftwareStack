# ParMETIS user documentation

Since 25.03, we provide different versions of ParMETIS and have reworked the EasyConfig so that
users can easily build their own version with the desired precision.

-   The `-idx32-fp32` version is the default version of ParMETIS which most programs will likely
    expect unless they mention otherwise. It uses 32-bit integer indices and 32-bit floating point
    numbers.

-   The `idx32-fp64` version uses 32-bit indices and 64-bit floating point numbers.
