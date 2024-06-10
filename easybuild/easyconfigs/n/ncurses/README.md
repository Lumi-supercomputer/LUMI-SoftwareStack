# ncurses

  * [GNU ncurses library web page](https://invisible-island.net/ncurses/)

  * [ncurses download from the GNU download site](https://ftp.gnu.org/pub/gnu/ncurses/)


## EasyBuild

  * [Regular EasyBuild support](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/n/ncurses)
  * [CSCS EasyConfigs](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/n/ncurses)


### 6.2 from 21.06 on

  * We started from the regular EasyBuild configuration that does a dual pass
    build of ncurses to also build a version of the library with more/different
    options. We made this choice to ensure maximal compatibility with EasyConfigs
    from the main EasyBuild repository.

  * We also generate files for pkg-config, something that the original EasyConfig
    files didn't do.

  * There is a more complete setup in comments in the EasyConfig file but that one
    is probably even more dangerous as bash will pick it up, so there is a risk
    that the shell may not work the way it should anymore if a new shell is loaded.


### 6.2 from 22.06 on

  * We stuck to 6.2 as there is a bug in the generation of .pc files in 6.3. It is
    impossible to put the files in the correct location: The comibnation of 
    `--enable-pc-files` and `--with-pkg-config-libdir` produces problems in
    the configure step.

  * Improvements:

      * Added a checksum

      * Added some symbolic links that are used in the standard EasyBuilders EasyConfig.


### 6.4 from 22.12 on

  * Skipped 6.3 used in 2022b and went immediately for 6.4 as it fixes the bug 
    in the configure process of 6.3 when `--enable-pc-files` and `--with-pkg-config-libdir`
    are used together.
    
  * Tried a few new options in the EasyConfig.
  
  * Did not succeed in solving the compatibility problem with the `gdb` from SUSE which 
    expects some very old version symbols that are not even included anymore with the
    `--with-versioned-syms` flag.
    
    It may or may not be solved by patching the `*.map` files in the `package` subdirectory
    but we have no idea how to do this.

  * For LUMI/23.12, license information was added to the installation.
  
    The behaviour of the linker has changed in the Cray compiler and it now produces an error
    if the version script defines versions for symbols with exact matches that are not present.
    So we needed to add `-Wl,--undefined-version` to the linker options to work around this issue.
