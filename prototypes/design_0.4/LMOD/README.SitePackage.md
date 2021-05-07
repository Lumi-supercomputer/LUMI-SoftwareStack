# LUMI prototype SitePackage.lua

SitePackage.lu is used to implement various customistations to Lmod.

So far the package only defines a few hooks but does not add new functions to
the sandbox for the modulefiles.

To activate these site hooks, ensure that ``

## SiteName hook

This hook is used to define the prefix for some of the environment variables that
Lmod will generate internally. Rather then just setting it to ``LUMI`` we decided to
set it to ``LUMI_LMOD`` to lower the chance of conflicts with environment variables
that may be defined elsewhere.

## avail hook

This hook is used to replace directories with labels in the output of ``module avail``.

To work for the prototypes, one needs to set:
*   For the ``stack_partition`` prototype:
    ```bash
    export LMOD_AVAIL_STYLE=sp_labeled:system
    ```
    which will make the labeled view the default but will still allow to see the directory
    view using
    ```bash
    module -s system avail
    ```
*   For the ``partition_stack`` prototype:
    ```bash
    export LMOD_AVAIL_STYLE=ps_labeled:system
    ```


## msgHook

This hook is used to adapt the following messages:
*   output of ``module avail``:  Add more information about how to search for software
    and to contact LUMI User Support.
