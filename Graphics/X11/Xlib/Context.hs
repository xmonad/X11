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

-- | interface to the X11 library function @XSetArcMode()@.
foreign import ccall unsafe "HsXlib.h XSetArcMode"
	setArcMode     	     :: Display -> GC -> ArcMode               -> IO ()

-- | interface to the X11 library function @XSetBackground()@.
foreign import ccall unsafe "HsXlib.h XSetBackground"
	setBackground  	     :: Display -> GC -> Pixel                 -> IO ()

-- | interface to the X11 library function @XSetForeground()@.
foreign import ccall unsafe "HsXlib.h XSetForeground"
	setForeground 	     :: Display -> GC -> Pixel                 -> IO ()

-- | interface to the X11 library function @XSetFunction()@.
foreign import ccall unsafe "HsXlib.h XSetFunction"
	setFunction	     :: Display -> GC -> GXFunction            -> IO ()

-- | interface to the X11 library function @XSetGraphicsExposures()@.
foreign import ccall unsafe "HsXlib.h XSetGraphicsExposures"
	setGraphicsExposures :: Display -> GC -> Bool                  -> IO ()

-- | interface to the X11 library function @XSetClipMask()@.
foreign import ccall unsafe "HsXlib.h XSetClipMask"
	setClipMask          :: Display -> GC -> Pixmap                -> IO ()

-- | interface to the X11 library function @XSetClipOrigin()@.
foreign import ccall unsafe "HsXlib.h XSetClipOrigin"
	setClipOrigin        :: Display -> GC -> Position -> Position  -> IO ()

-- XSetClipRectangles omitted because it's not clear when it's safe to delete the
-- array of rectangles

-- | interface to the X11 library function @XSetDashes()@.
setDashes            :: Display -> GC -> Int -> String -> Int  -> IO ()
setDashes display gc dash_offset dashes n =
	withCString dashes $ \ dash_list ->
	xSetDashes display gc dash_offset dash_list n
foreign import ccall unsafe "HsXlib.h XSetDashes"
	xSetDashes           :: Display -> GC -> Int -> CString -> Int -> IO ()

-- | interface to the X11 library function @XSetFillRule()@.
foreign import ccall unsafe "HsXlib.h XSetFillRule"
	setFillRule          :: Display -> GC -> FillRule              -> IO ()

-- | interface to the X11 library function @XSetFillStyle()@.
foreign import ccall unsafe "HsXlib.h XSetFillStyle"
	setFillStyle         :: Display -> GC -> FillStyle             -> IO ()

-- | interface to the X11 library function @XSetFont()@.
foreign import ccall unsafe "HsXlib.h XSetFont"
	setFont              :: Display -> GC -> Font                  -> IO ()

-- | interface to the X11 library function @XSetLineAttributes()@.
foreign import ccall unsafe "HsXlib.h XSetLineAttributes"
	setLineAttributes    :: Display -> GC -> Int -> LineStyle ->
					CapStyle -> JoinStyle -> IO ()

-- | interface to the X11 library function @XSetPlaneMask()@.
foreign import ccall unsafe "HsXlib.h XSetPlaneMask"
	setPlaneMask         :: Display -> GC -> Pixel                 -> IO ()

-- | interface to the X11 library function @XSetState()@.
foreign import ccall unsafe "HsXlib.h XSetState"
	setState             :: Display -> GC -> Pixel -> Pixel ->
					GXFunction -> Pixel            -> IO ()

-- | interface to the X11 library function @XSetStipple()@.
foreign import ccall unsafe "HsXlib.h XSetStipple"
	setStipple           :: Display -> GC -> Pixmap                -> IO ()

-- | interface to the X11 library function @XSetSubwindowMode()@.
foreign import ccall unsafe "HsXlib.h XSetSubwindowMode"
	setSubwindowMode     :: Display -> GC -> SubWindowMode         -> IO ()

-- | interface to the X11 library function @XSetTSOrigin()@.
foreign import ccall unsafe "HsXlib.h XSetTSOrigin"
	setTSOrigin          :: Display -> GC -> Position -> Position  -> IO ()

-- | interface to the X11 library function @XSetTile()@.
foreign import ccall unsafe "HsXlib.h XSetTile"
	setTile              :: Display -> GC -> Pixmap                -> IO ()

-- ToDo: create a real interface to this
-- | partial interface to the X11 library function @XCreateGC()@.
createGC :: Display -> Drawable -> IO GC
createGC display d = xCreateGC display d 0 nullPtr
foreign import ccall unsafe "HsXlib.h XCreateGC"
	xCreateGC  :: Display -> Drawable -> ValueMask -> Ptr GCValues -> IO GC

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

-- | interface to the X11 library function @XGContextFromGC()@.
foreign import ccall unsafe "HsXlib.h XGContextFromGC"
	gContextFromGC :: GC -> GContext

-- | interface to the X11 library function @XFreeGC()@.
foreign import ccall unsafe "HsXlib.h XFreeGC"
	freeGC  :: Display -> GC -> IO ()

-- | interface to the X11 library function @XFlushGC()@.
foreign import ccall unsafe "HsXlib.h XFlushGC"
	flushGC :: Display -> GC -> IO ()

-- | interface to the X11 library function @XCopyGC()@.
foreign import ccall unsafe "HsXlib.h XCopyGC"
	copyGC  :: Display -> GC -> Mask -> GC -> IO ()

----------------------------------------------------------------
-- End
----------------------------------------------------------------
