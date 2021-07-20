# The directory structure

This hierarchy is created with the prototype_partition_stack script.

The Cray PE modules are left in their own hierarchy.

In the LUMI software stack installation directory, one can find the following subdirectories:

  * ``modules``: Key here was to follow Lmod guidelines on hierarchical structures for
    the software stack itself, though once at the level of the software we currently
    do not use a hierarchy.

      * ``SoftwareStack``: A module file that enables the default Cray environment, and one
        for each of our LUMI software stacks, of the form LUMI/version.lua.

      * ``SystemPartition/LUMI/yy.mm``: The next level in the hierarchy. It contains modules
        by LUMI SoftwareStack to enable the different partitions. Structure:

          * The modules are called ``partition/C.lua`` etc.

            We could not use LUMIpartition as this lead to problems with the Lmod hierachyA
            function which produced wrong results for LUMIpartition/L.lua but not for
            LUMIpartition/C.lua even though both modules had identical code.

          * Besides the four regular partitions, there is also a meta-partition common that is
            used to house software that is common to all regular partitions. The corresponding
            module is hidden from regular users.

      * ``Infrastructure/LUMI/yy.mm/partition/part``: Infrastructure modules. This structure
        is needed for those modules of which we need versions of each of the regular
        partition and for the common partition. This does include the modules that
        are used for EasyBuild settings.

      * ``easybuild/LUMI/yy.mm/partition/part``: Directory for the EasyBuild-generated modules
        for the LUMI/yy.mm software stack for the LUMI-part partition (part actually being
        a single letter, except for the software that is common to all partitions, where
        part is common)

      * ``spack/LUMI/yy.mm/partition/part`` (provisionary): Similar as the above, but for Spack-installed software.

      * ``manual/LUMI/yy.mm/partition/part``: Similar as the above, but for manually installed
        software.

      * ``CrayOverwrite``: A directory that is currently used to implement modules
        that are missing on our test system in Grenoble and to work around some of
        the problems in the Cray ``cpe/yy.mm`` modules.

      * ``StyleModifiers``: Links to the corresponding module in the repository. It
        contains the modules that can be used to change the presentation of the modules
        in ``module avail``.

  * SW : This is for the actual binaries, lib directories etc. Names are deliberately kept short to
    avoid problems with too long shebang lines. As shebang lines do not undergoe variable expansion,
    we cannot use the EBROOT variables and so on in those lines to save space.

      * ``LUMI-yy.mm``

          * ``C``

              * ``EB``

              * ``SP``

              * ``MNL``

          * ``G``

          * ``D``

          * ``L``

          * ``common``

  * ``mgmt``: Files that are not stored in our GitHub, but are generated on the fly and are only
    useful to those users who want to build upon our software stack or for those who install
    software in our stacks.

      * ``ebrepo_files``

          * ``LUMI-yy.mm``

              * ``LUMI-C``

              * ``LUMI-G``

              * ``LUMI-D``

              * ``LUMI-L``

              * ``LUMI-common``

      * ``LMOD`` : Additional files for LMOD

          * ``VisibilityHookData`` : Auto-generated files used by the LMOD ``SitePackage.lua``
            file to hide Cray modules that are irrelevant for a particular software
            stack.

  * SystemRepo: GitHub repository with all managed files. The name is not fixed, any
    name can be used and will be picked up if the scripts from the ``scripts`` subdirectory
    inside the repository are used to initialise a new software stack or to determine
    the values for some of the environment variables for LMOD.

    For the structure inside the repository, see
    [the "overview of files in the repository and where they are being used](files_used.md).
