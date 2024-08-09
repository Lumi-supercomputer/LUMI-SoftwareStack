# gnuplot instructions

  * [gnuplot home page](http://gnuplot.sourceforge.net/)


## EasyBuild

  * [gnuplot support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/g/gnuplot)

  * [gnuplot support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/g/gnuplot)


### Version 5.4.2 for cpe 21.08.

  * Given the complexity of installing Qt5, we decided to go for an old-style
    gnuplot installation without Qt5. Hence we started from the UAntwerpen
    EasyConfig.


### Version 5.4.3 for CPE 21.12

  * Needed to add `--without-latex` to `configopts` as the makefiles did not honour
    `--prefix` for this option and tried to install files in a system directory.

 
### Version 5.4.6 from CPE 22.12 on

  * Trivial version bump of the 5.4.3 EasyConfig.
    
  * Problem with the cpeCray version: For some reason `-lfreetype` was not added to the
    link line or found automatically, causing a missing symbol error for a FreeType symbol.
    This may be due to errors in the pkg-config files of some other packages so that
    the configure script fails to determine the right options while the linker of the Cray PE
    may not be able to find libraries based on `LIBRARY_PATH`.

    The solution to the problem is to add `LDFLAGS="$LDFLAGS -L$EBROOTFREETYPE/lib"` to the
    `preconfigopts`.


### Version 5.4.8 from CPE 23.09 on

  * Trivial version bump of the 5.4.6 EasyConfig.

  * It turns out it now also needs libiconv as a dependency as that came previously in 
    through another package that doesn't need it anymore.

  * For LUMI/23.12, license information was added to the installation and the sanity checks
    were improved.

    
### Version 5.4.10 for LUMI/24.03

  * Trivial version bump of the 5.4.8 EasyConfig for LUMI/23.12.
