{-# LANGUAGE DeriveDataTypeable #-}
--------------------------------------------------------------------
-- |
-- Module    : Graphics.X11.Xrandr
-- Copyright : (c) Haskell.org, 2012
-- License   : BSD3
--
-- Maintainer: Ben Boeckel <mathstuf@gmail.com>
-- Stability : provisional
-- Portability: portable
--
--------------------------------------------------------------------
--
-- Interface to Xrandr API
--

module Graphics.X11.Xrandr (
  XRRScreenSize(..),
  compiledWithXrandr,
  Rotation,
  Reflection,
  SizeID,
  XRRScreenConfiguration,
  xrrQueryExtension,
  xrrQueryVersion,
  xrrGetScreenInfo,
  xrrFreeScreenConfigInfo,
  xrrSetScreenConfig,
  xrrSetScreenConfigAndRate,
  xrrConfigRotations,
  xrrConfigTimes,
  xrrConfigSizes,
  xrrConfigRates,
  xrrConfigCurrentConfiguration,
  xrrConfigCurrentRate,
  xrrRootToScreen,
  xrrSelectInput,
  xrrUpdateConfiguration,
  xrrRotations,
  xrrSizes,
  xrrRates,
  xrrTimes
 ) where

import Foreign
import Foreign.C.Types
import Control.Monad

import Graphics.X11.Xlib.Event
import Graphics.X11.Xlib.Types
import Graphics.X11.Types

#if __GLASGOW_HASKELL__
import Data.Generics
#endif

-- | Representation of the XRRScreenSize struct
data XRRScreenSize = XRRScreenSize
                     { xrr_ss_width   :: !CInt,
                       xrr_ss_height  :: !CInt,
                       xrr_ss_mwidth  :: !CInt,
                       xrr_ss_mheight :: !CInt }
                       deriving (Show)

-- We have Xinerama, so the library will actually work
compiledWithXrandr :: Bool
compiledWithXrandr = True

#include "HsXlib.h"

newtype XRRScreenConfiguration = XRRScreenConfiguration (Ptr XRRScreenConfiguration)
#if __GLASGOW_HASKELL__
        deriving (Eq, Ord, Show, Typeable, Data)
#else
        deriving (Eq, Ord, Show)
#endif

instance Storable XRRScreenSize where
  sizeOf _ = #{size XRRScreenSize}
  -- FIXME: Is this right?
  alignment _ = alignment (undefined :: CInt)

  poke p xrr_ss = do
    #{poke XRRScreenSize, width   } p $ xrr_ss_width xrr_ss
    #{poke XRRScreenSize, height  } p $ xrr_ss_height xrr_ss
    #{poke XRRScreenSize, mwidth  } p $ xrr_ss_mwidth xrr_ss
    #{poke XRRScreenSize, mheight } p $ xrr_ss_mheight xrr_ss

  peek p = return XRRScreenSize
            `ap` (#{peek XRRScreenSize, width} p)
            `ap` (#{peek XRRScreenSize, height} p)
            `ap` (#{peek XRRScreenSize, mwidth} p)
            `ap` (#{peek XRRScreenSize, mheight} p)

xrrQueryExtension :: Display -> IO (Maybe (CInt, CInt))
xrrQueryExtension dpy = wrapPtr2 (cXRRQueryExtension dpy) go
  where go False _ _                = Nothing
        go True eventbase errorbase = Just (fromIntegral eventbase, fromIntegral errorbase)
foreign import ccall "XRRQueryExtension"
  cXRRQueryExtension :: Display -> Ptr CInt -> Ptr CInt -> IO Bool

xrrQueryVersion :: Display -> IO (Maybe (CInt, CInt))
xrrQueryVersion dpy = wrapPtr2 (cXRRQueryVersion dpy) go
  where go False _ _        = Nothing
        go True major minor = Just (fromIntegral major, fromIntegral minor)
foreign import ccall "XRRQueryVersion"
  cXRRQueryVersion :: Display -> Ptr CInt -> Ptr CInt -> IO Bool

xrrGetScreenInfo :: Display -> Drawable -> IO (Maybe XRRScreenConfiguration)
xrrGetScreenInfo dpy draw = do
  p <- cXRRGetScreenInfo dpy draw
  if p == nullPtr
     then return Nothing
     else return (Just (XRRScreenConfiguration p))
foreign import ccall "XRRGetScreenInfo"
  cXRRGetScreenInfo :: Display -> Drawable -> IO (Ptr XRRScreenConfiguration)

xrrFreeScreenConfigInfo :: XRRScreenConfiguration -> IO ()
xrrFreeScreenConfigInfo = cXRRFreeScreenConfigInfo
foreign import ccall "XRRFreeScreenConfigInfo"
  cXRRFreeScreenConfigInfo :: XRRScreenConfiguration -> IO ()

xrrSetScreenConfig :: Display -> XRRScreenConfiguration -> Drawable -> CInt -> Rotation -> Time -> IO Status
xrrSetScreenConfig = cXRRSetScreenConfig
foreign import ccall "XRRSetScreenConfig"
  cXRRSetScreenConfig :: Display -> XRRScreenConfiguration -> Drawable -> CInt -> Rotation -> Time -> IO Status

xrrSetScreenConfigAndRate :: Display -> XRRScreenConfiguration -> Drawable -> CInt -> Rotation -> CShort -> Time -> IO Status
xrrSetScreenConfigAndRate = cXRRSetScreenConfigAndRate
foreign import ccall "XRRSetScreenConfigAndRate"
  cXRRSetScreenConfigAndRate :: Display -> XRRScreenConfiguration -> Drawable -> CInt -> Rotation -> CShort -> Time -> IO Status

xrrConfigRotations :: XRRScreenConfiguration -> IO (Rotation, Rotation)
xrrConfigRotations config =
  withPool $ \pool -> do rptr <- pooledMalloc pool
                         rotations <- cXRRConfigRotations config rptr
                         cur_rotation <- peek rptr
                         return (rotations, cur_rotation)
foreign import ccall "XRRConfigRotations"
  cXRRConfigRotations :: XRRScreenConfiguration -> Ptr Rotation -> IO Rotation

xrrConfigTimes :: XRRScreenConfiguration -> IO (Time, Time)
xrrConfigTimes config =
  withPool $ \pool -> do tptr <- pooledMalloc pool
                         time <- cXRRConfigTimes config tptr
                         cur_time <- peek tptr
                         return (time, cur_time)
foreign import ccall "XRRConfigTimes"
  cXRRConfigTimes :: XRRScreenConfiguration -> Ptr Time -> IO Time

xrrConfigSizes :: XRRScreenConfiguration -> IO (Maybe [XRRScreenSize])
xrrConfigSizes config =
  withPool $ \pool -> do intp <- pooledMalloc pool
                         p <- cXRRConfigSizes config intp
                         if p == nullPtr
                            then return Nothing
                            else do nsizes <- peek intp
                                    sizes <- if nsizes == 0
                                                then return Nothing
                                                else peekArray (fromIntegral nsizes) p >>= return . Just
                                    _ <- cXFree p
                                    return sizes
foreign import ccall "XRRConfigSizes"
  cXRRConfigSizes :: XRRScreenConfiguration -> Ptr CInt -> IO (Ptr XRRScreenSize)

xrrConfigRates :: XRRScreenConfiguration -> CInt -> IO (Maybe [CShort])
xrrConfigRates config size_index =
  withPool $ \pool -> do intp <- pooledMalloc pool
                         p <- cXRRConfigRates config size_index intp
                         if p == nullPtr
                            then return Nothing
                            else do nrates <- peek intp
                                    rates <- if nrates == 0
                                                then return Nothing
                                                else peekArray (fromIntegral nrates) p >>= return . Just
                                    _ <- cXFree p
                                    return rates
foreign import ccall "XRRConfigRates"
  cXRRConfigRates :: XRRScreenConfiguration -> CInt -> Ptr CInt -> IO (Ptr CShort)

xrrConfigCurrentConfiguration :: XRRScreenConfiguration -> IO (Rotation, SizeID)
xrrConfigCurrentConfiguration config =
  withPool $ \pool -> do rptr <- pooledMalloc pool
                         sizeid <- cXRRConfigCurrentConfiguration config rptr
                         rotation <- peek rptr
                         return (rotation, sizeid)
foreign import ccall "XRRConfigCurrentConfiguration"
  cXRRConfigCurrentConfiguration :: XRRScreenConfiguration -> Ptr Rotation -> IO SizeID

xrrConfigCurrentRate :: XRRScreenConfiguration -> IO CShort
xrrConfigCurrentRate = cXRRConfigCurrentRate
foreign import ccall "XRRConfigCurrentRate"
  cXRRConfigCurrentRate :: XRRScreenConfiguration -> IO CShort

xrrRootToScreen :: Display -> Window -> IO CInt
xrrRootToScreen = cXRRRootToScreen
foreign import ccall "XRRRootToScreen"
  cXRRRootToScreen :: Display -> Window -> IO CInt

xrrSelectInput :: Display -> Window -> EventMask -> IO ()
xrrSelectInput dpy window mask = cXRRSelectInput dpy window (fromIntegral mask)
foreign import ccall "XRRSelectInput"
  cXRRSelectInput :: Display -> Window -> CInt -> IO ()

xrrUpdateConfiguration :: XEvent -> IO CInt
xrrUpdateConfiguration = cXRRUpdateConfiguration
foreign import ccall "XRRUpdateConfiguration"
  cXRRUpdateConfiguration :: XEvent -> IO CInt

xrrRotations :: Display -> CInt -> IO (Rotation, Rotation)
xrrRotations dpy screen =
  withPool $ \pool -> do rptr <- pooledMalloc pool
                         rotations <- cXRRRotations dpy screen rptr
                         cur_rotation <- peek rptr
                         return (rotations, cur_rotation)
foreign import ccall "XRRRotations"
  cXRRRotations :: Display -> CInt -> Ptr Rotation -> IO Rotation

xrrSizes :: Display -> CInt -> IO (Maybe [XRRScreenSize])
xrrSizes dpy screen =
  withPool $ \pool -> do intp <- pooledMalloc pool
                         p <- cXRRSizes dpy screen intp
                         if p == nullPtr
                            then return Nothing
                            else do nsizes <- peek intp
                                    sizes <- if nsizes == 0
                                                then return Nothing
                                                else peekArray (fromIntegral nsizes) p >>= return . Just
                                    _ <- cXFree p
                                    return sizes
foreign import ccall "XRRSizes"
  cXRRSizes :: Display -> CInt -> Ptr CInt -> IO (Ptr XRRScreenSize)

xrrRates :: Display -> CInt -> CInt -> IO (Maybe [CShort])
xrrRates dpy screen size_index =
  withPool $ \pool -> do intp <- pooledMalloc pool
                         p <- cXRRRates dpy screen size_index intp
                         if p == nullPtr
                            then return Nothing
                            else do nrates <- peek intp
                                    rates <- if nrates == 0
                                                then return Nothing
                                                else peekArray (fromIntegral nrates) p >>= return . Just
                                    _ <- cXFree p
                                    return rates
foreign import ccall "XRRRates"
  cXRRRates :: Display -> CInt -> CInt -> Ptr CInt -> IO (Ptr CShort)

xrrTimes :: Display -> CInt -> IO (Time, Time)
xrrTimes dpy screen =
  withPool $ \pool -> do tptr <- pooledMalloc pool
                         time <- cXRRTimes dpy screen tptr
                         config_time <- peek tptr
                         return (time, config_time)
foreign import ccall "XRRTimes"
  cXRRTimes :: Display -> CInt -> Ptr Time -> IO Time

foreign import ccall "XFree"
  cXFree :: Ptr a -> IO CInt

wrapPtr2 :: (Storable a, Storable b) => (Ptr a -> Ptr b -> IO c) -> (c -> a -> b -> d) -> IO d
wrapPtr2 cfun f =
  withPool $ \pool -> do aptr <- pooledMalloc pool
                         bptr <- pooledMalloc pool
                         ret <- cfun aptr bptr
                         a <- peek aptr
                         b <- peek bptr
                         return (f ret a b)
