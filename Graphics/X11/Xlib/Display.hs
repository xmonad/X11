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

-- | interface to the X11 library function @XAllPlanes()@.
foreign import ccall unsafe "HsXlib.h XAllPlanes"
	allPlanes_aux           :: Pixel

-- | interface to the X11 library function @XBlackPixel()@.
foreign import ccall unsafe "HsXlib.h XBlackPixel"
	blackPixel              :: Display -> ScreenNumber -> Pixel

-- | interface to the X11 library function @XWhitePixel()@.
foreign import ccall unsafe "HsXlib.h XWhitePixel"
	whitePixel              :: Display -> ScreenNumber -> Pixel

-- This may vary from one execution to another but I believe it
-- is constant during any given execution and so it can be made PURE
-- without breaking referential transparency.
--
-- Note: underneath the opaque name, it turns out that this
-- is the file descriptor.  You need to know this if you want to
-- use select.

-- | interface to the X11 library function @XConnectionNumber()@.
foreign import ccall unsafe "HsXlib.h XConnectionNumber"
	connectionNumber        :: Display -> Int

-- | interface to the X11 library function @XDefaultColormap()@.
foreign import ccall unsafe "HsXlib.h XDefaultColormap"
	defaultColormap         :: Display -> ScreenNumber -> Colormap

-- XListDepths :: Display -> ScreenNumber -> ListInt using res1 = XListDepths(arg1,arg2,&res1_size)

-- | interface to the X11 library function @XDefaultGC()@.
foreign import ccall unsafe "HsXlib.h XDefaultGC"
	defaultGC               :: Display -> ScreenNumber -> GC

-- | interface to the X11 library function @XDefaultDepth()@.
foreign import ccall unsafe "HsXlib.h XDefaultDepth"
	defaultDepth            :: Display -> ScreenNumber -> Int

-- | interface to the X11 library function @XDefaultScreen()@.
foreign import ccall unsafe "HsXlib.h XDefaultScreen"
	defaultScreen           :: Display -> ScreenNumber

-- | interface to the X11 library function @XDefaultScreenOfDisplay()@.
foreign import ccall unsafe "HsXlib.h XDefaultScreenOfDisplay"
	defaultScreenOfDisplay  :: Display -> Screen

-- | interface to the X11 library function @XDisplayHeight()@.
foreign import ccall unsafe "HsXlib.h XDisplayHeight"
	displayHeight           :: Display -> ScreenNumber -> Int

-- | interface to the X11 library function @XDisplayHeightMM()@.
foreign import ccall unsafe "HsXlib.h XDisplayHeightMM"
	displayHeightMM         :: Display -> ScreenNumber -> Int

-- | interface to the X11 library function @XDisplayWidth()@.
foreign import ccall unsafe "HsXlib.h XDisplayWidth"
	displayWidth            :: Display -> ScreenNumber -> Int

-- | interface to the X11 library function @XDisplayWidthMM()@.
foreign import ccall unsafe "HsXlib.h XDisplayWidthMM"
	displayWidthMM          :: Display -> ScreenNumber -> Int

-- | interface to the X11 library function @XMaxRequestSize()@.
foreign import ccall unsafe "HsXlib.h XMaxRequestSize"
	maxRequestSize          :: Display -> Int

-- | interface to the X11 library function @XDisplayMotionBufferSize()@.
foreign import ccall unsafe "HsXlib.h XDisplayMotionBufferSize"
	displayMotionBufferSize :: Display -> Int
--Disnae exist in X11R5 	XExtendedMaxRequestSize :: Display -> Int

-- | interface to the X11 library function @XResourceManagerString()@.
resourceManagerString   :: Display -> String
resourceManagerString display = xlibCString (xResourceManagerString display)
foreign import ccall unsafe "HsXlib.h XResourceManagerString"
	xResourceManagerString  :: Display -> IO CString

-- | interface to the X11 library function @XScreenResourceString()@.
screenResourceString    :: Screen   -> String
screenResourceString screen = xlibCString (xScreenResourceString screen)
foreign import ccall unsafe "HsXlib.h XScreenResourceString"
	xScreenResourceString   :: Screen   -> IO CString

-- | interface to the X11 library function @XDisplayString()@.
displayString           :: Display -> String
displayString display = xlibCString (xDisplayString display)
foreign import ccall unsafe "HsXlib.h XDisplayString"
	xDisplayString          :: Display -> IO CString

-- | interface to the X11 library function @XImageByteOrder()@.
foreign import ccall unsafe "HsXlib.h XImageByteOrder"
	imageByteOrder          :: Display -> Int

-- | interface to the X11 library function @XProtocolRevision()@.
foreign import ccall unsafe "HsXlib.h XProtocolRevision"
	protocolRevision        :: Display -> Int

-- | interface to the X11 library function @XProtocolVersion()@.
foreign import ccall unsafe "HsXlib.h XProtocolVersion"
	protocolVersion         :: Display -> Int

-- | interface to the X11 library function @XServerVendor()@.
serverVendor            :: Display -> String
serverVendor display = xlibCString (xServerVendor display)
foreign import ccall unsafe "HsXlib.h XServerVendor"
	xServerVendor           :: Display -> IO CString

--Disnae exist: 	XServerRelease          :: Display -> Int

-- | interface to the X11 library function @XScreenCount()@.
foreign import ccall unsafe "HsXlib.h XScreenCount"
	screenCount             :: Display -> Int

-- | interface to the X11 library function @XDefaultVisual()@.
foreign import ccall unsafe "HsXlib.h XDefaultVisual"
	defaultVisual           :: Display -> ScreenNumber -> Visual

-- | interface to the X11 library function @XDisplayCells()@.
foreign import ccall unsafe "HsXlib.h XDisplayCells"
	displayCells            :: Display -> ScreenNumber -> Int

-- | interface to the X11 library function @XDisplayPlanes()@.
foreign import ccall unsafe "HsXlib.h XDisplayPlanes"
	displayPlanes           :: Display -> ScreenNumber -> Int

-- | interface to the X11 library function @XScreenOfDisplay()@.
foreign import ccall unsafe "HsXlib.h XScreenOfDisplay"
	screenOfDisplay         :: Display -> ScreenNumber -> Screen

-- | interface to the X11 library function @XDefaultRootWindow()@.
foreign import ccall unsafe "HsXlib.h XDefaultRootWindow"
	defaultRootWindow       :: Display -> Window

-- The following are believed to be order dependent

-- | interface to the X11 library function @XRootWindow()@.
foreign import ccall unsafe "HsXlib.h XRootWindow"
	rootWindow    	        :: Display -> ScreenNumber -> IO Window

-- | interface to the X11 library function @XQLength()@.
foreign import ccall unsafe "HsXlib.h XQLength"
	qLength       	        :: Display -> IO Int

-- | interface to the X11 library function @XNoOp()@.
foreign import ccall unsafe "HsXlib.h XNoOp"
	noOp          	        :: Display -> IO ()

-- | interface to the X11 library function @XOpenDisplay()@.
openDisplay :: String -> IO Display
openDisplay name =
	withCString name $ \ c_name -> do
	display <- throwIfNull "openDisplay" (xOpenDisplay c_name)
	return (Display display)
foreign import ccall unsafe "HsXlib.h XOpenDisplay"
	xOpenDisplay :: CString -> IO (Ptr Display)

-- | interface to the X11 library function @XCloseDisplay()@.
foreign import ccall unsafe "HsXlib.h XCloseDisplay"
	closeDisplay            :: Display -> IO ()

-- | convert a CString owned by Xlib to a Haskell String
xlibCString :: IO CString -> String
xlibCString act = unsafePerformIO $ do
	cs <- act
	peekCString cs

----------------------------------------------------------------
-- End
----------------------------------------------------------------
