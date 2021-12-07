# ncurses

  * [GNU ncurses library web page](https://invisible-island.net/ncurses/)

  * [ncurses download from the GNU download site](https://ftp.gnu.org/pub/gnu/ncurses/)


## EasyBuild

  * [Regular EasyBuild support](https://github.com/easybuilders/easybuild-easyconfigs/tree/main/easybuild/easyconfigs/n/ncurses)
  * [CSCS EasyConfigs](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/n/ncurses)


### 6.2 from 21.06 on

  * We started from the regular EasyBuild configuration that does a dual pass
    build of ncurses to also build a version of the library with more/different
    options. We made this choice to ensure maximal compatibility with EasyConfigs
    from the main EasyBuild repository.

  * We also generate files for pkg-config, something that the orginal EasyConfig
    files didn't do.

  * There is a more complete setup in comments in the EasyConfig file but that one
    is probably even more dangerous as bash will pick it up, so there is a risk
    that the shell may not work the way it should anymore if a new shell is loaded.
