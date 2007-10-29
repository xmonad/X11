{-# OPTIONS -fglasgow-exts #-}
-----------------------------------------------------------------------------
-- |
-- Module      :
-- Copyright   :  (c) Spencer Janssen
-- License     :  BSD3-style (see LICENSE)
-- 
-- Stability   :  stable
--
-----------------------------------------------------------------------------
--
-- missing functionality from the X11 library
--

module Graphics.X11.Xlib.Extras where

import Data.Typeable ( Typeable )
import Graphics.X11.Xlib
import Graphics.X11.Xlib.Types
import Graphics.X11.Xlib.Misc
import Foreign
import Foreign.C.Types
import Foreign.C.String
import Control.Monad

#include "XlibExtras.h"

data Event
    = AnyEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_window                :: !Window
        }
    | ConfigureRequestEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_parent                :: !Window
        , ev_window                :: !Window
        , ev_x                     :: !CInt
        , ev_y                     :: !CInt
        , ev_width                 :: !CInt
        , ev_height                :: !CInt
        , ev_border_width          :: !CInt
        , ev_above                 :: !Window
        , ev_detail                :: !NotifyDetail
        , ev_value_mask            :: !CULong
        }
    | ConfigureEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_event                 :: !Window
        , ev_window                :: !Window
        , ev_x                     :: !CInt
        , ev_y                     :: !CInt
        , ev_width                 :: !CInt
        , ev_height                :: !CInt
        , ev_border_width          :: !CInt
        , ev_above                 :: !Window
        , ev_override_redirect     :: !Bool
        }
    | MapRequestEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_parent                :: !Window
        , ev_window                :: !Window
        }
    | KeyEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_window                :: !Window
        , ev_root                  :: !Window
        , ev_subwindow             :: !Window
        , ev_time                  :: !Time
        , ev_x                     :: !CInt
        , ev_y                     :: !CInt
        , ev_x_root                :: !CInt
        , ev_y_root                :: !CInt
        , ev_state                 :: !KeyMask
        , ev_keycode               :: !KeyCode
        , ev_same_screen           :: !Bool
        }
    | ButtonEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_window                :: !Window
        , ev_root                  :: !Window
        , ev_subwindow             :: !Window
        , ev_time                  :: !Time
        , ev_x                     :: !CInt
        , ev_y                     :: !CInt
        , ev_x_root                :: !CInt
        , ev_y_root                :: !CInt
        , ev_state                 :: !KeyMask
        , ev_button                :: !Button
        , ev_same_screen           :: !Bool
        }
    | MotionEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_x                     :: !CInt
        , ev_y                     :: !CInt
        , ev_window                :: !Window
        }
    | DestroyWindowEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_event                 :: !Window
        , ev_window                :: !Window
        }
    | UnmapEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_event                 :: !Window
        , ev_window                :: !Window
        , ev_from_configure        :: !Bool
        }
    | MapNotifyEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_event                 :: !Window
        , ev_window                :: !Window
        , ev_override_redirect     :: !Bool
        }
    | MappingNotifyEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_window                :: !Window
        , ev_request               :: !MappingRequest
        , ev_first_keycode         :: !KeyCode
        , ev_count                 :: !CInt
        }
    | CrossingEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_window                :: !Window
        , ev_root                  :: !Window
        , ev_subwindow             :: !Window
        , ev_time                  :: !Time
        , ev_x                     :: !CInt
        , ev_y                     :: !CInt
        , ev_x_root                :: !CInt
        , ev_y_root                :: !CInt
        , ev_mode                  :: !NotifyMode
        , ev_detail                :: !NotifyDetail
        , ev_same_screen           :: !Bool
        , ev_focus                 :: !Bool
        , ev_state                 :: !Modifier
        }
    | SelectionRequest
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_owner                 :: !Window
        , ev_requestor             :: !Window
        , ev_selection             :: !Atom
        , ev_target                :: !Atom
        , ev_property              :: !Atom
        , ev_time                  :: !Time
        }
    | PropertyEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_window                :: !Window
        , ev_atom                  :: !Atom
        , ev_time                  :: !Time
        , ev_propstate             :: !CInt
        }
    | ExposeEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_window                :: !Window
        , ev_x                     :: !CInt
        , ev_y                     :: !CInt
        , ev_width                 :: !CInt
        , ev_height                :: !CInt
        , ev_count                 :: !CInt
        }
    | ClientMessageEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_window                :: !Window
        , ev_message_type          :: !Atom
        , ev_data                  :: ![CInt]
        }

    deriving ( Show, Typeable )

eventTable :: [(EventType, String)]
eventTable =
    [ (keyPress             , "KeyPress")
    , (keyRelease           , "KeyRelease")
    , (buttonPress          , "ButtonPress")
    , (buttonRelease        , "ButtonRelease")
    , (motionNotify         , "MotionNotify")
    , (enterNotify          , "EnterNotify")
    , (leaveNotify          , "LeaveNotify")
    , (focusIn              , "FocusIn")
    , (focusOut             , "FocusOut")
    , (keymapNotify         , "KeymapNotify")
    , (expose               , "Expose")
    , (graphicsExpose       , "GraphicsExpose")
    , (noExpose             , "NoExpose")
    , (visibilityNotify     , "VisibilityNotify")
    , (createNotify         , "CreateNotify")
    , (destroyNotify        , "DestroyNotify")
    , (unmapNotify          , "UnmapNotify")
    , (mapNotify            , "MapNotify")
    , (mapRequest           , "MapRequest")
    , (reparentNotify       , "ReparentNotify")
    , (configureNotify      , "ConfigureNotify")
    , (configureRequest     , "ConfigureRequest")
    , (gravityNotify        , "GravityNotify")
    , (resizeRequest        , "ResizeRequest")
    , (circulateNotify      , "CirculateNotify")
    , (circulateRequest     , "CirculateRequest")
    , (propertyNotify       , "PropertyNotify")
    , (selectionClear       , "SelectionClear")
    , (selectionRequest     , "SelectionRequest")
    , (selectionNotify      , "SelectionNotify")
    , (colormapNotify       , "ColormapNotify")
    , (clientMessage        , "ClientMessage")
    , (mappingNotify        , "MappingNotify")
    , (lASTEvent            , "LASTEvent")
    ]

eventName :: Event -> String
eventName e = maybe ("unknown " ++ show x) id $ lookup x eventTable
 where x = fromIntegral $ ev_event_type e

getEvent :: XEventPtr -> IO Event
getEvent p = do
    -- All events share this layout and naming convention, there is also a
    -- common Window field, but the names for this field vary.
    type_      <- #{peek XAnyEvent, type} p
    serial     <- #{peek XAnyEvent, serial} p
    send_event <- #{peek XAnyEvent, send_event} p
    display    <- fmap Display (#{peek XAnyEvent, display} p)
    case () of

        -------------------------
        -- ConfigureRequestEvent:
        -------------------------
        _ | type_ == configureRequest -> do
            parent       <- #{peek XConfigureRequestEvent, parent      } p
            window       <- #{peek XConfigureRequestEvent, window      } p
            x            <- #{peek XConfigureRequestEvent, x           } p
            y            <- #{peek XConfigureRequestEvent, y           } p
            width        <- #{peek XConfigureRequestEvent, width       } p
            height       <- #{peek XConfigureRequestEvent, height      } p
            border_width <- #{peek XConfigureRequestEvent, border_width} p
            above        <- #{peek XConfigureRequestEvent, above       } p
            detail       <- #{peek XConfigureRequestEvent, detail      } p
            value_mask   <- #{peek XConfigureRequestEvent, value_mask  } p
            return $ ConfigureRequestEvent
                        { ev_event_type    = type_
                        , ev_serial        = serial
                        , ev_send_event    = send_event
                        , ev_event_display = display
                        , ev_parent        = parent
                        , ev_window        = window
                        , ev_x             = x
                        , ev_y             = y
                        , ev_width         = width
                        , ev_height        = height
                        , ev_border_width  = border_width
                        , ev_above         = above
                        , ev_detail        = detail
                        , ev_value_mask    = value_mask
                        }

          ------------------
          -- ConfigureEvent:
          ------------------
          | type_ == configureNotify -> do
            return (ConfigureEvent type_ serial send_event display)
                `ap` #{peek XConfigureEvent, event             } p
                `ap` #{peek XConfigureEvent, window            } p
                `ap` #{peek XConfigureEvent, x                 } p
                `ap` #{peek XConfigureEvent, y                 } p
                `ap` #{peek XConfigureEvent, width             } p
                `ap` #{peek XConfigureEvent, height            } p
                `ap` #{peek XConfigureEvent, border_width      } p
                `ap` #{peek XConfigureEvent, above             } p
                `ap` #{peek XConfigureEvent, override_redirect } p

          -------------------
          -- MapRequestEvent:
          -------------------
          | type_ == mapRequest -> do
            parent <- #{peek XMapRequestEvent, parent} p
            window <- #{peek XMapRequestEvent, window} p
            return $ MapRequestEvent
                        { ev_event_type    = type_
                        , ev_serial        = serial
                        , ev_send_event    = send_event
                        , ev_event_display = display
                        , ev_parent        = parent
                        , ev_window        = window
                        }

          -------------------
          -- MapNotifyEvent
          -------------------
          | type_ == mapNotify -> do
            event             <- #{peek XMapEvent, event}  p
            window            <- #{peek XMapEvent, window} p
            override_redirect <- #{peek XMapEvent, override_redirect} p
            return $ MapNotifyEvent
                        { ev_event_type        = type_
                        , ev_serial            = serial
                        , ev_send_event        = send_event
                        , ev_event_display     = display
                        , ev_event             = event
                        , ev_window            = window
                        , ev_override_redirect = override_redirect
                        }

          -------------------
          -- MappingNotifyEvent
          -------------------
          | type_ == mappingNotify -> do
            window        <- #{peek XMappingEvent,window}          p
            request       <- #{peek XMappingEvent,request}         p
            first_keycode <- #{peek XMappingEvent,first_keycode}   p
            count         <- #{peek XMappingEvent,count}           p

            return $ MappingNotifyEvent
                        { ev_event_type    = type_
                        , ev_serial        = serial
                        , ev_send_event    = send_event
                        , ev_event_display = display
                        , ev_window        = window
                        , ev_request       = request
                        , ev_first_keycode = first_keycode
                        , ev_count         = count
                        }

          ------------
          -- KeyEvent:
          ------------
          | type_ == keyPress || type_ == keyRelease -> do
            window      <- #{peek XKeyEvent, window     } p
            root        <- #{peek XKeyEvent, root       } p
            subwindow   <- #{peek XKeyEvent, subwindow  } p
            time        <- #{peek XKeyEvent, time       } p
            x           <- #{peek XKeyEvent, x          } p
            y           <- #{peek XKeyEvent, y          } p
            x_root      <- #{peek XKeyEvent, x_root     } p
            y_root      <- #{peek XKeyEvent, y_root     } p
            state       <- (#{peek XKeyEvent, state     } p) :: IO CUInt
            keycode     <- #{peek XKeyEvent, keycode    } p
            same_screen <- #{peek XKeyEvent, same_screen} p
            return $ KeyEvent
                        { ev_event_type    = type_
                        , ev_serial        = serial
                        , ev_send_event    = send_event
                        , ev_event_display = display
                        , ev_window        = window
                        , ev_root          = root
                        , ev_subwindow     = subwindow
                        , ev_time          = time
                        , ev_x             = x
                        , ev_y             = y
                        , ev_x_root        = x_root
                        , ev_y_root        = y_root
                        , ev_state         = fromIntegral state
                        , ev_keycode       = keycode
                        , ev_same_screen   = same_screen
                        }

          ---------------
          -- ButtonEvent:
          ---------------
          | type_ == buttonPress || type_ == buttonRelease -> do

            window      <- #{peek XButtonEvent, window     } p
            root        <- #{peek XButtonEvent, root       } p
            subwindow   <- #{peek XButtonEvent, subwindow  } p
            time        <- #{peek XButtonEvent, time       } p
            x           <- #{peek XButtonEvent, x          } p
            y           <- #{peek XButtonEvent, y          } p
            x_root      <- #{peek XButtonEvent, x_root     } p
            y_root      <- #{peek XButtonEvent, y_root     } p
            state       <- (#{peek XButtonEvent, state     } p) :: IO CUInt
            button      <- #{peek XButtonEvent, button     } p
            same_screen <- #{peek XButtonEvent, same_screen} p

            return $ ButtonEvent
                        { ev_event_type    = type_
                        , ev_serial        = serial
                        , ev_send_event    = send_event
                        , ev_event_display = display
                        , ev_window        = window
                        , ev_root          = root
                        , ev_subwindow     = subwindow
                        , ev_time          = time
                        , ev_x             = x
                        , ev_y             = y
                        , ev_x_root        = x_root
                        , ev_y_root        = y_root
                        , ev_state         = fromIntegral state
                        , ev_button        = button
                        , ev_same_screen   = same_screen
                        }

          ---------------
          -- MotionEvent:
          ---------------
          | type_ == motionNotify -> do
            window <- #{peek XMotionEvent, window} p
            x      <- #{peek XMotionEvent, x     } p
            y      <- #{peek XMotionEvent, y     } p
            return $ MotionEvent
                        { ev_event_type    = type_
                        , ev_serial        = serial
                        , ev_send_event    = send_event
                        , ev_event_display = display
                        , ev_x             = x
                        , ev_y             = y
                        , ev_window        = window
                        }


          ----------------------
          -- DestroyWindowEvent:
          ----------------------
          | type_ == destroyNotify -> do
            event  <- #{peek XDestroyWindowEvent, event } p
            window <- #{peek XDestroyWindowEvent, window} p
            return $ DestroyWindowEvent
                        { ev_event_type    = type_
                        , ev_serial        = serial
                        , ev_send_event    = send_event
                        , ev_event_display = display
                        , ev_event         = event
                        , ev_window        = window
                        }


          --------------------
          -- UnmapNotifyEvent:
          --------------------
          | type_ == unmapNotify -> do
            event          <- #{peek XUnmapEvent, event         } p
            window         <- #{peek XUnmapEvent, window        } p
            from_configure <- #{peek XUnmapEvent, from_configure} p
            return $ UnmapEvent
                        { ev_event_type    = type_
                        , ev_serial        = serial
                        , ev_send_event    = send_event
                        , ev_event_display = display
                        , ev_event         = event
                        , ev_window        = window
                        , ev_from_configure = from_configure
                        }

          --------------------
          -- CrossingEvent
          --------------------
          | type_ == enterNotify || type_ == leaveNotify -> do
            window        <- #{peek XCrossingEvent, window         } p
            root          <- #{peek XCrossingEvent, root           } p
            subwindow     <- #{peek XCrossingEvent, subwindow      } p
            time          <- #{peek XCrossingEvent, time           } p
            x             <- #{peek XCrossingEvent, x              } p
            y             <- #{peek XCrossingEvent, y              } p
            x_root        <- #{peek XCrossingEvent, x_root         } p
            y_root        <- #{peek XCrossingEvent, y_root         } p
            mode          <- #{peek XCrossingEvent, mode           } p
            detail        <- #{peek XCrossingEvent, detail         } p
            same_screen   <- #{peek XCrossingEvent, same_screen    } p
            focus         <- #{peek XCrossingEvent, focus          } p
            state         <- (#{peek XCrossingEvent, state         } p) :: IO CUInt

            return $ CrossingEvent
                        { ev_event_type    = type_
                        , ev_serial        = serial
                        , ev_send_event    = send_event
                        , ev_event_display = display
                        , ev_window        = window
                        , ev_root          = root
                        , ev_subwindow     = subwindow
                        , ev_time          = time
                        , ev_x             = x
                        , ev_y             = y
                        , ev_x_root        = x_root
                        , ev_y_root        = y_root
                        , ev_mode          = mode
                        , ev_detail        = detail
                        , ev_same_screen   = same_screen
                        , ev_focus         = focus
                        , ev_state         = fromIntegral state
                        }

          -------------------------
          -- SelectionRequestEvent:
          -------------------------
          | type_ == selectionRequest -> do
            owner          <- #{peek XSelectionRequestEvent, owner     } p
            requestor      <- #{peek XSelectionRequestEvent, requestor } p
            selection      <- #{peek XSelectionRequestEvent, selection } p
            target         <- #{peek XSelectionRequestEvent, target    } p
            property       <- #{peek XSelectionRequestEvent, property  } p
            time           <- #{peek XSelectionRequestEvent, time      } p
            return $ SelectionRequest
                        { ev_event_type    = type_
                        , ev_serial        = serial
                        , ev_send_event    = send_event
                        , ev_event_display = display
                        , ev_owner         = owner
                        , ev_requestor     = requestor
                        , ev_selection     = selection
                        , ev_target        = target
                        , ev_property      = property
                        , ev_time          = time
                        }

          -------------------------
          -- PropertyEvent
          -------------------------
          | type_ == propertyNotify -> do
            window <- #{peek XPropertyEvent, window } p
            atom   <- #{peek XPropertyEvent, atom   } p
            time   <- #{peek XPropertyEvent, time   } p
            state  <- #{peek XPropertyEvent, state  } p
            return $ PropertyEvent
                        { ev_event_type    = type_
                        , ev_serial        = serial
                        , ev_send_event    = send_event
                        , ev_event_display = display
                        , ev_window        = window
                        , ev_atom          = atom
                        , ev_time          = time
                        , ev_propstate     = state
                        }

          -------------------------
          -- ExposeEvent
          -------------------------
          | type_ == expose -> do
            window <- #{peek XExposeEvent, window } p
            x      <- #{peek XExposeEvent, x      } p
            y      <- #{peek XExposeEvent, y      } p
            width  <- #{peek XExposeEvent, width  } p
            height <- #{peek XExposeEvent, height } p
            count  <- #{peek XExposeEvent, count  } p
            return $ ExposeEvent
                        { ev_event_type    = type_
                        , ev_serial        = serial
                        , ev_send_event    = send_event
                        , ev_event_display = display
                        , ev_window        = window
                        , ev_x             = x
                        , ev_y             = y
                        , ev_width         = width
                        , ev_height        = height
                        , ev_count         = count
                        }

          -------------------------
          -- ClientMessageEvent
          -------------------------
          | type_ == clientMessage -> do
            window       <- #{peek XClientMessageEvent, window       } p
            message_type <- #{peek XClientMessageEvent, message_type } p
            format       <- #{peek XClientMessageEvent, format       } p
            let datPtr =    #{ptr  XClientMessageEvent, data } p
            dat          <- case (format::CInt) of
                        8  -> do a <- peekArray 20 datPtr
                                 return $ map fromIntegral (a::[Word8])
                        16 -> do a <- peekArray 10 datPtr
                                 return $ map fromIntegral (a::[Word16])
                        32 -> do a <- peekArray 5 datPtr
                                 return $ map fromIntegral (a::[Word32])
            return $ ClientMessageEvent
                        { ev_event_type    = type_
                        , ev_serial        = serial
                        , ev_send_event    = send_event
                        , ev_event_display = display
                        , ev_window        = window
                        , ev_message_type  = message_type
                        , ev_data          = dat
                        }

          -- We don't handle this event specifically, so return the generic
          -- AnyEvent.
          | otherwise -> do
            window <- #{peek XAnyEvent, window} p
            return $ AnyEvent
                        { ev_event_type    = type_
                        , ev_serial        = serial
                        , ev_send_event    = send_event
                        , ev_event_display = display
                        , ev_window        = window
                        }

data WindowChanges = WindowChanges
                        { wc_x :: CInt
                        , wc_y :: CInt
                        , wc_width :: CInt
                        , wc_height:: CInt
                        , wc_border_width :: CInt
                        , wc_sibling :: Window
                        , wc_stack_mode :: CInt
                        }

instance Storable WindowChanges where
    sizeOf _ = #{size XWindowChanges}

    -- I really hope this is right:
    alignment _ = alignment (undefined :: CInt)

    poke p wc = do
        #{poke XWindowChanges, x           } p $ wc_x wc
        #{poke XWindowChanges, y           } p $ wc_y wc
        #{poke XWindowChanges, width       } p $ wc_width wc
        #{poke XWindowChanges, height      } p $ wc_height wc
        #{poke XWindowChanges, border_width} p $ wc_border_width wc
        #{poke XWindowChanges, sibling     } p $ wc_sibling wc
        #{poke XWindowChanges, stack_mode  } p $ wc_stack_mode wc
        
    peek p = return WindowChanges
                `ap` (#{peek XWindowChanges, x} p)
                `ap` (#{peek XWindowChanges, y} p)
                `ap` (#{peek XWindowChanges, width} p)
                `ap` (#{peek XWindowChanges, height} p)
                `ap` (#{peek XWindowChanges, border_width} p)
                `ap` (#{peek XWindowChanges, sibling} p)
                `ap` (#{peek XWindowChanges, stack_mode} p)

--
-- Some extra constants
--

none :: XID
none = #{const None}

anyButton :: Button
anyButton = #{const AnyButton}

anyKey :: KeyCode
anyKey = toEnum #{const AnyKey}

currentTime :: Time
currentTime = #{const CurrentTime}

--
-- The use of Int rather than CInt isn't 64 bit clean.
--

foreign import ccall unsafe "XlibExtras.h XConfigureWindow"
    xConfigureWindow :: Display -> Window -> CULong -> Ptr WindowChanges -> IO CInt

foreign import ccall unsafe "XlibExtras.h XKillClient"
    killClient :: Display -> Window -> IO CInt

configureWindow :: Display -> Window -> CULong -> WindowChanges -> IO ()
configureWindow d w m c = do
    with c (xConfigureWindow d w m)
    return ()

foreign import ccall unsafe "XlibExtras.h XFree"
    xFree :: Ptr a -> IO CInt

foreign import ccall unsafe "XlibExtras.h XQueryTree"
    xQueryTree :: Display -> Window -> Ptr Window -> Ptr Window -> Ptr (Ptr Window) -> Ptr CInt -> IO Status

queryTree :: Display -> Window -> IO (Window, Window, [Window])
queryTree d w =
    alloca $ \root_return ->
    alloca $ \parent_return ->
    alloca $ \children_return ->
    alloca $ \nchildren_return -> do
        xQueryTree d w root_return parent_return children_return nchildren_return
        p <- peek children_return
        n <- fmap fromIntegral $ peek nchildren_return
        ws <- peekArray n p
        xFree p
        liftM3 (,,) (peek root_return) (peek parent_return) (return ws)

-- TODO: this data type is incomplete wrt. the C struct
data WindowAttributes = WindowAttributes
            { wa_x, wa_y, wa_width, wa_height, wa_border_width :: CInt
            , wa_map_state :: CInt
            , wa_override_redirect :: Bool
            }

-- 
-- possible map_states'
--
waIsUnmapped, waIsUnviewable, waIsViewable :: CInt
waIsUnmapped   = fromIntegral ( #{const IsUnmapped}   :: CInt )  -- 0
waIsUnviewable = fromIntegral ( #{const IsUnviewable} :: CInt )  -- 1
waIsViewable   = fromIntegral ( #{const IsViewable}   :: CInt )  -- 2

instance Storable WindowAttributes where
    -- this might be incorrect
    alignment _ = alignment (undefined :: CInt)
    sizeOf _ = #{size XWindowAttributes}
    peek p = return WindowAttributes
                `ap` (#{peek XWindowAttributes, x                } p)
                `ap` (#{peek XWindowAttributes, y                } p)
                `ap` (#{peek XWindowAttributes, width            } p)
                `ap` (#{peek XWindowAttributes, height           } p)
                `ap` (#{peek XWindowAttributes, border_width     } p)
                `ap` (#{peek XWindowAttributes, map_state        } p)
                `ap` (#{peek XWindowAttributes, override_redirect} p)
    poke p wa = do
        #{poke XWindowAttributes, x                } p $ wa_x wa
        #{poke XWindowAttributes, y                } p $ wa_y wa
        #{poke XWindowAttributes, width            } p $ wa_width wa
        #{poke XWindowAttributes, height           } p $ wa_height wa
        #{poke XWindowAttributes, border_width     } p $ wa_border_width wa
        #{poke XWindowAttributes, map_state        } p $ wa_map_state wa
        #{poke XWindowAttributes, override_redirect} p $ wa_override_redirect wa

foreign import ccall unsafe "XlibExtras.h XGetWindowAttributes"
    xGetWindowAttributes :: Display -> Window -> Ptr (WindowAttributes) -> IO Status

getWindowAttributes :: Display -> Window -> IO WindowAttributes
getWindowAttributes d w = alloca $ \p -> do
    xGetWindowAttributes d w p
    peek p

-- | interface to the X11 library function @XChangeWindowAttributes()@.
foreign import ccall unsafe "XlibExtras.h XChangeWindowAttributes"
        changeWindowAttributes :: Display -> Window -> AttributeMask -> Ptr SetWindowAttributes -> IO ()

-- | Run an action with the server
withServer :: Display -> IO () -> IO ()
withServer dpy f = do
    grabServer dpy
    f
    ungrabServer dpy

data TextProperty = TextProperty {
        tp_value    :: CString,
        tp_encoding :: Atom,
        tp_format   :: CInt,
        tp_nitems   :: #{type unsigned long}
    }

instance Storable TextProperty where
    sizeOf    _ = #{size XTextProperty}
    alignment _ = alignment (undefined :: #{type unsigned long})
    peek p = TextProperty `fmap` #{peek XTextProperty, value   } p
                          `ap`   #{peek XTextProperty, encoding} p
                          `ap`   #{peek XTextProperty, format  } p
                          `ap`   #{peek XTextProperty, nitems  } p
    poke p (TextProperty val enc fmt nitems) = do
        #{poke XTextProperty, value   } p val
        #{poke XTextProperty, encoding} p enc
        #{poke XTextProperty, format  } p fmt
        #{poke XTextProperty, nitems  } p nitems

foreign import ccall unsafe "XlibExtras.h XGetTextProperty"
    xGetTextProperty :: Display -> Window -> Ptr TextProperty -> Atom -> IO Status

getTextProperty :: Display -> Window -> Atom -> IO TextProperty
getTextProperty d w a =
    alloca $ \textp -> do
        throwIf (0==) (const "getTextProperty") $ xGetTextProperty d w textp a
        peek textp

foreign import ccall unsafe "XlibExtras.h XwcTextPropertyToTextList"
    xwcTextPropertyToTextList :: Display -> Ptr TextProperty -> Ptr (Ptr CWString) -> Ptr CInt -> IO CInt

wcTextPropertyToTextList :: Display -> TextProperty -> IO [String]
wcTextPropertyToTextList d prop =
    alloca    $ \listp  ->
    alloca    $ \countp ->
    with prop $ \propp  -> do
        throwIf (success>) (const "wcTextPropertyToTextList") $
            xwcTextPropertyToTextList d propp listp countp
        count <- peek countp
        list  <- peek listp
        texts <- flip mapM [0..fromIntegral count - 1] $ \i ->
                     peekElemOff list i >>= peekCWString
        wcFreeStringList list
        return texts

foreign import ccall unsafe "XlibExtras.h XwcFreeStringList"
    wcFreeStringList :: Ptr CWString -> IO ()

newtype FontSet = FontSet (Ptr FontSet)
    deriving (Eq, Ord, Show)

foreign import ccall unsafe "XlibExtras.h XCreateFontSet"
    xCreateFontSet :: Display -> CString -> Ptr (Ptr CString) -> Ptr CInt -> Ptr CString -> IO (Ptr FontSet)

createFontSet :: Display -> String -> IO ([String], String, FontSet)
createFontSet d fn =
    withCString fn $ \fontp  ->
    alloca         $ \listp  ->
    alloca         $ \countp ->
    alloca         $ \defp   -> do
        fs      <- throwIfNull "createFontSet" $
                       xCreateFontSet d fontp listp countp defp
        count   <- peek countp
        list    <- peek listp
        missing <- flip mapM [0..fromIntegral count - 1] $ \i ->
                       peekElemOff list i >>= peekCString
        def     <- peek defp >>= peekCString
        freeStringList list
        return (missing, def, FontSet fs)

foreign import ccall unsafe "XlibExtras.h XFreeStringList"
    freeStringList :: Ptr CString -> IO ()

foreign import ccall unsafe "XlibExtras.h XFreeFontSet"
    freeFontSet :: Display -> FontSet -> IO ()

foreign import ccall unsafe "XlibExtras.h XwcTextExtents"
    xwcTextExtents :: FontSet -> CWString -> CInt -> Ptr Rectangle -> Ptr Rectangle -> IO CInt

wcTextExtents :: FontSet -> String -> (Rectangle, Rectangle)
wcTextExtents fs text = unsafePerformIO $
    withCWStringLen text $ \(textp, len) ->
    alloca               $ \inkp          ->
    alloca               $ \logicalp      -> do
        xwcTextExtents fs textp (fromIntegral len) inkp logicalp
        (,) `fmap` peek inkp `ap` peek logicalp

foreign import ccall unsafe "XlibExtras.h XwcDrawString"
    xwcDrawString :: Display -> Drawable -> FontSet -> GC -> Position -> Position -> CWString -> CInt -> IO ()

wcDrawString :: Display -> Drawable -> FontSet -> GC -> Position -> Position -> String -> IO ()
wcDrawString d w fs gc x y =
    flip withCWStringLen $ \(s, len) ->
        xwcDrawString d w fs gc x y s (fromIntegral len)

foreign import ccall unsafe "XlibExtras.h XwcDrawImageString"
    xwcDrawImageString :: Display -> Drawable -> FontSet -> GC -> Position -> Position -> CWString -> CInt -> IO ()

wcDrawImageString :: Display -> Drawable -> FontSet -> GC -> Position -> Position -> String -> IO ()
wcDrawImageString d w fs gc x y =
    flip withCWStringLen $ \(s, len) ->
        xwcDrawImageString d w fs gc x y s (fromIntegral len)

foreign import ccall unsafe "XlibExtras.h XwcTextEscapement"
    xwcTextEscapement :: FontSet -> CWString -> CInt -> IO Int32

wcTextEscapement :: FontSet -> String -> Int32
wcTextEscapement font_set string = unsafePerformIO $
    withCWStringLen string $ \ (c_string, len) ->
    xwcTextEscapement font_set c_string (fromIntegral len)

foreign import ccall unsafe "XlibExtras.h XFetchName"
    xFetchName :: Display -> Window -> Ptr CString -> IO Status

fetchName :: Display -> Window -> IO (Maybe String)
fetchName d w = alloca $ \p -> do
    xFetchName d w p
    cstr <- peek p
    if cstr == nullPtr
        then return Nothing
        else do
            str <- peekCString cstr
            xFree cstr
            return $ Just str

foreign import ccall unsafe "XlibExtras.h XGetTransientForHint"
    xGetTransientForHint :: Display -> Window -> Ptr Window -> IO Status

getTransientForHint :: Display -> Window -> IO (Maybe Window)
getTransientForHint d w = alloca $ \wp -> do
    status <- xGetTransientForHint d w wp
    if status == 0
        then return Nothing
        else Just `liftM` peek wp

------------------------------------------------------------------------
-- setWMProtocols :: Display -> Window -> [Atom] -> IO ()

{-
setWMProtocols :: Display -> Window -> [Atom] -> IO ()
setWMProtocols display w protocols =
    withArray protocols $ \ protocol_array ->
    xSetWMProtocols display w protocol_array (length protocols)
foreign import ccall unsafe "HsXlib.h XSetWMProtocols"
    xSetWMProtocols :: Display -> Window -> Ptr Atom -> CInt -> IO ()
-}

-- | The XGetWMProtocols function returns the list of atoms
-- stored in the WM_PROTOCOLS property on the specified win­
-- dow.  These atoms describe window manager protocols in
-- which the owner of this window is willing to participate.
-- If the property exists, is of type ATOM, is of format 32,
-- and the atom WM_PROTOCOLS can be interned, XGetWMProtocols
-- sets the protocols_return argument to a list of atoms,
-- sets the count_return argument to the number of elements
-- in the list, and returns a nonzero status.  Otherwise, it
-- sets neither of the return arguments and returns a zero
-- status.  To release the list of atoms, use XFree.
--
getWMProtocols :: Display -> Window -> IO [Atom]
getWMProtocols display w = do
    alloca $ \atom_ptr_ptr ->
      alloca $ \count_ptr -> do

       st <- xGetWMProtocols display w atom_ptr_ptr count_ptr
       if st == 0
            then return []
            else do sz       <- peek count_ptr
                    atom_ptr <- peek atom_ptr_ptr
                    atoms    <- peekArray (fromIntegral sz) atom_ptr
                    xFree atom_ptr
                    return atoms

foreign import ccall unsafe "HsXlib.h XGetWMProtocols"
    xGetWMProtocols :: Display -> Window -> Ptr (Ptr Atom) -> Ptr CInt -> IO Status


------------------------------------------------------------------------
-- Creating events

setEventType :: XEventPtr -> EventType -> IO ()
setEventType = #{poke XEvent,type}

{-
typedef struct {
        int type;               /* SelectionNotify */
        unsigned long serial;   /* # of last request processed by server */
        Bool send_event;        /* true if this came from a SendEvent request */
        Display *display;       /* Display the event was read from */
        Window requestor;
        Atom selection;
        Atom target;
        Atom property;          /* atom or None */
        Time time;
} XSelectionEvent;
-}

setSelectionNotify :: XEventPtr -> Window -> Atom -> Atom -> Atom -> Time -> IO ()
setSelectionNotify p requestor selection target property time = do
    setEventType p selectionNotify
    #{poke XSelectionEvent, requestor}    p requestor
    #{poke XSelectionEvent, selection}    p selection
    #{poke XSelectionEvent, target}       p target
    #{poke XSelectionEvent, property}     p property
    #{poke XSelectionEvent, time}         p time

-- hacky way to set up an XClientMessageEvent
-- Should have a Storable instance for XEvent/Event?
setClientMessageEvent :: XEventPtr -> Window -> Atom -> CInt -> Atom -> Time -> IO ()
setClientMessageEvent p window message_type format l_0_ l_1_ = do
    #{poke XClientMessageEvent, window}         p window
    #{poke XClientMessageEvent, message_type}   p message_type
    #{poke XClientMessageEvent, format}         p format
    let datap = #{ptr XClientMessageEvent, data} p :: Ptr CLong
    poke        datap   (fromIntegral l_0_) -- does this work?
    pokeElemOff datap 1 (fromIntegral l_1_)

    return ()

setConfigureEvent :: XEventPtr -> Window -> Window -> CInt -> CInt -> CInt -> CInt -> CInt -> Window -> Bool -> IO ()
setConfigureEvent p ev win x y w h bw abv org = do
    #{poke XConfigureEvent, event            } p ev
    #{poke XConfigureEvent, window           } p win
    #{poke XConfigureEvent, x                } p x
    #{poke XConfigureEvent, y                } p y
    #{poke XConfigureEvent, width            } p w
    #{poke XConfigureEvent, height           } p h
    #{poke XConfigureEvent, border_width     } p bw
    #{poke XConfigureEvent, above            } p abv
    #{poke XConfigureEvent, override_redirect} p (if org then 1 else 0 :: CInt)


{-
       typedef struct {
            int type;                /* ClientMessage */
            unsigned long serial;    /* # of last request processed by server */
            Bool send_event;         /* true if this came from a SendEvent request */
            Display *display;        /* Display the event was read from */
            Window window;
            Atom message_type;
            int format;
            union {
                 char b[20];
                 short s[10];
                 long l[5];
                    } data;
       } XClientMessageEvent;

-}

------------------------------------------------------------------------
-- XErrorEvents
-- 
-- I'm too lazy to write the binding
--

foreign import ccall unsafe "XlibExtras.h x11_extras_set_error_handler"
    xSetErrorHandler   :: IO ()

-- | refreshKeyboardMapping.  TODO Remove this binding when the fix has been commited to
-- X11
refreshKeyboardMapping :: Event -> IO ()
refreshKeyboardMapping ev@(MappingNotifyEvent {ev_event_display = (Display d)})
 = allocaBytes #{size XMappingEvent} $ \p -> do
    #{poke XMappingEvent, type          } p $ ev_event_type    ev
    #{poke XMappingEvent, serial        } p $ ev_serial        ev
    #{poke XMappingEvent, send_event    } p $ ev_send_event    ev
    #{poke XMappingEvent, display       } p $ d
    #{poke XMappingEvent, window        } p $ ev_window        ev
    #{poke XMappingEvent, request       } p $ ev_request       ev
    #{poke XMappingEvent, first_keycode } p $ ev_first_keycode ev
    #{poke XMappingEvent, count         } p $ ev_count         ev
    xRefreshKeyboardMapping p
    return ()
refreshKeyboardMapping _ = return ()

foreign import ccall unsafe "XlibExtras.h XRefreshKeyboardMapping"
    xRefreshKeyboardMapping :: Ptr () -> IO CInt

-- Properties

anyPropertyType :: Atom
anyPropertyType = #{const AnyPropertyType}

foreign import ccall unsafe "XlibExtras.h XChangeProperty"
    xChangeProperty :: Display -> Window -> Atom -> Atom -> CInt -> CInt -> Ptr CUChar -> CInt -> IO Status

foreign import ccall unsafe "XlibExtras.h XGetWindowProperty"
    xGetWindowProperty :: Display -> Window -> Atom -> CLong -> CLong -> Bool -> Atom -> Ptr Atom -> Ptr CInt -> Ptr CULong -> Ptr CULong -> Ptr (Ptr CUChar) -> IO Status

rawGetWindowProperty :: Storable a => Int -> Display -> Atom -> Window -> IO (Maybe [a])
rawGetWindowProperty bits d atom w =
    alloca $ \actual_type_return ->
    alloca $ \actual_format_return ->
    alloca $ \nitems_return ->
    alloca $ \bytes_after_return ->
    alloca $ \prop_return -> do
        xGetWindowProperty d w atom 0 0xFFFFFFFF False anyPropertyType
                           actual_type_return
                           actual_format_return
                           nitems_return
                           bytes_after_return
                           prop_return

        prop_ptr      <- peek prop_return
        actual_format <- fromIntegral `liftM` peek actual_format_return
        nitems        <- fromIntegral `liftM` peek nitems_return
        getprop prop_ptr nitems actual_format
  where
    getprop prop_ptr nitems actual_format
        | actual_format == 0    = return Nothing -- Property not found
        | actual_format /= bits = xFree prop_ptr >> return Nothing
        | otherwise = do
            retval <- peekArray nitems (castPtr prop_ptr)
            xFree prop_ptr
            return $ Just retval

getWindowProperty8 :: Display -> Atom -> Window -> IO (Maybe [Word8])
getWindowProperty8 = rawGetWindowProperty 8

getWindowProperty16 :: Display -> Atom -> Window -> IO (Maybe [Word16])
getWindowProperty16 = rawGetWindowProperty 16

getWindowProperty32 :: Display -> Atom -> Window -> IO (Maybe [Word32])
getWindowProperty32 = rawGetWindowProperty 32

-- this assumes bytes are 8 bits.  I hope X isn't more portable than that :(

changeProperty8 :: Display -> Window -> Atom -> Atom -> CInt -> [Word8] -> IO ()
changeProperty8 dpy w prop typ mode dat =
    withArrayLen dat $ \ len ptr -> do
        xChangeProperty dpy w prop typ 8 mode (castPtr ptr) (fromIntegral len)
        return ()

changeProperty16 :: Display -> Window -> Atom -> Atom -> CInt -> [Word16] -> IO ()
changeProperty16 dpy w prop typ mode dat =
    withArrayLen dat $ \ len ptr -> do
        xChangeProperty dpy w prop typ 16 mode (castPtr ptr) (fromIntegral len)
        return ()

changeProperty32 :: Display -> Window -> Atom -> Atom -> CInt -> [Word32] -> IO ()
changeProperty32 dpy w prop typ mode dat =
    withArrayLen dat $ \ len ptr -> do
        xChangeProperty dpy w prop typ 32 mode (castPtr ptr) (fromIntegral len)
        return ()

propModeReplace, propModePrepend, propModeAppend :: CInt
propModeReplace = #{const PropModeReplace}
propModePrepend = #{const PropModePrepend}
propModeAppend = #{const PropModeAppend}

-- Windows

foreign import ccall unsafe "XlibExtras.h XUnmapWindow"
    xUnmapWindow :: Display -> Window -> IO CInt

unmapWindow :: Display -> Window -> IO ()
unmapWindow d w = xUnmapWindow d w >> return ()

------------------------------------------------------------------------
-- Size hints

data SizeHints = SizeHints
                   { sh_min_size     :: Maybe (Dimension, Dimension)
                   , sh_max_size     :: Maybe (Dimension, Dimension)
                   , sh_resize_inc   :: Maybe (Dimension, Dimension)
                   , sh_aspect       :: Maybe ((Dimension, Dimension), (Dimension, Dimension))
                   , sh_base_size    :: Maybe (Dimension, Dimension)
                   , sh_win_gravity  :: Maybe (BitGravity)
                   }

pMinSizeBit, pMaxSizeBit, pResizeIncBit, pAspectBit, pBaseSizeBit, pWinGravityBit :: Int
pMinSizeBit    = 4
pMaxSizeBit    = 5
pResizeIncBit  = 6
pAspectBit     = 7
pBaseSizeBit   = 8
pWinGravityBit = 9

instance Storable SizeHints where
    alignment _ = alignment (undefined :: CInt)
    sizeOf _ = #{size XSizeHints}

    poke p sh = do
      let whenSet f x = maybe (return ()) x (f sh)
      let pokeFlag b = do flag <- #{peek XSizeHints, flags} p :: IO CLong
                          #{poke XSizeHints, flags} p (setBit flag b)
      #{poke XSizeHints, flags} p (0 :: CLong)
      whenSet sh_min_size $ \(w, h) -> do
        pokeFlag pMinSizeBit
        #{poke XSizeHints, min_width   } p w
        #{poke XSizeHints, min_height  } p h
      whenSet sh_max_size $ \(w, h) -> do
        pokeFlag pMaxSizeBit
        #{poke XSizeHints, max_width   } p w
        #{poke XSizeHints, max_height  } p h
      whenSet sh_resize_inc $ \(w, h) -> do
        pokeFlag pResizeIncBit
        #{poke XSizeHints, width_inc   } p w
        #{poke XSizeHints, height_inc  } p w
      whenSet sh_aspect $ \((minx, miny), (maxx, maxy)) -> do
        pokeFlag pAspectBit
        #{poke XSizeHints, min_aspect.x} p minx
        #{poke XSizeHints, min_aspect.y} p miny
        #{poke XSizeHints, max_aspect.x} p maxx
        #{poke XSizeHints, max_aspect.y} p maxy
      whenSet sh_base_size $ \(w, h) -> do
        pokeFlag pBaseSizeBit
        #{poke XSizeHints, base_width  } p w
        #{poke XSizeHints, base_height } p h
      whenSet sh_win_gravity $ \g -> do
        pokeFlag pWinGravityBit
        #{poke XSizeHints, win_gravity } p g

    peek p = do
      flags <- #{peek XSizeHints, flags} p :: IO CLong
      let whenBit n x = if testBit flags n then liftM Just x else return Nothing
      return SizeHints
         `ap` whenBit pMinSizeBit    (do liftM2 (,) (#{peek XSizeHints, min_width  } p)
                                                    (#{peek XSizeHints, min_height } p))
         `ap` whenBit pMaxSizeBit    (do liftM2 (,) (#{peek XSizeHints, max_width  } p)
                                                    (#{peek XSizeHints, max_height } p))
         `ap` whenBit pResizeIncBit  (do liftM2 (,) (#{peek XSizeHints, width_inc  } p)
                                                    (#{peek XSizeHints, height_inc } p))
         `ap` whenBit pAspectBit     (do minx <- #{peek XSizeHints, min_aspect.x} p
                                         miny <- #{peek XSizeHints, min_aspect.y} p
                                         maxx <- #{peek XSizeHints, max_aspect.x} p
                                         maxy <- #{peek XSizeHints, max_aspect.y} p
                                         return ((minx, miny), (maxx, maxy)))
         `ap` whenBit pBaseSizeBit   (do liftM2 (,) (#{peek XSizeHints, base_width } p)
                                                    (#{peek XSizeHints, base_height} p))
         `ap` whenBit pWinGravityBit (#{peek XSizeHints, win_gravity} p)


foreign import ccall unsafe "XlibExtras.h XGetWMNormalHints"
    xGetWMNormalHints :: Display -> Window -> Ptr SizeHints -> Ptr CLong -> IO Status

getWMNormalHints :: Display -> Window -> IO SizeHints
getWMNormalHints d w
    = alloca $ \sh -> do
        alloca $ \supplied_return -> do
          -- what's the purpose of supplied_return?
          xGetWMNormalHints d w sh supplied_return
          peek sh


data ClassHint = ClassHint
                        { resName  :: String
                        , resClass :: String
                        }

getClassHint :: Display -> Window -> IO ClassHint
getClassHint d w =  allocaBytes (#{size XClassHint}) $ \ p -> do
    s <- xGetClassHint d w p
    if s /= 0 -- returns a nonzero status on success
        then do
            res_name_p <- #{peek XClassHint, res_name} p
            res_class_p <- #{peek XClassHint, res_class} p
            res <- liftM2 ClassHint (peekCString res_name_p) (peekCString res_class_p)
            xFree res_name_p
            xFree res_class_p
            return res
        else return $ ClassHint "" ""

foreign import ccall unsafe "XlibExtras.h XGetClassHint"
    xGetClassHint :: Display -> Window -> Ptr ClassHint -> IO Status

------------------------------------------------------------------------
-- WM Hints

-- These are the documented values for a window's "WM State", set, for example,
-- in wmh_initial_state, below. Note, you may need to play games with
-- fromIntegral and/or fromEnum.
withdrawnState = #{const WithdrawnState} :: Int
normalState    = #{const NormalState}    :: Int
iconicState    = #{const IconicState}    :: Int

-- The following values are the documented bit positions on XWMHints's flags field.
-- Use testBit, setBit, and clearBit to manipulate the field.
inputHintBit        = 0 :: Int
stateHintBit        = 1 :: Int
iconPixmapHintBit   = 2 :: Int
iconWindowHintBit   = 3 :: Int
iconPositionHintBit = 4 :: Int
iconMaskHintBit     = 5 :: Int
windowGroupHintBit  = 6 :: Int
urgencyHintBit      = 8 :: Int

-- The following bitmask tests for the presence of all bits except for the
-- urgencyHintBit.
allHintsBitmask    = #{const AllHints} :: CLong

data WMHints = WMHints
                 { wmh_flags         :: CLong
                 , wmh_input         :: Bool
                 , wmh_initial_state :: CInt
                 , wmh_icon_pixmap   :: Pixmap
                 , wmh_icon_window   :: Window
                 , wmh_icon_x        :: CInt
                 , wmh_icon_y        :: CInt
                 , wmh_icon_mask     :: Pixmap
                 , wmh_window_group  :: XID
                 }

instance Storable WMHints where
    -- should align to the alignment of the largest type
    alignment _ = alignment (undefined :: CLong)
    sizeOf _ = #{size XWMHints}

    peek p = return WMHints
                `ap` #{peek XWMHints, flags}         p
                `ap` #{peek XWMHints, input}         p
                `ap` #{peek XWMHints, initial_state} p
                `ap` #{peek XWMHints, icon_pixmap}   p
                `ap` #{peek XWMHints, icon_window}   p
                `ap` #{peek XWMHints, icon_x}        p
                `ap` #{peek XWMHints, icon_x}        p
                `ap` #{peek XWMHints, icon_mask}     p
                `ap` #{peek XWMHints, window_group}  p

    poke p wmh = do
        #{poke XWMHints, flags}         p $ wmh_flags         wmh
        #{poke XWMHints, input}         p $ wmh_input         wmh
        #{poke XWMHints, initial_state} p $ wmh_initial_state wmh
        #{poke XWMHints, icon_pixmap}   p $ wmh_icon_pixmap   wmh
        #{poke XWMHints, icon_window}   p $ wmh_icon_window   wmh
        #{poke XWMHints, icon_x}        p $ wmh_icon_x        wmh
        #{poke XWMHints, icon_y}        p $ wmh_icon_y        wmh
        #{poke XWMHints, icon_mask}     p $ wmh_icon_mask     wmh
        #{poke XWMHints, window_group}  p $ wmh_window_group  wmh

foreign import ccall unsafe "XlibExtras.h XGetWMHints"
    xGetWMHints :: Display -> Window -> IO (Ptr WMHints)

getWMHints :: Display -> Window -> IO WMHints
getWMHints dpy w = xGetWMHints dpy w >>= peek

foreign import ccall unsafe "XlibExtras.h XAllocWMHints"
    xAllocWMHints :: IO (Ptr WMHints)

foreign import ccall unsafe "XlibExtras.h XSetWMHints"
    xSetWMHints :: Display -> Window -> Ptr WMHints -> IO Status

setWMHints :: Display -> Window -> WMHints -> IO Status
setWMHints dpy w wmh = do
    p_wmh <- xAllocWMHints
    poke p_wmh wmh
    res <- xSetWMHints dpy w p_wmh
    xFree p_wmh
    return res

------------------------------------------------------------------------
-- Keysym Macros
--
-- Which we have to wrap in functions, then bind here.

foreign import ccall unsafe "XlibExtras.h x11_extras_IsCursorKey"
    isCursorKey :: KeySym -> Bool
foreign import ccall unsafe "XlibExtras.h x11_extras_IsFunctionKey"
    isFunctionKey :: KeySym -> Bool
foreign import ccall unsafe "XlibExtras.h x11_extras_IsKeypadKey"
    isKeypadKey :: KeySym -> Bool
foreign import ccall unsafe "XlibExtras.h x11_extras_IsMiscFunctionKey"
    isMiscFunctionKey :: KeySym -> Bool
foreign import ccall unsafe "XlibExtras.h x11_extras_IsModifierKey"
    isModifierKey :: KeySym -> Bool
foreign import ccall unsafe "XlibExtras.h x11_extras_IsPFKey"
    isPFKey :: KeySym -> Bool
foreign import ccall unsafe "XlibExtras.h x11_extras_IsPrivateKeypadKey"
    isPrivateKeypadKey :: KeySym -> Bool

-- FIXME: X11 doesn't have a Read instance for Rectangle, so we include one for now.
{-* Generated by DrIFT : Look, but Don't Touch. *-}
instance Read Rectangle where
    readsPrec d input =
          readParen (d > 9)
          (\ inp ->
           [((Rectangle aa ab ac ad) , rest) | ("Rectangle" , inp) <- lex inp
        , ("{" , inp) <- lex inp , ("rect_x" , inp) <- lex inp ,
        ("=" , inp) <- lex inp , (aa , inp) <- readsPrec 10 inp ,
        ("," , inp) <- lex inp , ("rect_y" , inp) <- lex inp ,
        ("=" , inp) <- lex inp , (ab , inp) <- readsPrec 10 inp ,
        ("," , inp) <- lex inp , ("rect_width" , inp) <- lex inp ,
        ("=" , inp) <- lex inp , (ac , inp) <- readsPrec 10 inp ,
        ("," , inp) <- lex inp , ("rect_height" , inp) <- lex inp ,
        ("=" , inp) <- lex inp , (ad , inp) <- readsPrec 10 inp ,
        ("}" , rest) <- lex inp])
          input

-------------------------------------------------------------------------------
-- Selections
--
foreign import ccall unsafe "HsXlib.h XSetSelectionOwner"
    xSetSelectionOwner :: Display -> Atom -> Window -> Time -> IO ()

foreign import ccall unsafe "HsXlib.h XGetSelectionOwner"
    xGetSelectionOwner :: Display -> Atom -> IO Window

foreign import ccall unsafe "HsXlib.h XConvertSelection"
    xConvertSelection :: Display -> Atom -> Atom -> Atom -> Window -> Time -> IO ()
