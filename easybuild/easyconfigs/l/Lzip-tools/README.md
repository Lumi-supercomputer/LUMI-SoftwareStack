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
 