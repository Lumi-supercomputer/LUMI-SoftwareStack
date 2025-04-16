# systools user instructions

<<<<<<< HEAD
Available tools depend on the version of the module. This list is for the latest
version of the module.

=======
>>>>>>> 82274776 (Added pbzip2 to systools and updated the documentation.)

### The `gpp` command

The [`gpp` command](https://logological.org/gpp) 
is a general-purpose preprocessor with customizable syntax, suitable for a
wide range of preprocessing tasks. Its independence from any one programming
language makes it much more versatile than the C preprocessor (cpp), while its
syntax is lighter and more flexible than that of GNU m4. There are built-in
macros for use with C/C++, LaTeX, HTML, XHTML, and Prolog files.


## The `htop` command

The [`htop` command](https://htop.dev/) is an interactive process viewer for Unix/Linux.

Note that by default, htop will not show the load of individual cores as you may be used from
many other sites. However, given that there are 256 virtual cores on most nodes, this produces
visual overload for may. It is still possible to change the settings in htop by going into the
settings screen using "SHFIT-S" and then changing the meters, e.g., adding
"CPUS (1-4/8): first half in 4 shorter columns" to the first half and
"CPUS (5-8/8): second half in 4 shorter columns" to the second.

This configuration will be stored in ~/.config/htop/htoprc, so you can also copy settings
from another user by exchanging that file.


## The `pbzip2` command

The [`pbzip2` command](http://compression.great-site.net/pbzip2/) 
is a multithreaded version of the `bzip2` command.
Check the manual page though as it has additional options to determine the
amount of parallelism. The code was patched by LUST so that by default
it will detect the correct number of hyperthreads available in a Slurm job
and limit the number of threads to 16 on the login nodes to not overwhelm
them (and as you are limited to the CPU capacity equivalent with 16 
cores anyway).

This code has been unmaintained since 2015, so there is no guarantee that
we can continue to provide it. Issues with it will not get fixed.

The code was never truly adapted the the 64-bit world. Memory management is 
still 32-bit code, limiting the amount of memory one can request via the 
`-m` parameter to 2000 blocks.

It is also an alternative to [`lbzip2`](https://lbzip2.org/) which is also unmaintained and
has become almost impossible to compile on modern machines.


## The `tree` command

The [`tree` command](https://gitlab.com/OldManProgrammer/unix-tree) 
is a recursive directory listing command that produces a depth indented
listing of files, which is colorized ala dircolors if the LS_COLORS environment
variable is set and output is to tty.


## The `proot` command

The [`proot` command](https://proot-me.github.io/) is a user-space implementation of 
chroot, mount --bind, and 
binfmt_misc. This means that users don't need any privileges or setup to do 
things like using an arbitrary directory as the new root filesystem, making 
files accessible somewhere else in the filesystem hierarchy, or executing 
programs built for another CPU architecture transparently through QEMU 
user-mode.

It is provided in this module mainly for use with singularity.

Note that there is now also a separate [`PRoot` module](../../p/PRoot/index.md)
as that turned out to be needed to work easily with EasyBuild to enhance 
containers. The command is kept here so that older documentation that tells 
to load `systools` remains valid.
