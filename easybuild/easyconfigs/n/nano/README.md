# nano installation instructions

-   [nano web site](https://www.nano-editor.org/)

    -   [Latest version downloads](https://www.nano-editor.org/download.php)

    -   [Download archives](https://www.nano-editor.org/dist/)

-   [nano on Savannah git](https://git.savannah.gnu.org/cgit/nano.git/log/)


## EasyBuild

-   [Support for nano in the EasyBuilders repository is archived](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/__archive__/n/nano)

-   [Sopport for nano in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/n/nano)


### nano 5.9 for LUMI/21.08 and later

-   Nano is a typical tool to compile using the SYSTEM toolchain. It does
    however require the header files for ncurses which were missing in the
    initial setup of LUMI.

-   Hence we developed new EasyConfig files that uses a ncurses module


### nano 6.2 for LUMI/21.12 and later

-   A trivial port of the 5.9 one. No new options were added to the EasyConfig.


### nano 6.3 for LUMI/22.06 and later

-   A trivial upgrade from 6.2. No new options were added to the EasyConfig.


### nano 6.4 for LUMI/22.08 and later
 
-   A trivial upgrade from 6.3. No new options were added to the EasyConfig.


### nano 7.2 for 22.11/23.03/23.09

-   Trivial version bump from 6.4, but we did explicitly enable posix threading
    even though that seems to be the default.


### nano 8.0 for 23.12 and 24.03

-   Trivial version bump from 7.2.


### nano 8.5 for 25.03

-   Trivial version bump from 8.0, but cleaned up the EasyConfig a bit.
