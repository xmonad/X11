{-# LANGUAGE DeriveDataTypeable, ForeignFunctionInterface #-}
--------------------------------------------------------------------
-- |
-- Module    : Graphics.X11.XScreenSaver
-- Copyright : (c) Joachim Breitner
--             (c) Jochen Keil
-- License   : BSD3
--
-- Maintainer: Joachim Breitner <mail@joachim-breitner.de>
-- Stability : provisional
-- Portability: portable
--
-- Note that most functions in this module are only exported if
-- the libXScrnSaver library was available at the time of compilation.
--
--------------------------------------------------------------------
--
-- Interface to XScreenSaver API
--

#include <HsX11Config.h>

#ifdef HAVE_X11_EXTENSIONS_SCRNSAVER_H

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
import Graphics.X11.Xlib.Internal

import Control.Monad

-- | XScreenSaverState is for use in both XScreenSaverNotifyEvent and
-- XScreenSaverInfo
-- ScreenSaverCycle is not a valid value for use in XScreenSaverInfo
-- ScreenSaverDisabled will not occur in an XScreenSaverNotifyEvent
data XScreenSaverState
    -- | The  screen is not currently being saved; til-or-since specifies the
    -- number of milliseconds until the screen saver is expected to activate.
    = ScreenSaverOff
    -- | The screen is currently being saved; til-or-since specifies the number
    -- of milliseconds since the screen saver activated.
    | ScreenSaverOn
    -- | If  this  bit  is  set,  ScreenSaverNotify events are generated
    -- whenever the screen saver cycle interval passes.
    | ScreenSaverCycle
    -- | The screen saver is currently disabled; til-or-since is zero.
    | ScreenSaverDisabled
    deriving Show

-- | Data type for use in a XScreenSaverInfo struct
data XScreenSaverKind
    -- | The video signal to the display monitor was disabled.
    = ScreenSaverBlanked
    -- | A server-dependent, built-in screen saver image was displayed; either
    -- no client had set the screen saver window attributes or a different
    -- client had the server grabbed when the screen saver activated.
    | ScreenSaverInternal
    -- | The screen saver window was mapped with attributes set by a client
    -- using the ScreenSaverSetAttributes request.
    | ScreenSaverExternal
    deriving Show

-- | Representation of the XScreenSaverInfo struct.
data XScreenSaverInfo = XScreenSaverInfo
    { xssi_window        :: !Window
        -- | The state field specified whether or not the screen saver is
        -- currently active and how the til-or-since value should be interpreted
    , xssi_state         :: !XScreenSaverState
        -- | The kind field specifies the mechanism that either is currently
        -- being used or would have been were the screen being saved
    , xssi_kind          :: !XScreenSaverKind
    , xssi_til_or_since  :: !CULong
        -- | The idle field specifies the number of milliseconds since the last
        -- input was received from the user on any of the input devices.
    , xssi_idle          :: !CULong
        -- | The event-mask field specifies which, if any, screen saver events
        -- this client has requested using ScreenSaverSelectInput.
    , xssi_event_mask    :: !CULong
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
    _ <- xFree p
    return (Just xssi)

-- | xScreenSaverSelectInput asks that events related to the screen saver be
-- generated for this client.  If no bits are set in event-mask,  then no events
-- will be generated.
xScreenSaverSelectInput :: Display -> EventMask -> IO ()
xScreenSaverSelectInput dpy xssem = do
    p <- cXScreenSaverAllocInfo
    if p == nullPtr then return () else do
    cXScreenSaverSelectInput dpy (defaultRootWindow dpy) xssem

-- | XScreenSaverSetAttributes sets the attributes to be used the next  time
-- the  external  screen  saver is activated.  If another client currently
-- has the attributes set, a BadAccess error is generated and the  request
-- is ignored.
--
-- Otherwise,  the specified window attributes are checked as if they were
-- used in a core CreateWindow request whose  parent  is  the  root.   The
-- override-redirect field is ignored as it is implicitly set to True.  If
-- the window attributes result in an error according  to  the  rules  for
-- CreateWindow, the request is ignored.
--
-- Otherwise,  the  attributes are stored and will take effect on the next
-- activation that occurs when  the  server  is  not  grabbed  by  another
-- client.   Any  resources  specified for the background-pixmap or cursor
-- attributes may be freed immediately.  The server is free  to  copy  the
-- background-pixmap  or  cursor resources or to use them in place; therefore,
-- the effect of changing the contents of those resources  is  undefined.
-- If  the  specified  colormap  no longer exists when the screen
-- saver activates, the parent's colormap is used instead.  If  no  errors
-- are  generated  by  this  request,  any  previous  screen  saver window
-- attributes set by this client are released.
--
-- When the screen saver next activates and the server is not  grabbed  by
-- another  client,  the screen saver window is created, if necessary, and
-- set to the specified attributes and events are generated as usual.  The
-- colormap   associated  with  the  screen  saver  window  is  installed.
-- Finally, the screen saver window is mapped.
--
-- The window remains mapped and at the top of the  stacking  order  until
-- the  screen  saver is deactivated in response to activity on any of the
-- user input devices, a ForceScreenSaver request with a value  of  Reset,
-- or any request that would cause the window to be unmapped.
--
-- If  the  screen  saver activates while the server is grabbed by another
-- client, the internal saver mechanism  is  used.   The  ForceScreenSaver
-- request  may  be used with a value of Active to deactivate the internal
-- saver and activate the external saver.
--
-- If the screen saver client's connection to the server is  broken  while
-- the  screen saver is activated and the client's close down mode has not
-- been RetainPermanent or RetainTemporary, the current  screen  saver  is
-- deactivated and the internal screen saver is immediately activated.
--
-- When  the  screen saver deactivates, the screen saver window's colormap
-- is uninstalled and the window is unmapped (except as described  below).
-- The  screen  saver  XID is disassociated with the window and the server
-- may, but is not required to, destroy the window along  with  any  children.
--
-- When the screen saver is being deactivated and then immediately reactivated
-- (such as when switching screen savers), the server may leave  the
-- screen saver window mapped (typically to avoid generating exposures).

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

-- | XScreenSaverUnsetAttributes  instructs the server to discard any previ‐
-- ous screen saver window attributes set by this client.

xScreenSaverUnsetAttributes :: Display -> IO ()
xScreenSaverUnsetAttributes dpy =
    cXScreenSaverUnsetAttributes dpy (defaultRootWindow dpy)

-- | XScreenSaverRegister stores the given XID in the _SCREEN_SAVER_ID prop‐
-- erty  (of  the  given type) on the root window of the specified screen.
-- It returns zero if an error is encountered  and  the  property  is  not
-- changed, otherwise it returns non-zero.

xScreenSaverSaverRegister :: Display -> ScreenNumber -> XID -> Atom -> IO ()
xScreenSaverSaverRegister = cXScreenSaverSaverRegister

-- | XScreenSaverUnregister  removes any _SCREEN_SAVER_ID from the root win‐
-- dow of the specified screen.  It returns zero if an  error  is  encoun‐
-- tered and the property is changed, otherwise it returns non-zero.

xScreenSaverUnregister :: Display -> ScreenNumber -> IO Status
xScreenSaverUnregister = cXScreenSaverUnregister

-- | XScreenSaverGetRegistered  returns  the  XID  and  type  stored  in the
-- _SCREEN_SAVER_ID property on the root window of the  specified  screen.
-- It  returns zero if an error is encountered or if the property does not
-- exist or is not of the correct format; otherwise it returns non-zero.

xScreenSaverGetRegistered :: Display -> ScreenNumber -> XID -> Atom -> IO Status
xScreenSaverGetRegistered = cXScreenSaverGetRegistered

-- | XScreenSaverSuspend temporarily suspends the screensaver and DPMS timer
-- if suspend is 'True', and restarts the timer if suspend is 'False'.
-- This  function  should  be  used  by  applications  that don't want the
-- screensaver or DPMS to become activated while they're  for  example  in
-- the  process of playing a media sequence, or are otherwise continuously
-- presenting visual information to the user while  in  a  non-interactive
-- state.  This  function  is  not  intended  to  be called by an external
-- screensaver application.
--
-- If XScreenSaverSuspend is called multiple times  with  suspend  set  to
-- 'True',  it must be called an equal number of times with suspend set to
-- 'False' in order for  the  screensaver  timer  to  be  restarted.  This
-- request has no affect if a client tries to resume the screensaver with‐
-- out first having suspended it.  XScreenSaverSuspend  can  thus  not  be
-- used  by one client to resume the screensaver if it's been suspended by
-- another client.
--
-- If a client that has suspended  the  screensaver  becomes  disconnected
-- from  the  X  server,  the  screensaver  timer  will  automatically  be
-- restarted, unless it's still suspended by  another  client.  Suspending
-- the screensaver timer doesn't prevent the screensaver from being forceably
-- activated with the ForceScreenSaver request, or a DPMS  mode  from
-- being set with the DPMSForceLevel request.
--
-- XScreenSaverSuspend  also doesn't deactivate the screensaver or DPMS if
-- either is active at the time the request to suspend them is received by
-- the  X  server. But once they've been deactivated, they won't automatically
-- be activated again, until the client has canceled the suspension.

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

#else
module Graphics.X11.XScreenSaver where

compiledWithXScreenSaver :: Bool
compiledWithXScreenSaver = False
#endif
