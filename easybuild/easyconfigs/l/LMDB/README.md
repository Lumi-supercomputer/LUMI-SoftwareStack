# LMDB instructions

  * [LMDB web site](https://symas.com/lmdb/)

  * [GitHub mirror of the code](https://github.com/LMDB/lmdb)

      * [GitHub releases](https://github.com/LMDB/lmdb/tags)

## General information

* LMDB comes without a configure script, only a Makefile
   * The Makefile does support `make install` but of course
     `prefix` needs to be redefined.
   * The Makefile doesn't honour compiler-related environment
     flags. Hence the need to redefine CC and OPT when calling
     make to build the code. Re-defining CFLAGS may be dangerous
     as the Makefile doesn't only use the optimization options but
     adds various options that are necessary.

## EasyBuild information

  * [LMDB support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/LMDB)

  * [LMDB support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/l/LMDB)

There is support for LMDB in the EasyBuilders repositories. However,
that support uses the MakeCp generic EasyBlock rather than the install
target in the Makefile. It also copies `midl.h` which on inspection is
only used internally in LMDB and not copies by the install Makefile
target.

### 0.9.29 from CPE 21.06 on

  * The EasyConfig is derived from the University of Antwerpen one.

    It uses the ConfigureMake generic EasyBlock to use the install target
    from the Makefile rather than the MakeCp block used by the EasyBuilders
    EasyConfig.

      * Required skipping the configure step

      * Required adding the definition of `prefix` when calling `make install`.

      * Required a correction of the sanity_check from the EasyBuilders recipes
        as `midl.h` is not installed.

