AC_INIT([Haskell X11 package], [1.0], [libraries@haskell.org], [X11])

# Safety check: Ensure that we are in the correct source directory.
AC_CONFIG_SRCDIR([include/HsXlib.h])

AC_CONFIG_HEADERS([include/HsX11Config.h])

# Check for X11 include paths and libraries
AC_PATH_XTRA()

# Build the package if we found X11 stuff
if test "$no_x" = yes; then
  X11_BUILD_PACKAGE=no
else
  X11_BUILD_PACKAGE=yes
fi
AC_SUBST([X11_BUILD_PACKAGE])

# Define CPP variables used in package.conf.in
if test "$X11_BUILD_PACKAGE" = yes; then

  AC_DEFINE_UNQUOTED(X_CFLAGS,
    [`echo '' $X_CFLAGS | sed -e 's/-[[^ ]]*/,"&"/g' -e 's/^ *,//'`],
    [C flags for X11, as a list of string literals.])

  AC_DEFINE_UNQUOTED(X_LIBS,
    [`echo '' $X_LIBS | sed -e 's/-[[^ ]]*/,"&"/g' -e 's/^ *,//'`],
    [Library flags for X11, as a list of string literals.])

fi

AC_CONFIG_FILES([config.mk])
AC_OUTPUT
