-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Screen
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of FFI declarations for interfacing with Xlib Screens.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Screen(

        blackPixelOfScreen,
        whitePixelOfScreen,
        cellsOfScreen,
        defaultColormapOfScreen,
        defaultDepthOfScreen,
        defaultGCOfScreen,
        defaultVisualOfScreen,
        doesBackingStore,
        doesSaveUnders,
        displayOfScreen,
        eventMaskOfScreen,
        minCmapsOfScreen,
        maxCmapsOfScreen,
        rootWindowOfScreen,
        widthOfScreen,
        widthMMOfScreen,
        heightOfScreen,
        heightMMOfScreen,
        planesOfScreen,
        screenNumberOfScreen,

        ) where

import Graphics.X11.Types
import Graphics.X11.Xlib.Types

----------------------------------------------------------------
-- Screen
----------------------------------------------------------------

-- Many flags assumed to be PURE.

-- | interface to the X11 library function @XBlackPixelOfScreen()@.
foreign import ccall unsafe "HsXlib.h XBlackPixelOfScreen"
	blackPixelOfScreen      :: Screen -> Pixel

-- | interface to the X11 library function @XWhitePixelOfScreen()@.
foreign import ccall unsafe "HsXlib.h XWhitePixelOfScreen"
	whitePixelOfScreen      :: Screen -> Pixel

-- | interface to the X11 library function @XCellsOfScreen()@.
foreign import ccall unsafe "HsXlib.h XCellsOfScreen"
	cellsOfScreen           :: Screen -> Int

-- | interface to the X11 library function @XDefaultColormapOfScreen()@.
foreign import ccall unsafe "HsXlib.h XDefaultColormapOfScreen"
	defaultColormapOfScreen :: Screen -> Colormap

-- | interface to the X11 library function @XDefaultDepthOfScreen()@.
foreign import ccall unsafe "HsXlib.h XDefaultDepthOfScreen"
	defaultDepthOfScreen    :: Screen -> Int

-- | interface to the X11 library function @XDefaultGCOfScreen()@.
foreign import ccall unsafe "HsXlib.h XDefaultGCOfScreen"
	defaultGCOfScreen       :: Screen -> GC

-- | interface to the X11 library function @XDefaultVisualOfScreen()@.
foreign import ccall unsafe "HsXlib.h XDefaultVisualOfScreen"
	defaultVisualOfScreen   :: Screen -> Visual

-- | interface to the X11 library function @XDoesBackingStore()@.
foreign import ccall unsafe "HsXlib.h XDoesBackingStore"
	doesBackingStore        :: Screen -> Bool

-- | interface to the X11 library function @XDoesSaveUnders()@.
foreign import ccall unsafe "HsXlib.h XDoesSaveUnders"
	doesSaveUnders          :: Screen -> Bool

-- | interface to the X11 library function @XDisplayOfScreen()@.
foreign import ccall unsafe "HsXlib.h XDisplayOfScreen"
	displayOfScreen         :: Screen -> Display

-- | interface to the X11 library function @XEventMaskOfScreen()@.
-- Event mask at connection setup time - not current event mask!
foreign import ccall unsafe "HsXlib.h XEventMaskOfScreen"
	eventMaskOfScreen       :: Screen -> EventMask

-- | interface to the X11 library function @XMinCmapsOfScreen()@.
foreign import ccall unsafe "HsXlib.h XMinCmapsOfScreen"
	minCmapsOfScreen        :: Screen -> Int

-- | interface to the X11 library function @XMaxCmapsOfScreen()@.
foreign import ccall unsafe "HsXlib.h XMaxCmapsOfScreen"
	maxCmapsOfScreen        :: Screen -> Int

-- | interface to the X11 library function @XRootWindowOfScreen()@.
foreign import ccall unsafe "HsXlib.h XRootWindowOfScreen"
	rootWindowOfScreen      :: Screen -> Window

-- | interface to the X11 library function @XWidthOfScreen()@.
foreign import ccall unsafe "HsXlib.h XWidthOfScreen"
	widthOfScreen           :: Screen -> Dimension

-- | interface to the X11 library function @XWidthMMOfScreen()@.
foreign import ccall unsafe "HsXlib.h XWidthMMOfScreen"
	widthMMOfScreen         :: Screen -> Dimension

-- | interface to the X11 library function @XHeightOfScreen()@.
foreign import ccall unsafe "HsXlib.h XHeightOfScreen"
	heightOfScreen          :: Screen -> Dimension

-- | interface to the X11 library function @XHeightMMOfScreen()@.
foreign import ccall unsafe "HsXlib.h XHeightMMOfScreen"
	heightMMOfScreen        :: Screen -> Dimension

-- | interface to the X11 library function @XPlanesOfScreen()@.
foreign import ccall unsafe "HsXlib.h XPlanesOfScreen"
	planesOfScreen          :: Screen -> Int

-- | interface to the X11 library function @XScreenNumberOfScreen()@.
foreign import ccall unsafe "HsXlib.h XScreenNumberOfScreen"
	screenNumberOfScreen    :: Screen -> ScreenNumber

----------------------------------------------------------------
-- End
----------------------------------------------------------------
