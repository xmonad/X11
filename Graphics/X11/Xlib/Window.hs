-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Window
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of FFI declarations for interfacing with Xlib Windows.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Window(
        storeName,
        createSimpleWindow,
        createWindow,
        translateCoordinates,
        moveResizeWindow,
        resizeWindow,
        moveWindow,
        reparentWindow,
        mapSubwindows,
        unmapSubwindows,
        mapWindow,
        lowerWindow,
        raiseWindow,
        circulateSubwindowsDown,
        circulateSubwindowsUp,
        circulateSubwindows,
        iconifyWindow,
        withdrawWindow,
        destroyWindow,
        destroySubwindows,
        setWindowBorder,
        setWindowBorderPixmap,
        setWindowBorderWidth,
        setWindowBackground,
        setWindowBackgroundPixmap,
        setWindowColormap,
        addToSaveSet,
        removeFromSaveSet,
        changeSaveSet,
        clearWindow,
        clearArea,
        restackWindows,

        ) where

import Graphics.X11.Types
import Graphics.X11.Xlib.Types

import Foreign
import Foreign.C

----------------------------------------------------------------
-- Windows
----------------------------------------------------------------

-- | interface to the X11 library function @XStoreName()@.
storeName :: Display -> Window -> String -> IO ()
storeName display window name =
	withCString name $ \ c_name ->
	xStoreName display window c_name
foreign import ccall unsafe "HsXlib.h XStoreName"
	xStoreName :: Display -> Window -> CString -> IO ()

-- | interface to the X11 library function @XCreateSimpleWindow()@.
foreign import ccall unsafe "HsXlib.h XCreateSimpleWindow"
	createSimpleWindow :: Display -> Window -> Position -> Position ->
		Dimension -> Dimension -> Int -> Pixel -> Pixel -> IO Window

-- | interface to the X11 library function @XCreateWindow()@.
foreign import ccall unsafe "HsXlib.h XCreateWindow"
	createWindow :: Display -> Window -> Position -> Position ->
		Dimension -> Dimension -> Int -> Int -> WindowClass ->
		Visual -> AttributeMask -> Ptr SetWindowAttributes -> IO Window

----------------------------------------------------------------

--ToDo: find an effective way to use Maybes

-- | interface to the X11 library function @XTranslateCoordinates()@.
translateCoordinates :: Display -> Window -> Window -> Position -> Position ->
	IO (Bool,Position,Position,Window)
translateCoordinates display src_w dest_w src_x src_y =
	alloca $ \ dest_x_return ->
	alloca $ \ dest_y_return ->
	alloca $ \ child_return -> do
	res <- xTranslateCoordinates display src_w dest_w src_x src_y
			dest_x_return dest_y_return child_return
	dest_x <- peek dest_x_return
	dest_y <- peek dest_y_return
	child  <- peek child_return
	return (res, dest_x, dest_y, child)
foreign import ccall unsafe "HsXlib.h XTranslateCoordinates"
	xTranslateCoordinates :: Display -> Window -> Window ->
		Position -> Position ->
		Ptr Position -> Ptr Position -> Ptr Window -> IO Bool

-- | interface to the X11 library function @XMoveResizeWindow()@.
foreign import ccall unsafe "HsXlib.h XMoveResizeWindow"
	moveResizeWindow             :: Display -> Window -> Position  -> Position  -> Dimension -> Dimension -> IO ()

-- | interface to the X11 library function @XResizeWindow()@.
foreign import ccall unsafe "HsXlib.h XResizeWindow"
	resizeWindow                 :: Display -> Window -> Dimension -> Dimension -> IO ()

-- | interface to the X11 library function @XMoveWindow()@.
foreign import ccall unsafe "HsXlib.h XMoveWindow"
	moveWindow                   :: Display -> Window -> Position  -> Position  -> IO ()

-- | interface to the X11 library function @XReparentWindow()@.
foreign import ccall unsafe "HsXlib.h XReparentWindow"
	reparentWindow               :: Display -> Window -> Window -> Position -> Position  -> IO ()

-- | interface to the X11 library function @XMapSubwindows()@.
foreign import ccall unsafe "HsXlib.h XMapSubwindows"
	mapSubwindows                :: Display -> Window -> IO ()

-- | interface to the X11 library function @XUnmapSubwindows()@.
foreign import ccall unsafe "HsXlib.h XUnmapSubwindows"
	unmapSubwindows              :: Display -> Window -> IO ()

-- | interface to the X11 library function @XMapWindow()@.
foreign import ccall unsafe "HsXlib.h XMapWindow"
	mapWindow                    :: Display -> Window -> IO ()
-- Disnae exist: %fun XUnmapWindows                :: Display -> Window -> IO ()
-- Disnae exist: %fun XMapRaisedWindow             :: Display -> Window -> IO ()

-- | interface to the X11 library function @XLowerWindow()@.
foreign import ccall unsafe "HsXlib.h XLowerWindow"
	lowerWindow                  :: Display -> Window -> IO ()

-- | interface to the X11 library function @XRaiseWindow()@.
foreign import ccall unsafe "HsXlib.h XRaiseWindow"
	raiseWindow                  :: Display -> Window -> IO ()

-- | interface to the X11 library function @XCirculateSubwindowsDown()@.
foreign import ccall unsafe "HsXlib.h XCirculateSubwindowsDown"
	circulateSubwindowsDown      :: Display -> Window -> IO ()

-- | interface to the X11 library function @XCirculateSubwindowsUp()@.
foreign import ccall unsafe "HsXlib.h XCirculateSubwindowsUp"
	circulateSubwindowsUp        :: Display -> Window -> IO ()

-- | interface to the X11 library function @XCirculateSubwindows()@.
foreign import ccall unsafe "HsXlib.h XCirculateSubwindows"
	circulateSubwindows          :: Display -> Window -> CirculationDirection -> IO ()

-- | interface to the X11 library function @XIconifyWindow()@.
iconifyWindow  :: Display -> Window -> ScreenNumber -> IO ()
iconifyWindow display window screenno =
	throwIfZero "iconifyWindow"
		(xIconifyWindow display window screenno)
foreign import ccall unsafe "HsXlib.h XIconifyWindow"
	xIconifyWindow  :: Display -> Window -> ScreenNumber -> IO Status

-- | interface to the X11 library function @XWithdrawWindow()@.
withdrawWindow :: Display -> Window -> ScreenNumber -> IO ()
withdrawWindow display window screenno =
	throwIfZero "withdrawWindow"
		(xWithdrawWindow display window screenno)
foreign import ccall unsafe "HsXlib.h XWithdrawWindow"
	xWithdrawWindow :: Display -> Window -> ScreenNumber -> IO Status

-- | interface to the X11 library function @XDestroyWindow()@.
foreign import ccall unsafe "HsXlib.h XDestroyWindow"
	destroyWindow                :: Display -> Window -> IO ()

-- | interface to the X11 library function @XDestroySubwindows()@.
foreign import ccall unsafe "HsXlib.h XDestroySubwindows"
	destroySubwindows            :: Display -> Window -> IO ()

-- | interface to the X11 library function @XSetWindowBorder()@.
foreign import ccall unsafe "HsXlib.h XSetWindowBorder"
	setWindowBorder              :: Display -> Window -> Pixel     -> IO ()

-- | interface to the X11 library function @XSetWindowBorderPixmap()@.
foreign import ccall unsafe "HsXlib.h XSetWindowBorderPixmap"
	setWindowBorderPixmap        :: Display -> Window -> Pixmap    -> IO ()

-- | interface to the X11 library function @XSetWindowBorderWidth()@.
foreign import ccall unsafe "HsXlib.h XSetWindowBorderWidth"
	setWindowBorderWidth         :: Display -> Window -> Dimension -> IO ()

-- | interface to the X11 library function @XSetWindowBackground()@.
foreign import ccall unsafe "HsXlib.h XSetWindowBackground"
	setWindowBackground          :: Display -> Window -> Pixel     -> IO ()

-- | interface to the X11 library function @XSetWindowBackgroundPixmap()@.
foreign import ccall unsafe "HsXlib.h XSetWindowBackgroundPixmap"
	setWindowBackgroundPixmap    :: Display -> Window -> Pixmap    -> IO ()

-- | interface to the X11 library function @XSetWindowColormap()@.
foreign import ccall unsafe "HsXlib.h XSetWindowColormap"
	setWindowColormap            :: Display -> Window -> Colormap  -> IO ()

-- | interface to the X11 library function @XAddToSaveSet()@.
foreign import ccall unsafe "HsXlib.h XAddToSaveSet"
	addToSaveSet                 :: Display -> Window -> IO ()

-- | interface to the X11 library function @XRemoveFromSaveSet()@.
foreign import ccall unsafe "HsXlib.h XRemoveFromSaveSet"
	removeFromSaveSet            :: Display -> Window -> IO ()

-- | interface to the X11 library function @XChangeSaveSet()@.
foreign import ccall unsafe "HsXlib.h XChangeSaveSet"
	changeSaveSet                :: Display -> Window -> ChangeSaveSetMode -> IO ()

-- | interface to the X11 library function @XClearWindow()@.
foreign import ccall unsafe "HsXlib.h XClearWindow"
	clearWindow                  :: Display -> Window -> IO ()

-- | interface to the X11 library function @XClearArea()@.
foreign import ccall unsafe "HsXlib.h XClearArea"
	clearArea                    :: Display -> Window ->
		Position -> Position -> Dimension -> Dimension -> Bool -> IO ()

-- This is almost good enough - but doesn't call XFree
-- -- %errfun BadStatus XQueryTree :: Display -> Window -> IO (Window, Window, ListWindow) using err = XQueryTree(arg1,arg2,&res1,&res2,&res3,&res3_size)
-- %prim XQueryTree :: Display -> Window -> IO (Window, Window, ListWindow)
-- Window root_w, parent;
-- Int children_size;
-- Window *children;
-- Status r = XQueryTree(arg1,arg2,&root_w, &parent, &children, &children_size);
-- if (Success != r) { %failWith(BadStatus,r); }
-- %update(root_w,parent,children);
-- XFree(children);
-- return;

-- | interface to the X11 library function @XRestackWindows()@.
restackWindows :: Display -> [Window] -> IO ()
restackWindows display windows =
	withArray windows $ \ window_array ->
	xRestackWindows display window_array (length windows)
foreign import ccall unsafe "HsXlib.h XRestackWindows"
	xRestackWindows :: Display -> Ptr Window -> Int -> IO ()

-- ToDo: I want to be able to write this
-- -- %fun XListInstalledColormaps :: Display -> Window -> IO ListColormap using res1 = XListInstalledColormaps(arg1,arg2,&res1_size)
-- -- But I have to write this instead - need to add a notion of cleanup code!
-- %prim XListInstalledColormaps :: Display -> Window -> IO ListColormap
-- Int r_size;
-- Colormap* r = XListInstalledColormaps(arg1,arg2,&r_size);
-- %update(r);
-- XFree(r);
-- return;
--
-- -- Again, this is almost good enough
-- -- %errfun BadStatus XGetCommand :: Display -> Window -> IO ListString using err = XGetCommand(arg1,arg2,&res1,&res1_size)
-- -- but not quite
-- -- %prim XGetCommand :: Display -> Window -> IO ListString
-- --Int    argv_size;
-- --String *argv;
-- --Status r = XGetCommand(arg1,arg2,&argv,&argv_size);
-- --if (Success != r) { %failWith(BadStatus, r); }
-- -- %update(argv);
-- --XFreeStringList(argv);
-- --return;
--
-- -- %fun XSetCommand :: Display -> Window -> ListString -> IO ()            using XSetCommand(arg1,arg2,arg3,res3_size)
--
-- %errfun BadStatus XGetTransientForHint :: Display -> Window -> IO Window using err = XGetTransientForHint(arg1,arg2,&res1)
--
-- %fun XSetTransientForHint :: Display -> Window -> Window -> IO ()
--
-- -- XRotateWindowProperties omitted
-- -- XGetWindowProperty omitted
--
-- -- XGetWindowAttributes omitted
-- -- XChangeWindowAttributes omitted

----------------------------------------------------------------
-- End
----------------------------------------------------------------
