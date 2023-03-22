# ncurses user instructions

This module has known incompatibilities with some tools that come with SUSE Linux,
but we fail to find a proper solution to build `ncurses` in a way that is fully
compatible with SUSE Linux. The problem is that the SUSE `ncurses` library contains
some versioned symbols for ancient or nonstandard versions of `ncurses` that is not 
included when building more recent regular versions.

One application that fails is the `gdb` command. A workaround for this command is
to start it as

```
LD_PRELOAD=/lib64/libncursesw.so.6 gdb
```
