{-# LANGUAGE DeriveDataTypeable #-}
--------------------------------------------------------------------
-- |
-- Module    : Graphics.X11.Xrandr
-- Copyright : (c) Haskell.org, 2012
--             (c) Jochen Keil, 2012
-- License   : BSD3
--
-- Maintainer: Ben Boeckel <mathstuf@gmail.com>
--           , Jochen Keil <jochen dot keil at gmail dot com>
--
-- Stability : provisional
-- Portability: portable
--
--------------------------------------------------------------------
--
-- Interface to Xrandr API
--

module Graphics.X11.Xrandr (
  XRRScreenSize(..),
  XRRModeInfo(..),
  XRRScreenResources(..),
  XRROutputInfo(..),
  XRRCrtcInfo(..),
  XRRPropertyInfo(..),
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
  xrrTimes,
  xrrGetScreenResources,
  xrrGetOutputInfo,
  xrrGetCrtcInfo,
  xrrGetScreenResourcesCurrent,
  xrrSetOutputPrimary,
  xrrGetOutputPrimary,
  xrrListOutputProperties,
  xrrQueryOutputProperty,
  xrrConfigureOutputProperty,
  xrrChangeOutputProperty,
  xrrGetOutputProperty,
  xrrDeleteOutputProperty
  ) where

import Foreign
import Foreign.C.Types
import Foreign.C.String
import Control.Monad
import Data.Default

import Graphics.X11.Xlib.Event
import Graphics.X11.Xlib.Internal
import Graphics.X11.Xlib.Types
import Graphics.X11.Types

#if __GLASGOW_HASKELL__
import Data.Data
#endif

-- | Representation of the XRRScreenSize struct
data XRRScreenSize = XRRScreenSize
                     { xrr_ss_width   :: !CInt,
                       xrr_ss_height  :: !CInt,
                       xrr_ss_mwidth  :: !CInt,
                       xrr_ss_mheight :: !CInt }
                       deriving (Show)

-- | Representation of the XRRModeInfo struct
data XRRModeInfo = XRRModeInfo
    { xrr_mi_id         :: !RRMode
    , xrr_mi_width      :: !CUInt
    , xrr_mi_height     :: !CUInt
    , xrr_mi_dotClock   :: !CUInt
    , xrr_mi_hSyncStart :: !CUInt
    , xrr_mi_hSyncEnd   :: !CUInt
    , xrr_mi_hTotal     :: !CUInt
    , xrr_mi_hSkew      :: !CUInt
    , xrr_mi_vSyncStart :: !CUInt
    , xrr_mi_vSyncEnd   :: !CUInt
    , xrr_mi_vTotal     :: !CUInt
    , xrr_mi_name       :: !String
    , xrr_mi_modeFlags  :: !XRRModeFlags
    } deriving (Eq, Show)

-- | Representation of the XRRScreenResources struct
data XRRScreenResources = XRRScreenResources
    { xrr_sr_timestamp       :: !Time
    , xrr_sr_configTimestamp :: !Time
    , xrr_sr_crtcs           :: [RRCrtc]
    , xrr_sr_outputs         :: [RROutput]
    , xrr_sr_modes           :: [XRRModeInfo]
    } deriving (Eq, Show)

-- | Representation of the XRROutputInfo struct
data XRROutputInfo = XRROutputInfo
    { xrr_oi_timestamp      :: !Time
    , xrr_oi_crtc           :: !RRCrtc
    , xrr_oi_name           :: !String
    , xrr_oi_mm_width       :: !CULong
    , xrr_oi_mm_height      :: !CULong
    , xrr_oi_connection     :: !Connection
    , xrr_oi_subpixel_order :: !SubpixelOrder
    , xrr_oi_crtcs          :: [RRCrtc]
    , xrr_oi_clones         :: [RROutput]
    , xrr_oi_npreferred     :: !CInt
    , xrr_oi_modes          :: [RRMode]
    } deriving (Eq, Show)

-- | Representation of the XRRCrtcInfo struct
data XRRCrtcInfo = XRRCrtcInfo
    { xrr_ci_timestamp    :: !Time
    , xrr_ci_x            :: !CInt
    , xrr_ci_y            :: !CInt
    , xrr_ci_width        :: !CUInt
    , xrr_ci_height       :: !CUInt
    , xrr_ci_mode         :: !RRMode
    , xrr_ci_rotation     :: !Rotation
    , xrr_ci_outputs      :: [RROutput]
    , xrr_ci_rotations    :: !Rotation
    , xrr_ci_possible     :: [RROutput]
    } deriving (Eq, Show)

-- | Representation of the XRRPropertyInfo struct
data XRRPropertyInfo = XRRPropertyInfo
    { xrr_pi_pending      :: !Bool
    , xrr_pi_range        :: !Bool
    , xrr_pi_immutable    :: !Bool
    , xrr_pi_values       :: [CLong]
    } deriving (Eq, Show)

newtype XRRScreenConfiguration = XRRScreenConfiguration (Ptr XRRScreenConfiguration)
#if __GLASGOW_HASKELL__
        deriving (Eq, Ord, Show, Typeable, Data)
#else
        deriving (Eq, Ord, Show)
#endif

xrrQueryExtension :: Display -> IO (Maybe (CInt, CInt))
xrrQueryExtension dpy = wrapPtr2 (cXRRQueryExtension dpy) go
  where go False _ _                = Nothing
        go True eventbase errorbase = Just (fromIntegral eventbase, fromIntegral errorbase)

xrrQueryVersion :: Display -> IO (Maybe (CInt, CInt))
xrrQueryVersion dpy = wrapPtr2 (cXRRQueryVersion dpy) go
  where go False _ _        = Nothing
        go True major minor = Just (fromIntegral major, fromIntegral minor)

xrrGetScreenInfo :: Display -> Drawable -> IO (Maybe XRRScreenConfiguration)
xrrGetScreenInfo dpy draw = do
  p <- cXRRGetScreenInfo dpy draw
  if p == nullPtr
     then return Nothing
     else return (Just (XRRScreenConfiguration p))

xrrFreeScreenConfigInfo :: XRRScreenConfiguration -> IO ()
xrrFreeScreenConfigInfo = cXRRFreeScreenConfigInfo

xrrSetScreenConfig :: Display -> XRRScreenConfiguration -> Drawable -> CInt -> Rotation -> Time -> IO Status
xrrSetScreenConfig = cXRRSetScreenConfig

xrrSetScreenConfigAndRate :: Display -> XRRScreenConfiguration -> Drawable -> CInt -> Rotation -> CShort -> Time -> IO Status
xrrSetScreenConfigAndRate = cXRRSetScreenConfigAndRate

xrrConfigRotations :: XRRScreenConfiguration -> IO (Rotation, Rotation)
xrrConfigRotations config =
  withPool $ \pool -> do rptr <- pooledMalloc pool
                         rotations <- cXRRConfigRotations config rptr
                         cur_rotation <- peek rptr
                         return (rotations, cur_rotation)

xrrConfigTimes :: XRRScreenConfiguration -> IO (Time, Time)
xrrConfigTimes config =
  withPool $ \pool -> do tptr <- pooledMalloc pool
                         time <- cXRRConfigTimes config tptr
                         cur_time <- peek tptr
                         return (time, cur_time)

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
                                    _ <- xFree p
                                    return sizes

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
                                    _ <- xFree p
                                    return rates

xrrConfigCurrentConfiguration :: XRRScreenConfiguration -> IO (Rotation, SizeID)
xrrConfigCurrentConfiguration config =
  withPool $ \pool -> do rptr <- pooledMalloc pool
                         sizeid <- cXRRConfigCurrentConfiguration config rptr
                         rotation <- peek rptr
                         return (rotation, sizeid)

xrrConfigCurrentRate :: XRRScreenConfiguration -> IO CShort
xrrConfigCurrentRate = cXRRConfigCurrentRate

xrrRootToScreen :: Display -> Window -> IO CInt
xrrRootToScreen = cXRRRootToScreen

xrrSelectInput :: Display -> Window -> EventMask -> IO ()
xrrSelectInput dpy window mask = cXRRSelectInput dpy window (fromIntegral mask)

xrrUpdateConfiguration :: XEvent -> IO CInt
xrrUpdateConfiguration = cXRRUpdateConfiguration

xrrRotations :: Display -> CInt -> IO (Rotation, Rotation)
xrrRotations dpy screen =
  withPool $ \pool -> do rptr <- pooledMalloc pool
                         rotations <- cXRRRotations dpy screen rptr
                         cur_rotation <- peek rptr
                         return (rotations, cur_rotation)

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
                                    _ <- xFree p
                                    return sizes

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
                                    _ <- xFree p
                                    return rates

xrrTimes :: Display -> CInt -> IO (Time, Time)
xrrTimes dpy screen =
  withPool $ \pool -> do tptr <- pooledMalloc pool
                         time <- cXRRTimes dpy screen tptr
                         config_time <- peek tptr
                         return (time, config_time)

xrrGetScreenResources :: Display -> Window -> IO (Maybe XRRScreenResources)
xrrGetScreenResources dpy win = do
    srp <- cXRRGetScreenResources dpy win
    if srp == nullPtr
        then return Nothing
        else do
            res <- peek srp
            cXRRFreeScreenResources srp
            return $ Just res

xrrGetOutputInfo :: Display -> XRRScreenResources -> RROutput -> IO (Maybe XRROutputInfo)
xrrGetOutputInfo dpy xrr_sr rro = withPool $ \pool -> do
    -- XRRGetOutputInfo only uses the timestamp field from the
    -- XRRScreenResources struct, so it's probably ok to pass the incomplete
    -- structure here (see also the poke implementation for the Storable
    -- instance of XRRScreenResources)
    -- Alternative version below; This is extremely slow, though!
    {- xrrGetOutputInfo :: Display -> Window -> RROutput -> IO (Maybe XRROutputInfo)
       xrrGetOutputInfo dpy win rro = do
           srp <- cXRRGetScreenResources dpy win
           oip <- cXRRGetOutputInfo dpy srp rro
           cXRRFreeScreenResources srp
    -}
    oip <- pooledMalloc pool >>= \srp -> do
        poke srp xrr_sr
        cXRRGetOutputInfo dpy srp rro -- no need to free srp, because pool mem

    if oip == nullPtr
        then return Nothing
        else do
            oi <- peek oip
            _ <- cXRRFreeOutputInfo oip
            return $ Just oi

xrrGetCrtcInfo :: Display -> XRRScreenResources -> RRCrtc -> IO (Maybe XRRCrtcInfo)
xrrGetCrtcInfo dpy xrr_sr crtc = withPool $ \pool -> do
    -- XRRGetCrtcInfo only uses the timestamp field from the
    -- XRRScreenResources struct, so it's probably ok to pass the incomplete
    -- structure here (see also the poke implementation for the Storable
    -- instance of XRRScreenResources)
    cip <- pooledMalloc pool >>= \srp -> do
        poke srp xrr_sr
        cXRRGetCrtcInfo dpy srp crtc -- no need to free srp, because pool mem

    if cip == nullPtr
        then return Nothing
        else do
            ci <- peek cip
            cXRRFreeCrtcInfo cip
            return $ Just ci

xrrGetScreenResourcesCurrent :: Display -> Window -> IO (Maybe XRRScreenResources)
xrrGetScreenResourcesCurrent dpy win = do
    srcp <- cXRRGetScreenResourcesCurrent dpy win
    if srcp == nullPtr
        then return Nothing
        else do
            res <- peek srcp
            cXRRFreeScreenResources srcp
            return $ Just res

xrrListOutputProperties :: Display -> RROutput -> IO (Maybe [Atom])
xrrListOutputProperties dpy rro = withPool $ \pool -> do
    intp <- pooledMalloc pool
    p <- cXRRListOutputProperties dpy rro intp
    if p == nullPtr
        then return Nothing
        else do
            nprop <- peek intp
            res <- fmap Just $ peekCArray nprop p
            _ <- xFree p
            return res

xrrQueryOutputProperty :: Display -> RROutput -> Atom -> IO (Maybe XRRPropertyInfo)
xrrQueryOutputProperty dpy rro prop = do
    p <- cXRRQueryOutputProperty dpy rro prop
    if p == nullPtr
        then return Nothing
        else do
            res <- peek p
            _ <- xFree p
            return $ Just res

xrrConfigureOutputProperty :: Display -> RROutput -> Atom -> Bool -> Bool -> [CLong] -> IO ()
xrrConfigureOutputProperty dpy rro prop pend range xs = withArrayLen xs $
    cXRRConfigureOutputProperty dpy rro prop pend range . fromIntegral

xrrChangeOutputProperty :: Display -> RROutput -> Atom -> Atom -> CInt -> CInt -> [Word32] -> IO ()
xrrChangeOutputProperty dpy rro prop typ format mode xs = withPool $ \pool -> do
    ptr <- case format of
        8 ->  pooledNewArray pool (map fromIntegral xs :: [Word8])
        16 -> castPtr `fmap` pooledNewArray pool (map fromIntegral xs :: [Word16])
        32 -> castPtr `fmap` pooledNewArray pool xs
        _  -> error "invalid format"

    cXRRChangeOutputProperty dpy rro prop typ format mode ptr (fromIntegral $ length xs)

-- | @xrrGetOutputProperty display output property offset length delete pending propertyType@
-- | returns @Maybe (actualType, format, bytesAfter, data)@.
xrrGetOutputProperty ::
    Display -> RROutput -> Atom -> CLong -> CLong -> Bool -> Bool -> Atom ->
    IO (Maybe (Atom, Int, CULong, [Word32]))
xrrGetOutputProperty dpy rro prop offset len delete preferPending reqType = withPool $ \pool -> do
    actualTypep <- pooledMalloc pool
    actualFormatp <- pooledMalloc pool
    nItemsp <- pooledMalloc pool
    bytesAfterp <- pooledMalloc pool
    datapp <- pooledMalloc pool
    status <- cXRRGetOutputProperty dpy rro prop offset len
        delete preferPending reqType
        actualTypep actualFormatp nItemsp bytesAfterp datapp

    if status /= 0
        then return Nothing
        else do
          format <- fmap fromIntegral (peek actualFormatp)
          nitems <- fmap fromIntegral (peek nItemsp)
          ptr <- peek datapp

          dat <- case format of
            0 -> return []
            8 -> fmap (map fromIntegral) $ peekArray nitems ptr
            16 -> fmap (map fromIntegral) $ peekArray nitems (castPtr ptr :: Ptr Word16)
            32 -> peekArray nitems (castPtr ptr :: Ptr Word32)
            _  -> error $ "impossible happened: prop format is not in 0,8,16,32 (" ++ show format ++ ")"

          _ <- xFree ptr

          typ <- peek actualTypep
          bytesAfter <- peek bytesAfterp
          return $ Just (typ, format, bytesAfter, dat)

xrrDeleteOutputProperty :: Display -> RROutput -> Atom -> IO ()
xrrDeleteOutputProperty = cXRRDeleteOutputProperty

#ifdef HAVE_X11_EXTENSIONS_XRANDR_H
-- We have Xrandr, so the library will actually work
compiledWithXrandr :: Bool
compiledWithXrandr = True

#include "HsXlib.h"

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

instance Storable XRRModeInfo where
    sizeOf _ = #{size XRRModeInfo}
    -- FIXME: Is this right?
    alignment _ = alignment (undefined :: CInt)

    poke p xrr_mi = do
        #{poke XRRModeInfo, id         } p $ xrr_mi_id         xrr_mi
        #{poke XRRModeInfo, width      } p $ xrr_mi_width      xrr_mi
        #{poke XRRModeInfo, height     } p $ xrr_mi_height     xrr_mi
        #{poke XRRModeInfo, dotClock   } p $ xrr_mi_dotClock   xrr_mi
        #{poke XRRModeInfo, hSyncStart } p $ xrr_mi_hSyncStart xrr_mi
        #{poke XRRModeInfo, hSyncEnd   } p $ xrr_mi_hSyncEnd   xrr_mi
        #{poke XRRModeInfo, hTotal     } p $ xrr_mi_hTotal     xrr_mi
        #{poke XRRModeInfo, hSkew      } p $ xrr_mi_hSkew      xrr_mi
        #{poke XRRModeInfo, vSyncStart } p $ xrr_mi_vSyncStart xrr_mi
        #{poke XRRModeInfo, vSyncEnd   } p $ xrr_mi_vSyncEnd   xrr_mi
        #{poke XRRModeInfo, vTotal     } p $ xrr_mi_vTotal     xrr_mi
        #{poke XRRModeInfo, modeFlags  } p $ xrr_mi_modeFlags  xrr_mi
        -- see comment in Storable XRRScreenResources about dynamic resource allocation
        #{poke XRRModeInfo, nameLength } p ( 0 :: CInt )
        #{poke XRRModeInfo, name       } p ( nullPtr :: Ptr CChar )

    peek p = return XRRModeInfo
        `ap` ( #{peek XRRModeInfo, id         } p )
        `ap` ( #{peek XRRModeInfo, width      } p )
        `ap` ( #{peek XRRModeInfo, height     } p )
        `ap` ( #{peek XRRModeInfo, dotClock   } p )
        `ap` ( #{peek XRRModeInfo, hSyncStart } p )
        `ap` ( #{peek XRRModeInfo, hSyncEnd   } p )
        `ap` ( #{peek XRRModeInfo, hTotal     } p )
        `ap` ( #{peek XRRModeInfo, hSkew      } p )
        `ap` ( #{peek XRRModeInfo, vSyncStart } p )
        `ap` ( #{peek XRRModeInfo, vSyncEnd   } p )
        `ap` ( #{peek XRRModeInfo, vTotal     } p )
        `ap` peekCStringLenIO (#{peek XRRModeInfo, nameLength } p)
                              (#{peek XRRModeInfo, name       } p)
        `ap` ( #{peek XRRModeInfo, modeFlags  } p )


instance Storable XRRScreenResources where
    sizeOf _ = #{size XRRScreenResources}
    -- FIXME: Is this right?
    alignment _ = alignment (undefined :: CInt)

    poke p xrr_sr = do
        #{poke XRRScreenResources, timestamp       } p $ xrr_sr_timestamp       xrr_sr
        #{poke XRRScreenResources, configTimestamp } p $ xrr_sr_configTimestamp xrr_sr
        -- there is no simple way to handle ptrs to arrays or struct through ffi
        -- Using plain malloc will result in a memory leak, unless the poking
        -- function will free the memory manually
        -- Unfortunately a ForeignPtr with a Finalizer is not going to work
        -- either, because the Finalizer will be run after poke returns, making
        -- the allocated memory unusable.
        -- The safest option is therefore probably to have the calling function
        -- handle this issue for itself
        -- e.g.
        -- #{poke XRRScreenResources, ncrtc} p ( fromIntegral $ length $ xrr_sr_crtcs xrr_sr :: CInt )
        -- crtcp <- mallocArray $ length $ xrr_sr_crtcs xrr_sr
        -- pokeArray crtcp $ xrr_sr_crtcs xrr_sr
        -- #{poke XRRScreenResources, crtcs} p crtcp
        #{poke XRRScreenResources, ncrtc           } p ( 0 :: CInt )
        #{poke XRRScreenResources, noutput         } p ( 0 :: CInt )
        #{poke XRRScreenResources, nmode           } p ( 0 :: CInt )
        #{poke XRRScreenResources, crtcs           } p ( nullPtr :: Ptr RRCrtc      )
        #{poke XRRScreenResources, outputs         } p ( nullPtr :: Ptr RROutput    )
        #{poke XRRScreenResources, modes           } p ( nullPtr :: Ptr XRRModeInfo )

    peek p = return XRRScreenResources
        `ap` ( #{peek XRRScreenResources, timestamp       } p )
        `ap` ( #{peek XRRScreenResources, configTimestamp } p )
        `ap` peekCArrayIO (#{peek XRRScreenResources, ncrtc   } p)
                          (#{peek XRRScreenResources, crtcs   } p)
        `ap` peekCArrayIO (#{peek XRRScreenResources, noutput } p)
                          (#{peek XRRScreenResources, outputs } p)
        `ap` peekCArrayIO (#{peek XRRScreenResources, nmode   } p)
                          (#{peek XRRScreenResources, modes   } p)


instance Storable XRROutputInfo where
    sizeOf _ = #{size XRROutputInfo}
    -- FIXME: Is this right?
    alignment _ = alignment (undefined :: CInt)

    poke p xrr_oi = do
        #{poke XRROutputInfo, timestamp      } p $ xrr_oi_timestamp      xrr_oi
        #{poke XRROutputInfo, crtc           } p $ xrr_oi_crtc           xrr_oi
        #{poke XRROutputInfo, mm_width       } p $ xrr_oi_mm_width       xrr_oi
        #{poke XRROutputInfo, mm_height      } p $ xrr_oi_mm_height      xrr_oi
        #{poke XRROutputInfo, connection     } p $ xrr_oi_connection     xrr_oi
        #{poke XRROutputInfo, subpixel_order } p $ xrr_oi_subpixel_order xrr_oi
        #{poke XRROutputInfo, npreferred     } p $ xrr_oi_npreferred     xrr_oi
        -- see comment in Storable XRRScreenResources about dynamic resource allocation
        #{poke XRROutputInfo, nameLen        } p ( 0 :: CInt )
        #{poke XRROutputInfo, ncrtc          } p ( 0 :: CInt )
        #{poke XRROutputInfo, nclone         } p ( 0 :: CInt )
        #{poke XRROutputInfo, nmode          } p ( 0 :: CInt )
        #{poke XRROutputInfo, name           } p ( nullPtr :: Ptr CChar    )
        #{poke XRROutputInfo, crtcs          } p ( nullPtr :: Ptr RRCrtc   )
        #{poke XRROutputInfo, clones         } p ( nullPtr :: Ptr RROutput )
        #{poke XRROutputInfo, modes          } p ( nullPtr :: Ptr RRMode   )

    peek p = return XRROutputInfo
            `ap` ( #{peek XRROutputInfo, timestamp      } p )
            `ap` ( #{peek XRROutputInfo, crtc           } p )
            `ap` peekCStringLenIO (#{peek XRROutputInfo, nameLen } p)
                                  (#{peek XRROutputInfo, name    } p)
            `ap` ( #{peek XRROutputInfo, mm_width       } p )
            `ap` ( #{peek XRROutputInfo, mm_height      } p )
            `ap` ( #{peek XRROutputInfo, connection     } p )
            `ap` ( #{peek XRROutputInfo, subpixel_order } p )
            `ap` peekCArrayIO (#{peek XRROutputInfo, ncrtc   } p)
                              (#{peek XRROutputInfo, crtcs   } p)
            `ap` peekCArrayIO (#{peek XRROutputInfo, nclone  } p)
                              (#{peek XRROutputInfo, clones  } p)
            `ap` ( #{peek XRROutputInfo, npreferred     } p )
            `ap` peekCArrayIO (#{peek XRROutputInfo, nmode   } p)
                              (#{peek XRROutputInfo, modes   } p)


instance Storable XRRCrtcInfo where
    sizeOf _ = #{size XRRCrtcInfo}
    -- FIXME: Is this right?
    alignment _ = alignment (undefined :: CInt)

    poke p xrr_ci = do
        #{poke XRRCrtcInfo, timestamp } p $ xrr_ci_timestamp xrr_ci
        #{poke XRRCrtcInfo, x         } p $ xrr_ci_x         xrr_ci
        #{poke XRRCrtcInfo, y         } p $ xrr_ci_y         xrr_ci
        #{poke XRRCrtcInfo, width     } p $ xrr_ci_width     xrr_ci
        #{poke XRRCrtcInfo, height    } p $ xrr_ci_height    xrr_ci
        #{poke XRRCrtcInfo, mode      } p $ xrr_ci_mode      xrr_ci
        #{poke XRRCrtcInfo, rotation  } p $ xrr_ci_rotation  xrr_ci
        #{poke XRRCrtcInfo, rotations } p $ xrr_ci_rotations xrr_ci
        -- see comment in Storable XRRScreenResources about dynamic resource allocation
        #{poke XRRCrtcInfo, noutput   } p ( 0 :: CInt )
        #{poke XRRCrtcInfo, npossible } p ( 0 :: CInt )
        #{poke XRRCrtcInfo, outputs   } p ( nullPtr :: Ptr RROutput )
        #{poke XRRCrtcInfo, possible  } p ( nullPtr :: Ptr RROutput )

    peek p = return XRRCrtcInfo
        `ap` ( #{peek XRRCrtcInfo, timestamp } p )
        `ap` ( #{peek XRRCrtcInfo, x         } p )
        `ap` ( #{peek XRRCrtcInfo, y         } p )
        `ap` ( #{peek XRRCrtcInfo, width     } p )
        `ap` ( #{peek XRRCrtcInfo, height    } p )
        `ap` ( #{peek XRRCrtcInfo, mode      } p )
        `ap` ( #{peek XRRCrtcInfo, rotation  } p )
        `ap` peekCArrayIO (#{peek XRRCrtcInfo, noutput  } p)
                          (#{peek XRRCrtcInfo, outputs  } p)
        `ap` ( #{peek XRRCrtcInfo, rotations } p )
        `ap` peekCArrayIO (#{peek XRRCrtcInfo, npossible } p)
                          (#{peek XRRCrtcInfo, possible  } p)


instance Storable XRRPropertyInfo where
    sizeOf _ = #{size XRRPropertyInfo}
    -- FIXME: Is this right?
    alignment _ = alignment (undefined :: CInt)

    poke p xrr_pi = do
        #{poke XRRPropertyInfo, pending    } p $ xrr_pi_pending   xrr_pi
        #{poke XRRPropertyInfo, range      } p $ xrr_pi_range     xrr_pi
        #{poke XRRPropertyInfo, immutable  } p $ xrr_pi_immutable xrr_pi
        -- see comment in Storable XRRScreenResources about dynamic resource allocation
        #{poke XRRPropertyInfo, num_values } p ( 0 :: CInt )
        #{poke XRRPropertyInfo, values     } p ( nullPtr :: Ptr CLong )

    peek p = return XRRPropertyInfo
        `ap` ( #{peek XRRPropertyInfo, pending   } p )
        `ap` ( #{peek XRRPropertyInfo, range     } p )
        `ap` ( #{peek XRRPropertyInfo, immutable } p )
        `ap` peekCArrayIO ( #{peek XRRPropertyInfo, num_values} p)
                          ( #{peek XRRPropertyInfo, values} p)

foreign import ccall "XRRQueryExtension"
  cXRRQueryExtension :: Display -> Ptr CInt -> Ptr CInt -> IO Bool

foreign import ccall "XRRQueryVersion"
  cXRRQueryVersion :: Display -> Ptr CInt -> Ptr CInt -> IO Bool

foreign import ccall "XRRGetScreenInfo"
  cXRRGetScreenInfo :: Display -> Drawable -> IO (Ptr XRRScreenConfiguration)

foreign import ccall "XRRFreeScreenConfigInfo"
  cXRRFreeScreenConfigInfo :: XRRScreenConfiguration -> IO ()

foreign import ccall "XRRSetScreenConfig"
  cXRRSetScreenConfig :: Display -> XRRScreenConfiguration -> Drawable -> CInt -> Rotation -> Time -> IO Status

foreign import ccall "XRRSetScreenConfigAndRate"
  cXRRSetScreenConfigAndRate :: Display -> XRRScreenConfiguration -> Drawable -> CInt -> Rotation -> CShort -> Time -> IO Status

foreign import ccall "XRRConfigRotations"
  cXRRConfigRotations :: XRRScreenConfiguration -> Ptr Rotation -> IO Rotation

foreign import ccall "XRRConfigTimes"
  cXRRConfigTimes :: XRRScreenConfiguration -> Ptr Time -> IO Time

foreign import ccall "XRRConfigSizes"
  cXRRConfigSizes :: XRRScreenConfiguration -> Ptr CInt -> IO (Ptr XRRScreenSize)

foreign import ccall "XRRConfigRates"
  cXRRConfigRates :: XRRScreenConfiguration -> CInt -> Ptr CInt -> IO (Ptr CShort)

foreign import ccall "XRRConfigCurrentConfiguration"
  cXRRConfigCurrentConfiguration :: XRRScreenConfiguration -> Ptr Rotation -> IO SizeID

foreign import ccall "XRRConfigCurrentRate"
  cXRRConfigCurrentRate :: XRRScreenConfiguration -> IO CShort

foreign import ccall "XRRRootToScreen"
  cXRRRootToScreen :: Display -> Window -> IO CInt

foreign import ccall "XRRSelectInput"
  cXRRSelectInput :: Display -> Window -> CInt -> IO ()

foreign import ccall "XRRUpdateConfiguration"
  cXRRUpdateConfiguration :: XEvent -> IO CInt

foreign import ccall "XRRRotations"
  cXRRRotations :: Display -> CInt -> Ptr Rotation -> IO Rotation

foreign import ccall "XRRSizes"
  cXRRSizes :: Display -> CInt -> Ptr CInt -> IO (Ptr XRRScreenSize)

foreign import ccall "XRRRates"
  cXRRRates :: Display -> CInt -> CInt -> Ptr CInt -> IO (Ptr CShort)

foreign import ccall "XRRTimes"
  cXRRTimes :: Display -> CInt -> Ptr Time -> IO Time

foreign import ccall "XRRGetScreenResources"
    cXRRGetScreenResources :: Display -> Window -> IO (Ptr XRRScreenResources)

foreign import ccall "XRRFreeScreenResources"
    cXRRFreeScreenResources :: Ptr XRRScreenResources -> IO ()

foreign import ccall "XRRGetOutputInfo"
    cXRRGetOutputInfo :: Display -> Ptr XRRScreenResources -> RROutput -> IO (Ptr XRROutputInfo)

foreign import ccall "XRRFreeOutputInfo"
    cXRRFreeOutputInfo :: Ptr XRROutputInfo -> IO ()

foreign import ccall "XRRGetCrtcInfo"
    cXRRGetCrtcInfo :: Display -> Ptr XRRScreenResources -> RRCrtc -> IO (Ptr XRRCrtcInfo)

foreign import ccall "XRRFreeCrtcInfo"
    cXRRFreeCrtcInfo :: Ptr XRRCrtcInfo -> IO ()

foreign import ccall "XRRSetOutputPrimary"
    xrrSetOutputPrimary :: Display -> Window -> RROutput -> IO ()

foreign import ccall "XRRGetOutputPrimary"
    xrrGetOutputPrimary :: Display -> Window -> IO RROutput

foreign import ccall "XRRGetScreenResourcesCurrent"
    cXRRGetScreenResourcesCurrent :: Display -> Window -> IO (Ptr XRRScreenResources)

foreign import ccall "XRRListOutputProperties"
    cXRRListOutputProperties :: Display -> RROutput -> Ptr CInt -> IO (Ptr Atom)

foreign import ccall "XRRQueryOutputProperty"
    cXRRQueryOutputProperty :: Display -> RROutput -> Atom -> IO (Ptr XRRPropertyInfo)

foreign import ccall "XRRConfigureOutputProperty"
    cXRRConfigureOutputProperty :: Display -> RROutput -> Atom -> Bool -> Bool -> CInt ->  Ptr CLong -> IO ()

foreign import ccall "XRRChangeOutputProperty"
    cXRRChangeOutputProperty :: Display -> RROutput -> Atom -> Atom -> CInt -> CInt -> Ptr Word8 -> CInt -> IO ()

foreign import ccall "XRRGetOutputProperty"
    cXRRGetOutputProperty :: Display -> RROutput -> Atom -> CLong -> CLong -> Bool -> Bool
      -> Atom -> Ptr Atom -> Ptr CInt -> Ptr CULong -> Ptr CULong -> Ptr (Ptr Word8) -> IO CInt

foreign import ccall "XRRDeleteOutputProperty"
    cXRRDeleteOutputProperty :: Display -> RROutput -> Atom -> IO ()

#else
compiledWithXrandr :: Bool
compiledWithXrandr = False

instance Storable XRRScreenSize
instance Storable XRRModeInfo
instance Storable XRRScreenResources
instance Storable XRROutputInfo
instance Storable XRRCrtcInfo
instance Storable XRRPropertyInfo

cXRRQueryExtension :: Display -> Ptr CInt -> Ptr CInt -> IO Bool
cXRRQueryExtension _ _ _ = return False

cXRRQueryVersion :: Display -> Ptr CInt -> Ptr CInt -> IO Bool
cXRRQueryVersion _ _ _ = return False

-- All these `\_ _ _ -> return nullPtr` implementations *could* just be def, if
-- only there were a Ptr instance of Default. But this is really not the right
-- module to put such an instance in.
cXRRGetScreenInfo :: Display -> Drawable -> IO (Ptr XRRScreenConfiguration)
cXRRGetScreenInfo _ _ = return nullPtr

cXRRFreeScreenConfigInfo :: XRRScreenConfiguration -> IO ()
cXRRFreeScreenConfigInfo = def

cXRRSetScreenConfig :: Display -> XRRScreenConfiguration -> Drawable -> CInt -> Rotation -> Time -> IO Status
cXRRSetScreenConfig _ _ _ _ _ _ = return badValue

cXRRSetScreenConfigAndRate :: Display -> XRRScreenConfiguration -> Drawable -> CInt -> Rotation -> CShort -> Time -> IO Status
cXRRSetScreenConfigAndRate _ _ _ _ _ _ _ = return badValue

cXRRConfigRotations :: XRRScreenConfiguration -> Ptr Rotation -> IO Rotation
cXRRConfigRotations _ = peek -- haha, what

cXRRConfigTimes :: XRRScreenConfiguration -> Ptr Time -> IO Time
cXRRConfigTimes _ = peek

cXRRConfigSizes :: XRRScreenConfiguration -> Ptr CInt -> IO (Ptr XRRScreenSize)
cXRRConfigSizes _ _ = return nullPtr

cXRRConfigRates :: XRRScreenConfiguration -> CInt -> Ptr CInt -> IO (Ptr CShort)
cXRRConfigRates _ _ _ = return nullPtr

cXRRConfigCurrentConfiguration :: XRRScreenConfiguration -> Ptr Rotation -> IO SizeID
cXRRConfigCurrentConfiguration _ _ = return (-1)

cXRRConfigCurrentRate :: XRRScreenConfiguration -> IO CShort
cXRRConfigCurrentRate _ = return (-1)

cXRRRootToScreen :: Display -> Window -> IO CInt
cXRRRootToScreen _ _ = return (-1)

cXRRSelectInput :: Display -> Window -> CInt -> IO ()
cXRRSelectInput = def

cXRRUpdateConfiguration :: XEvent -> IO CInt
cXRRUpdateConfiguration _ = return (-1)

cXRRRotations :: Display -> CInt -> Ptr Rotation -> IO Rotation
cXRRRotations _ _ = peek

cXRRSizes :: Display -> CInt -> Ptr CInt -> IO (Ptr XRRScreenSize)
cXRRSizes _ _ _ = return nullPtr

cXRRRates :: Display -> CInt -> CInt -> Ptr CInt -> IO (Ptr CShort)
cXRRRates  _ _ _ _ = return nullPtr

cXRRTimes :: Display -> CInt -> Ptr Time -> IO Time
cXRRTimes _ _ = peek

cXRRGetScreenResources :: Display -> Window -> IO (Ptr XRRScreenResources)
cXRRGetScreenResources  _ _ = return nullPtr

cXRRFreeScreenResources :: Ptr XRRScreenResources -> IO ()
cXRRFreeScreenResources = def

cXRRGetOutputInfo :: Display -> Ptr XRRScreenResources -> RROutput -> IO (Ptr XRROutputInfo)
cXRRGetOutputInfo _ _ _ = return nullPtr

cXRRFreeOutputInfo :: Ptr XRROutputInfo -> IO ()
cXRRFreeOutputInfo = def

cXRRGetCrtcInfo :: Display -> Ptr XRRScreenResources -> RRCrtc -> IO (Ptr XRRCrtcInfo)
cXRRGetCrtcInfo _ _ _ = return nullPtr

cXRRFreeCrtcInfo :: Ptr XRRCrtcInfo -> IO ()
cXRRFreeCrtcInfo = def

xrrSetOutputPrimary :: Display -> Window -> RROutput -> IO ()
xrrSetOutputPrimary = def

xrrGetOutputPrimary :: Display -> Window -> IO RROutput
xrrGetOutputPrimary = def

cXRRGetScreenResourcesCurrent :: Display -> Window -> IO (Ptr XRRScreenResources)
cXRRGetScreenResourcesCurrent _ _ = return nullPtr

cXRRListOutputProperties :: Display -> RROutput -> Ptr CInt -> IO (Ptr Atom)
cXRRListOutputProperties _ _ _ = return nullPtr

cXRRQueryOutputProperty :: Display -> RROutput -> Atom -> IO (Ptr XRRPropertyInfo)
cXRRQueryOutputProperty _ _ _ = return nullPtr

cXRRConfigureOutputProperty :: Display -> RROutput -> Atom -> Bool -> Bool -> CInt -> Ptr CLong -> IO ()
cXRRConfigureOutputProperty = def

cXRRChangeOutputProperty :: Display -> RROutput -> Atom -> Atom -> CInt -> CInt -> Ptr Word8 -> CInt -> IO ()
cXRRChangeOutputProperty = def

cXRRGetOutputProperty :: Display -> RROutput -> Atom -> CLong -> CLong -> Bool -> Bool
      -> Atom -> Ptr Atom -> Ptr CInt -> Ptr CULong -> Ptr CULong -> Ptr (Ptr Word8) -> IO CInt
cXRRGetOutputProperty _ _ _ _ _ _ _ _ _ _ _ _ _ = return (-1)

cXRRDeleteOutputProperty :: Display -> RROutput -> Atom -> IO ()
cXRRDeleteOutputProperty = def

#endif

wrapPtr2 :: (Storable a, Storable b) => (Ptr a -> Ptr b -> IO c) -> (c -> a -> b -> d) -> IO d
wrapPtr2 cfun f =
  withPool $ \pool -> do aptr <- pooledMalloc pool
                         bptr <- pooledMalloc pool
                         ret <- cfun aptr bptr
                         a <- peek aptr
                         b <- peek bptr
                         return (f ret a b)

peekCArray :: Storable a => CInt -> Ptr a -> IO [a]
peekCArray n = peekArray (fromIntegral n)

peekCArrayIO :: Storable a => IO CInt -> IO (Ptr a) -> IO [a]
peekCArrayIO n = join . liftM2 peekCArray n

peekCStringLenIO :: IO CInt -> IO (Ptr CChar) -> IO String
peekCStringLenIO n p = liftM2 (,) p (fmap fromIntegral n) >>= peekCStringLen
