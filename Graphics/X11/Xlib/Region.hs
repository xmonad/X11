{-# OPTIONS_GHC -cpp -fglasgow-exts #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Region
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of FFI declarations for interfacing with Xlib Regions.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Region(
        Region,

        RectInRegionResult,
        rectangleOut,
        rectangleIn,
        rectanglePart,

        createRegion,
        polygonRegion,
        intersectRegion,
        subtractRegion,
        unionRectWithRegion,
        unionRegion,
        xorRegion,
        emptyRegion,
        equalRegion,
        pointInRegion,
        rectInRegion,
        clipBox,
        offsetRegion,
        shrinkRegion,
        setRegion,

        ) where

import Graphics.X11.Types
import Graphics.X11.Xlib.Types

import Foreign.ForeignPtr
import Foreign.Ptr
import Foreign.Storable
import Foreign.Marshal.Alloc
import Foreign.Marshal.Array
import Foreign.Marshal.Utils

#if __GLASGOW_HASKELL__
import Data.Generics
#endif

----------------------------------------------------------------
-- Regions
----------------------------------------------------------------

newtype Region = Region (ForeignPtr Region)
#if __GLASGOW_HASKELL__
	deriving (Eq, Ord, Show, Typeable, Data)
#else
	deriving (Eq, Ord, Show)
#endif

withRegion :: Region -> (Ptr Region -> IO a) -> IO a
withRegion (Region r) = withForeignPtr r

type RectInRegionResult = Int

-- Return values from XRectInRegion()
rectangleOut, rectangleIn, rectanglePart :: RectInRegionResult
rectangleOut  = 0
rectangleIn   = 1
rectanglePart = 2

----------------------------------------------------------------
-- Creating regions
----------------------------------------------------------------

-- regions deallocation is handled by the GC (ForeignPtr magic)
-- so we don't provide XDestroyRegion explicitly
-- no idea what the int is for
-- %fun XDestroyRegion :: Region -> IO Int
foreign import ccall unsafe "HsXlib.h &XDestroyRegion"
        xDestroyRegionPtr :: FunPtr (Ptr Region -> IO ())

makeRegion :: Ptr Region -> IO Region
makeRegion rp = do
	r <- newForeignPtr xDestroyRegionPtr rp
	return (Region r)

-- an empty region
-- (often used as "out argument" to binary operators which return regions)

-- | interface to the X11 library function @XCreateRegion()@.
createRegion :: IO Region
createRegion = do
	rp <- xCreateRegion
	makeRegion rp
foreign import ccall unsafe "HsXlib.h XCreateRegion"
        xCreateRegion :: IO (Ptr Region)

-- | interface to the X11 library function @XPolygonRegion()@.
polygonRegion :: [Point] -> FillRule -> IO Region
polygonRegion points fill_rule =
	withArrayLen points $ \ n point_arr -> do
	rp <- xPolygonRegion point_arr n fill_rule
	makeRegion rp
foreign import ccall unsafe "HsXlib.h XPolygonRegion"
	xPolygonRegion :: Ptr Point -> Int -> FillRule -> IO (Ptr Region)

----------------------------------------------------------------
-- Combining Regions
--
-- The usual shoddy state of Xlib documentation fails to mention
-- what the Int is for.
--
-- All operations overwrite the region in their third argument
-- which is usually a freshly created region.
----------------------------------------------------------------

-- | interface to the X11 library function @XIntersectRegion()@.
intersectRegion     :: Region -> Region -> Region -> IO Int
intersectRegion src1 src2 dest =
	withRegion src1 $ \ src1_ptr ->
	withRegion src2 $ \ src2_ptr ->
	withRegion dest $ \ dest_ptr ->
	xIntersectRegion src1_ptr src2_ptr dest_ptr
foreign import ccall unsafe
	"HsXlib.h XIntersectRegion" xIntersectRegion ::
	Ptr Region -> Ptr Region -> Ptr Region -> IO Int

-- | interface to the X11 library function @XSubtractRegion()@.
subtractRegion     :: Region -> Region -> Region -> IO Int
subtractRegion src1 src2 dest =
	withRegion src1 $ \ src1_ptr ->
	withRegion src2 $ \ src2_ptr ->
	withRegion dest $ \ dest_ptr ->
	xSubtractRegion src1_ptr src2_ptr dest_ptr
foreign import ccall unsafe
	"HsXlib.h XSubtractRegion" xSubtractRegion ::
	Ptr Region -> Ptr Region -> Ptr Region -> IO Int

-- | interface to the X11 library function @XUnionRectWithRegion()@.
unionRectWithRegion     :: Rectangle -> Region -> Region -> IO Int
unionRectWithRegion rect src dest =
	with rect $ \ rect_ptr ->
	withRegion src $ \ src_ptr ->
	withRegion dest $ \ dest_ptr ->
	xUnionRectWithRegion rect_ptr src_ptr dest_ptr
foreign import ccall unsafe
	"HsXlib.h XUnionRectWithRegion" xUnionRectWithRegion ::
	Ptr Rectangle -> Ptr Region -> Ptr Region -> IO Int

-- | interface to the X11 library function @XUnionRegion()@.
unionRegion     :: Region -> Region -> Region -> IO Int
unionRegion src1 src2 dest =
	withRegion src1 $ \ src1_ptr ->
	withRegion src2 $ \ src2_ptr ->
	withRegion dest $ \ dest_ptr ->
	xUnionRegion src1_ptr src2_ptr dest_ptr
foreign import ccall unsafe
	"HsXlib.h XUnionRegion" xUnionRegion ::
	Ptr Region -> Ptr Region -> Ptr Region -> IO Int

-- | interface to the X11 library function @XXorRegion()@.
xorRegion     :: Region -> Region -> Region -> IO Int
xorRegion src1 src2 dest =
	withRegion src1 $ \ src1_ptr ->
	withRegion src2 $ \ src2_ptr ->
	withRegion dest $ \ dest_ptr ->
	xXorRegion src1_ptr src2_ptr dest_ptr
foreign import ccall unsafe
	"HsXlib.h XXorRegion" xXorRegion ::
	Ptr Region -> Ptr Region -> Ptr Region -> IO Int

----------------------------------------------------------------
-- Examining regions (tests, bounding boxes, etc)
----------------------------------------------------------------

-- | interface to the X11 library function @XEmptyRegion()@.
emptyRegion :: Region -> IO Bool
emptyRegion r = withRegion r xEmptyRegion
foreign import ccall unsafe "HsXlib.h XEmptyRegion"
	xEmptyRegion :: Ptr Region -> IO Bool

-- | interface to the X11 library function @XEqualRegion()@.
equalRegion :: Region -> Region -> IO Bool
equalRegion r1 r2 =
	withRegion r1 $ \ rp1 ->
	withRegion r2 $ \ rp2 ->
	xEqualRegion rp1 rp2
foreign import ccall unsafe "HsXlib.h XEqualRegion"
	xEqualRegion :: Ptr Region -> Ptr Region -> IO Bool

-- | interface to the X11 library function @XPointInRegion()@.
pointInRegion :: Region -> Point -> IO Bool
pointInRegion r (Point x y) =
	withRegion r $ \ rp ->
	xPointInRegion rp x y
foreign import ccall unsafe "HsXlib.h XPointInRegion"
	xPointInRegion :: Ptr Region -> Position -> Position -> IO Bool

-- | interface to the X11 library function @XRectInRegion()@.
rectInRegion :: Region -> Rectangle -> IO RectInRegionResult
rectInRegion r (Rectangle x y w h) =
	withRegion r $ \ rp ->
	xRectInRegion rp x y w h
foreign import ccall unsafe "HsXlib.h XRectInRegion"
	xRectInRegion :: Ptr Region -> Position -> Position ->
		Dimension -> Dimension -> IO RectInRegionResult

-- I have no idea what the int is for

-- | interface to the X11 library function @XClipBox()@.
clipBox :: Region -> IO (Rectangle,Int)
clipBox r =
	withRegion r $ \ rp ->
	alloca $ \ rect_ptr -> do
	res <- xClipBox rp rect_ptr
	rect <- peek rect_ptr
	return (rect, res)
foreign import ccall unsafe "HsXlib.h XClipBox"
	xClipBox :: Ptr Region -> Ptr Rectangle -> IO Int

----------------------------------------------------------------
-- Modifying regions
-- (If you use any of these, you can't make regions look like
--  first class data structures.)
----------------------------------------------------------------

-- translate region

-- | interface to the X11 library function @XOffsetRegion()@.
offsetRegion :: Region -> Point -> IO Int
offsetRegion r (Point x y) =
	withRegion r $ \ rp ->
	xOffsetRegion rp x y
foreign import ccall unsafe "HsXlib.h XOffsetRegion"
	xOffsetRegion :: Ptr Region -> Position -> Position -> IO Int

-- increase size of region by +ve or -ve number of pixels
-- while preserving the centre of the region (ie half the pixels
-- come off the left, and half off the right)

-- | interface to the X11 library function @XShrinkRegion()@.
shrinkRegion :: Region -> Point -> IO Int
shrinkRegion r (Point x y) =
	withRegion r $ \ rp ->
	xShrinkRegion rp x y
foreign import ccall unsafe "HsXlib.h XShrinkRegion"
	xShrinkRegion :: Ptr Region -> Position -> Position -> IO Int

----------------------------------------------------------------
-- Graphics Context
----------------------------------------------------------------

-- set clip mask of GC

-- | interface to the X11 library function @XSetRegion()@.
setRegion :: Display -> GC -> Region -> IO Int
setRegion disp gc r =
	withRegion r $ \ rp ->
	xSetRegion disp gc rp
foreign import ccall unsafe "HsXlib.h XSetRegion"
	xSetRegion :: Display -> GC -> Ptr Region -> IO Int

----------------------------------------------------------------
-- End
----------------------------------------------------------------
