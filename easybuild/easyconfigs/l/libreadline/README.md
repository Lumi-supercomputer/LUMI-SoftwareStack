# libreadline

-   [GNU Readline Library home page](https://tiswww.case.edu/php/chet/readline/rltop.html)

-   [readline download from the GNU download site](https://ftp.gnu.org/pub/gnu/readline/)


## EasyBuild

-   [Regular EasyBuild support](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libreadline)

-   [CSCS EasyConfigs](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/l/libreadline)


### 8.1 from 21.06 on

-   The EasyConfig file is a mix of that of CSCS, an correction from the regular EasyBuilders
    repository and additional module info from the UAntwerpen setup.


### 8.1.2 from CPE 22.08 on

-   The EasyConfig is a trivial port of the 8.1 one.


### 8.2 from CPE 22.12 on

-    The EasyConfig is a trivial port of the 8.1.2 one.

-   From LUMI/23.12 onwards, license information was added to the installation.

  
### 8.2.13 for LUMI/25.03.

-   The EasyBuilders version never incorporates the patch level versions because there is 
    only a download for the latest patch version which is removed when a new patch comes out.
    
    We opted to download the separate patches and apply them in the unpack phase already,
    as they don't come from the EasyBuild repository. The patches remain available, 
    also when there is a new minor version of libreadline, so this is a safer approach
    guaranteeing that during a re-installation the code can still be downloaded.
    
-   Because of this we do not follow the 2025a toolchain as that one still uses an unpatched
    8.2.
