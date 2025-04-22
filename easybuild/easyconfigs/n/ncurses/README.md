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
  
  * Did not succeed in solving the compatibility problem with the `gdb` from SUSE when 
    working on LUMI/22.12.

  * For LUMI/23.12, license information was added to the installation.
  
    The behaviour of the linker has changed in the Cray compiler and it now produces an error
    if the version script defines versions for symbols with exact matches that are not present.
    So we needed to add `-Wl,--undefined-version` to the linker options to work around this issue.
    
    We also did further work on trying to figure out how to get the proper version symbols in the
    libraries. We are now using a different set of options and also dropped the application-specific
    EasyBlock as that only added stuff in the background which is misleading while experimenting.
    The problem appears to be that NCURSEST/NCURSESTW symbols are used in the SUSE libraries, which
    should stand for the threaded version, yet the libraries have the names of the unthreaded
    versions, so it looks like some renaming may have taken place.
    
    We have tried with `--enable-weak-symbols` which should not add the `t` to the file name but
    haven't gotten it to work yet. It may need some special flags for the compiler and/or linker
    to work as expected.

    
### 6.4 from 24.11 on

 
   * Found how SUSE builds `ncurses`: 
     [See the spec sheet](https://build.opensuse.org/projects/SUSE:SLE-15:Update/packages/ncurses/files/ncurses.spec?expand=1).
     
   * SUSE uses the weak symbols feature from the GNU compiler. It generates libraries with the regular
     names, but that also have the multithreaded code in them and the versioned symbols are the
     multithreaded ones. 
     
     This is accompished by a combination of compiler/linker flags and arguments to the configure
     script, see the EasyConfig.
     
   * To be sure that the weak symbols work, we do not compile via the Cray wrappers, but overwrite `CC`,
     etc., to always use a suitable version of the GCC compiler, even for non-GCC toolchains.
     
   * We stay close to the SUSE options, but also generate debug libraries as that is done in the regular
     EasyBuild ncurses.

   * It turned out that the Makefile picks up environment variables during the build and install phases
     rather than using the values given during the configure step which is why we set the variables 
     again in all three phases.
