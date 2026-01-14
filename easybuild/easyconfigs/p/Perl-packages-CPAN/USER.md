From `LUMI/24.03` onwards, this module is the new home for many Perl packages
that we used to provide in the [Perl](../Perl/index.md) module.

This is done to speed up the development and installation of a new central software
stack after a system update, as Perl is in the critical path and having to 
build a full configuration slows down the development and deployment tremendously.

From `LUMI/25.03` onwards, we no longer support installing tons of Perl packages this
way as too many packages are badly maintained and managing packages in an environment
like EasyBuild has become too time consuming to manage all package dependencies, to  
deal with the ever changing URLs to the sources of packages and to develop fixes for
compile problems of old packages with new compilers. 
