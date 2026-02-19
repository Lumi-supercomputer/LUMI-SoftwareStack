# Lzip-tools technical information

The module contains:

-   lzip:
    
    -   [Home page](https://www.nongnu.org/lzip/)
    
    -   [Downloads](https://download.savannah.gnu.org/releases/lzip/)
    
-   lunzip:

    -   [Home page](https://www.nongnu.org/lzip/lunzip.html)
    
    -   [Downloads](https://download.savannah.gnu.org/releases/lzip/lunzip/)

-   lziprecover:

    -   [Home page](https://www.nongnu.org/lzip/lziprecover.html)
    
    -   [Downloads](https://download.savannah.gnu.org/releases/lzip/lziprecover/)
   
-   plzip:

    -   [Home page](https://www.nongnu.org/lzip/plzip.html)
    
    -   [Downloads](https://download.savannah.gnu.org/releases/lzip/plzip/)
    
-   tarlz:

    -   [Home page](https://www.nongnu.org/lzip/tarlz.html)
    
    -   [Downloads](https://download.savannah.gnu.org/releases/lzip/tarlz/)
    
-   Zutils:

    -   [Home page](https://www.nongnu.org/zutils/zutils.html)
    
    -   [Downloads](https://quantum-mirror.hu/mirrors/pub/gnusavannah/zutils/)
    
-   lzlib: Library needed to build some of these tools:

    -   [Home page](https://www.nongnu.org/lzip/lzlib.html)
    
    -   [Downloads](https://download.savannah.gnu.org/releases/lzip/lzlib/) 

    
## EasyBuild

-   At the time of development, there was no support for lzip in EasyBuild
    
-   There is no support in Spack for lzip.
    
    
### Lzip-tools for LUMI/24.11
    
-   The EasyConfig is a LUST development. All packages have a very simple 
    configure-make build process so developing a Bundle was easy.
    
-   The EasyConfig needs our new EasyBuild 4.9.4 installation as it needs
    the `lzip` command and the modifications to support `.tar.lz` files.


### Lzip-tools for 25.03

-   Identical to the 24.11 version.   


### Lzip-tools for 25.09

-   A trivial port with updates to the version of 2 packages compared to 25.03.

-   But we switched to the new parameter names to prepare for EasyBuild 6.

