Note that from `LUMI/24.03` onwards, the way we offer Perl has changed.
The Perl module now only provides a very limited selection of packages. Packages
will only be added to it if they are needed to install the central software stack.
Other Perl packages that we provided in the Perl module in earlier versions, are
now provided by the [`Perl-packages-CPAN`](../Perl-packages-CPAN/index.md) module.

This is done to speed up the development and installation of a new central software
stack after a system update, as Perl is in the critical path and having to 
build a full configuration slows down the development and deployment tremenduously.

Note also that many Perl packages are badly maintained and sometimes fail to build
with more recent library versions. As many of those packages are hardly used or
not used at all, we do no effort to update those as long as there is no clear
demand for them.
