# CUDA user information

The `CUDA` module is provided so that visualisation packages that need CUDA can be 
compiled on the login nodes and wouldn't need to be compiled on the visualisation nodes.
This is also because packages for the central software stack (and we do offer some 
that need CUDA to reduce compilation time of user-installable packages) can only be
compiled on a special login node due to the underlying distribution mechanism of the
software stack.

The `CUDA` module and the visualisation nodes should only be used for visualisation software. 
They are not meant to be used with other software that uses CUDA for compute.
