# Haskell binding to the X11 graphics library [![Hackage](https://img.shields.io/hackage/v/X11.svg?style=flat)](https://hackage.haskell.org/package/X11) [![Build Status](https://img.shields.io/travis/xmonad/X11.svg?style=flat)](https://travis-ci.org/xmonad/X11)

To build this package using Cabal directly from Git, you must run
`autoreconf` before the usual Cabal build steps (configure/build/install).
`autoreconf` is included in the GNU autoconf tools.  There is no need to run
the `configure` script: the `cabal configure` step will do this for you.

If you are building from a source tarball, you can just use the standard Cabal
installation stanza:

    cabal configure
    cabal build
    cabal install

Xinerama support is enabled by default if Xinerama headers are detected.  To
disable Xinerama support, add the `--without-xinerama` flag to
`configure-option`:

    cabal configure --configure-option="--without-xinerama"

However, if you are building from Git, X11 uses `autoconf`, so you need
to have `autoconf` installed and run `autoconf`/`autoheader` before building:

    autoconf
    autoheader

or

    autoreconf
