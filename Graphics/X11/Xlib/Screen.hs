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

foreign import ccall unsafe "HsXlib.h XBlackPixelOfScreen"
	blackPixelOfScreen      :: Screen -> Pixel
foreign import ccall unsafe "HsXlib.h XWhitePixelOfScreen"
	whitePixelOfScreen      :: Screen -> Pixel
foreign import ccall unsafe "HsXlib.h XCellsOfScreen"
	cellsOfScreen           :: Screen -> Int
foreign import ccall unsafe "HsXlib.h XDefaultColormapOfScreen"
	defaultColormapOfScreen :: Screen -> Colormap
foreign import ccall unsafe "HsXlib.h XDefaultDepthOfScreen"
	defaultDepthOfScreen    :: Screen -> Int
foreign import ccall unsafe "HsXlib.h XDefaultGCOfScreen"
	defaultGCOfScreen       :: Screen -> GC
foreign import ccall unsafe "HsXlib.h XDefaultVisualOfScreen"
	defaultVisualOfScreen   :: Screen -> Visual
foreign import ccall unsafe "HsXlib.h XDoesBackingStore"
	doesBackingStore        :: Screen -> Bool
foreign import ccall unsafe "HsXlib.h XDoesSaveUnders"
	doesSaveUnders          :: Screen -> Bool
foreign import ccall unsafe "HsXlib.h XDisplayOfScreen"
	displayOfScreen         :: Screen -> Display

-- event mask at connection setup time - not current event mask!
foreign import ccall unsafe "HsXlib.h XEventMaskOfScreen"
	eventMaskOfScreen       :: Screen -> EventMask

foreign import ccall unsafe "HsXlib.h XMinCmapsOfScreen"
	minCmapsOfScreen        :: Screen -> Int
foreign import ccall unsafe "HsXlib.h XMaxCmapsOfScreen"
	maxCmapsOfScreen        :: Screen -> Int
foreign import ccall unsafe "HsXlib.h XRootWindowOfScreen"
	rootWindowOfScreen      :: Screen -> Window
foreign import ccall unsafe "HsXlib.h XWidthOfScreen"
	widthOfScreen           :: Screen -> Dimension
foreign import ccall unsafe "HsXlib.h XWidthMMOfScreen"
	widthMMOfScreen         :: Screen -> Dimension
foreign import ccall unsafe "HsXlib.h XHeightOfScreen"
	heightOfScreen          :: Screen -> Dimension
foreign import ccall unsafe "HsXlib.h XHeightMMOfScreen"
	heightMMOfScreen        :: Screen -> Dimension
foreign import ccall unsafe "HsXlib.h XPlanesOfScreen"
	planesOfScreen          :: Screen -> Int
foreign import ccall unsafe "HsXlib.h XScreenNumberOfScreen"
	screenNumberOfScreen    :: Screen -> ScreenNumber

----------------------------------------------------------------
-- End
----------------------------------------------------------------
