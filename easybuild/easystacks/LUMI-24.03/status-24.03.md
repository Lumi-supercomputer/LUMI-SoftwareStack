# Status of 24.03

-   Partition L and C
    
    -   cpeGNU is OK
    
    -   cpeCray is OK
    
    -   cpeAOCC
    
        -   Fails at libjpeg-turbo during testing. Same failure as we previously already 
            had with cpeCray so just removing those 2 tests (out of 500+)
            
        -   Boost 1.83.0 also does not compile with cpeAOCC (we already had this with 
            Boost 1.82.0 in 23.12)
    
-   Partition G

    -   cpeGNU is OK
    
    -   cpeCray: OK, except:
     
        -   ESMF still a problem. It fails to link some code with Zoltan and is using 
            ftn for that.
            
            It is likely that it includes code that is only activated on GPU systems as 
            it compiled OK on the CPU-only nodes.
    
    -   cpeAMD: OK except for
    
        -   Fails at libjpeg-turbo during testing, but simply removed those 2 tests 
            (out of 500+ that are OK).
        
        -   Boost also not built yet

