{-# OPTIONS_GHC -fglasgow-exts #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Event
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of FFI declarations for interfacing with Xlib Events.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Event(
        QueuedMode,
        queuedAlready,
        queuedAfterFlush,
        queuedAfterReading,
        XEvent,
        XEventPtr,
        allocaXEvent,
        get_EventType,
        get_Window,
        XKeyEvent,
        XKeyEventPtr,
        asKeyEvent,
        XButtonEvent,
        get_KeyEvent,
        get_ButtonEvent,
        get_MotionEvent,
        XMotionEvent,
        XExposeEvent,
        get_ExposeEvent,
        XMappingEvent,
        XConfigureEvent,
        get_ConfigureEvent,
        waitForEvent,
        gettimeofday_in_milliseconds,
        -- gettimeofday_in_milliseconds_internal,
        flush,
        sync,
        pending,
        eventsQueued,
        nextEvent,
        allowEvents,
        selectInput,
        sendEvent,
        windowEvent,
        checkWindowEvent,
        maskEvent,
        checkMaskEvent,
        checkTypedEvent,
        checkTypedWindowEvent,
        putBackEvent,
        peekEvent,
        refreshKeyboardMapping,

        ) where

import Graphics.X11.Types
import Graphics.X11.Xlib.Types
import Graphics.X11.Xlib.Display( connectionNumber )

import Foreign

#if __GLASGOW_HASKELL__
import Data.Generics
#endif

#include "HsXlib.h"

{-# CFILES cbits/fdset.c #-}

----------------------------------------------------------------
-- Events
----------------------------------------------------------------

type   QueuedMode   = Int
#{enum QueuedMode,
 , queuedAlready	= QueuedAlready
 , queuedAfterFlush	= QueuedAfterFlush
 , queuedAfterReading	= QueuedAfterReading
 }

-- Because of the way the corresponding C types are defined,
-- These "structs" are somewhat unusual - they omit fields which can
-- be found in more general structs.
-- For example, XAnyEvent omits type since it is in XEvent.
-- Therefore, to get the complete contents of an event one typically
-- writes:
--   do
--     ty <- get_XEvent e
--     (serial,send_event,display,window) <- get_XAnyEvent
--     window' <- get_XDestroyWindowEvent

newtype XEvent = XEvent XEventPtr
#if __GLASGOW_HASKELL__
	deriving (Eq, Ord, Show, Typeable, Data)
#else
	deriving (Eq, Ord, Show)
#endif
type XEventPtr = Ptr XEvent

allocaXEvent :: (XEventPtr -> IO a) -> IO a
allocaXEvent = allocaBytes #{size XEvent}

get_EventType :: XEventPtr -> IO EventType
get_EventType = #{peek XEvent,type}

get_Window :: XEventPtr -> IO Window
get_Window = #{peek XAnyEvent,window}

-- %struct : XAnyEvent : XAnyEvent arg1
--   Int32     : serial            # # of last request processed by server
--   Bool      : send_event        # true if this came from a SendEvent request
--   Display   : display           # Display the event was read from
--   Window    : window            # window on which event was requested in event mask

type XKeyEvent =
	( Window    -- root window that the event occured on
	, Window    -- child window
	, Time      -- milliseconds
	, Int       -- pointer x, y coordinates in event window
	, Int       --
	, Int       -- coordinates relative to root
	, Int       --
	, Modifier  -- key or button mask
	, KeyCode   -- detail
	, Bool      -- same screen flag
	)

peekXKeyEvent :: Ptr XKeyEvent -> IO XKeyEvent
peekXKeyEvent p = do
	root		<- #{peek XKeyEvent,root} p
	subwindow	<- #{peek XKeyEvent,subwindow} p
	time		<- #{peek XKeyEvent,time} p
	x		<- #{peek XKeyEvent,x} p
	y		<- #{peek XKeyEvent,y} p
	x_root		<- #{peek XKeyEvent,x_root} p
	y_root		<- #{peek XKeyEvent,y_root} p
	state		<- #{peek XKeyEvent,state} p
	keycode		<- #{peek XKeyEvent,keycode} p
	same_screen	<- #{peek XKeyEvent,same_screen} p
	return (root, subwindow, time, x, y, x_root, y_root,
		state, keycode, same_screen)

get_KeyEvent :: XEventPtr -> IO XKeyEvent
get_KeyEvent p = peekXKeyEvent (castPtr p)

type XKeyEventPtr   = Ptr XKeyEvent

asKeyEvent :: XEventPtr -> XKeyEventPtr
asKeyEvent = castPtr

type XButtonEvent =
	( Window    --	root window that the event occured on
	, Window    --	child window
	, Time      --	milliseconds
	, Int       --	pointer x, y coordinates in event window
	, Int
	, Int       --	coordinates relative to root
	, Int
	, Modifier  --	key or button mask
	, Button    --	detail
	, Bool      --	same screen flag
	)

peekXButtonEvent :: Ptr XButtonEvent -> IO XButtonEvent
peekXButtonEvent p = do
	root		<- #{peek XButtonEvent,root} p
	subwindow	<- #{peek XButtonEvent,subwindow} p
	time		<- #{peek XButtonEvent,time} p
	x		<- #{peek XButtonEvent,x} p
	y		<- #{peek XButtonEvent,y} p
	x_root		<- #{peek XButtonEvent,x_root} p
	y_root		<- #{peek XButtonEvent,y_root} p
	state		<- #{peek XButtonEvent,state} p
	button		<- #{peek XButtonEvent,button} p
	same_screen	<- #{peek XButtonEvent,same_screen} p
	return (root, subwindow, time, x, y, x_root, y_root,
		state, button, same_screen)

get_ButtonEvent :: XEventPtr -> IO XButtonEvent
get_ButtonEvent p = peekXButtonEvent (castPtr p)

type XMotionEvent =
	( Window      -- root window that the event occured on
	, Window      -- child window
	, Time        -- milliseconds
	, Int         -- pointer x, y coordinates in event window
	, Int
	, Int         -- coordinates relative to root
	, Int
	, Modifier    -- key or button mask
	, NotifyMode  -- detail
	, Bool        -- same screen flag
	)

peekXMotionEvent :: Ptr XMotionEvent -> IO XMotionEvent
peekXMotionEvent p = do
	root		<- #{peek XMotionEvent,root} p
	subwindow	<- #{peek XMotionEvent,subwindow} p
	time		<- #{peek XMotionEvent,time} p
	x		<- #{peek XMotionEvent,x} p
	y		<- #{peek XMotionEvent,y} p
	x_root		<- #{peek XMotionEvent,x_root} p
	y_root		<- #{peek XMotionEvent,y_root} p
	state		<- #{peek XMotionEvent,state} p
	is_hint		<- #{peek XMotionEvent,is_hint} p
	same_screen	<- #{peek XMotionEvent,same_screen} p
	return (root, subwindow, time, x, y, x_root, y_root,
		state, is_hint, same_screen)

get_MotionEvent :: XEventPtr -> IO XMotionEvent
get_MotionEvent p = peekXMotionEvent (castPtr p)

-- %struct : XCrossingEvent : XCrossingEvent arg1
--   Window       : root 	        # root window that the event occured on
--   Window       : subwindow 	# child window
--   Time         : time 		# milliseconds
--   Int          : x 		# pointer x, y coordinates in event window
--   Int          : y
--   Int          : x_root	 	# coordinates relative to root
--   Int          : y_root
--   NotifyMode   : mode
--   NotifyDetail : detail
--   Bool         : same_screen	# same screen flag
--   Bool         : focus		# boolean focus
--   Modifier     : state	        # key or button mask
--
-- %struct : XFocusChangeEvent : XFocusChangeEvent arg1
--   NotifyMode   : mode
--   NotifyDetail : detail
--
-- -- omitted: should be translated into bitmaps
-- -- PURE void	getKeymapEvent(event)
-- -- IN XEvent*	event
-- -- OUT Window	window	 	= ((XKeymapEvent*)event)->window
-- -- OUT array[32] Char key_vector 	= ((XKeymapEvent*)event)->key_vector
-- -- RESULT:

type XExposeEvent =
	( Position	-- x
	, Position	-- y
	, Dimension	-- width
	, Dimension	-- height
	, Int		-- count
	)

peekXExposeEvent :: Ptr XExposeEvent -> IO XExposeEvent
peekXExposeEvent p = do
	x	<- #{peek XExposeEvent,x} p
	y	<- #{peek XExposeEvent,y} p
	width	<- #{peek XExposeEvent,width} p
	height	<- #{peek XExposeEvent,height} p
	count	<- #{peek XExposeEvent,count} p
	return (x, y, width, height, count)

get_ExposeEvent :: XEventPtr -> IO XExposeEvent
get_ExposeEvent p = peekXExposeEvent (castPtr p)

-- %struct : XGraphicsExposeEvent : XGraphicsExposeEvent arg1
--   Position	: x
--   Position	: y
--   Dimension	: width	 	.
--   Dimension	: height
--   Int		: count
--   Int		: major_code
--   Int		: minor_code
--
-- %struct : XCirculateEvent : XCirculateEvent arg1
--   Window	: window
--   Place		: place
--
-- %struct : XConfigureEvent : XConfigureEvent arg1
--   Window	: window
--   Position	: x
--   Position	: y
--   Dimension	: width
--   Dimension	: height
--   Dimension	: border_width
--   Window	: above
--   Bool	        : override_redirect
--
-- %struct : XCreateWindowEvent : XCreateWindowEvent arg1
--   Window	: window
--   Position	: x
--   Position	: y
--   Dimension	: width
--   Dimension	: height
--   Dimension	: border_width
--   Bool	        : override_redirect
--
-- %struct : XDestroyWindowEvent : XDestroyWindowEvent arg1
--   Window	: window
--
-- %struct : XGravityEvent : XGravityEvent arg1
--   Window	: window
--   Position	: x
--   Position	: y
--
-- %struct : XMapEvent : XMapEvent arg1
--   Bool	        : override_redirect

type XMappingEvent =
	( MappingRequest  -- request
	, KeyCode	  -- first_keycode
	, Int		  -- count
	)

withXMappingEvent :: XMappingEvent -> (Ptr XMappingEvent -> IO a) -> IO a
withXMappingEvent event_map f =
	allocaBytes #{size XMappingEvent} $ \ event_map_ptr -> do
	pokeXMappingEvent event_map_ptr event_map
	f event_map_ptr

pokeXMappingEvent :: Ptr XMappingEvent -> XMappingEvent -> IO ()
pokeXMappingEvent p (request, first_keycode, count) = do
	#{poke XMappingEvent,request}		p request
	#{poke XMappingEvent,first_keycode}	p first_keycode
	#{poke XMappingEvent,count}		p count

type XConfigureEvent =
	( Position
	, Position
	, Dimension
	, Dimension
	)

peekXConfigureEvent :: Ptr XConfigureEvent -> IO XConfigureEvent
peekXConfigureEvent p = do
	x	<- #{peek XConfigureEvent,x} p
	y	<- #{peek XConfigureEvent,y} p
	width	<- #{peek XConfigureEvent,width} p
	height	<- #{peek XConfigureEvent,height} p
	return (x, y, width, height)

get_ConfigureEvent :: XEventPtr -> IO XConfigureEvent
get_ConfigureEvent p = peekXConfigureEvent (castPtr p)

-- %struct : XResizeRequestEvent : XResizeRequestEvent arg1
--   Dimension	: width
--   Dimension	: height
--

-- %struct : XReparentEvent : XReparentEvent arg1
--   Window	: window
--   Window	: parent
--   Position	: x
--   Position	: y
--   Bool	        : override_redirect
--
-- %struct : XUnmapEvent : XUnmapEvent arg1
--   Window	: window
--   Bool	        : from_configure
--
-- %struct : XVisibilityEvent : XVisibilityEvent arg1
--   Visibility	: state
--
-- %struct : XCirculateRequestEvent : XCirculateRequestEvent arg1
--   Place	        : place
--
-- -- omitted because valuemask looks tricky
-- -- %struct : XConfigureRequestEvent : XConfigureRequestEvent arg1
-- --   Window	 : window
-- --   Position	 : x
-- --   Position	 : y
-- --   Dimension	 : width
-- --   Dimension	 : height
-- --   Dimension	 : border_width
-- --   Window	 : above
-- --   StackingMethod : detail
-- --   ???	         : valuemask
--
-- %struct : XMapRequestEvent : XMapRequestEvent arg1
--   Window	: window
--
-- %struct : XColormapEvent : XColormapEvent arg1
--   Colormap		: colormap
--   Bool		        : new
--   ColormapNotification	: state
--
-- -- getClientMessageEvent omitted
-- -- getPropertyEvent omitted
-- -- getSelectionClearEvent omitted
-- -- getSelectionRequestEvent omitted
-- -- getSelectionEvent omitted

-- functions

-- The following is useful if you want to do a read with timeout.

-- | Reads an event with a timeout (in microseconds).
-- Returns True if timeout occurs.
waitForEvent :: Display -> Word32 -> IO Bool
waitForEvent display usecs =
	with (TimeVal (usecs `div` 1000000) (usecs `mod` 1000000)) $ \ tv_ptr ->
	allocaBytes #{size fd_set} $ \ readfds ->
	allocaBytes #{size fd_set} $ \ nofds -> do
	let fd = connectionNumber display
	fdZero readfds
	fdZero nofds
	fdSet fd readfds
	n <- select (fd+1) readfds nofds nofds tv_ptr
	return (n == 0)

newtype FdSet = FdSet (Ptr FdSet)
#if __GLASGOW_HASKELL__
	deriving (Eq, Ord, Show, Typeable, Data)
#else
	deriving (Eq, Ord, Show)
#endif

foreign import ccall unsafe "HsXlib.h" fdZero :: Ptr FdSet -> IO ()
foreign import ccall unsafe "HsXlib.h" fdSet :: Int -> Ptr FdSet -> IO ()

foreign import ccall unsafe "HsXlib.h" select ::
	Int -> Ptr FdSet -> Ptr FdSet -> Ptr FdSet -> Ptr TimeVal -> IO Int

-- | This function is somewhat compatible with Win32's @TimeGetTime()@
gettimeofday_in_milliseconds :: IO Integer
gettimeofday_in_milliseconds =
	alloca $ \ tv_ptr -> do
	rc <- gettimeofday tv_ptr nullPtr
	TimeVal sec usec <- peek tv_ptr
	return (toInteger sec * 1000 + toInteger usec `div` 1000)

data TimeVal = TimeVal Word32 Word32

instance Storable TimeVal where
	alignment _ = #{size int}
	sizeOf _ = #{size struct timeval}
	peek p = do
		sec <- #{peek struct timeval,tv_sec} p
		usec <- #{peek struct timeval,tv_usec} p
		return (TimeVal sec usec)
	poke p (TimeVal sec usec) = do
		#{poke struct timeval,tv_sec} p sec
		#{poke struct timeval,tv_usec} p usec

newtype TimeZone = TimeZone (Ptr TimeZone)
#if __GLASGOW_HASKELL__
	deriving (Eq, Ord, Show, Typeable, Data)
#else
	deriving (Eq, Ord, Show)
#endif

foreign import ccall unsafe "HsXlib.h"
	gettimeofday :: Ptr TimeVal -> Ptr TimeZone -> IO ()

-- | interface to the X11 library function @XFlush()@.
foreign import ccall unsafe "HsXlib.h XFlush"
	flush        :: Display ->               IO ()

-- | interface to the X11 library function @XSync()@.
foreign import ccall unsafe "HsXlib.h XSync"
	sync         :: Display -> Bool ->       IO ()

-- | interface to the X11 library function @XPending()@.
foreign import ccall unsafe "HsXlib.h XPending"
	pending      :: Display ->               IO Int

-- | interface to the X11 library function @XEventsQueued()@.
foreign import ccall unsafe "HsXlib.h XEventsQueued"
	eventsQueued :: Display -> QueuedMode -> IO Int

-- | interface to the X11 library function @XNextEvent()@.
foreign import ccall unsafe "HsXlib.h XNextEvent"
	nextEvent    :: Display -> XEventPtr  -> IO ()

-- | interface to the X11 library function @XAllowEvents()@.
foreign import ccall unsafe "HsXlib.h XAllowEvents"
	allowEvents  :: Display -> AllowEvents -> Time -> IO ()

-- ToDo: XFree(res1) after constructing result
-- %fun XGetMotionEvents :: Display -> Window -> Time -> Time -> IO ListXTimeCoord
-- %code res1 = XGetMotionEvents(arg1,arg2,arg3,arg4,&res1_size)

-- | interface to the X11 library function @XSelectInput()@.
foreign import ccall unsafe "HsXlib.h XSelectInput"
	selectInput :: Display -> Window -> EventMask -> IO ()

-- | interface to the X11 library function @XSendEvent()@.
sendEvent :: Display -> Window -> Bool -> EventMask -> XEventPtr -> IO ()
sendEvent display w propagate event_mask event_send =
	throwIfZero "sendEvent" $
		xSendEvent display w propagate event_mask event_send
foreign import ccall unsafe "HsXlib.h XSendEvent"
	xSendEvent :: Display -> Window -> Bool -> EventMask ->
		XEventPtr -> IO Status

-- | interface to the X11 library function @XWindowEvent()@.
foreign import ccall unsafe "HsXlib.h XWindowEvent"
	windowEvent :: Display -> Window -> EventMask -> XEventPtr -> IO ()

-- | interface to the X11 library function @XCheckWindowEvent()@.
foreign import ccall unsafe "HsXlib.h XCheckWindowEvent"
	checkWindowEvent :: Display -> Window -> EventMask ->
		XEventPtr -> IO Bool

-- | interface to the X11 library function @XMaskEvent()@.
foreign import ccall unsafe "HsXlib.h XMaskEvent"
	maskEvent :: Display -> EventMask -> XEventPtr -> IO ()

-- | interface to the X11 library function @XCheckMaskEvent()@.
foreign import ccall unsafe "HsXlib.h XCheckMaskEvent"
	checkMaskEvent :: Display -> EventMask -> XEventPtr -> IO Bool

-- | interface to the X11 library function @XCheckTypedEvent()@.
foreign import ccall unsafe "HsXlib.h XCheckTypedEvent"
	checkTypedEvent :: Display -> EventType -> XEventPtr -> IO Bool

-- | interface to the X11 library function @XCheckTypedWindowEvent()@.
foreign import ccall unsafe "HsXlib.h XCheckTypedWindowEvent"
	checkTypedWindowEvent :: Display -> Window -> EventType ->
		XEventPtr -> IO Bool

-- | interface to the X11 library function @XPutBackEvent()@.
foreign import ccall unsafe "HsXlib.h XPutBackEvent"
	putBackEvent :: Display -> XEventPtr -> IO ()

-- | interface to the X11 library function @XPeekEvent()@.
foreign import ccall unsafe "HsXlib.h XPeekEvent"
	peekEvent :: Display -> XEventPtr -> IO ()

-- XFilterEvent omitted (can't find documentation)
-- XIfEvent omitted (can't pass predicates (yet))
-- XCheckIfEvent omitted (can't pass predicates (yet))
-- XPeekIfEvent omitted (can't pass predicates (yet))

-- | interface to the X11 library function @XRefreshKeyboardMapping()@.
refreshKeyboardMapping :: XMappingEvent -> IO ()
refreshKeyboardMapping event_map =
	withXMappingEvent event_map $ \ event_map_ptr ->
	xRefreshKeyboardMapping event_map_ptr
foreign import ccall unsafe "HsXlib.h XRefreshKeyboardMapping"
	xRefreshKeyboardMapping :: Ptr XMappingEvent -> IO ()

-- XSynchronize omitted (returns C function)
-- XSetAfterFunction omitted (can't pass functions (yet))

----------------------------------------------------------------
-- End
----------------------------------------------------------------
