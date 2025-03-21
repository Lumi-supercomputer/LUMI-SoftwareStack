# PRoot user instructions

The `PRoot` module provides the `proot` command to `partition/container` in the LUMI stacks.
This enables the so-called ["Unprivileged `proot` builds"](https://docs.sylabs.io/guides/3.11/user-guide/build_a_container.html#unprivilged-proot-builds)
in recent versions of Singularity Community Edition, one of the few ways available on LUMI to
extend containers as user namespaces or fakeroot are not available.

The main use case is to be able to develop EasyConfigs that modify an existing container
and install the container with matching module file in `partition/container`.

The `proot` command is also provided by the [`systools` module](../../s/systools/index.md),
but that module cannot be used as a build dependency in EasyBuild when building for
`partition/common` and cannot easily be made available in that partition without breaking the
whole idea of the LUMI software stack and of that partition.
