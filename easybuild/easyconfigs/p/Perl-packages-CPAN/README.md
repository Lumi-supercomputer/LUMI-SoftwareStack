# Technical information for Perl-packages-CPAN

This is a bundle of packages taken from CPAN and largely based on the
[EasyBuild PErl-bundle-CPAN module](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/p/Perl-bundle-CPAN).

Even with the GNU compilers, we experience problems that may be unique to SUSE or COS
(Cray Operating System, a restricted SUSE). This situation only becomes worse when 
using other compilers, as many of those packages are not well maintained or tested 
on only a very limited range of OS variants and compilers. 
Moreover, Perl packages tend to be very small but with lots of dependencies,
and CPAN is organised in a way that it is hard to do reproducible installations which
is needed for a central software stack.
The packages were split off from the regular
Perl module as they slow down the development of the software stack too much.

Given that a Perl installation typically consists of hundreds of packages with small 
files, it is one of those things that should better be done into a container, especially
when Perl is called inside a parallel process.

**Getting this module into a new software stack does not have a high priority for LUST
and it may be removed entirely in the future.**


## Packages for 5.38.0

-   As usual, more compilation issues with clang-based compilers.

-   For the 24.11 container, we had to remove several packages as they wouldn't
    compile or install correctly, but the source of issues is usually hard to find.
    Some failed in `partition/G` but not in the CPU partitions for very unclear reasons,
    even though we tried to disable Lmod CPE modules that may cause trouble but likely aren't
    used by any Perl package.
