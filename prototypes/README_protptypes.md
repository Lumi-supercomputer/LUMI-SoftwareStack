# Prototypes for the LUMI module hierarchy and EasyBuild setup

## Design 0.1

  * Two variants of the module tree: stack and partition or partition and stack,
    each with two variants: modules and software separated or kept together.


## Design 0.2

  * Same variants as design 0.1.
  * Several improvements though, see the [REAME file in that directory](design_0.2/README_design_0.2.md)
  * The prototype does contain some dummy modules to test the process of finding software.


## Design 0.3

  * Design 0.2 is robust but it requires generating the software stack and partition
    modules by preprocessing templates. In design 0.3 we seek to avoid this by using
    the Lmod introspection functions, but this requires a different way of setting
    up the module structure to be compatible with the way Lmod handles a module hierarchy.


## Experimenting with the prototypes

  * Make sure lmod and gpp are installed. gpp is needed from design 0.2 on.
  * Installing a prototype simply requires running the corresponding make_.sh script.
  * You'll need to add a directory to the MODULEPATH though to find the root of the
    module tree.
  * The code assumes
      * That it can make a subdirectory work in your home directory when installing lmod and gpp
      * That the repository is in your home directory
      * That it can create a subdirectory appltest in your home directory
