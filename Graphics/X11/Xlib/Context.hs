-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Context
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of FFI declarations for interfacing with Xlib Graphics
-- Contexts.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Context(

        setArcMode,
        setBackground,
        setForeground,
        setFunction,
        setGraphicsExposures,
        setClipMask,
        setClipOrigin,
        setDashes,
        setFillRule,
        setFillStyle,
        setFont,
        setLineAttributes,
        setPlaneMask,
        setState,
        setStipple,
        setSubwindowMode,
        setTSOrigin,
        setTile,
        createGC,
        gContextFromGC,
        freeGC,
        flushGC,
        copyGC,

        ) where

import Graphics.X11.Types
import Graphics.X11.Xlib.Types

import Foreign
import Foreign.C

----------------------------------------------------------------
-- Graphics contexts
----------------------------------------------------------------

-- Convenience functions

foreign import ccall unsafe "HsXlib.h XSetArcMode"
	setArcMode     	     :: Display -> GC -> ArcMode               -> IO ()
foreign import ccall unsafe "HsXlib.h XSetBackground"
	setBackground  	     :: Display -> GC -> Pixel                 -> IO ()
foreign import ccall unsafe "HsXlib.h XSetForeground"
	setForeground 	     :: Display -> GC -> Pixel                 -> IO ()
foreign import ccall unsafe "HsXlib.h XSetFunction"
	setFunction	     :: Display -> GC -> GXFunction            -> IO ()
foreign import ccall unsafe "HsXlib.h XSetGraphicsExposures"
	setGraphicsExposures :: Display -> GC -> Bool                  -> IO ()
foreign import ccall unsafe "HsXlib.h XSetClipMask"
	setClipMask          :: Display -> GC -> Pixmap                -> IO ()
foreign import ccall unsafe "HsXlib.h XSetClipOrigin"
	setClipOrigin        :: Display -> GC -> Position -> Position  -> IO ()

-- XSetClipRectangles omitted because it's not clear when it's safe to delete the
-- array of rectangles

setDashes            :: Display -> GC -> Int -> String -> Int  -> IO ()
setDashes display gc dash_offset dashes n =
	withCString dashes $ \ dash_list ->
	xSetDashes display gc dash_offset dash_list n
foreign import ccall unsafe "HsXlib.h XSetDashes"
	xSetDashes           :: Display -> GC -> Int -> CString -> Int -> IO ()
foreign import ccall unsafe "HsXlib.h XSetFillRule"
	setFillRule          :: Display -> GC -> FillRule              -> IO ()
foreign import ccall unsafe "HsXlib.h XSetFillStyle"
	setFillStyle         :: Display -> GC -> FillStyle             -> IO ()
foreign import ccall unsafe "HsXlib.h XSetFont"
	setFont              :: Display -> GC -> Font                  -> IO ()
foreign import ccall unsafe "HsXlib.h XSetLineAttributes"
	setLineAttributes    :: Display -> GC -> Int -> LineStyle ->
					CapStyle -> JoinStyle -> IO ()
foreign import ccall unsafe "HsXlib.h XSetPlaneMask"
	setPlaneMask         :: Display -> GC -> Pixel                 -> IO ()
foreign import ccall unsafe "HsXlib.h XSetState"
	setState             :: Display -> GC -> Pixel -> Pixel ->
					GXFunction -> Pixel            -> IO ()
foreign import ccall unsafe "HsXlib.h XSetStipple"
	setStipple           :: Display -> GC -> Pixmap                -> IO ()
foreign import ccall unsafe "HsXlib.h XSetSubwindowMode"
	setSubwindowMode     :: Display -> GC -> SubWindowMode         -> IO ()
foreign import ccall unsafe "HsXlib.h XSetTSOrigin"
	setTSOrigin          :: Display -> GC -> Position -> Position  -> IO ()
foreign import ccall unsafe "HsXlib.h XSetTile"
	setTile              :: Display -> GC -> Pixmap                -> IO ()

-- ToDo: create a real interface to this
createGC :: Display -> Drawable -> IO GC
createGC display d = xCreateGC display d 0 nullPtr
foreign import ccall unsafe "HsXlib.h XCreateGC"
	xCreateGC  :: Display -> Drawable -> ValueMask -> Ptr XGCValues -> IO GC

type ValueMask = Word32

-- OLD:
-- %synonym : GCValueSet : Ptr
--   in rtsDummy
--
-- {%
-- typedef unsigned long GCMask; /* cf XtGCMask */
-- typedef struct _gcvalues {
--     GCMask	mask;
--     XGCValues	values;
-- }* GCValueSet;
-- %}
--
-- IMPURE GCValueSet	emptyGCValueSet()
-- RESULT: (RETVAL = (GCValueSet) malloc(sizeof(struct _gcvalues))) ? RETVAL->mask = 0, RETVAL : RETVAL;
-- POST: RETVAL != NULL
--
-- IMPURE void	setGCForeground(colour, set)
-- IN Pixel	colour
-- IN GCValueSet	set
-- RESULT: set->mask |= GCForeground; set->values.foreground = colour
--
-- IMPURE void	setGCBackground(colour, set)
-- IN Pixel	colour
-- IN GCValueSet	set
-- RESULT: set->mask |= GCBackground; set->values.background = colour
--
-- IMPURE void	freeGCValueSet(set)
-- IN GCValueSet	set
-- RESULT: free(set)
--
-- IMPURE GC	XCreateGC(display, d, set->mask, &(set->values))
-- NAME: xCreateGC
-- IN Display*	display
-- IN Drawable	d
-- IN GCValueSet	set
--
-- IMPURE void	XChangeGC(display, gc, set->mask, &(set->values))
-- NAME: xChangeGC
-- IN Display*	display
-- IN GC		gc
-- IN GCValueSet	set
--
-- STARTH
-- -- Code that packages GCValueSets up in a clean monoidic way.
--
-- data GCSetter = GCSetter (GCValueSet -> IO ()) -- should be newtype
--
-- createGC :: Display -> Drawable -> GCSetter -> IO GC
-- createGC display d (GCSetter setter) =
--   emptyGCValueSet        >>= \ set ->
--   setter set             >>
--   xCreateGC display d set >>= \ gc ->
--   freeGCValueSet set     >>
--   return gc
--
-- changeGC :: Display -> Drawable -> GC -> GCSetter -> IO ()
-- changeGC display d gc (GCSetter setter) =
--   emptyGCValueSet        >>= \ set ->
--   setter set             >>
--   xChangeGC display d set >>= \ gc ->
--   freeGCValueSet set
--
-- instance Monoid GCSetter where
--   (GCSetter m) >>> (GCSetter k)
--     = GCSetter (\ settings -> m settings >> k settings)
--   unit = GCSetter (\ _ -> return ())
--
-- set_Background :: Pixel -> GCSetter
-- set_Background c = GCSetter (setGCBackground c)
--
-- set_Foreground :: Pixel -> GCSetter
-- set_Foreground c = GCSetter (setGCForeground c)
-- ENDH

foreign import ccall unsafe "HsXlib.h XGContextFromGC"
	gContextFromGC :: GC -> GContext

foreign import ccall unsafe "HsXlib.h XFreeGC"
	freeGC  :: Display -> GC -> IO ()
foreign import ccall unsafe "HsXlib.h XFlushGC"
	flushGC :: Display -> GC -> IO ()

foreign import ccall unsafe "HsXlib.h XCopyGC"
	copyGC  :: Display -> GC -> Mask -> GC -> IO ()

----------------------------------------------------------------
-- End
----------------------------------------------------------------
