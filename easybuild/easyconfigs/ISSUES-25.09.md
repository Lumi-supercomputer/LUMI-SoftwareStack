# Issues in 25.09

-   The .pc file of libcerf is incompatible with the LUMI pkg-config tool, while
    we cannot change that one as that then breaks the HPE Cray PE.

-   We're not sure if all intended functionality of Boost is included.
    It looks like the list of libraries has changed in this version.

-   util-linux for cpeAOCC is not fully functional, in turn due to a possible issue
    with SQLite. The `lslogins` command does not work.

-   GSL does not build for cpeCray.
