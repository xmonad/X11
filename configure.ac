AC_INIT([Haskell X11 package], [1.1], [libraries@haskell.org], [X11])

FP_ARG_X11

if test "$enable_x11" = no; then
  X11_BUILD_PACKAGE=no
  BUILD_PACKAGE_BOOL=False
else
# Safety check: Ensure that we are in the correct source directory.
AC_CONFIG_SRCDIR([include/HsXlib.h])

AC_CONFIG_HEADERS([include/HsX11Config.h])

# Check for X11 include paths and libraries
AC_PATH_XTRA

# AC_PATH_XTRA doesn't actually check that the C compiler can
# really include the X headers, so double-check here.  In particular,
# this will catch the case of using a mingw32 gcc on a Cygwin system:
# Cygwin has the X headers & libs installed, but the mingw32 gcc can't
# use them, and we want to disable the package in this case.
CPPFLAGS="$CPPFLAGS $X_CFLAGS"
AC_TRY_CPP([#include <X11/Xlib.h>],,[no_x=yes])

# Build the package if we found X11 stuff
if test "$no_x" = yes; then
  X11_BUILD_PACKAGE=no
  BUILD_PACKAGE_BOOL=False
else
  X11_BUILD_PACKAGE=yes
  BUILD_PACKAGE_BOOL=True
fi
fi
AC_SUBST([X11_BUILD_PACKAGE])
AC_SUBST([BUILD_PACKAGE_BOOL])

# Define CPP variables used in package.conf.in
if test "$X11_BUILD_PACKAGE" = yes; then

  AC_DEFINE_UNQUOTED(X_CFLAGS,
    [`echo '' $X_CFLAGS | sed -e 's/-[[^ ]]*/,"&"/g' -e 's/^ *,//'`],
    [C flags for X11, as a list of string literals.])

  AC_DEFINE_UNQUOTED(X_LIBS,
    [`echo '' $X_LIBS | sed -e 's/-[[^ ]]*/,"&"/g' -e 's/^ *,//'`],
    [Library flags for X11, as a list of string literals.])

fi

AC_CONFIG_FILES([config.mk X11.buildinfo])
AC_OUTPUT
