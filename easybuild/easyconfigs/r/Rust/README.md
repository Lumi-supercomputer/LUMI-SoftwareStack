# Rust

  * [Rust home page](https://www.rust-lang.org)


## EasyBuild

  * [Rust support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/main/easybuild/easyconfigs/r/Rust)

  * There is no support for Rust in the CSCS repository


### Rust 1.54.0 from CPE 21.06 on

  * The EasyConfig builds upon the one of the EasyBuilders repository. It uses
    the SYSTEM toolchain however so that it can be used to generate packages
    for the SYSTEM toolchain or any other toolchain on LUMI.

  * It is intended for installation in ``partition/common`` as processor-specific
    binaries don't make much sense for compilers and as it can then be used to
    compile software for that partition also.
