# libiconv

  * [libiconv home page](https://www.gnu.org/software/libiconv/)

  * [Download libiconv from the GNU repository](https://ftp.gnu.org/pub/gnu/libiconv/)

## EasyBuild

  * [libiconv support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libiconv)

### 1.16 from 21.06 on

  * We started from an EasyConfig file obtained from the University of Antwerpen
    which already employs gettext (which is in fact the first source of a circular
    dependency as gettext can also benefit from libiconv).

### 1.17 from 22.05 on

  * Trivial port of the 1.16 EasyConfig.


