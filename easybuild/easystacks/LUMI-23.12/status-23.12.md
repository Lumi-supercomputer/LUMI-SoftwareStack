# Status LUMI/23.12

-   Problems with htop
-   Partition L/C
    -   cpeGNU OK on partition L/C
    -   cpeCray OK on partition L/C except for x265 and FFmpeg
    -   cpeAOCC:
        -   AOCC has a hard compiler crash compiling Boost 1.82.0.
            Limited consequences for the central software stack, but there are
            many packages in the user-installable stack that use Boost, though we
            don't use AOCC a lot.

-   Partition G
    -   cpeGNU
        -   LibTIFF and cairo needed fixes: unload ROCm module.
        -   For some reason, FFmpeg compiled in partition/L and C, but not in G,
            even not after unloading ROCm.
        -   Otherwise successful compilation
    -   cpeCray:
        -   GSL with OpenMP fails to compile.
        -   And of course x265 and FFmpeg are also missing
        -   Otherwise succesfull
    -   cpeAMD:
        -   gpu_check in lumi-CPEtools does no longer compile.


Todo: 
-   Can we re-enable the last extension in Perl with cpeAOCC?
