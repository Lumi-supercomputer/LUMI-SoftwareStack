# Design 0.3 of the module system

Changes compared to design 0.2:

  * Design 0.2 is robust but it requires generating the software stack and partition
    modules by preprocessing templates. In design 0.3 we seek to avoid this by using
    the Lmod introspection functions, but this requires a different way of setting
    up the module structure to be compatible with the way Lmod handles a module hierarchy.

Changes compared to design 0.1:

  * We rely on the Cray LMOD modules for the programming environment
    and don't try to copy those to our own directory structures as
    there is not that much to gain from it given the hierarchical
    structure.
  * We avoid reading environment variables in the partition and stack
    modules and instead produce them via running a template through
    the gpp preprocessor. This is simpler than letting each module
    remember its settings.
  * We need to see if we will create PrgEnv-* equivalents in the
    LUMI/yy.mm software stacks using EasyBuild (as in CSCS) or via
    our own script, in which case we would put them elsewhere. In that
    case we could even initialise a LUMI/yy.mm software stack without
    using EasyBuild, which granted is not a good match with the
    "EasyBuild first" strategy.

## Hierarchy with software stack first, partition/architecture second, flat otherwise - Prototype module_stack_partition

Here we mount the same file system with applications and modules
everywhere, but within that file system we have binaries for each
architecture in separate directories

Directory hierarchy

-   Cray modules in their own hierarchy.

-   appl

    -   modules

        -   SoftwareStack: A module file that enables the default Cray
            environment, and one for each of our LUMI software stacks,
            of the form ``LUMI/version.lua``.

        -   LUMIpartition/LUMI/yy.mm: The next level in the hierarchy. It contains modules by
            LUMI SoftwareStack to enable the different partitions. Structure:
            -   The modules are called ``LUMIpartition/C.lua`` etc.
            -   Modules for the ``LUMI/yy.mm`` software stack are in
                ``LUMIpartition/LUMI/yy.mm``.

        -   easybuild/LUMI/yy.mm/LUMIpartition/part: Directory for the EasyBuild-generated
            modules for the ``LUMI/yy.mm`` software stack for the ``LUMI-part``
            partition (``part`` actually being a single letter)

        -   spack/LUMI/yy.mm/LUMIpartition/part: Similar as the above, but for
            Spack-installed software.

        -   manual/LUMI/yy.mm/LUMIpartition/part: Similar as the above, but for
            manually installed software.

    -   software : This is for the actual binaries, lib directories etc.

        -   LUMI-21.02

            -   LUMI-C

                -   easybuild

                -   spack

                -   manual

            -   LUMI-G

            -   LUMI-D

            -   LUMI-L

    -   mgmt: Files that are not stored in our GitHub, but are generated
        on the fly and are only useful to those users who want to
        build upon our software stack or for those who install
        software in our stacks. 

        -   ebrepo_files

            -   LUMI-21.02

                -   LUMI-L

                -   LUMI-D

                -   LUMI-C

                -   LUMI-O

    -   github: GitHub repository with all managed files

        -   easybuild

            -   easyconfig

            -   config: Configuration of EasyBuild

            -   Structure for hooks and easyblocks to be decided.



### Assumptions

-   The system sets an environment variable LUMI_PARTITION with value
    LUMI-C, LUMI-G, LUMI-D or LUMI-L depending on the node type.
    This is used by the SoftwareStack module to then auto-load the
    module for the current partition when it is loaded.


### Default behaviour when loading modules

-   A user will always need to load a software stack module first.

    -   For those software stack modules that further split up according
        to partition (the LUMI/yy.mm modules), the relevant partition
        module will be loaded automatically when loading the software
        stack.

-    In this variant of the desing, we made the SoftwareStack and LUMIpartition
     modules sticky so that once loaded a user can use ``module purge`` if they
     want to continue working in the same software stack but load other packages.


### Advantages

-   Having the software stack as the highest level in the hierarchy
    makes it easy to also make other software stacks available through
    software stack modules that can then each have their own internal
    organisation, e.g., EESSI should it mature enough during the life of
    LUMI and become suitable for LUMI and should we find a distribution
    mechanism that would integrate with LUMI.

-   \...


### Disadvantages

-   \...


## Remarks

-   Since we want to use ``hierarchyA`` in a consistent manner in the modules, we only
    uses modules with a name of the form ``name/version`` so we no longer use the
    ``LUMI-C`` etc.  modules to switch partion.


## Hierarchy with the partition first, software stack second, flat otherwise - Prototype make_partition_stack

Here we mount the same file system with applications and modules
everywhere, but within that file system we again have binaries for each
architecture in separate directories

Directory hierarchy

-   Cray modules in their own hierarchy.

-   appl

    -   modules

        -   LUMIpartition: Modules to adapt the module path for a
            partition. The modules have a name in the form
            ``LUMIpartition/part.lua``(so ``/appl/modules/LUMIpartition/LUMIpartition/part.lua``,
            and with ``part`` a single letter denoting the partion.)

        -   SoftwareStack/LUMIpartition/part: The next level of the hierarchy. It contains
            modules by LUMI partition for all software stacks provided. The modules
            for the LUMI software stack are called ``LUMI/yy.mm.lua``.

        -   easybuild/LUMIpartition/part/LUMI/yy.mm: Directory for the EasyBuild-generated
            modules for the ``LUMI/yy.mm`` software stack for the ``LUMI-part``
            partition (``part`` actually being a single letter)

        -   spack/LUMIpartition/part/LUMI/yy.mm: Similar as the above, but for
            Spack-installed software.

        -   manual/LUMIpartition/part/LUMI/yy.mm: Similar as the above, but for
            manually installed software.

    -   software

        -   LUMI-C

            -   LUMI-21.02

                -   easybuild

                -   spack

                -   manual

    -   mgmt

        -   ebrepo_files

            -   LUMI-C

                -   LUMI-21.02

    -   github: GitHub repository with all managed files

        -   easybuild

            -   easyconfig

            -   config: Configuration of EasyBuild

            -   Structure for hooks and easyblocks to be decided.


### Assumptions

-   The system sets an environment variable LUMI_PARTITION with value
    LUMI-C, LUMI-G, LUMI-D or LUMI-L depending on the node type.
    The system also loads the matching partition module by default.


### Default behaviour when loading modules

-   The system will have the right partition module loaded for the
    partition type. These are sticky modules but can be swapped at the
    user\'s own risk.

-   In this design we chose to also make the software stack module sticky once loaded.
    Hence a user who wants to continue to work in a particular software stack can use
    ``module purge`` without having to reload the software stack and partition modules.


### Advantages

-   \...


### Disadvantages

-   This setup is more confusing if there are also software stacks that
    do not depend on the architecture (e.g., offering the native Cray
    environment) or that have other means to deal with the architecture
    (e.g., EESSI should we ever offer that, though we may as well not
    use the EESSI way to select the optimal architecture).


### Remarks

-   Since we want to use ``hierarchyA`` in a consistent manner in the modules, we only
    uses modules with a name of the form ``name/version`` so we no longer use the
    ``LUMI-C`` etc.  modules to switch partion.

