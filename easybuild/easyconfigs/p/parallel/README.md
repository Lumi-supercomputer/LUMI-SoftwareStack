# GNU parallel instructions

-   [GNU parallel web site](http://savannah.gnu.org/projects/parallel/)
    -   [Check version](https://ftp.gnu.org/gnu/parallel/)
-   [GNU parallel on gnu.org](https://www.gnu.org/software/parallel/)
-   [git repository on GNU git](http://git.savannah.gnu.org/cgit/parallel.git)
-   [GNU parallel tutorial](https://www.gnu.org/software/parallel/parallel_tutorial.html)


## General information

-    GNU parallel is just a bunch of Perl scripts. There are no compiled binaries.

## EasyBuild

-   [Support for parallel in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/p/parallel).

    The EasyBuilders recipes rely on a Perl build in the toolchain.

-   [Support for parallel in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/p/parallel)

-   [Support for parallel in Spack](https://spack.readthedocs.io/en/latest/package_list.html#parallel)


### Version 20230222 using the system perl.

-   For LUMI we followed the EasyConfig in use at UAntwerpen that uses the 
    OS-provided Perl as this seems sufficient to run GNU parallel.
    
-   All shebangs where checked to have `/usr/bin/perl` hard-coded rather
    then `/usr/bin/env perl` to avoid using another PErl binary that may
    be loaded via a module.
    
-    Extensive documentation is also taken from the UAntwerpen module.


### Version 20231022 using the system perl.

-   Trivial version bump of the EasyConfig for 20230222.


### Version 20240422 using the system perl.

-   Trivial version bump of the EasyConfig for 20231022.


### Version 20240522 using the system perl.

-   Trivial version bump of the EasyConfig for 20240422.


