# Prototypes for the LUMI module hierarchy and EasyBuild setup

## Design 0.1

  * Two variants of the module tree: stack and partition or partition and stack,
    each with two variants: modules and software separated or kept together.


## Design 0.2

  * Same variants as design 0.1.
  * Several improvements though, see the [REAME file in that directory](design_0.2/RADME_design_0.2.md)
  * The prototype does contain some dummy modules to test the process of finding software.


## Experimenting with the prototypes

  * Make sure lmod and gpp are installed. gpp is needed from design 0.2 on.
  * Installing a prototype simply requires running the corresponding make_.sh script.
  * You'll need to add a directory to the MODULEPATH though to find the root of the
    module tree.
