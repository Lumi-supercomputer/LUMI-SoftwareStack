# cairo user instructions

## What is cairo?

Cairo is a 2D graphics library with support for multiple output devices. 
The library supports a range of output targets, including the X Window System 
(via both Xlib and XCB), image buffers, PostScript, PDF, and SVG file output.
However, not all of them are currently supported on LUMI by these modules.
E.g., Qt is missing and so are various OpenGL-based targets.

Cairo is designed to produce consistent output on all output media while taking 
advantage of display hardware acceleration when available (eg. through the X Render Extension).

The cairo API provides operations similar to the drawing operators of PostScript and PDF. 
Operations in cairo including stroking and filling cubic Bézier splines, transforming and 
compositing translucent images, and antialiased text rendering. All drawing operations 
can be transformed by any affine transformation (scale, rotation, shear, etc.)

Cairo is implemented as a library written in the C programming language, but bindings 
are available for several different programming languages.
