#ifndef HSALLKEYSYMS_H
#define HSALLKEYSYMS_H 1

#include "HsX11Config.h"

/* Defaults */
#if HAVE_X11_KEYSYM_H
#  include <X11/keysym.h>
#elif HAVE_X11_KEYSYMDEF_H
/* Everything in X.org by default */
#  define XK_MISCELLANY
#  define XK_XKB_KEYS
#  define XK_LATIN1
#  define XK_LATIN2
#  define XK_LATIN3
#  define XK_LATIN4
#  define XK_LATIN8
#  define XK_LATIN9
#  define XK_CAUCASUS
#  define XK_GREEK
#  define XK_KATAKANA
#  define XK_ARABIC
#  define XK_CYRILLIC
#  define XK_HEBREW
#  define XK_THAI
#  define XK_KOREAN
#  define XK_ARMENIAN
#  define XK_GEORGIAN
#  define XK_VIETNAMESE
#  define XK_CURRENCY
#  define XK_MATHEMATICAL
#  define XK_BRAILLE

#  include <X11/keysymdef.h>
#endif

/* Vendor specific */
#if HAVE_X11_DECKEYSYM_H
#  include <X11/DECkeysym.h>
#endif
#if HAVE_X11_SUNKEYSYM_H
#  include <X11/Sunkeysym.h>
#endif
#if HAVE_X11_AP_KEYSYM_H
#  include <X11/ap_keysym.h>
#endif
#if HAVE_X11_HPKEYSYM_H
#  include <X11/HPkeysym.h>
#endif
#if HAVE_X11_XF86KEYSYM_H
#  include <X11/XF86keysym.h>
#endif

#include <X11/X.h>

#endif /* HSALLKEYSYMS_H */
