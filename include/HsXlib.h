/* -----------------------------------------------------------------------------
 * $Id: HsXlib.h,v 1.1 2003/04/03 23:44:04 reid Exp $
 *
 * Definitions for package `lang' which are visible in Haskell land.
 *
 * ---------------------------------------------------------------------------*/

#ifndef HSXLIB_H
#define HSXLIB_H

#include <X11/X.h>
#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>

#define XK_MISCELLANY
#define XK_LATIN1
#include <X11/keysymdef.h>

/* These macros are used to generate error messages in GreenCard code */
#define ErrorMsg(where,what) "Error " what " raised in function " #where

#define NullPtr(where)       ErrorMsg(where,"null ptr")
#define BadStatus(err,where) ErrorMsg(where,"bad status")
#define Zero(err,where)      ErrorMsg(where,"zero")

/* AllPlanes is a macro so we can't call it.
 * For now we can get round this by defining a macro that looks like
 * it is a function.  (Slightly illegal under the ffi spec.)
 */
#define AllPlanes_aux() AllPlanes

/* This error handler is used from GreenCard code.
 * It generates a slightly better error message than the one
 * that comes with Xlib.
 */
extern int defaultErrorHandler(Display *, XErrorEvent *);

/* Used in waitForTimeout */
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

#endif
