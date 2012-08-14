{-# LANGUAGE DeriveDataTypeable, ForeignFunctionInterface #-}
--------------------------------------------------------------------
-- |
-- Module    : Graphics.X11.XScreenSaver
-- Copyright : (c) Joachim Breitner
-- License   : GPL2
--
-- Maintainer: Joachim Breitner <mail@joachim-breitner.de>
-- Stability : provisional
-- Portability: portable
--
--------------------------------------------------------------------
--
-- Interface to XScreenSaver API
--

module Graphics.X11.XScreenSaver (
    getXIdleTime,
    XScreenSaverState(..),
    XScreenSaverKind(..),
    XScreenSaverInfo(..),
    XScreenSaverNotifyEvent,
    xScreenSaverQueryExtension,
    xScreenSaverQueryVersion,
    xScreenSaverQueryInfo,
    xScreenSaverSelectInput,
    xScreenSaverSetAttributes,
    xScreenSaverUnsetAttributes,
    xScreenSaverSaverRegister,
    xScreenSaverUnregister,
    xScreenSaverGetRegistered,
    xScreenSaverSuspend,
    get_XScreenSaverNotifyEvent,
    compiledWithXScreenSaver
 ) where

import Graphics.X11.Types
import Graphics.X11.Xlib.Types

import Foreign
import Foreign.C.Types
import Graphics.X11.Xlib
import Control.Monad

                       | ScreenSaverCycle

data XScreenSaverKind = ScreenSaverBlanked
                      | ScreenSaverInternal
                      | ScreenSaverExternal
                      deriving Show

-- | Representation of the XScreenSaverInfo struct.
data XScreenSaverInfo = XScreenSaverInfo
    { xssi_window        :: !Window
    , xssi_state         :: !XScreenSaverState
-- ^ The state field specified whether or not the screen saver is currently
-- active and how the til-or-since value should be interpreted:
--
-- ['ScreenSaverOff'] The  screen is not currently being saved; til-or-since
-- specifies the number of milliseconds until the screen saver is expected to
-- activate.
--
-- ['ScreenSaverOn'] The screen is currently being saved; til-or-since specifies
-- the number of milliseconds since the screen saver activated.
--
-- ['ScreenSaverDisabled'] The screen saver is currently disabled; til-or-since
-- is zero.
    , xssi_kind          :: !XScreenSaverKind
-- ^ The kind field specifies the mechanism that either is currently being used
-- or would have been were the screen being saved:
--
-- ['ScreenSaverBlanked'] The video signal to the display monitor was disabled.
--
-- ['ScreenSaverInternal'] A server-dependent, built-in screen saver image was
-- displayed; either no client had set the screen saver window attributes or a
-- different client had the server grabbed when the screen saver activated.
--
-- ['ScreenSaverExternal'] The screen saver window was mapped with attributes
-- set by a client using the ScreenSaverSetAttributes request.
    , xssi_til_or_since  :: !CULong
    , xssi_idle          :: !CULong
-- ^ The idle field specifies the number of milliseconds since the last input
-- was received from the user on any of the input devices.
    , xssi_event_mask    :: !CULong
-- ^ The event-mask field specifies which, if any, screen saver events this
-- client has requested using ScreenSaverSelectInput.
    } deriving (Show)

-- | Simple wrapper around 'xScreenSaverQueryInfo' if you are only interested in
-- the idle time, in milliseconds. Returns 0 if the XScreenSaver extension is
-- not available
getXIdleTime :: Display -> IO Int
getXIdleTime dpy =
    maybe 0 (fromIntegral . xssi_idle) `fmap` xScreenSaverQueryInfo dpy

-- We have XScreenSaver, so the library will actually work
compiledWithXScreenSaver :: Bool
compiledWithXScreenSaver = True

-- for XFree() (already included from scrnsaver.h, but I don't know if I can
-- count on that.)
#include <X11/Xlib.h>
#include <X11/extensions/scrnsaver.h>

xScreenSaverState2CInt :: XScreenSaverState -> CInt
xScreenSaverState2CInt ScreenSaverOn = #const ScreenSaverOn
xScreenSaverState2CInt ScreenSaverOff = #const ScreenSaverOff
xScreenSaverState2CInt ScreenSaverCycle = #const ScreenSaverCycle
xScreenSaverState2CInt ScreenSaverDisabled = #const ScreenSaverDisabled

cInt2XScreenSaverState :: CInt -> XScreenSaverState
cInt2XScreenSaverState (#const ScreenSaverOn) = ScreenSaverOn
cInt2XScreenSaverState (#const ScreenSaverOff) = ScreenSaverOff
cInt2XScreenSaverState (#const ScreenSaverCycle) = ScreenSaverCycle
cInt2XScreenSaverState (#const ScreenSaverDisabled) = ScreenSaverDisabled
cInt2XScreenSaverState s = error $
    "Unknown state in xScreenSaverQueryInfo for XScreenSaverState: " ++ show s

instance Storable XScreenSaverState where
    sizeOf    _ = sizeOf (undefined :: CInt)
    alignment _ = alignment (undefined :: CInt)
    poke p xsss = poke (castPtr p) (xScreenSaverState2CInt xsss)
    peek p = cInt2XScreenSaverState `fmap` peek (castPtr p)


xScreenSaverKind2CInt :: XScreenSaverKind -> CInt
xScreenSaverKind2CInt ScreenSaverBlanked = #const ScreenSaverBlanked
xScreenSaverKind2CInt ScreenSaverInternal = #const ScreenSaverInternal
xScreenSaverKind2CInt ScreenSaverExternal = #const ScreenSaverExternal

cInt2XScreenSaverKind :: CInt -> XScreenSaverKind
cInt2XScreenSaverKind (#const ScreenSaverBlanked) = ScreenSaverBlanked
cInt2XScreenSaverKind (#const ScreenSaverInternal) = ScreenSaverInternal
cInt2XScreenSaverKind (#const ScreenSaverExternal) = ScreenSaverExternal
cInt2XScreenSaverKind s = error $
    "Unknown kind in xScreenSaverQueryInfo for XScreenSaverKind: " ++ show s

instance Storable XScreenSaverKind where
    sizeOf    _ = sizeOf (undefined :: CInt)
    alignment _ = alignment (undefined :: CInt)
    poke p xsss = poke (castPtr p) (xScreenSaverKind2CInt xsss)
    peek p = cInt2XScreenSaverKind `fmap` peek (castPtr p)


instance Storable XScreenSaverInfo where
    sizeOf _ = #{size XScreenSaverInfo}
    -- FIXME: Is this right?
    alignment _ = alignment (undefined :: CInt)

    poke p xssi = do
        #{poke XScreenSaverInfo, window       } p $ xssi_window xssi
        #{poke XScreenSaverInfo, state        } p $ xssi_state xssi
        #{poke XScreenSaverInfo, kind         } p $ xssi_kind xssi
        #{poke XScreenSaverInfo, til_or_since } p $ xssi_til_or_since xssi
        #{poke XScreenSaverInfo, idle         } p $ xssi_idle xssi
        #{poke XScreenSaverInfo, eventMask    } p $ xssi_event_mask xssi

    peek p = return XScreenSaverInfo
                `ap` (#{peek XScreenSaverInfo, window} p)
                `ap` (#{peek XScreenSaverInfo, state} p)
                `ap` (#{peek XScreenSaverInfo, kind} p)
                `ap` (#{peek XScreenSaverInfo, til_or_since} p)
                `ap` (#{peek XScreenSaverInfo, idle} p)
                `ap` (#{peek XScreenSaverInfo, eventMask} p)

type XScreenSaverNotifyEvent =
    ( Window      -- screen saver window
    , Window      -- root window of event screen
    , CInt        -- State: ScreenSaver{Off,On,Cycle}
    , CInt        -- Kind:  ScreenSaver{Blanked,Internal,External}
    , Bool        -- extents of new region
    , Time        -- event timestamp
    )

pokeXScreenSaverNotifyEvent :: Ptr XScreenSaverNotifyEvent
                            -> XScreenSaverNotifyEvent -> IO ()
pokeXScreenSaverNotifyEvent p (window, root, state, kind, forced, time) = do
        #{poke XScreenSaverNotifyEvent, window     } p window
        #{poke XScreenSaverNotifyEvent, root       } p root
        #{poke XScreenSaverNotifyEvent, state      } p state
        #{poke XScreenSaverNotifyEvent, kind       } p kind
        #{poke XScreenSaverNotifyEvent, forced     } p forced
        #{poke XScreenSaverNotifyEvent, time       } p time

peekXScreenSaverNotifyEvent :: Ptr XScreenSaverNotifyEvent
                            -> IO XScreenSaverNotifyEvent
peekXScreenSaverNotifyEvent p = do
        window <- (#{peek XScreenSaverNotifyEvent, window     } p )
        root   <- (#{peek XScreenSaverNotifyEvent, root       } p )
        state  <- (#{peek XScreenSaverNotifyEvent, state      } p )
        kind   <- (#{peek XScreenSaverNotifyEvent, kind       } p )
        forced <- (#{peek XScreenSaverNotifyEvent, forced     } p )
        time   <- (#{peek XScreenSaverNotifyEvent, time       } p )
        return (window, root, state, kind, forced, time)

get_XScreenSaverNotifyEvent :: XEventPtr -> IO XScreenSaverNotifyEvent
get_XScreenSaverNotifyEvent p = peekXScreenSaverNotifyEvent (castPtr p)

xScreenSaverQueryExtension :: Display -> IO (Maybe (CInt, CInt))
xScreenSaverQueryExtension dpy = wrapPtr2 (cXScreenSaverQueryExtension dpy) go
    where go False _ _                = Nothing
          go True eventbase errorbase = Just ( fromIntegral eventbase
                                             , fromIntegral errorbase
                                             )

xScreenSaverQueryVersion :: Display -> IO (Maybe (CInt, CInt))
xScreenSaverQueryVersion dpy = wrapPtr2 (cXScreenSaverQueryVersion dpy) go
    where go False _ _        = Nothing
          go True major minor = Just (fromIntegral major, fromIntegral minor)

wrapPtr2 :: (Storable a, Storable b)
         => (Ptr a -> Ptr b -> IO c) -> (c -> a -> b -> d) -> IO d
wrapPtr2 cfun f = withPool $ \pool -> do aptr <- pooledMalloc pool
                                         bptr <- pooledMalloc pool
                                         ret <- cfun aptr bptr
                                         a <- peek aptr
                                         b <- peek bptr
                                         return (f ret a b)

-- | xScreenSaverQueryInfo returns information about the current state of the
-- screen server. If the xScreenSaver extension is not available, it returns
-- Nothing
xScreenSaverQueryInfo :: Display -> IO (Maybe XScreenSaverInfo)
xScreenSaverQueryInfo dpy = do
    p <- cXScreenSaverAllocInfo
    if p == nullPtr then return Nothing else do
    s <- cXScreenSaverQueryInfo dpy (defaultRootWindow dpy) p
    if s == 0 then return Nothing else do
    xssi <- peek p
    _ <- cXFree p
    return (Just xssi)

-- | xScreenSaverSelectInput asks that events related to the screen saver be
-- generated for this client.  If no bits are set in event-mask,  then no events
-- will be generated.
xScreenSaverSelectInput :: Display -> EventMask -> IO ()
xScreenSaverSelectInput dpy xssem = do
    p <- cXScreenSaverAllocInfo
    if p == nullPtr then return () else do
    cXScreenSaverSelectInput dpy (defaultRootWindow dpy) xssem

xScreenSaverSetAttributes :: Display
                          -> Position       -- ^ x
                          -> Position       -- ^ y
                          -> Dimension      -- ^ width
                          -> Dimension      -- ^ height
                          -> Dimension      -- ^ border width
                          -> CInt           -- ^ depth ('defaultDepthOfScreen')
                          -> WindowClass    -- ^ class
                          -> Visual         -- ^ visual ('defaultVisualOfScreen')
                          -> AttributeMask  -- ^ valuemask
                          -> Ptr SetWindowAttributes
                          -> IO ()
xScreenSaverSetAttributes dpy x y w h bw d wc v am pswa = do
    cXScreenSaverSetAttributes dpy (defaultRootWindow dpy)
                                    x y w h bw d wc v am pswa

xScreenSaverUnsetAttributes :: Display -> IO ()
xScreenSaverUnsetAttributes dpy =
    cXScreenSaverUnsetAttributes dpy (defaultRootWindow dpy)

xScreenSaverSaverRegister :: Display -> ScreenNumber -> XID -> Atom -> IO ()
xScreenSaverSaverRegister = cXScreenSaverSaverRegister

xScreenSaverUnregister :: Display -> ScreenNumber -> IO Status
xScreenSaverUnregister = cXScreenSaverUnregister


xScreenSaverGetRegistered :: Display -> ScreenNumber -> XID -> Atom -> IO Status
xScreenSaverGetRegistered = cXScreenSaverGetRegistered

xScreenSaverSuspend :: Display -> Bool -> IO ()
xScreenSaverSuspend = cXScreenSaverSuspend


foreign import ccall "XScreenSaverQueryExtension"
    cXScreenSaverQueryExtension :: Display -> Ptr CInt -> Ptr CInt -> IO Bool

foreign import ccall "XScreenSaverQueryVersion"
    cXScreenSaverQueryVersion :: Display -> Ptr CInt -> Ptr CInt -> IO Bool

foreign import ccall "XScreenSaverAllocInfo"
    cXScreenSaverAllocInfo :: IO (Ptr XScreenSaverInfo)

foreign import ccall "XScreenSaverQueryInfo"
    cXScreenSaverQueryInfo :: Display -> Drawable -> Ptr XScreenSaverInfo
                           -> IO Status

foreign import ccall "XScreenSaverSelectInput"
    cXScreenSaverSelectInput :: Display -> Drawable -> EventMask -> IO ()

foreign import ccall "XScreenSaverSetAttributes"
    cXScreenSaverSetAttributes :: Display -> Drawable -> Position -> Position
                               -> Dimension -> Dimension -> Dimension
                               -> CInt
                               -> WindowClass
                               -> Visual
                               -> AttributeMask
                               -> Ptr SetWindowAttributes
                               -> IO ()

foreign import ccall "XScreenSaverUnsetAttributes"
    cXScreenSaverUnsetAttributes :: Display -> Drawable -> IO ()

foreign import ccall "XScreenSaverRegister"
    cXScreenSaverSaverRegister :: Display -> ScreenNumber -> XID -> Atom
                               -> IO ()

foreign import ccall "XScreenSaverUnregister"
    cXScreenSaverUnregister :: Display -> ScreenNumber -> IO Status

foreign import ccall "XScreenSaverGetRegistered"
    cXScreenSaverGetRegistered :: Display -> ScreenNumber -> XID -> Atom
                               -> IO Status

foreign import ccall "XScreenSaverSuspend"
    cXScreenSaverSuspend :: Display -> Bool -> IO ()

foreign import ccall "XFree"
    cXFree :: Ptr a -> IO CInt
