# libtheora instructions

  * [libtheora web site](https://www.theora.org/)
      * [downloads via the web site](https://www.theora.org/downloads/)
  * [libvorbis on GitHub](https://github.com/xiph/theora)
      * [libvorbis releases on GitHub](https://github.com/xiph/theora/releases)

## General information

  * libtheora needs libogg.
  * The optional sample encoder also needs libvorbis.
  * [LibSDL](https://www.libsdl.org/) is an optional dependency used for the player
    and not useful for the cluster.
  * libtheora has a configure - make - make install build process.

## EasyConfig

  * No support was found in EasyBuild at the moment of the first installation,
    so we developed our own EasyConfig.
  * The `autogen.sh` script does start `configure` at the end which is unfortunate
    in the EasyBuild context. We remove the last line of `autogen.sh`.
  * We do explicitly disable the search for LibSDL to avoid the associated warning
    and to make it very clear in the EasyConfig that we did not overlook this
    dependency. (Well, the option doesn't work in version 1.1.1...)
  * Integrated into the baselibs module from the 2020a toolchains on.

### Version 1.1.1, 2020a toolchains

* It turns out that libtheora has problems with our version of libpng, so we stopped
  the effort to get it to install. The problem occurs while compiling one of the 
  example files, 'png2theora.c'. The bug has been submitted and corrected in February
  2014 but has not yet made it into a released version. 
  Hence we decided to disable building the examples until a new version of libtheora
  becomes available which should fix this problem as it is already corrected in the
  source code of 'examples/png2theora.c' 
  ([relevant GitHub commit](https://gitlab.xiph.org/xiph/theora/commit/7288b539c52e99168488dc3a343845c9365617c8)).
