-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Types
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of type declarations for interfacing with Xlib.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Types(
        module Graphics.X11.Xlib.Types
        ) where

import Control.Monad( zipWithM_ )
import Data.Int
import Data.Word
import Foreign.Marshal.Alloc( allocaBytes )
import Foreign.Ptr
import Foreign.Storable( Storable(..) )

#include "HsXlib.h"

----------------------------------------------------------------
-- Types
----------------------------------------------------------------

-- | pointer to an X11 @Display@ structure
newtype Display    = Display    (Ptr Display)
-- | pointer to an X11 @Screen@ structure
newtype Screen     = Screen     (Ptr Screen)
-- | pointer to an X11 @Visual@ structure
newtype Visual     = Visual     (Ptr Visual)
-- | pointer to an X11 @XFontStruct@ structure
newtype FontStruct = FontStruct (Ptr FontStruct)
newtype GC         = GC         (Ptr GC)
newtype XGCValues  = XGCValues  (Ptr XGCValues)

newtype XSetWindowAttributes = XSetWindowAttributes XSetWindowAttributesPtr
type XSetWindowAttributesPtr = Ptr XSetWindowAttributes

type Pixel         = #{type unsigned long}
type Position      = #{type int}
type Dimension     = #{type unsigned int}
type Angle         = Int
type ScreenNumber  = Word32
type Byte          = Word8
type Buffer        = Int

----------------------------------------------------------------
-- Short forms used in structs
----------------------------------------------------------------

type ShortPosition = #{type short}
type ShortDimension = #{type unsigned short}
type ShortAngle    = #{type short}
type Short         = #{type short}

peekPositionField :: Ptr a -> Int -> IO Position
peekPositionField ptr off = do
	v <- peekByteOff ptr off
	return (fromIntegral (v::ShortPosition))

peekDimensionField :: Ptr a -> Int -> IO Dimension
peekDimensionField ptr off = do
	v <- peekByteOff ptr off
	return (fromIntegral (v::ShortDimension))

peekAngleField :: Ptr a -> Int -> IO Angle
peekAngleField ptr off = do
	v <- peekByteOff ptr off
	return (fromIntegral (v::ShortAngle))

pokePositionField :: Ptr a -> Int -> Position -> IO ()
pokePositionField ptr off v =
	pokeByteOff ptr off (fromIntegral v::ShortPosition)

pokeDimensionField :: Ptr a -> Int -> Dimension -> IO ()
pokeDimensionField ptr off v =
	pokeByteOff ptr off (fromIntegral v::ShortDimension)

pokeAngleField :: Ptr a -> Int -> Angle -> IO ()
pokeAngleField ptr off v =
	pokeByteOff ptr off (fromIntegral v::ShortAngle)

----------------------------------------------------------------
-- Marshalling of arbitrary types
----------------------------------------------------------------

-- We can't use the similarily named library functions for several reasons:
-- 1) They deal with Ptrs instead of Ptr-Len pairs
-- 2) They require instances of Storable but we apply these functions
--    to type synonyms like 'Point = (Int,Int)' which cannot be
--    instances.

data Storable' a = Storable'
	{ size  :: Int
	, peek' :: Ptr a -> IO a
	, poke' :: Ptr a -> a -> IO ()
	}

alloca' :: Storable' a -> (Ptr a -> IO b) -> IO b
alloca' st = allocaBytes (size st)

withStorable' :: Storable' a -> a -> (Ptr a -> IO b) -> IO b
withStorable' st x f = alloca' st $ \ ptr -> do
	poke' st ptr x
	f ptr

peekElemOff' :: Storable' a -> Ptr a -> Int      -> IO a
peekElemOff' st p off = peek' st (p `plusPtr` (size st*off))

pokeElemOff' :: Storable' a -> Ptr a -> Int -> a -> IO ()
pokeElemOff' st p off = poke' st (p `plusPtr` (size st*off))

peekArray' :: Storable' a -> Int -> Ptr a -> IO [a]
peekArray' st len ptr = mapM (peekElemOff' st ptr) [0..len-1]

pokeArray' :: Storable' a -> Ptr a -> [a] -> IO ()
pokeArray' st ptr xs = zipWithM_ (pokeElemOff' st ptr) [0..] xs

withArray' :: Storable' a -> [a] -> (Ptr a -> Int -> IO b) -> IO b
withArray' st xs f = allocaBytes (size st * len) $ \ ptr -> do
	pokeArray' st ptr xs
	f ptr len
  where	len = length xs

----------------------------------------------------------------
-- Point
----------------------------------------------------------------

-- | counterpart of an X11 @XPoint@ structure
type Point =
	( Position  -- x
	, Position  -- y
	)

s_Point :: Storable' Point
s_Point = Storable' #{size XPoint} peekPoint pokePoint

peekPoint :: Ptr Point -> IO Point
peekPoint p = do
	x <- peekPositionField p #{offset XPoint,x}
	y <- peekPositionField p #{offset XPoint,y}
	return (x,y)

pokePoint :: Ptr Point -> Point -> IO ()
pokePoint p (x,y) = do
	pokePositionField p #{offset XPoint,x} x
	pokePositionField p #{offset XPoint,y} y

peekPointArray :: Int -> Ptr Point -> IO [Point]
peekPointArray = peekArray' s_Point

withPointArray :: [Point] -> (Ptr Point -> Int -> IO b) -> IO b
withPointArray = withArray' s_Point

----------------------------------------------------------------
-- Rectangle
----------------------------------------------------------------

-- | counterpart of an X11 @XRectangle@ structure
type Rectangle =
	( Position  -- x
	, Position  -- y
	, Dimension -- width
	, Dimension -- height
	)

s_Rectangle :: Storable' Rectangle
s_Rectangle = Storable' #{size XRectangle} peekRectangle pokeRectangle

peekRectangle :: Ptr Rectangle -> IO Rectangle
peekRectangle p = do
	x	<- peekPositionField p #{offset XRectangle,x}
	y	<- peekPositionField p #{offset XRectangle,y}
	width	<- peekDimensionField p #{offset XRectangle,width}
	height	<- peekDimensionField p #{offset XRectangle,height}
	return (x,y,width,height)

pokeRectangle :: Ptr Rectangle -> Rectangle -> IO ()
pokeRectangle p (x,y,width,height) = do
	pokePositionField p #{offset XRectangle,x} x
	pokePositionField p #{offset XRectangle,y} y
	pokeDimensionField p #{offset XRectangle,width} width
	pokeDimensionField p #{offset XRectangle,height} height

allocaRectangle :: (Ptr Rectangle -> IO a) -> IO a
allocaRectangle = alloca' s_Rectangle

withRectangle :: Rectangle -> (Ptr Rectangle -> IO a) -> IO a
withRectangle = withStorable' s_Rectangle

peekRectangleArray :: Int -> Ptr Rectangle -> IO [Rectangle]
peekRectangleArray = peekArray' s_Rectangle

withRectangleArray :: [Rectangle] -> (Ptr Rectangle -> Int -> IO b) -> IO b
withRectangleArray = withArray' s_Rectangle

----------------------------------------------------------------
-- Arc
----------------------------------------------------------------

-- | counterpart of an X11 @XArc@ structure
type Arc =
	( Position  -- x
	, Position  -- y
	, Dimension -- width
	, Dimension -- height
	, Angle     -- angle1
	, Angle     -- angle2
	)

s_Arc :: Storable' Arc
s_Arc = Storable' #{size XArc} peekArc pokeArc

peekArc :: Ptr Arc -> IO Arc
peekArc p = do
	x	<- peekPositionField p #{offset XArc,x}
	y	<- peekPositionField p #{offset XArc,y}
	width	<- peekDimensionField p #{offset XArc,width}
	height	<- peekDimensionField p #{offset XArc,height}
	angle1	<- peekAngleField p #{offset XArc,angle1}
	angle2	<- peekAngleField p #{offset XArc,angle2}
	return (x,y,width,height,angle1,angle2)

pokeArc :: Ptr Arc -> Arc -> IO ()
pokeArc p (x,y,width,height,angle1,angle2) = do
	pokePositionField p #{offset XArc,x} x
	pokePositionField p #{offset XArc,y} y
	pokeDimensionField p #{offset XArc,width} width
	pokeDimensionField p #{offset XArc,height} height
	pokeAngleField p #{offset XArc,angle1} angle1
	pokeAngleField p #{offset XArc,angle2} angle2

peekArcArray :: Int -> Ptr Arc -> IO [Arc]
peekArcArray = peekArray' s_Arc

withArcArray :: [Arc] -> (Ptr Arc -> Int -> IO b) -> IO b
withArcArray = withArray' s_Arc

----------------------------------------------------------------
-- Segment
----------------------------------------------------------------

-- | counterpart of an X11 @XSegment@ structure
type Segment =
	( Position -- x1
	, Position -- y1
	, Position -- x2
	, Position -- y2
	)

s_Segment :: Storable' Segment
s_Segment = Storable' #{size XSegment} peekSegment pokeSegment

peekSegment :: Ptr Segment -> IO Segment
peekSegment p = do
	x1 <- peekPositionField p #{offset XSegment,x1}
	y1 <- peekPositionField p #{offset XSegment,y1}
	x2 <- peekPositionField p #{offset XSegment,x2}
	y2 <- peekPositionField p #{offset XSegment,y2}
	return (x1,y1,x2,y2)

pokeSegment :: Ptr Segment -> Segment -> IO ()
pokeSegment p (x1,y1,x2,y2) = do
	pokePositionField p #{offset XSegment,x1} x1
	pokePositionField p #{offset XSegment,y1} y1
	pokePositionField p #{offset XSegment,x2} x2
	pokePositionField p #{offset XSegment,y2} y2

peekSegmentArray :: Int -> Ptr Segment -> IO [Segment]
peekSegmentArray = peekArray' s_Segment

withSegmentArray :: [Segment] -> (Ptr Segment -> Int -> IO b) -> IO b
withSegmentArray = withArray' s_Segment

----------------------------------------------------------------
-- Color
----------------------------------------------------------------

-- | counterpart of an X11 @XColor@ structure
type Color =
	( Pixel  -- pixel
	, Word16 -- red
	, Word16 -- green
	, Word16 -- blue
	, Word8  -- flags
	)

s_Color :: Storable' Color
s_Color = Storable' #{size XColor} peekColor pokeColor

peekColor :: Ptr Color -> IO Color
peekColor p = do
	pixel	<- #{peek XColor,pixel}	p
	red	<- #{peek XColor,red}	p
	green	<- #{peek XColor,green}	p
	blue	<- #{peek XColor,blue}	p
	flags	<- #{peek XColor,flags}	p
	return (pixel,red,green,blue,flags)

pokeColor :: Ptr Color -> Color -> IO ()
pokeColor p (pixel,red,green,blue,flags) = do
	#{poke XColor,pixel}	p pixel
	#{poke XColor,red}	p red
	#{poke XColor,green}	p green
	#{poke XColor,blue}	p blue
	#{poke XColor,flags}	p flags

allocaColor :: (Ptr Color -> IO a) -> IO a
allocaColor = alloca' s_Color

withColor :: Color -> (Ptr Color -> IO a) -> IO a
withColor = withStorable' s_Color

peekColorArray :: Int -> Ptr Color -> IO [Color]
peekColorArray = peekArray' s_Color

withColorArray :: [Color] -> (Ptr Color -> Int -> IO b) -> IO b
withColorArray = withArray' s_Color

----------------------------------------------------------------
-- Backwards compatibility
----------------------------------------------------------------

type ListPoint = [Point]
type ListRectangle = [Rectangle]
type ListArc = [Arc]
type ListSegment = [Segment]
type ListColor = [Color]

----------------------------------------------------------------
-- End
----------------------------------------------------------------
