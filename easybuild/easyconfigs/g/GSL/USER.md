# GSL user instructions

GSL does not yet work on the GPU nodes.

There are two versions of GSL, and they differ in the version of LibSci they actually
link. Which version you need depends on the other components of your code. And you 
have to be consistent. Either all code that uses LibSci is compiled with OpenMP support
or none of that code is compiled with OpenMP support (and the linking is also done
with and without OpenMP support respectively).

-   The `-sequential` versions are for use with code that does not use OpenMP.
-   The `OpenMP` versions are for use with code that does use OpenMP.
