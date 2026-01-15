# Perl

-   [Perl home page](https://www.perl.org/)

    -   [Perl latest versions](https://www.cpan.org/src/README.html)


## Possible issues

-   Packages that need C++ may fail with certain versions of the Cray compiler. One
    issue already observed is that C++ include files cannot be found because the compiler
    is called as ``clang++`` rather than with the ``CC`` wrapper script.

    The issue is with the code in Perl that builds a Makefile. It uses MakeMaker which
    and ExtUtils::CppGuess, and the latter fails to recognize the Cray wrappers and
    instead detect the compiler used to build Perl as clang and hence uses clang++
    as the compatible C++-compiler.


## EasyBuild

-   [Perl support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/p/Perl)

-   [Perl support in the CSCS repository](https://github.com/eth-cscs/production/tree/master/easybuild/easyconfigs/p/Perl)


### Version 5.34 for CPE 21.08

-   The EasyConfig is a straight port of the EasyBuilders one for 2021b, except that
    we made OpenSSL a OS dependency since we want to use the OS version of security
    libraries as much as possible to ensure that they get patched.

-   Issue with cpeCray/21.08 for the ``Set::IntervalTree`` package: The makefile that
    is generated during the configure step uses ``clang++`` rather then ``CC`` and as
    a consequence not all include files are found.

    Workaround: Edit the Makefile in ``prebuildopts`` with ``sed``:
    ``'prebuildopts': 'sed -i -e "s|CC = .*|CC = CC|" Makefile && '``.

### Version 5.36 for CPE 22.06

-   We used the list of extensions from the EasyConfig for GCCcore/11.3.0, part of 2022a.

-   Issue with cpeCray/21.08 for the ``Set::IntervalTree`` package: The makefile that
    is generated during the configure step uses ``clang++`` rather then ``CC`` and as
    a consequence not all include files are found.

    Workaround: Edit the Makefile in ``prebuildopts`` with ``sed``:
    ``'prebuildopts': 'sed -i -e "s|CC = .*|CC = CC|" Makefile && '``.
    This is safe for all CPE toolchains.

-   Do not forget to remove the `preconfigopts` or `Net::SSLeay`.

-   Other issues:

    -   AOCC: 
 
        - `DBD::SQLite` extension does not compile
          
-   Updated package list in the versions for CPE 22.12 and 23.03 to those from the 
    EasyConfig for GCCcore/12.2.0, part of 2022b.
    
    -   Did not update all user requeste packages as it looks like the version of
        Alien::Libxml2 did not build on top of the version of Alien::Base that was
        up-to-date at the time of development. This may be caused by some new extensions
        that require other missing dependencies, but we did not want to slow down the
        development of a central stack on which too many users depend too much for 
        the wishes of just one or a few users.

### Updates to 5.36.0 for CPE 22.12/23.03

-   Clang 15 is stricter on conversions from integers to pointers and does not accept
    converting a negative integer (or signed integer type in general) to a pointer.
    This breaks the "XML::Bare" extension. The solution is to add a compiler flag to turn
    of that feature. The way to get that into the makefile was actually:
    ```
    'buildopts': 'OPTIMIZE="-O2 -Wno-int-conversion" ',
    ```
  

### Version 5.36.1 for CPE 23.09

-   Updated the version of Perl to align with 2023a, but did not update the package
    list due to the amount of work this takes. EasyBuild has changed its policy with
    respect to additional packages which would change the way our users need to use the
    Perl module.
    
-   Clang 16 based compilers are more picky and also no longer accept C90 by default, 
    so we needed to set special options for several packages.

-   Needed to add additional flags to some packages with `cpeAMD` when that toolchain
    is configured with ROCm 6.0.3 (for recompilation after the system update of the
    summer of 2024).

-   For LUMI/23.12, the license information for the main Perl package was added to the installation.

  
### Version 5.38.0 for LUMI/24.03

-   The EasyConfig is an update of the one for 5.36.1 for LUMI/23.12.
  
-   Some clean-up of dependencies for the -bare configurations.


### Version 5.40.0 for LUMI/25.03

-   Almost straightforward port of the EasyConfig for 5.38.0.

-   Did the package clean-up that is also done in the EasyBuilders recipe as several
    modules are nowadays part of Perl.


### Version 5.40.2 for LUMI/25.09

-   Straightforward port of the EasyConfig for 5.40.0.

