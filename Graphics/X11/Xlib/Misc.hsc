{-# OPTIONS_GHC -fglasgow-exts #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Misc
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of FFI declarations for interfacing with Xlib.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Misc(

        rmInitialize,
        autoRepeatOff,
        autoRepeatOn,
        bell,
        setCloseDownMode,
        lastKnownRequestProcessed,
        getInputFocus,
        setInputFocus,
        grabButton,
        ungrabButton,
        grabPointer,
        ungrabPointer,
        grabKey,
        ungrabKey,
        grabKeyboard,
        ungrabKeyboard,
        grabServer,
        ungrabServer,
        queryBestTile,
        queryBestStipple,
        queryBestCursor,
        queryBestSize,
        queryPointer,

	-- * Error reporting
        displayName,
        setDefaultErrorHandler,

	-- * Geometry
        geometry,
        getGeometry,

	-- * Locale
        supportsLocale,
        setLocaleModifiers,

	-- * Screen saver
        AllowExposuresMode,
        dontAllowExposures,
        allowExposures,
        defaultExposures,
        PreferBlankingMode,
        dontPreferBlanking,
        preferBlanking,
        defaultBlanking,
        ScreenSaverMode,
        screenSaverActive,
        screenSaverReset,
        getScreenSaver,
        setScreenSaver,
        activateScreenSaver,
        resetScreenSaver,
        forceScreenSaver,

	-- * Pointer
        getPointerControl,
        warpPointer,

	-- * Pixmaps
        createPixmap,
        freePixmap,
        bitmapBitOrder,
        bitmapUnit,
        bitmapPad,

	-- * Keycodes
        displayKeycodes,
        lookupKeysym,
        keycodeToKeysym,
        keysymToKeycode,
        keysymToString,
        stringToKeysym,
        noSymbol,
        lookupString,

	-- * Icons
        getIconName,
        setIconName,

	-- * Cursors
        defineCursor,
        undefineCursor,
        createPixmapCursor,
        createGlyphCursor,
        createFontCursor,
        freeCursor,
        recolorCursor,

	-- * Window manager stuff
        setWMProtocols,

	-- * Set window attributes
        allocaSetWindowAttributes,
        set_background_pixmap,
        set_background_pixel,
        set_border_pixmap,
        set_border_pixel,
        set_bit_gravity,
        set_win_gravity,
        set_backing_store,
        set_backing_planes,
        set_backing_pixel,
        set_save_under,
        set_event_mask,
        set_do_not_propagate_mask,
        set_override_redirect,
        set_colormap,
        set_cursor,

	-- * Drawing
        drawPoint,
        drawPoints,
        drawLine,
        drawLines,
        drawSegments,
        drawRectangle,
        drawRectangles,
        drawArc,
        drawArcs,
        fillRectangle,
        fillRectangles,
        fillPolygon,
        fillArc,
        fillArcs,
        copyArea,
        copyPlane,
        drawString,
        drawImageString,

	-- * Cut and paste buffers
        storeBuffer,
        storeBytes,
        fetchBuffer,
        fetchBytes,
        rotateBuffers,

	-- * Window properties
        setTextProperty,

        ) where

import Graphics.X11.Types
import Graphics.X11.Xlib.Types
import Graphics.X11.Xlib.Atom
import Graphics.X11.Xlib.Event
import Graphics.X11.Xlib.Font

import Foreign
import Foreign.C

#if __GLASGOW_HASKELL__
import Data.Generics
#endif

#include "HsXlib.h"

-- I'm not sure why I added this since I don't have any of the related
-- functions.

-- | interface to the X11 library function @XrmInitialize()@.
foreign import ccall unsafe "HsXlib.h XrmInitialize"
	rmInitialize :: IO ()

-- %fun XGetDefault :: Display -> String -> String -> IO ()

-- | interface to the X11 library function @XAutoRepeatOff()@.
foreign import ccall unsafe "HsXlib.h XAutoRepeatOff"
	autoRepeatOff    :: Display -> IO ()

-- | interface to the X11 library function @XAutoRepeatOn()@.
foreign import ccall unsafe "HsXlib.h XAutoRepeatOn"
	autoRepeatOn     :: Display -> IO ()

-- | interface to the X11 library function @XBell()@.
foreign import ccall unsafe "HsXlib.h XBell"
	bell             :: Display -> Int -> IO ()

-- | interface to the X11 library function @XSetCloseDownMode()@.
foreign import ccall unsafe "HsXlib.h XSetCloseDownMode"
	setCloseDownMode :: Display -> CloseDownMode -> IO ()

-- | interface to the X11 library function @XLastKnownRequestProcessed()@.
foreign import ccall unsafe "HsXlib.h XLastKnownRequestProcessed"
	lastKnownRequestProcessed :: Display -> IO Int

-- | interface to the X11 library function @XGetInputFocus()@.
getInputFocus :: Display -> IO (Window, FocusMode)
getInputFocus display =
	alloca $ \ focus_return ->
	alloca $ \ revert_to_return -> do
	xGetInputFocus display focus_return revert_to_return
	focus <- peek focus_return
	revert_to <- peek revert_to_return
	return (focus, revert_to)
foreign import ccall unsafe "HsXlib.h XGetInputFocus"
	xGetInputFocus :: Display -> Ptr Window -> Ptr FocusMode -> IO ()

-- | interface to the X11 library function @XSetInputFocus()@.
foreign import ccall unsafe "HsXlib.h XSetInputFocus"
	setInputFocus   :: Display -> Window -> FocusMode -> Time -> IO ()

-- XAllocID omitted
-- XKillClient omitted
-- XFetchName omitted
-- XGetKeyboardControl omitted
-- XChangeKeyboardControl omitted
-- XChangeKeyboardMapping omitted
-- XChangePointerControl omitted

-- | interface to the X11 library function @XGrabButton()@.
foreign import ccall unsafe "HsXlib.h XGrabButton"
	grabButton     :: Display -> Button -> ButtonMask -> Window -> Bool -> EventMask -> GrabMode -> GrabMode -> Window -> Cursor -> IO ()

-- | interface to the X11 library function @XUngrabButton()@.
foreign import ccall unsafe "HsXlib.h XUngrabButton"
	ungrabButton   :: Display -> Button -> ButtonMask -> Window -> IO ()

-- | interface to the X11 library function @XGrabPointer()@.
foreign import ccall unsafe "HsXlib.h XGrabPointer"
	grabPointer    :: Display -> Window -> Bool -> EventMask -> GrabMode -> GrabMode -> Window -> Cursor -> Time -> IO GrabStatus

-- | interface to the X11 library function @XUngrabPointer()@.
foreign import ccall unsafe "HsXlib.h XUngrabPointer"
	ungrabPointer  :: Display -> Time -> IO ()

-- | interface to the X11 library function @XGrabKey()@.
foreign import ccall unsafe "HsXlib.h XGrabKey"
	grabKey        :: Display -> KeyCode -> ButtonMask -> Window -> Bool -> GrabMode -> GrabMode -> IO ()

-- | interface to the X11 library function @XUngrabKey()@.
foreign import ccall unsafe "HsXlib.h XUngrabKey"
	ungrabKey      :: Display -> KeyCode -> ButtonMask -> Window -> IO ()

-- | interface to the X11 library function @XGrabKeyboard()@.
foreign import ccall unsafe "HsXlib.h XGrabKeyboard"
	grabKeyboard   :: Display -> Window -> Bool -> GrabMode -> GrabMode -> Time -> IO GrabStatus

-- | interface to the X11 library function @XUngrabKeyboard()@.
foreign import ccall unsafe "HsXlib.h XUngrabKeyboard"
	ungrabKeyboard :: Display -> Time -> IO ()

-- | interface to the X11 library function @XGrabServer()@.
foreign import ccall unsafe "HsXlib.h XGrabServer"
	grabServer   :: Display -> IO ()

-- | interface to the X11 library function @XUngrabServer()@.
foreign import ccall unsafe "HsXlib.h XUngrabServer"
	ungrabServer :: Display -> IO ()

-- XChangeActivePointerGrab omitted

-- | interface to the X11 library function @XFree()@.
foreign import ccall unsafe "HsXlib.h XFree" xFree :: Ptr a -> IO ()

-- XFreeStringList omitted

-- | interface to the X11 library function @XQueryBestTile()@.
queryBestTile    :: Display -> Drawable -> Dimension -> Dimension ->
			IO (Dimension, Dimension)
queryBestTile display which_screen width height =
	outParameters2 (throwIfZero "queryBestTile") $
		xQueryBestTile display which_screen width height
foreign import ccall unsafe "HsXlib.h XQueryBestTile"
	xQueryBestTile    :: Display -> Drawable -> Dimension -> Dimension ->
				Ptr Dimension -> Ptr Dimension -> IO Status

-- | interface to the X11 library function @XQueryBestStipple()@.
queryBestStipple :: Display -> Drawable -> Dimension -> Dimension ->
			IO (Dimension, Dimension)
queryBestStipple display which_screen width height =
	outParameters2 (throwIfZero "queryBestStipple") $
		xQueryBestStipple display which_screen width height
foreign import ccall unsafe "HsXlib.h XQueryBestStipple"
	xQueryBestStipple :: Display -> Drawable -> Dimension -> Dimension ->
				Ptr Dimension -> Ptr Dimension -> IO Status

-- | interface to the X11 library function @XQueryBestCursor()@.
queryBestCursor  :: Display -> Drawable -> Dimension -> Dimension ->
			IO (Dimension, Dimension)
queryBestCursor display d width height =
	outParameters2 (throwIfZero "queryBestCursor") $
		xQueryBestCursor display d width height
foreign import ccall unsafe "HsXlib.h XQueryBestCursor"
	xQueryBestCursor  :: Display -> Drawable -> Dimension -> Dimension ->
				Ptr Dimension -> Ptr Dimension -> IO Status

-- | interface to the X11 library function @XQueryBestSize()@.
queryBestSize    :: Display -> QueryBestSizeClass -> Drawable ->
			Dimension -> Dimension -> IO (Dimension, Dimension)
queryBestSize display shape_class which_screen width height =
	outParameters2 (throwIfZero "queryBestSize") $
		xQueryBestSize display shape_class which_screen width height
foreign import ccall unsafe "HsXlib.h XQueryBestSize"
	xQueryBestSize    :: Display -> QueryBestSizeClass -> Drawable ->
				Dimension -> Dimension ->
				Ptr Dimension -> Ptr Dimension -> IO Status

-- Note: Returns false if pointer not in window w (and win_x = win_y = 0)
-- ToDo: more effective use of Maybes?

-- | interface to the X11 library function @XQueryPointer()@.
queryPointer :: Display -> Window ->
		IO (Bool, Window, Window, Int, Int, Int, Int, Modifier)
queryPointer display w =
	alloca $ \ root_return ->
	alloca $ \ child_return ->
	alloca $ \ root_x_return ->
	alloca $ \ root_y_return ->
	alloca $ \ win_x_return ->
	alloca $ \ win_y_return ->
	alloca $ \ mask_return -> do
	rel <- xQueryPointer display w root_return child_return root_x_return
		root_y_return win_x_return win_y_return mask_return
	root <- peek root_return
	child <- peek child_return
	root_x <- peek root_x_return
	root_y <- peek root_y_return
	win_x <- peek win_x_return
	win_y <- peek win_y_return
	mask <- peek mask_return
	return (rel, root, child, root_x, root_y, win_x, win_y, mask)
foreign import ccall unsafe "HsXlib.h XQueryPointer"
	xQueryPointer :: Display -> Window ->
		Ptr Window -> Ptr Window -> Ptr Int -> Ptr Int ->
		Ptr Int -> Ptr Int -> Ptr Modifier -> IO Bool

-- XSetSelectionOwner omitted

-- XOpenOM omitted
-- XCloseOM omitted
-- XSetOMValues omitted
-- XGetOMValues omitted
-- DisplayOfOM omitted
-- XLocaleOfOM omitted

-- XCreateOC omitted
-- XDestroyOC omitted
-- XOMOfOC omitted
-- XSetOCValues omitted
-- XGetOCValues omitted

-- XVaCreateNestedList omitted

----------------------------------------------------------------
-- Error reporting
----------------------------------------------------------------

-- | interface to the X11 library function @XDisplayName()@.
displayName :: String -> String
displayName str = unsafePerformIO $
	withCString str $ \ c_str -> do
	c_name <- xDisplayName c_str
	peekCString c_name
foreign import ccall unsafe "HsXlib.h XDisplayName"
	xDisplayName :: CString -> IO CString

-- type ErrorHandler   = Display -> ErrorEvent -> IO Int
-- %dis errorHandler x = (stable x)
--
-- type IOErrorHandler = Display ->                IO Int
-- %dis ioErrorHandler x = (stable x)

-- Sadly, this code doesn't work because hugs->runIO creates a fresh
-- stack of exception handlers so the exception gets thrown to the
-- wrong place.
--
-- %C
-- % static HugsStablePtr ioErrorHandlerPtr;
-- %
-- % int genericIOErrorHandler(Display *d)
-- % {
-- %     if (ioErrorHandlerPtr >= 0) {
-- %     	  hugs->putStablePtr(ioErrorHandlerPtr);
-- %     	  hugs->putAddr(d);
-- %     	  if (hugs->runIO(1)) { /* exitWith value returned */
-- %     	   return hugs->getInt();
-- %     	  } else {
-- %     	   return hugs->getWord();
-- %     	  }
-- %     }
-- %     return 1;
-- % }

-- Here's what we might do instead.  The two error handlers set flags
-- when they fire and every single call to X contains the line:
--
--   %fail { errorFlags != 0 } { XError(errorFlags) }
--
-- This really sucks.
-- Oh, and it won't even work with IOErrors since they terminate
-- the process if the handler returns.  I don't know what the hell they
-- think they're doing taking it upon themselves to terminate MY
-- process when THEIR library has a problem but I don't think anyone
-- ever accused X of being well-designed.
--
-- % static int genericIOErrorHandler(Display *d)
-- % {
-- %     if (ioErrorHandlerPtr >= 0) {
-- %     	  hugs->putStablePtr(ioErrorHandlerPtr);
-- %     	  hugs->putAddr(d);
-- %     	  if (hugs->runIO(1)) { /* exitWith value returned */
-- %     	   return hugs->getInt();
-- %     	  } else {
-- %     	   return hugs->getWord();
-- %     	  }
-- %     }
-- %     return 1;
-- % }

-- HN 2001-02-06
-- Moved to auxiliaries.c to make it easier to use the inlining option.
-- -- Sigh, for now we just use an error handler that prints an error
-- -- message on the screen
-- %C
-- % static int defaultErrorHandler(Display *d, XErrorEvent *ev)
-- % {
-- % 	  char buffer[1000];
-- % 	  XGetErrorText(d,ev->error_code,buffer,1000);
-- % 	  printf("Error: %s\n", buffer);
-- % 	  return 0;
-- % }

{-# CFILES cbits/auxiliaries.c #-}

newtype XErrorEvent = XErrorEvent (Ptr XErrorEvent)
#if __GLASGOW_HASKELL__
	deriving (Eq, Ord, Show, Typeable, Data)
#else
	deriving (Eq, Ord, Show)
#endif

type ErrorHandler = FunPtr (Display -> Ptr XErrorEvent -> IO Int)

foreign import ccall unsafe "HsXlib.h &defaultErrorHandler"
	defaultErrorHandler :: FunPtr (Display -> Ptr XErrorEvent -> IO Int)

-- | The Xlib library reports most errors by invoking a user-provided
-- error handler.  This function installs an error handler that prints a
-- textual representation of the error.
setDefaultErrorHandler :: IO ()
setDefaultErrorHandler = do
	xSetErrorHandler defaultErrorHandler
	return ()

-- %fun XSetIOErrorHandler :: IOErrorHandler -> IO IOErrorHandler

foreign import ccall unsafe "HsXlib.h XSetErrorHandler"
	xSetErrorHandler   :: ErrorHandler   -> IO ErrorHandler

-- XGetErrorDatabaseText omitted
-- XGetErrorText omitted

----------------------------------------------------------------
-- -- Buffers
-- ----------------------------------------------------------------
--
-- -- OLD: Would arrays be more appropriate?
-- --
-- -- IMPURE void	XStoreBytes(display, bytes, nbytes)
-- -- IN Display*		display
-- -- VAR Int			nbytes
-- -- IN list[nbytes] Byte	bytes
-- --
-- -- IMPURE list[nbytes] Byte	XFetchBytes(display, &nbytes)
-- -- IN Display*	display
-- -- VAR Int		nbytes
-- --
-- -- IMPURE void	XStoreBuffer(display, bytes, nbytes, buffer)
-- -- IN Display*		display
-- -- VAR Int			nbytes
-- -- IN list[nbytes] Byte	bytes
-- -- IN Buffer		buffer
-- --
-- -- IMPURE list[nbytes] Byte	XFetchBuffer(display, &nbytes, buffer)
-- -- IN Display*	display
-- -- VAR Int		nbytes
-- -- IN Buffer	buffer
-- --
-- -- IMPURE void	XRotateBuffers(display, rotate)
-- -- IN Display*	display
-- -- VAR Int		rotate

----------------------------------------------------------------
-- Extensions
----------------------------------------------------------------

-- ToDo: Use XFreeExtensionList
-- %fun XListExtensions :: Display -> IO ListString using res1 = XListExtensions(arg1,&res1_size)

-- %errfun False XQueryExtension :: Display -> String -> IO (Int,Int,Int) using res4 = XQueryExtension(arg1,arg2,&res1,&res2,&res3)->(res1,res2,res3)
-- %fun XInitExtensions :: Display -> String -> IO XExtCodes
-- %fun XAddExtensions  :: Display ->           IO XExtCodes

-- XAddToExtensionList omitted
-- XFindOnExtensionList omitted
-- XEHeadOfExtensionList omitted

----------------------------------------------------------------
-- Hosts
----------------------------------------------------------------

-- ToDo: operations to construct and destruct an XHostAddress

-- %fun XAddHost :: Display -> XHostAddress -> IO ()
-- %fun XRemoveHost :: Display -> XHostAddress -> IO ()
--
-- %fun XAddHosts    :: Display -> ListXHostAddress -> IO () using XAddHosts(arg1,arg2,arg2_size)
-- %fun XRemoveHosts :: Display -> ListXHostAddress -> IO () using XRemoveHosts(arg1,arg2,arg2_size)
--
-- -- Uses %prim to let us call XFree
-- %prim XListHosts :: Display -> IO (ListXHostAddress, Bool)
-- Bool state;
-- Int r_size;
-- XHostAddress* r = XListHosts(arg1,&r_size,&state);
-- %update(r,state);
-- XFree(r);
-- return;

-- %fun XEnableAccessControl  :: Display -> IO ()
-- %fun XDisableAccessControl :: Display -> IO ()
-- %fun XSetAccessControl     :: Display -> Access -> IO ()

----------------------------------------------------------------
-- Geometry
----------------------------------------------------------------

-- | interface to the X11 library function @XGeometry()@.
geometry :: Display -> Int -> String -> String ->
		Dimension -> Dimension -> Dimension -> Int -> Int ->
		IO (Int, Position, Position, Dimension, Dimension)
geometry display screen position default_position
		bwidth fwidth fheight xadder yadder =
	withCString position $ \ c_position ->
	withCString default_position $ \ c_default_position ->
	alloca $ \ x_return ->
	alloca $ \ y_return ->
	alloca $ \ width_return ->
	alloca $ \ height_return -> do
	res <- xGeometry display screen c_position c_default_position
		bwidth fwidth fheight xadder yadder
		x_return y_return width_return height_return
	x <- peek x_return
	y <- peek y_return
	width <- peek width_return
	height <- peek height_return
	return (res, x, y, width, height)
foreign import ccall unsafe "HsXlib.h XGeometry"
	xGeometry :: Display -> Int -> CString -> CString ->
		Dimension -> Dimension -> Dimension -> Int -> Int ->
		Ptr Position -> Ptr Position ->
		Ptr Dimension -> Ptr Dimension -> IO Int

-- | interface to the X11 library function @XGetGeometry()@.
getGeometry :: Display -> Drawable ->
	IO (Window, Position, Position, Dimension, Dimension, Dimension, Int)
getGeometry display d =
	outParameters7 (throwIfZero "getGeometry") $
		xGetGeometry display d
foreign import ccall unsafe "HsXlib.h XGetGeometry"
	xGetGeometry :: Display -> Drawable ->
		Ptr Window -> Ptr Position -> Ptr Position -> Ptr Dimension ->
		Ptr Dimension -> Ptr Dimension -> Ptr Int -> IO Status

-- XParseGeometry omitted (returned bitset too weird)

----------------------------------------------------------------
-- Locale
----------------------------------------------------------------

-- | interface to the X11 library function @XSupportsLocale()@.
foreign import ccall unsafe "HsXlib.h XSupportsLocale"
	supportsLocale :: IO Bool

-- | interface to the X11 library function @XSetLocaleModifiers()@.
setLocaleModifiers :: String -> IO String
setLocaleModifiers mods =
	withCString mods $ \ modifier_list -> do
	c_str <- xSetLocaleModifiers modifier_list
	peekCString c_str
foreign import ccall unsafe "HsXlib.h XSetLocaleModifiers"
	xSetLocaleModifiers :: CString -> IO CString

----------------------------------------------------------------
-- Screen Saver
----------------------------------------------------------------

type AllowExposuresMode = Int
#{enum AllowExposuresMode,
 , dontAllowExposures	= DontAllowExposures
 , allowExposures	= AllowExposures
 , defaultExposures	= DefaultExposures
 }

type PreferBlankingMode = Int
#{enum PreferBlankingMode,
 , dontPreferBlanking	= DontPreferBlanking
 , preferBlanking	= PreferBlanking
 , defaultBlanking	= DefaultBlanking
 }

type ScreenSaverMode = Int
#{enum ScreenSaverMode,
 , screenSaverActive	= ScreenSaverActive
 , screenSaverReset	= ScreenSaverReset
 }

getScreenSaver :: Display ->
	IO (Int, Int, PreferBlankingMode, AllowExposuresMode)
getScreenSaver display = outParameters4 id (xGetScreenSaver display)
foreign import ccall unsafe "HsXlib.h XGetScreenSaver"
	xGetScreenSaver :: Display -> Ptr Int -> Ptr Int ->
		Ptr PreferBlankingMode -> Ptr AllowExposuresMode -> IO ()

-- | interface to the X11 library function @XSetScreenSaver()@.
foreign import ccall unsafe "HsXlib.h XSetScreenSaver"
	setScreenSaver      :: Display -> Int -> Int ->
		PreferBlankingMode -> AllowExposuresMode -> IO ()

-- | interface to the X11 library function @XActivateScreenSaver()@.
foreign import ccall unsafe "HsXlib.h XActivateScreenSaver"
	activateScreenSaver :: Display -> IO ()

-- | interface to the X11 library function @XResetScreenSaver()@.
foreign import ccall unsafe "HsXlib.h XResetScreenSaver"
	resetScreenSaver    :: Display -> IO ()

-- | interface to the X11 library function @XForceScreenSaver()@.
foreign import ccall unsafe "HsXlib.h XForceScreenSaver"
	forceScreenSaver    :: Display -> ScreenSaverMode -> IO ()

----------------------------------------------------------------
-- Pointer
----------------------------------------------------------------

-- | interface to the X11 library function @XGetPointerControl()@.
getPointerControl :: Display -> IO (Int, Int, Int)
getPointerControl display = outParameters3 id (xGetPointerControl display)
foreign import ccall unsafe "HsXlib.h XGetPointerControl"
	xGetPointerControl :: Display -> Ptr Int -> Ptr Int -> Ptr Int -> IO ()

-- | interface to the X11 library function @XWarpPointer()@.
foreign import ccall unsafe "HsXlib.h XWarpPointer"
	warpPointer :: Display -> Window -> Window -> Position -> Position ->
		Dimension -> Dimension -> Position -> Position -> IO ()

-- XGetPointerMapping omitted
-- XSetPointerMapping omitted

----------------------------------------------------------------
-- Visuals
----------------------------------------------------------------

-- XVisualIDFromVisual omitted

----------------------------------------------------------------
-- Threads
----------------------------------------------------------------

-- XInitThreads omitted (leary of thread stuff)
-- XLockDisplay omitted (leary of thread stuff)
-- XUnlockDisplay omitted (leary of thread stuff)

----------------------------------------------------------------
-- Pixmaps
----------------------------------------------------------------

-- | interface to the X11 library function @XCreatePixmap()@.
foreign import ccall unsafe "HsXlib.h XCreatePixmap"
	createPixmap :: Display -> Drawable -> Dimension -> Dimension -> Int -> IO Pixmap

-- | interface to the X11 library function @XFreePixmap()@.
foreign import ccall unsafe "HsXlib.h XFreePixmap"
	freePixmap :: Display -> Pixmap -> IO ()

-- XCreatePixmapFromBitmapData omitted (type looks strange)

-- %fun XListPixmapFormatValues = res1 = XListPixmapFormatValues(display, &res1_size) :: Display -> ListXPixmapFormatValues

----------------------------------------------------------------
-- Bitmaps
----------------------------------------------------------------

-- ToDo: do these need to be available to the programmer?
-- Maybe I could just wire them into all other operations?

-- | interface to the X11 library function @XBitmapBitOrder()@.
foreign import ccall unsafe "HsXlib.h XBitmapBitOrder"
	bitmapBitOrder :: Display -> ByteOrder

-- | interface to the X11 library function @XBitmapUnit()@.
foreign import ccall unsafe "HsXlib.h XBitmapUnit"
	bitmapUnit     :: Display -> Int

-- | interface to the X11 library function @XBitmapPad()@.
foreign import ccall unsafe "HsXlib.h XBitmapPad"
	bitmapPad      :: Display -> Int

-- ToDo: make sure that initialisation works correctly for x/y_hot
-- omitted
-- IMPURE void	XWriteBitmapFile(display, filename, bitmap, width, height, x_hot, y_hot) RAISES Either
-- RETURNTYPE	BitmapFileStatus
-- GLOBAL ERROR BitmapFileStatus	RETVAL
-- IN Display*	display
-- IN String	filename
-- IN Pixmap	bitmap
-- IN Dimension	width
-- IN Dimension	height
-- IN Maybe Int	x_hot = -1
-- IN Maybe Int	y_hot = -1
-- POST: RETVAL == BitmapSuccess

-- omitted
-- IMPURE void	XReadBitmapFile(display, d, filename, bitmap, width, height, x_hot, y_hot) RAISES Either
-- RETURNTYPE	BitmapFileStatus
-- GLOBAL ERROR BitmapFileStatus	RETVAL
-- IN Display*	display
-- IN Drawable	d
-- IN String	filename
-- OUT Pixmap	bitmap
-- OUT Dimension	width
-- OUT Dimension	height
-- OUT Int		x_hot RAISES Maybe IF x_hot == -1
-- OUT Int		y_hot RAISES Maybe IF x_hot == -1
-- POST: RETVAL == BitmapSuccess

-- XCreateBitmapFromData omitted (awkward looking type)
-- XReadBitmapFileData omitted (awkward looking type)

----------------------------------------------------------------
-- Keycodes
----------------------------------------------------------------

-- | interface to the X11 library function @XDisplayKeycodes()@.
displayKeycodes :: Display -> (Int,Int)
displayKeycodes display =
	unsafePerformIO $ outParameters2 id $ xDisplayKeycodes display
foreign import ccall unsafe "HsXlib.h XDisplayKeycodes"
	xDisplayKeycodes :: Display -> Ptr Int -> Ptr Int -> IO ()

-- | interface to the X11 library function @XLookupKeysym()@.
foreign import ccall unsafe "HsXlib.h XLookupKeysym"
	lookupKeysym    :: XKeyEventPtr -> Int -> IO KeySym

-- | interface to the X11 library function @XKeycodeToKeysym()@.
foreign import ccall unsafe "HsXlib.h XKeycodeToKeysym"
	keycodeToKeysym :: Display -> KeyCode -> Int -> IO KeySym

-- | interface to the X11 library function @XKeysymToKeycode()@.
foreign import ccall unsafe "HsXlib.h XKeysymToKeycode"
	keysymToKeycode :: Display -> KeySym  -> IO KeyCode

-- | interface to the X11 library function @XKeysymToString()@.
keysymToString  :: KeySym -> String
keysymToString keysym = unsafePerformIO $ do
	c_str <- xKeysymToString keysym
	peekCString c_str
foreign import ccall unsafe "HsXlib.h XKeysymToString"
	xKeysymToString  :: KeySym -> IO CString

-- | interface to the X11 library function @XStringToKeysym()@.
stringToKeysym  :: String -> KeySym
stringToKeysym str = unsafePerformIO $
	withCString str $ \ c_str ->
	xStringToKeysym c_str
foreign import ccall unsafe "HsXlib.h XStringToKeysym"
	xStringToKeysym  :: CString -> IO KeySym

noSymbol :: KeySym
noSymbol = #{const NoSymbol}

newtype XComposeStatus = XComposeStatus (Ptr XComposeStatus)
#if __GLASGOW_HASKELL__
	deriving (Eq, Ord, Show, Typeable, Data)
#else
	deriving (Eq, Ord, Show)
#endif

-- XLookupString cannot handle compose, it seems.

-- | interface to the X11 library function @XLookupString()@.
lookupString :: XKeyEventPtr -> IO (Maybe KeySym, String)
lookupString event_ptr =
	allocaBytes 100 $ \ buf ->
	alloca $ \ keysym_return -> do
	n <- xLookupString event_ptr buf 100 keysym_return nullPtr
	str <- peekCStringLen (buf, n)
	keysym <- peek keysym_return
	return (if keysym == noSymbol then Nothing else Just keysym, str)
foreign import ccall unsafe "HsXlib.h XLookupString"
	xLookupString :: XKeyEventPtr -> CString -> Int ->
		Ptr KeySym -> Ptr XComposeStatus -> IO Int

-- XQueryKeymap omitted
-- XRebindKeysym omitted
-- XDeleteModifiermapEntry omitted
-- XInsertModifiermapEntry omitted
-- XNewModifiermap omitted
-- XFreeModifiermap omitted
-- XSetModifierMapping omitted
-- XGetModifierMapping omitted
-- XGetKeyboardMapping omitted

----------------------------------------------------------------
-- Image
----------------------------------------------------------------

-- XCreateImage omitted
-- XInitImage omitted
-- XGetImage omitted
-- XPutImage omitted
-- XGetSubImage omitted

----------------------------------------------------------------
-- Icons
----------------------------------------------------------------

-- | interface to the X11 library function @XGetIconName()@.
getIconName :: Display -> Window -> IO String
getIconName display w =
	alloca $ \ icon_name_return -> do
	throwIfZero "getIconName" $
		xGetIconName display w icon_name_return
	c_icon_name <- peek icon_name_return
	peekCString c_icon_name
foreign import ccall unsafe "HsXlib.h XGetIconName"
	xGetIconName :: Display -> Window -> Ptr CString -> IO Status

-- | interface to the X11 library function @XSetIconName()@.
setIconName :: Display -> Window -> String -> IO ()
setIconName display w icon_name =
	withCString icon_name $ \ c_icon_name ->
	xSetIconName display w c_icon_name
foreign import ccall unsafe "HsXlib.h XSetIconName"
	xSetIconName :: Display -> Window -> CString -> IO ()

----------------------------------------------------------------
-- Cursors
----------------------------------------------------------------

-- | interface to the X11 library function @XDefineCursor()@.
foreign import ccall unsafe "HsXlib.h XDefineCursor"
	defineCursor       :: Display -> Window -> Cursor -> IO ()

-- | interface to the X11 library function @XUndefineCursor()@.
foreign import ccall unsafe "HsXlib.h XUndefineCursor"
	undefineCursor     :: Display -> Window -> IO ()

-- | interface to the X11 library function @XCreatePixmapCursor()@.
createPixmapCursor :: Display -> Pixmap -> Pixmap -> Color -> Color ->
	Dimension -> Dimension -> IO Cursor
createPixmapCursor display source mask fg_color bg_color x y =
	with fg_color $ \ fg_color_ptr ->
	with bg_color $ \ bg_color_ptr ->
	xCreatePixmapCursor display source mask fg_color_ptr bg_color_ptr x y
foreign import ccall unsafe "HsXlib.h XCreatePixmapCursor"
	xCreatePixmapCursor :: Display -> Pixmap -> Pixmap ->
		Ptr Color -> Ptr Color -> Dimension -> Dimension -> IO Cursor

-- | interface to the X11 library function @XCreateGlyphCursor()@.
createGlyphCursor  :: Display -> Font   -> Font -> Glyph -> Glyph ->
	Color -> Color -> IO Cursor
createGlyphCursor display source_font mask_font source_char mask_char
		fg_color bg_color =
	with fg_color $ \ fg_color_ptr ->
	with bg_color $ \ bg_color_ptr ->
	xCreateGlyphCursor display source_font mask_font source_char mask_char
		fg_color_ptr bg_color_ptr
foreign import ccall unsafe "HsXlib.h XCreateGlyphCursor"
	xCreateGlyphCursor  :: Display -> Font   -> Font -> Glyph -> Glyph ->
		Ptr Color -> Ptr Color -> IO Cursor

-- | interface to the X11 library function @XCreateFontCursor()@.
foreign import ccall unsafe "HsXlib.h XCreateFontCursor"
	createFontCursor   :: Display -> Glyph  -> IO Cursor

-- | interface to the X11 library function @XFreeCursor()@.
foreign import ccall unsafe "HsXlib.h XFreeCursor"
	freeCursor         :: Display -> Font   -> IO ()

-- | interface to the X11 library function @XRecolorCursor()@.
recolorCursor      :: Display -> Cursor -> Color -> Color -> IO ()
recolorCursor display cursor fg_color bg_color =
	with fg_color $ \ fg_color_ptr ->
	with bg_color $ \ bg_color_ptr ->
	xRecolorCursor display cursor fg_color_ptr bg_color_ptr
foreign import ccall unsafe "HsXlib.h XRecolorCursor"
	xRecolorCursor      :: Display -> Cursor -> Ptr Color -> Ptr Color -> IO ()

----------------------------------------------------------------
-- Window Manager stuff
----------------------------------------------------------------

-- XConfigureWMWindow omitted (can't find documentation)
-- XReconfigureWMWindow omitted (can't find documentation)
-- XWMGeometry omitted (can't find documentation)
-- XGetWMColormapWindows omitted (can't find documentation)
-- XSetWMColormapWindows omitted (can't find documentation)
-- XGetWMProtocols omitted

-- AC, 1/9/2000: Added definition for XSetWMProtocols

-- | interface to the X11 library function @XSetWMProtocols()@.
setWMProtocols :: Display -> Window -> [Atom] -> IO ()
setWMProtocols display w protocols =
	withArray protocols $ \ protocol_array ->
	xSetWMProtocols display w protocol_array (length protocols)
foreign import ccall unsafe "HsXlib.h XSetWMProtocols"
	xSetWMProtocols :: Display -> Window -> Ptr Atom -> Int -> IO ()

----------------------------------------------------------------
-- Set Window Attributes
----------------------------------------------------------------

-- ToDo: generate this kind of stuff automatically.

allocaSetWindowAttributes :: (Ptr SetWindowAttributes -> IO a) -> IO a
allocaSetWindowAttributes = allocaBytes #{size XSetWindowAttributes}

---------------- Access to individual fields ----------------

set_background_pixmap :: Ptr SetWindowAttributes -> Pixmap -> IO ()
set_background_pixmap = #{poke XSetWindowAttributes,background_pixmap}

set_background_pixel :: Ptr SetWindowAttributes -> Pixel -> IO ()
set_background_pixel = #{poke XSetWindowAttributes,background_pixel}

set_border_pixmap :: Ptr SetWindowAttributes -> Pixmap -> IO ()
set_border_pixmap = #{poke XSetWindowAttributes,border_pixmap}

set_border_pixel :: Ptr SetWindowAttributes -> Pixel -> IO ()
set_border_pixel = #{poke XSetWindowAttributes,border_pixel}

set_bit_gravity :: Ptr SetWindowAttributes -> BitGravity -> IO ()
set_bit_gravity = #{poke XSetWindowAttributes,bit_gravity}

set_win_gravity :: Ptr SetWindowAttributes -> WindowGravity -> IO ()
set_win_gravity = #{poke XSetWindowAttributes,win_gravity}

set_backing_store :: Ptr SetWindowAttributes -> BackingStore -> IO ()
set_backing_store = #{poke XSetWindowAttributes,backing_store}

set_backing_planes :: Ptr SetWindowAttributes -> Pixel -> IO ()
set_backing_planes = #{poke XSetWindowAttributes,backing_planes}

set_backing_pixel :: Ptr SetWindowAttributes -> Pixel -> IO ()
set_backing_pixel = #{poke XSetWindowAttributes,backing_pixel}

set_save_under :: Ptr SetWindowAttributes -> Bool -> IO ()
set_save_under = #{poke XSetWindowAttributes,save_under}

set_event_mask :: Ptr SetWindowAttributes -> EventMask -> IO ()
set_event_mask = #{poke XSetWindowAttributes,event_mask}

set_do_not_propagate_mask :: Ptr SetWindowAttributes -> EventMask -> IO ()
set_do_not_propagate_mask = #{poke XSetWindowAttributes,do_not_propagate_mask}

set_override_redirect :: Ptr SetWindowAttributes -> Bool -> IO ()
set_override_redirect = #{poke XSetWindowAttributes,override_redirect}

set_colormap :: Ptr SetWindowAttributes -> Colormap -> IO ()
set_colormap = #{poke XSetWindowAttributes,colormap}

set_cursor :: Ptr SetWindowAttributes -> Cursor -> IO ()
set_cursor = #{poke XSetWindowAttributes,cursor}

----------------------------------------------------------------
-- Drawing
----------------------------------------------------------------

-- | interface to the X11 library function @XDrawPoint()@.
foreign import ccall unsafe "HsXlib.h XDrawPoint"
	drawPoint      :: Display -> Drawable -> GC -> Position -> Position -> IO ()

-- | interface to the X11 library function @XDrawPoints()@.
drawPoints :: Display -> Drawable -> GC -> [Point] -> CoordinateMode -> IO ()
drawPoints display d gc points mode =
	withArrayLen points $ \ npoints point_array ->
	xDrawPoints display d gc point_array npoints mode
foreign import ccall unsafe "HsXlib.h XDrawPoints"
	xDrawPoints     :: Display -> Drawable -> GC -> Ptr Point -> Int ->
				CoordinateMode -> IO ()

-- | interface to the X11 library function @XDrawLine()@.
foreign import ccall unsafe "HsXlib.h XDrawLine"
	drawLine       :: Display -> Drawable -> GC -> Position -> Position ->
				Position -> Position -> IO ()

-- | interface to the X11 library function @XDrawLines()@.
drawLines :: Display -> Drawable -> GC -> [Point] -> CoordinateMode -> IO ()
drawLines display d gc points mode =
	withArrayLen points $ \ npoints point_array ->
	xDrawLines display d gc point_array npoints mode
foreign import ccall unsafe "HsXlib.h XDrawLines"
	xDrawLines      :: Display -> Drawable -> GC -> Ptr Point -> Int ->
				CoordinateMode -> IO ()

-- | interface to the X11 library function @XDrawSegments()@.
drawSegments :: Display -> Drawable -> GC -> [Segment] -> IO ()
drawSegments display d gc segments =
	withArrayLen segments $ \ nsegments segment_array ->
	xDrawSegments display d gc segment_array nsegments
foreign import ccall unsafe "HsXlib.h XDrawSegments"
	xDrawSegments   :: Display -> Drawable -> GC -> Ptr Segment -> Int -> IO ()

-- | interface to the X11 library function @XDrawRectangle()@.
foreign import ccall unsafe "HsXlib.h XDrawRectangle"
	drawRectangle  :: Display -> Drawable -> GC -> Position -> Position -> Dimension -> Dimension -> IO ()

-- | interface to the X11 library function @XDrawRectangles()@.
drawRectangles :: Display -> Drawable -> GC -> [Rectangle] -> IO ()
drawRectangles display d gc rectangles =
	withArrayLen rectangles $ \ nrectangles rectangle_array ->
	xDrawRectangles display d gc rectangle_array nrectangles
foreign import ccall unsafe "HsXlib.h XDrawRectangles"
	xDrawRectangles :: Display -> Drawable -> GC -> Ptr Rectangle -> Int -> IO ()

-- | interface to the X11 library function @XDrawArc()@.
foreign import ccall unsafe "HsXlib.h XDrawArc"
	drawArc        :: Display -> Drawable -> GC -> Position -> Position ->
			Dimension -> Dimension -> Angle -> Angle -> IO ()

-- | interface to the X11 library function @XDrawArcs()@.
drawArcs :: Display -> Drawable -> GC -> [Arc] -> IO ()
drawArcs display d gc arcs =
	withArrayLen arcs $ \ narcs arc_array ->
	xDrawArcs display d gc arc_array narcs
foreign import ccall unsafe "HsXlib.h XDrawArcs"
	xDrawArcs       :: Display -> Drawable -> GC -> Ptr Arc -> Int -> IO ()

-- | interface to the X11 library function @XFillRectangle()@.
foreign import ccall unsafe "HsXlib.h XFillRectangle"
	fillRectangle  :: Display -> Drawable -> GC -> Position -> Position ->
				Dimension -> Dimension -> IO ()

-- | interface to the X11 library function @XFillRectangles()@.
fillRectangles :: Display -> Drawable -> GC -> [Rectangle] -> IO ()
fillRectangles display d gc rectangles =
	withArrayLen rectangles $ \ nrectangles rectangle_array ->
	xFillRectangles display d gc rectangle_array nrectangles
foreign import ccall unsafe "HsXlib.h XFillRectangles"
	xFillRectangles :: Display -> Drawable -> GC -> Ptr Rectangle -> Int -> IO ()

-- | interface to the X11 library function @XFillPolygon()@.
fillPolygon :: Display -> Drawable -> GC -> [Point] -> PolygonShape -> CoordinateMode -> IO ()
fillPolygon display d gc points shape mode =
	withArrayLen points $ \ npoints point_array ->
	xFillPolygon display d gc point_array npoints shape mode
foreign import ccall unsafe "HsXlib.h XFillPolygon"
	xFillPolygon    :: Display -> Drawable -> GC -> Ptr Point -> Int -> PolygonShape -> CoordinateMode -> IO ()

-- | interface to the X11 library function @XFillArc()@.
foreign import ccall unsafe "HsXlib.h XFillArc"
	fillArc        :: Display -> Drawable -> GC -> Position -> Position ->
			Dimension -> Dimension -> Angle -> Angle -> IO ()

-- | interface to the X11 library function @XFillArcs()@.
fillArcs :: Display -> Drawable -> GC -> [Arc] -> IO ()
fillArcs display d gc arcs =
	withArrayLen arcs $ \ narcs arc_array ->
	xFillArcs display d gc arc_array narcs
foreign import ccall unsafe "HsXlib.h XFillArcs"
	xFillArcs       :: Display -> Drawable -> GC -> Ptr Arc -> Int -> IO ()

-- | interface to the X11 library function @XCopyArea()@.
foreign import ccall unsafe "HsXlib.h XCopyArea"
	copyArea       :: Display -> Drawable -> Drawable -> GC -> Position -> Position -> Dimension -> Dimension -> Position -> Position -> IO ()

-- | interface to the X11 library function @XCopyPlane()@.
foreign import ccall unsafe "HsXlib.h XCopyPlane"
	copyPlane      :: Display -> Drawable -> Drawable -> GC -> Position -> Position -> Dimension -> Dimension -> Position -> Position -> Pixel -> IO ()

-- draw characters over existing background

-- | interface to the X11 library function @XDrawString()@.
drawString :: Display -> Drawable -> GC -> Position -> Position -> String -> IO ()
drawString display d gc x y str =
	withCStringLen str $ \ (c_str, len) ->
	xDrawString display d gc x y c_str len
foreign import ccall unsafe "HsXlib.h XDrawString"
	xDrawString     :: Display -> Drawable -> GC -> Position -> Position -> CString -> Int -> IO ()

-- draw characters over a blank rectangle of current background colour

-- | interface to the X11 library function @XDrawImageString()@.
drawImageString :: Display -> Drawable -> GC -> Position -> Position -> String -> IO ()
drawImageString display d gc x y str =
	withCStringLen str $ \ (c_str, len) ->
	xDrawImageString display d gc x y c_str len
foreign import ccall unsafe "HsXlib.h XDrawImageString"
	xDrawImageString :: Display -> Drawable -> GC -> Position -> Position -> CString -> Int -> IO ()

-- XDrawString16 omitted (16bit chars not supported)
-- XDrawImageString16 omitted (16bit chars not supported)
-- XDrawText omitted (XTextItem not supported)
-- XDrawText16 omitted (XTextItem not supported)

----------------------------------------------------------------
-- Cut and paste buffers
----------------------------------------------------------------

-- | interface to the X11 library function @XStoreBuffer()@.
storeBuffer :: Display -> String -> Int -> IO ()
storeBuffer display bytes buffer =
	withCStringLen bytes $ \ (c_bytes, nbytes) ->
	throwIfZero "storeBuffer" $
		xStoreBuffer display c_bytes nbytes buffer
foreign import ccall unsafe "HsXlib.h XStoreBuffer"
	xStoreBuffer :: Display -> CString -> Int -> Int -> IO Status

-- | interface to the X11 library function @XStoreBytes()@.
storeBytes :: Display -> String -> IO ()
storeBytes display bytes =
	withCStringLen bytes $ \ (c_bytes, nbytes) ->
	throwIfZero "storeBytes" $
		xStoreBytes display c_bytes nbytes
foreign import ccall unsafe "HsXlib.h XStoreBytes"
	xStoreBytes :: Display -> CString -> Int -> IO Status

-- | interface to the X11 library function @XFetchBuffer()@.
fetchBuffer :: Display -> Int -> IO String
fetchBuffer display buffer =
	alloca $ \ nbytes_return -> do
	c_bytes <- throwIfNull "fetchBuffer" $
		xFetchBuffer display nbytes_return buffer
	nbytes <- peek nbytes_return
	bytes <- peekCStringLen (c_bytes, nbytes)
	xFree c_bytes
	return bytes
foreign import ccall unsafe "HsXlib.h XFetchBuffer"
	xFetchBuffer :: Display -> Ptr Int -> Int -> IO CString

-- | interface to the X11 library function @XFetchBytes()@.
fetchBytes :: Display -> IO String
fetchBytes display =
	alloca $ \ nbytes_return -> do
	c_bytes <- throwIfNull "fetchBytes" $
		xFetchBytes display nbytes_return
	nbytes <- peek nbytes_return
	bytes <- peekCStringLen (c_bytes, nbytes)
	xFree c_bytes
	return bytes
foreign import ccall unsafe "HsXlib.h XFetchBytes"
	xFetchBytes :: Display -> Ptr Int -> IO CString

-- | interface to the X11 library function @XRotateBuffers()@.
rotateBuffers :: Display -> Int -> IO ()
rotateBuffers display rotate =
	throwIfZero "rotateBuffers" $
		xRotateBuffers display rotate
foreign import ccall unsafe "HsXlib.h XRotateBuffers"
	xRotateBuffers :: Display -> Int -> IO Status

----------------------------------------------------------------
-- Window properties
----------------------------------------------------------------

newtype XTextProperty = XTextProperty (Ptr XTextProperty)
#if __GLASGOW_HASKELL__
	deriving (Eq, Ord, Show, Typeable, Data)
#else
	deriving (Eq, Ord, Show)
#endif

-- | interface to the X11 library function @XSetTextProperty()@.
setTextProperty :: Display -> Window -> String -> Atom -> IO ()
setTextProperty display w value property =
	withCStringLen value $ \ (c_value, value_len) ->
	allocaBytes #{size XTextProperty} $ \ text_prop -> do
	#{poke XTextProperty,value} text_prop c_value
	#{poke XTextProperty,encoding} text_prop sTRING
	#{poke XTextProperty,format} text_prop (8::Int)
	#{poke XTextProperty,nitems} text_prop (fromIntegral value_len::Word32)
	xSetTextProperty display w text_prop property
foreign import ccall unsafe "HsXlib.h XSetTextProperty"
	xSetTextProperty :: Display -> Window -> Ptr XTextProperty -> Atom -> IO ()

-- %fun XSetStandardProperties :: Display -> Window -> String -> String -> Pixmap -> [String] -> XSizeHints -> IO ()
-- %code Status err = XSetStandardProperties(arg1,arg2,arg3,arg4,arg5,arg6,arg6_size,&arg7)
-- %fail { Success != err }{ BadStatus(err,XSetStandardProperties) }

----------------------------------------------------------------
-- Canned handling of output parameters
----------------------------------------------------------------

outParameters2 :: (Storable a, Storable b) =>
	(IO r -> IO ()) -> (Ptr a -> Ptr b -> IO r) -> IO (a,b)
outParameters2 check fn =
	alloca $ \ a_return ->
	alloca $ \ b_return -> do
	check (fn a_return b_return)
	a <- peek a_return
	b <- peek b_return
	return (a,b)

outParameters3 :: (Storable a, Storable b, Storable c) =>
	(IO r -> IO ()) -> (Ptr a -> Ptr b -> Ptr c -> IO r) -> IO (a,b,c)
outParameters3 check fn =
	alloca $ \ a_return ->
	alloca $ \ b_return ->
	alloca $ \ c_return -> do
	check (fn a_return b_return c_return)
	a <- peek a_return
	b <- peek b_return
	c <- peek c_return
	return (a,b,c)

outParameters4 :: (Storable a, Storable b, Storable c, Storable d) =>
	(IO r -> IO ()) -> (Ptr a -> Ptr b -> Ptr c -> Ptr d -> IO r) ->
	IO (a,b,c,d)
outParameters4 check fn =
	alloca $ \ a_return ->
	alloca $ \ b_return ->
	alloca $ \ c_return ->
	alloca $ \ d_return -> do
	check (fn a_return b_return c_return d_return)
	a <- peek a_return
	b <- peek b_return
	c <- peek c_return
	d <- peek d_return
	return (a,b,c,d)

outParameters7 :: (Storable a, Storable b, Storable c, Storable d, Storable e, Storable f, Storable g) =>
	(IO r -> IO ()) -> (Ptr a -> Ptr b -> Ptr c -> Ptr d -> Ptr e -> Ptr f -> Ptr g -> IO r) ->
	IO (a,b,c,d,e,f,g)
outParameters7 check fn =
	alloca $ \ a_return ->
	alloca $ \ b_return ->
	alloca $ \ c_return ->
	alloca $ \ d_return ->
	alloca $ \ e_return ->
	alloca $ \ f_return ->
	alloca $ \ g_return -> do
	check (fn a_return b_return c_return d_return e_return f_return g_return)
	a <- peek a_return
	b <- peek b_return
	c <- peek c_return
	d <- peek d_return
	e <- peek e_return
	f <- peek f_return
	g <- peek g_return
	return (a,b,c,d,e,f,g)

----------------------------------------------------------------
-- End
----------------------------------------------------------------
