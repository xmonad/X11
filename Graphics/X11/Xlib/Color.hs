-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Color
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of FFI declarations for interfacing with Xlib Colors.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Color(

        lookupColor,
        allocNamedColor,
        allocColor,
        parseColor,
        freeColors,
        storeColor,
        queryColor,
        queryColors,
        installColormap,
        uninstallColormap,
        copyColormapAndFree,
        createColormap,
        freeColormap,

        ) where

import Graphics.X11.Types
import Graphics.X11.Xlib.Types

import Foreign
import Foreign.C

----------------------------------------------------------------
-- Color and Colormaps
----------------------------------------------------------------

-- | interface to the X11 library function @XLookupColor()@.
lookupColor :: Display -> Colormap -> String -> IO (Color, Color)
lookupColor display colormap color_name =
	withCString color_name $ \c_color_name ->
	alloca $ \ exact_def_return ->
	alloca $ \ screen_def_return -> do
	throwIfZero "lookupColor" $
		xLookupColor display colormap c_color_name
			exact_def_return screen_def_return
	exact_def <- peek exact_def_return
	screen_def <- peek screen_def_return
	return (exact_def, screen_def)
foreign import ccall unsafe "HsXlib.h XLookupColor"
	xLookupColor :: Display -> Colormap -> CString ->
		Ptr Color -> Ptr Color -> IO Status

-- | interface to the X11 library function @XAllocNamedColor()@.
allocNamedColor :: Display -> Colormap -> String -> IO (Color, Color)
allocNamedColor display colormap color_name =
	withCString color_name $ \c_color_name ->
	alloca $ \ exact_def_return ->
	alloca $ \ screen_def_return -> do
	throwIfZero "allocNamedColor" $
		xAllocNamedColor display colormap c_color_name
			exact_def_return screen_def_return
	exact_def <- peek exact_def_return
	screen_def <- peek screen_def_return
	return (exact_def, screen_def)
foreign import ccall unsafe "HsXlib.h XAllocNamedColor"
	xAllocNamedColor :: Display -> Colormap -> CString ->
		Ptr Color -> Ptr Color -> IO Status

-- | interface to the X11 library function @XAllocColor()@.
allocColor :: Display -> Colormap -> Color -> IO Color
allocColor display colormap color =
	with color $ \ color_ptr -> do
	throwIfZero "allocColor" $
		xAllocColor display colormap color_ptr
	peek color_ptr
foreign import ccall unsafe "HsXlib.h XAllocColor"
	xAllocColor :: Display -> Colormap -> Ptr Color -> IO Status

-- | interface to the X11 library function @XParseColor()@.
parseColor :: Display -> Colormap -> String -> IO Color
parseColor display colormap color_spec =
	withCString color_spec $ \ spec ->
	alloca $ \ exact_def_return -> do
	throwIfZero "parseColor" $
		xParseColor display colormap spec exact_def_return
	peek exact_def_return
foreign import ccall unsafe "HsXlib.h XParseColor"
	xParseColor :: Display -> Colormap -> CString -> Ptr Color -> IO Status

-- ToDo: Can't express relationship between arg4 and res1 properly (or arg5, res2)
-- %errfun Zero XAllocColorCells :: Display -> Colormap -> Bool -> Int -> Int -> IO (ListPixel, ListPixel) using err = XAllocColorCells(arg1,arg2,arg3,arg4_size,res1,arg5_size,res2)

-- ToDo: Can't express relationship between arg4 and res1 properly
-- %errfun Zero XAllocColorPlanes :: Display -> Colormap -> Bool -> Int -> Int -> Int -> Int IO (ListPixel, Pixel, Pixel, Pixel) using err = XAllocColorPlanes(...)

-- | interface to the X11 library function @XFreeColors()@.
freeColors :: Display -> Colormap -> [Pixel] -> Pixel -> IO ()
freeColors display colormap pixels planes =
	withArray pixels $ \ pixel_array ->
	xFreeColors display colormap pixel_array (length pixels) planes
foreign import ccall unsafe "HsXlib.h XFreeColors"
	xFreeColors :: Display -> Colormap -> Ptr Pixel -> Int -> Pixel -> IO ()

-- | interface to the X11 library function @XStoreColor()@.
storeColor :: Display -> Colormap -> Color -> IO ()
storeColor display colormap color =
	with color $ \ color_ptr ->
	xStoreColor display colormap color_ptr
foreign import ccall unsafe "HsXlib.h XStoreColor"
	xStoreColor  :: Display -> Colormap -> Ptr Color -> IO ()

-- %fun XStoreColors :: Display -> Colormap -> ListColor -> IO ()
-- %code XStoreColors(arg1,arg2,arg3,arg3_size)
-- %fun XStoreNamedColor :: Display -> Colormap -> String -> Pixel -> PrimaryMask -> IO ()

-- | interface to the X11 library function @XQueryColor()@.
queryColor :: Display -> Colormap -> Color -> IO Color
queryColor display colormap color =
	with color $ \ color_ptr -> do
	xQueryColor display colormap color_ptr
	peek color_ptr
foreign import ccall unsafe "HsXlib.h XQueryColor"
	xQueryColor  :: Display -> Colormap -> Ptr Color -> IO ()

-- | interface to the X11 library function @XQueryColors()@.
queryColors :: Display -> Colormap -> [Color] -> IO [Color]
queryColors display colormap colors =
	withArrayLen colors $ \ ncolors color_array -> do
	xQueryColors display colormap color_array ncolors
	peekArray ncolors color_array
foreign import ccall unsafe "HsXlib.h XQueryColors"
	xQueryColors :: Display -> Colormap -> Ptr Color -> Int -> IO ()

-- | interface to the X11 library function @XInstallColormap()@.
foreign import ccall unsafe "HsXlib.h XInstallColormap"
	installColormap     :: Display -> Colormap -> IO ()

-- | interface to the X11 library function @XUninstallColormap()@.
foreign import ccall unsafe "HsXlib.h XUninstallColormap"
	uninstallColormap   :: Display -> Colormap -> IO ()

-- | interface to the X11 library function @XCopyColormapAndFree()@.
foreign import ccall unsafe "HsXlib.h XCopyColormapAndFree"
	copyColormapAndFree :: Display -> Colormap -> IO Colormap

-- | interface to the X11 library function @XCreateColormap()@.
foreign import ccall unsafe "HsXlib.h XCreateColormap"
	createColormap      :: Display -> Window   -> Visual -> ColormapAlloc -> IO Colormap

-- | interface to the X11 library function @XFreeColormap()@.
foreign import ccall unsafe "HsXlib.h XFreeColormap"
	freeColormap        :: Display -> Colormap -> IO ()

----------------------------------------------------------------
-- End
----------------------------------------------------------------
