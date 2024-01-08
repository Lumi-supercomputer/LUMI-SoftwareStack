# Eigen User Instructions

## What is Eigen?

[Eigen](https://eigen.tuxfamily.org/) is a C++ template library for linear algebra: 
matrices, vectors, numerical solvers, and related algorithms.

Eigen is Free Software. Starting from the 3.1.1 version, it is licensed under
the MPL2, which is a simple weak copyleft license. Common questions about the
MPL2 are answered in the official MPL2 FAQ. Note that currently, a few features
rely on third-party code licensed under the LGPL: SimplicialCholesky, AMD
ordering, and constrained_cg. Such features can be explicitly disabled by
compiling with the EIGEN_MPL2_ONLY preprocessor symbol defined. Furthermore,
Eigen provides interface classes for various third-party libraries (usually
recognizable by the <Eigen/*Support> header name). Of course you have to mind
the license of the so-included library when using them. Virtually any software
may use Eigen. For example, closed-source software may use Eigen without having
to disclose its own source code. Many proprietary and closed-source software
projects are using Eigen right now, as well as many BSD-licensed projects.

As this module includes only templates in source form, it can be used with
any suitable C++ compiler.

This library was installed without taking care of potential dependencies
etc. as it seems that the installation process, despite doing plenty of
checks, doesn't do anything to the template library itself. If you would
experience problems when using Eigen with your own code, we suggest you
install it yourself for your compiler and your combination of mathematical
libraries as there are in fact a near infinite number of potential
configurations.
