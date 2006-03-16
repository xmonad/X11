# Empty file to avoid a dependency on automake: autoreconf calls aclocal to
# generate a temporary aclocal.m4t when no aclocal.m4 is present.

# FP_ARG_X11
# -------------
AC_DEFUN([FP_ARG_X11],
[AC_ARG_ENABLE([x11],
  [AC_HELP_STRING([--enable-x11],
    [build a Haskell binding for X11.
     (default=autodetect)])],
  [enable_x11=$enableval],
  [enable_x11=yes])
])# FP_ARG_X11
