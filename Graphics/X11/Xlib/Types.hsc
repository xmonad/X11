{-# OPTIONS_GHC -fglasgow-exts #-}
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

-- #hide
module Graphics.X11.Xlib.Types(
	Display(..), Screen, Visual, GC, GCValues, SetWindowAttributes,
	Point(..), Rectangle(..), Arc(..), Segment(..), Color(..),
	Pixel, Position, Dimension, Angle, ScreenNumber, Buffer
        ) where

import Control.Monad( zipWithM_ )
import Data.Int
import Data.Word
import Foreign.C.Types
import Foreign.Marshal.Alloc( allocaBytes )
import Foreign.Ptr
import Foreign.Storable( Storable(..) )

#if __GLASGOW_HASKELL__
import Data.Generics
#endif

#include "HsXlib.h"

----------------------------------------------------------------
-- Types
----------------------------------------------------------------

-- | pointer to an X11 @Display@ structure
newtype Display    = Display    (Ptr Display)
#if __GLASGOW_HASKELL__
	deriving (Eq, Ord, Show, Typeable, Data)
#else
	deriving (Eq, Ord, Show)
#endif

-- | pointer to an X11 @Screen@ structure
newtype Screen     = Screen     (Ptr Screen)
#if __GLASGOW_HASKELL__
	deriving (Eq, Ord, Show, Typeable, Data)
#else
	deriving (Eq, Ord, Show)
#endif

-- | pointer to an X11 @Visual@ structure
newtype Visual     = Visual     (Ptr Visual)
#if __GLASGOW_HASKELL__
	deriving (Eq, Ord, Show, Typeable, Data)
#else
	deriving (Eq, Ord, Show)
#endif

-- | pointer to an X11 @GC@ structure
newtype GC         = GC         (Ptr GC)
#if __GLASGOW_HASKELL__
	deriving (Eq, Ord, Show, Typeable, Data)
#else
	deriving (Eq, Ord, Show)
#endif

-- | pointer to an X11 @XGCValues@ structure
newtype GCValues   = GCValues  (Ptr GCValues)
#if __GLASGOW_HASKELL__
	deriving (Eq, Ord, Show, Typeable, Data)
#else
	deriving (Eq, Ord, Show)
#endif

-- | pointer to an X11 @XSetWindowAttributes@ structure
newtype SetWindowAttributes = SetWindowAttributes (Ptr SetWindowAttributes)
#if __GLASGOW_HASKELL__
	deriving (Eq, Ord, Show, Typeable, Data)
#else
	deriving (Eq, Ord, Show)
#endif

type Pixel         = #{type unsigned long}
type Position      = #{type int}
type Dimension     = #{type unsigned int}
type Angle         = Int
type ScreenNumber  = Word32
type Buffer        = Int

----------------------------------------------------------------
-- Short forms used in structs
----------------------------------------------------------------

type ShortPosition = CShort
type ShortDimension = CUShort
type ShortAngle    = CShort

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
-- Point
----------------------------------------------------------------

-- | counterpart of an X11 @XPoint@ structure
data Point = Point { pt_x :: Position, pt_y :: Position }
#if __GLASGOW_HASKELL__
	deriving (Eq, Show, Typeable, Data)
#else
	deriving (Eq, Show)
#endif

instance Storable Point where
	sizeOf _ = #{size XPoint}
	alignment _ = alignment (undefined::CInt)
	peek p = do
		x <- peekPositionField p #{offset XPoint,x}
		y <- peekPositionField p #{offset XPoint,y}
		return (Point x y)
	poke p (Point x y) = do
		pokePositionField p #{offset XPoint,x} x
		pokePositionField p #{offset XPoint,y} y

----------------------------------------------------------------
-- Rectangle
----------------------------------------------------------------

-- | counterpart of an X11 @XRectangle@ structure
data Rectangle = Rectangle {
	rect_x :: Position,
	rect_y :: Position,
	rect_width :: Dimension,
	rect_height :: Dimension
	}
#if __GLASGOW_HASKELL__
	deriving (Eq, Show, Typeable, Data)
#else
	deriving (Eq, Show)
#endif

instance Storable Rectangle where
	sizeOf _ = #{size XRectangle}
	alignment _ = alignment (undefined::CInt)
	peek p = do
		x	<- peekPositionField p #{offset XRectangle,x}
		y	<- peekPositionField p #{offset XRectangle,y}
		width	<- peekDimensionField p #{offset XRectangle,width}
		height	<- peekDimensionField p #{offset XRectangle,height}
		return (Rectangle x y width height)
	poke p (Rectangle x y width height) = do
		pokePositionField p #{offset XRectangle,x} x
		pokePositionField p #{offset XRectangle,y} y
		pokeDimensionField p #{offset XRectangle,width} width
		pokeDimensionField p #{offset XRectangle,height} height

----------------------------------------------------------------
-- Arc
----------------------------------------------------------------

-- | counterpart of an X11 @XArc@ structure
data Arc = Arc {
	arc_x :: Position,
	arc_y :: Position,
	arc_width :: Dimension,
	arc_height :: Dimension,
	arc_angle1 :: Angle,
	arc_angle2 :: Angle
	}
#if __GLASGOW_HASKELL__
	deriving (Eq, Show, Typeable, Data)
#else
	deriving (Eq, Show)
#endif

instance Storable Arc where
	sizeOf _ = #{size XArc}
	alignment _ = alignment (undefined::CInt)
	peek p = do
		x	<- peekPositionField p #{offset XArc,x}
		y	<- peekPositionField p #{offset XArc,y}
		width	<- peekDimensionField p #{offset XArc,width}
		height	<- peekDimensionField p #{offset XArc,height}
		angle1	<- peekAngleField p #{offset XArc,angle1}
		angle2	<- peekAngleField p #{offset XArc,angle2}
		return (Arc x y width height angle1 angle2)
	poke p (Arc x y width height angle1 angle2) = do
		pokePositionField p #{offset XArc,x} x
		pokePositionField p #{offset XArc,y} y
		pokeDimensionField p #{offset XArc,width} width
		pokeDimensionField p #{offset XArc,height} height
		pokeAngleField p #{offset XArc,angle1} angle1
		pokeAngleField p #{offset XArc,angle2} angle2

----------------------------------------------------------------
-- Segment
----------------------------------------------------------------

-- | counterpart of an X11 @XSegment@ structure
data Segment = Segment {
	seg_x1 :: Position,
	seg_y1 :: Position,
	seg_x2 :: Position,
	seg_y2 :: Position
	}
#if __GLASGOW_HASKELL__
	deriving (Eq, Show, Typeable, Data)
#else
	deriving (Eq, Show)
#endif

instance Storable Segment where
	sizeOf _ = #{size XSegment}
	alignment _ = alignment (undefined::CInt)
	peek p = do
		x1 <- peekPositionField p #{offset XSegment,x1}
		y1 <- peekPositionField p #{offset XSegment,y1}
		x2 <- peekPositionField p #{offset XSegment,x2}
		y2 <- peekPositionField p #{offset XSegment,y2}
		return (Segment x1 y1 x2 y2)
	poke p (Segment x1 y1 x2 y2) = do
		pokePositionField p #{offset XSegment,x1} x1
		pokePositionField p #{offset XSegment,y1} y1
		pokePositionField p #{offset XSegment,x2} x2
		pokePositionField p #{offset XSegment,y2} y2

----------------------------------------------------------------
-- Color
----------------------------------------------------------------

-- | counterpart of an X11 @XColor@ structure
data Color = Color {
	color_pixel :: Pixel,
	color_red :: Word16,
	color_green :: Word16,
	color_blue :: Word16,
	color_flags :: Word8
	}
#if __GLASGOW_HASKELL__
	deriving (Eq, Show, Typeable, Data)
#else
	deriving (Eq, Show)
#endif

instance Storable Color where
	sizeOf _ = #{size XColor}
	alignment _ = alignment (undefined::CInt)
	peek p = do
		pixel	<- #{peek XColor,pixel}	p
		red	<- #{peek XColor,red}	p
		green	<- #{peek XColor,green}	p
		blue	<- #{peek XColor,blue}	p
		flags	<- #{peek XColor,flags}	p
		return (Color pixel red green blue flags)
	poke p (Color pixel red green blue flags) = do
		#{poke XColor,pixel}	p pixel
		#{poke XColor,red}	p red
		#{poke XColor,green}	p green
		#{poke XColor,blue}	p blue
		#{poke XColor,flags}	p flags

----------------------------------------------------------------
-- End
----------------------------------------------------------------
