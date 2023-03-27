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
    
     