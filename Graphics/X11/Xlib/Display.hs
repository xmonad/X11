-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Display
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of FFI declarations for interfacing with Xlib Displays.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Display(

        allPlanes_aux,
        blackPixel,
        whitePixel,
        connectionNumber,
        defaultColormap,
        defaultGC,
        defaultDepth,
        defaultScreen,
        defaultScreenOfDisplay,
        displayHeight,
        displayHeightMM,
        displayWidth,
        displayWidthMM,
        maxRequestSize,
        displayMotionBufferSize,
        resourceManagerString,
        screenResourceString,
        displayString,
        imageByteOrder,
        protocolRevision,
        protocolVersion,
        serverVendor,
        screenCount,
        defaultVisual,
        displayCells,
        displayPlanes,
        screenOfDisplay,
        defaultRootWindow,
        rootWindow,
        qLength,
        noOp,
        openDisplay,
        closeDisplay,

        ) where

import Graphics.X11.Types
import Graphics.X11.Xlib.Types

import Foreign
import Foreign.C

----------------------------------------------------------------
-- Display
----------------------------------------------------------------

foreign import ccall unsafe "HsXlib.h XAllPlanes"
	allPlanes_aux           :: Pixel
foreign import ccall unsafe "HsXlib.h XBlackPixel"
	blackPixel              :: Display -> ScreenNumber -> Pixel
foreign import ccall unsafe "HsXlib.h XWhitePixel"
	whitePixel              :: Display -> ScreenNumber -> Pixel

-- This may vary from one execution to another but I believe it
-- is constant during any given execution and so it can be made PURE
-- without breaking referential transparency.
--
-- Note: underneath the opaque name, it turns out that this
-- is the file descriptor.  You need to know this if you want to
-- use select.
foreign import ccall unsafe "HsXlib.h XConnectionNumber"
	connectionNumber        :: Display -> Int

foreign import ccall unsafe "HsXlib.h XDefaultColormap"
	defaultColormap         :: Display -> ScreenNumber -> Colormap

-- 	XListDepths :: Display -> ScreenNumber -> ListInt using res1 = XListDepths(arg1,arg2,&res1_size)

foreign import ccall unsafe "HsXlib.h XDefaultGC"
	defaultGC               :: Display -> ScreenNumber -> GC
foreign import ccall unsafe "HsXlib.h XDefaultDepth"
	defaultDepth            :: Display -> ScreenNumber -> Int
foreign import ccall unsafe "HsXlib.h XDefaultScreen"
	defaultScreen           :: Display -> ScreenNumber
foreign import ccall unsafe "HsXlib.h XDefaultScreenOfDisplay"
	defaultScreenOfDisplay  :: Display -> Screen
foreign import ccall unsafe "HsXlib.h XDisplayHeight"
	displayHeight           :: Display -> ScreenNumber -> Int
foreign import ccall unsafe "HsXlib.h XDisplayHeightMM"
	displayHeightMM         :: Display -> ScreenNumber -> Int
foreign import ccall unsafe "HsXlib.h XDisplayWidth"
	displayWidth            :: Display -> ScreenNumber -> Int
foreign import ccall unsafe "HsXlib.h XDisplayWidthMM"
	displayWidthMM          :: Display -> ScreenNumber -> Int
foreign import ccall unsafe "HsXlib.h XMaxRequestSize"
	maxRequestSize          :: Display -> Int
foreign import ccall unsafe "HsXlib.h XDisplayMotionBufferSize"
	displayMotionBufferSize :: Display -> Int
--Disnae exist in X11R5 	XExtendedMaxRequestSize :: Display -> Int

resourceManagerString   :: Display -> String
resourceManagerString display = xlibCString (xResourceManagerString display)
foreign import ccall unsafe "HsXlib.h XResourceManagerString"
	xResourceManagerString  :: Display -> IO CString

screenResourceString    :: Screen   -> String
screenResourceString screen = xlibCString (xScreenResourceString screen)
foreign import ccall unsafe "HsXlib.h XScreenResourceString"
	xScreenResourceString   :: Screen   -> IO CString

displayString           :: Display -> String
displayString display = xlibCString (xDisplayString display)
foreign import ccall unsafe "HsXlib.h DisplayString"
	xDisplayString          :: Display -> IO CString

foreign import ccall unsafe "HsXlib.h ImageByteOrder"
	imageByteOrder          :: Display -> Int
foreign import ccall unsafe "HsXlib.h ProtocolRevision"
	protocolRevision        :: Display -> Int
foreign import ccall unsafe "HsXlib.h ProtocolVersion"
	protocolVersion         :: Display -> Int

serverVendor            :: Display -> String
serverVendor display = xlibCString (xServerVendor display)
foreign import ccall unsafe "HsXlib.h ServerVendor"
	xServerVendor           :: Display -> IO CString

--Disnae exist: 	XServerRelease          :: Display -> Int
foreign import ccall unsafe "HsXlib.h ScreenCount"
	screenCount             :: Display -> Int
foreign import ccall unsafe "HsXlib.h DefaultVisual"
	defaultVisual           :: Display -> ScreenNumber -> Visual
foreign import ccall unsafe "HsXlib.h DisplayCells"
	displayCells            :: Display -> ScreenNumber -> Int
foreign import ccall unsafe "HsXlib.h DisplayPlanes"
	displayPlanes           :: Display -> ScreenNumber -> Int
foreign import ccall unsafe "HsXlib.h ScreenOfDisplay"
	screenOfDisplay         :: Display -> ScreenNumber -> Screen
foreign import ccall unsafe "HsXlib.h DefaultRootWindow"
	defaultRootWindow       :: Display -> Window

-- The following are believed to be order dependent

foreign import ccall unsafe "HsXlib.h XRootWindow"
	rootWindow    	        :: Display -> ScreenNumber -> IO Window
foreign import ccall unsafe "HsXlib.h XQLength"
	qLength       	        :: Display -> IO Int

foreign import ccall unsafe "HsXlib.h XNoOp"
	noOp          	        :: Display -> IO ()

openDisplay :: String -> IO Display
openDisplay name =
	withCString name $ \ c_name -> do
	display <- throwIfNull "openDisplay" (xOpenDisplay c_name)
	return (Display display)
foreign import ccall unsafe "HsXlib.h XOpenDisplay"
	xOpenDisplay :: CString -> IO (Ptr Display)

foreign import ccall unsafe "HsXlib.h XCloseDisplay"
	closeDisplay            :: Display -> IO ()

-- convert a CString owned by Xlib to a Haskell String
xlibCString :: IO CString -> String
xlibCString act = unsafePerformIO $ do
	cs <- act
	peekCString cs

----------------------------------------------------------------
-- End
----------------------------------------------------------------
