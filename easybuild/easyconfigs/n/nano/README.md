# nano installation instructions

  * [nano web site](https://www.nano-editor.org/)

      * [Latest version downloads](https://www.nano-editor.org/download.php)

      * [Download archives](https://www.nano-editor.org/dist/)

  * [nano on Savannah git](https://git.savannah.gnu.org/cgit/nano.git/log/)


## EasyBuild

  * [Support for nano in the EasyBuilders repository is archived](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/__archive__/n/nano)

  * [Sopport for nano in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/n/nano)


### nano 5.9 for CPE 21.08 and later

  * Nano is a typical tool to compile using the SYSTEM toolchain. It does
    however require the header files for ncurses which were missing in the
    initial setup of LUMI.

  * Hence we developed new EasyConfig files that uses a ncurses module

### nano 6.2 for CPE 21.12 and later

  * A trivial port of the 5.9 one. No new options were added to the EasyConfig.
