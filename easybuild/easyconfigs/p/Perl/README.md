# Perl

  * [Perl home page](https://www.perl.org/)

      * [Perl latest versions](https://www.cpan.org/src/README.html)


## Possible issues

  * Packages that need C++ may fail with certain versions of the Cray compiler. One
    issue already observed is that C++ include files cannot be found because the compiler
    is called as ``clang++`` rather than with the ``CC`` wrapper script.

    The issue is with the code in Perl that builds a Makefile. It uses MakeMaker which
    and ExtUtils::CppGuess, and the latter fails to recognize the Cray wrappers and
    instead detect the compiler used to build Perl as clang and hence uses clang++
    as the compatible C++-compiler.


## EasyBuild

  * [Perl support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/p/Perl)

  * [Perl support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/p/Perl)


### Version 5.34 for CPE 21.08

  * The EasyConfig is a straight port of the EasyBuilders one for 2021b, except that
    we made OpenSSL a OS dependency since we want to use the OS version of security
    libraries as much as possible to ensure that they get patched.

  * Issue with cpeCray/21.08 for the ``Set::IntervalTree`` package: The makefile that
    is generated during the configure step uses ``clang++`` rather then ``CC`` and as
    a consequence not all include files are found.

    Workaround: Edit the Makefile in ``prebuildopts`` with ``sed``:
    ``'prebuildopts': 'sed -i -e "s|CC = .*|CC = CC|" Makefile && '``.

### Version 5.36 for CPE 22.05

  * We used the list of extensions from the EasyConfig for GCCcore/11.3.0, part of 2022a.

  * Issue with cpeCray/21.08 for the ``Set::IntervalTree`` package: The makefile that
    is generated during the configure step uses ``clang++`` rather then ``CC`` and as
    a consequence not all include files are found.

    Workaround: Edit the Makefile in ``prebuildopts`` with ``sed``:
    ``'prebuildopts': 'sed -i -e "s|CC = .*|CC = CC|" Makefile && '``.
    This is safe for all CPE toolchains.

  * Do not forget to remove the `preconfigopts` ofr `Net::SSLeay`.

  * Other issues:

      * AOCC: 
 
          * `DBD::SQLite` extension does not compile