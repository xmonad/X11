/* -----------------------------------------------------------------------------
 * $Id: HsXlib.h,v 1.3 2004/02/16 18:01:29 ross Exp $
 *
 * Definitions for package `X11' which are visible in Haskell land.
 *
 * ---------------------------------------------------------------------------*/

#ifndef HSXLIB_H
#define HSXLIB_H

#include <stdlib.h>

#include <X11/X.h>
#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>

#define XK_MISCELLANY
#define XK_LATIN1
#include <X11/keysymdef.h>

/* This error handler is used from FFI code.
 * It generates a slightly better error message than the one
 * that comes with Xlib.
 */
extern int defaultErrorHandler(Display *, XErrorEvent *);

/* Used in waitForEvent */
#include <sys/select.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

extern void fdZero(fd_set *set);
extern void fdSet(int fd, fd_set *set);

#endif
