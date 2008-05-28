AC_INIT([Haskell X11 package], [1.4.2], [dons@galois.com], [X11])

FP_ARG_X11

if test "$enable_x11" = no; then
  X11_BUILD_PACKAGE=no
  BUILD_PACKAGE_BOOL=False
else
# Safety check: Ensure that we are in the correct source directory.
AC_CONFIG_SRCDIR([include/HsXlib.h])

AC_CONFIG_HEADERS([include/HsX11Config.h include/X11_extras_config.h]) 

# Check for X11 include paths and libraries
AC_PATH_XTRA

# AC_PATH_XTRA doesn't actually check that the C compiler can
# really include the X headers, so double-check here.  In particular,
# this will catch the case of using a mingw32 gcc on a Cygwin system:
# Cygwin has the X headers & libs installed, but the mingw32 gcc can't
# use them, and we want to disable the package in this case.
CPPFLAGS="$CPPFLAGS $X_CFLAGS"
AC_TRY_CPP([#include <X11/Xlib.h>],,[no_x=yes])

# If there's some oddball X11 include path, we need it to check there for
# Xinerama headers.
if test -n "$x_includes"; then
    CPPFLAGS="$CPPFLAGS -I$x_includes"
fi

# Build the package if we found X11 stuff
if test "$no_x" = yes; then
  AC_MSG_FAILURE([X11 libraries not found, so X11 package cannot be built])
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


AC_MSG_CHECKING([whether to build Xinerama])
AC_ARG_WITH(xinerama,
            AS_HELP_STRING([--without-xinerama], [do not build Xinerama support]),
            [],
            [with_xinerama=yes])
AC_MSG_RESULT([$with_xinerama])

if test "$with_xinerama" = yes; then
    AC_CHECK_HEADERS([X11/extensions/Xinerama.h], [have_xinerama=yes])
    if test "$have_xinerama" = yes; then
        EXTRA_LIBRARIES="extra-libraries: Xinerama Xext"
    else
        EXTRA_LIBRARIES=""
        echo "WARNING: Xinerama headers not found. Building without Xinerama support"
    fi
else
    EXTRA_LIBRARIES=""
    echo "WARNING: Building without Xinerama support per user request"
fi

AC_MSG_CHECKING([whether to include X.org keysyms])
AC_ARG_WITH(xorg-keysym,
            AS_HELP_STRING([--without-xorg-keysym], [do not build X.org keysym support]),
            [],
            [with_xorg_keysym=yes])
AC_MSG_RESULT([$with_xorg_keysym])

if test "$with_xorg_keysym" = yes; then
    AC_CHECK_HEADERS([X11/keysym.h], [have_keysym=yes])
    if ! test "$have_keysym" = yes; then
        echo "WARNING: Couldn't find <X11/keysym.h> for X.org keysyms"
    fi

    AC_CHECK_HEADERS([X11/DECkeysym.h], [have_dec_keysym=yes])
    if ! test "$have_dec_keysym" = yes; then
        echo "WARNING: Couldn't find <X11/DECkeysym.h> for X.org keysyms"
    fi

    AC_CHECK_HEADERS([X11/Sunkeysym.h], [have_sun_keysym=yes])
    if ! test "$have_sun_keysym" = yes; then
        echo "WARNING: Couldn't find <X11/Sunkeysym.h> for X.org keysyms"
    fi

    AC_CHECK_HEADERS([X11/ap_keysym.h], [have_ap_keysym=yes])
    if ! test "$have_ap_keysym" = yes; then
        echo "WARNING: Couldn't find <X11/ap_keysym.h> for X.org keysyms"
    fi

    AC_CHECK_HEADERS([X11/HPkeysym.h], [have_hp_keysym=yes])
    if ! test "$have_hp_keysym" = yes; then
        echo "WARNING: Couldn't find <X11/HPkeysym.h> for X.org keysyms"
    fi

    AC_CHECK_HEADERS([X11/XF86keysym.h], [have_xf86_keysym=yes])
    if ! test "$have_xf86_keysym" = yes; then
        echo "WARNING: Couldn't find <X11/XF86keysym.h> for X.org keysyms"
    fi

    AC_CHECK_HEADERS([X11/keysymdef.h], [have_keysymdef=yes])
    if ! test "$have_keysymdef" = yes; then
        echo "WARNING: Couldn't find <X11/keysymdef.h> for X.org keysyms"
    fi
fi



AC_SUBST([EXTRA_LIBRARIES])

AC_CONFIG_FILES([config.mk X11.buildinfo])
AC_OUTPUT
