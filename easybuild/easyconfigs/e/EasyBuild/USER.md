# EasyBuild user instructions

## What is EasyBuild?

EasyBuild is a software build and installation framework
written in Python that allows you to install software in a structured,
repeatable and robust way.

There is a [web-based manual for EasyBuild](https://docs.easybuild.io/).
[Tutorials](https://easybuild.io/tutorial/) are also available on the web,
including a 
[tutorial specifically for LUMI in our training archive web site](https://lumi-supercomputer.github.io/LUMI-training-materials/EasyBuild-CSC-20220509/).

## Using EasyBuild on LUMI

Loading the EasyBuild module only gives you a standard configuration of EasyBuild that 
will install in your already space-limited home directory, not recognise the already 
installed software in the LUMI software stack, and in fact use build recipes that are
not all compatible with LUMI.

To install software building upon the centrally installed LUMI software stacks
(as provided by the LUMI/xx.yy modules), users should load the EasyBuild-user module
instead as discussed in 
[the EasyBuild section of the main LUMI documentation](https://docs.lumi-supercomputer.eu/software/installing/easybuild/).
