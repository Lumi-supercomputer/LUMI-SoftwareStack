# gettext

  * [GNU gettext home page](http://www.gnu.org/software/gettext)

  * [Download from the GNU download repository](https://ftp.gnu.org/pub/gnu/gettext/)


## EasyBuild

  * [ gettext support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/g/gettext)

  * [gettext support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/g/gettext)

### gettext 0.21 from 21.06 on

  * This repository provides 2 configurations of gettext

      * The ``-minimal`` configuration is compiled with a minimum of external dependencies.
        i.e., only ncurses

      * The regular configuration is more full-featured. It has however dependencies that
        themselves use gettext during the build process so we had to provide a more
        minimalistic version to work around circular dependencies.

    This aspect is different from the EasyConfigs in the Easybuilders and CSCS repositories.
    These repositories provide an in-between version that uses a libxml2 produced with
    EasyBuild rather than the internal one used in the ``-minimal`` configuration and
    hence also uses zlib.

    
### gettext 0.22.4 from 23.12 on

  * Started from the configirations for 0.21.1
  
      * Changed the minimal version to one without even ncurses as it looks like libreadline 
        is then also needed.
  
  * But added license information to the installation.
    