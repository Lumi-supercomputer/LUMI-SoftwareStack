# libsnd instructions

  * [libsnd web site](http://www.mega-nerd.com/libsndfile/)

  * [libsnd on GitHub](https://github.com/erikd/libsndfile/)

      * [Releases](https://github.com/erikd/libsndfile/releases)


## General information

### Dependencies

  * [libopus](https://www.opus-codec.org/)

  * [FLAC](https://xiph.org/flac/)

  * [libogg](https://xiph.org/ogg/) and [libvorbis](https://xiph.org/vorbis/)

  * [speex](https://www.speex.org/) is a potential dependency but has not been included since it is
    marked as obsolete on its web site.

  * [ALSA](https://alsa-project.org/wiki/Main_Page) support is also not included since
    that is not useful on a cluster.

  * SQLite3 is an optional dependency. We did not include it.


### Building

  * libsnd uses a configure - make - make install build process. There are
    traces of CMake support in the code, but in version 1.0.28 this does
    not work properly, or in fact tries to call the autoconf tools internally.

  * One needs to run `autogen.sh` to generate the `configure` script.

  * Notes about dependencies:

      * We don't include ALSA as that is an interface to hardware which likely doesn't make
        sense for applications on a supercomputer. According to the instructions it is only
        used in the sound player (`snd-play` executable).


## EasyConfig


  * [libsndfile support in the EasyBuilders repository](https://github.com/easybuilders/easybuild-easyconfigs/tree/develop/easybuild/easyconfigs/l/libsndfile)

  * There is no libsndfile support in the CSCS repository


### Version 1.0.31 from CPE 21.06 on

  * The EasyConfig file is a mix of the EasyBuilders one and the University
    of Antwerpen one which predates the former.


### Version 1.1.0 from CPE 22.06 on

  * Trivial bump of the EasyConfig.

  * Checked to add MPEG support, but LAME is not enough and MPG123 is also needed
    which may be a burden to install. We instead added the flag to disable MPEG support.

  * The static library is no longer generated.
  
 
### Version 1.2.0 from CPE 23.03

  * Trivial bump of the EasyConfig for 1.1.0, we did not yet switch to the CMake build
    process currently used in the EasyBuilders versions.


