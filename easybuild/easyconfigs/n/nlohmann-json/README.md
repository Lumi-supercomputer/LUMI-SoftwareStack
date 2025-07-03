# nlohmann-json

  * [nlohmann-json web site](https://json.nlohmann.me/)

  * [nlohmann-json on Github](https://github.com/nlohmann/json)


## EasyBuild

  * No nlohmann-json support in the EasyBuilders repository

  * No nlohmann-json support in the CSCS repository

  * [nlohmann-json support in the JSC repository](https://github.com/easybuilders/JSC/tree/2022/Golden_Repo/n/nlohmann-json)


### Version 3.10.4 for CPE 22.08

-   Based on the JSC easyconfig


### Version 3.11.2 for CPE 22.12 and 23.09 

-   Based on the JSC easyconfig


### Version 3.11.3 from CPE 23.12 on

-   Moved to the LUMI-SoftwareStack repository from LUMI-EasyBuild-contributed as
    it is needed to build another library that is in the main software stack.

-   Had to move to 3.11.3 already in 23.12 rather than following the 2023a EasyBuild
    release as 3.11.2 did not compile with the Cray compiler.

    
### 3.12.0 from 25.03 on

-   Trivial port of the 3.11.3 EasyConfig for 24.03/24.11.
    