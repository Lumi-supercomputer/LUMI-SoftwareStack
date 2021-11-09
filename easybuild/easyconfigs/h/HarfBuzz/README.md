# HarfBuzz instructions

  * [HarfBuzz web site](http://www.freedesktop.org/wiki/Software/HarfBuzz)

  * [HArfBuzz on GitHub](https://github.com/harfbuzz/harfbuzz)

      * [GitHub releases](https://github.com/harfbuzz/harfbuzz/releases)


## EasyBuild

  * [HarfBuzz support in the EasyBuilders repository]()

  * Three is no HarfBuzz support in the CSCS repository.


### Version 2.8.2 for cpe 21.08

  * It was a deliberate choice to stick to version 2.8.2 even though there
    was already a 3.1.1 version. There were API changes in version 3.0.0 (and
    the 2.9 versions which were really a preparation for 3.0) so there were
    concerns that it might break builds.

  * The EasyConfig is a mix of the EasyBuilders and UAntwerpen ones.
