{-# LANGUAGE DeriveDataTypeable #-}
-----------------------------------------------------------------------------
-- |
-- Module      : Graphics.X11.Xlib.Extras
-- Copyright   : 2007 (c) Spencer Janssen
-- License     : BSD3-style (see LICENSE)
-- Stability   : experimental
--
-----------------------------------------------------------------------------
--
-- missing functionality from the X11 library
--

module Graphics.X11.Xlib.Extras (
  module Graphics.X11.Xlib.Extras,
  module Graphics.X11.Xlib.Internal
  ) where

import Data.Maybe
import Data.Typeable ( Typeable )
import Graphics.X11.Xrandr
import Graphics.X11.XScreenSaver
import Graphics.X11.Xlib
import Graphics.X11.Xlib.Internal
import Graphics.X11.Xlib.Types
import Foreign (Storable, Ptr, peek, poke, pokeArray, peekElemOff, peekByteOff, pokeByteOff, peekArray, throwIfNull, nullPtr, sizeOf, alignment, alloca, with, throwIf, Word8, Word16, #{type unsigned long}, Int32, plusPtr, castPtr, withArrayLen, setBit, testBit, allocaBytes, FunPtr)
import Foreign.C.Types
import Foreign.C.String
import Control.Monad

import System.IO.Unsafe

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
    | SelectionClear
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_window                :: !Window
        , ev_selection             :: !Atom
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
    | RRScreenChangeNotifyEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_window                :: !Window
        , ev_root                  :: !Window
        , ev_timestamp             :: !Time
        , ev_config_timestamp      :: !Time
        , ev_size_index            :: !SizeID
        , ev_subpixel_order        :: !SubpixelOrder
        , ev_rotation              :: !Rotation
        , ev_width                 :: !CInt
        , ev_height                :: !CInt
        , ev_mwidth                :: !CInt
        , ev_mheight               :: !CInt
        }
    | RRNotifyEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_window                :: !Window
        , ev_subtype               :: !CInt
        }
    | RRCrtcChangeNotifyEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_window                :: !Window
        , ev_subtype               :: !CInt
        , ev_crtc                  :: !RRCrtc
        , ev_rr_mode               :: !RRMode
        , ev_rotation              :: !Rotation
        , ev_x                     :: !CInt
        , ev_y                     :: !CInt
        , ev_rr_width              :: !CUInt
        , ev_rr_height             :: !CUInt
        }
    | RROutputChangeNotifyEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_window                :: !Window
        , ev_subtype               :: !CInt
        , ev_output                :: !RROutput
        , ev_crtc                  :: !RRCrtc
        , ev_rr_mode               :: !RRMode
        , ev_rotation              :: !Rotation
        , ev_connection            :: !Connection
        , ev_subpixel_order        :: !SubpixelOrder
        }
    | RROutputPropertyNotifyEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_window                :: !Window
        , ev_subtype               :: !CInt
        , ev_output                :: !RROutput
        , ev_property              :: !Atom
        , ev_timestamp             :: !Time
        , ev_rr_state              :: !CInt
        }
    | ScreenSaverNotifyEvent
        { ev_event_type            :: !EventType
        , ev_serial                :: !CULong
        , ev_send_event            :: !Bool
        , ev_event_display         :: Display
        , ev_window                :: !Window
        , ev_root                  :: !Window
        , ev_ss_state              :: !XScreenSaverState
        , ev_ss_kind               :: !XScreenSaverKind
        , ev_forced                :: !Bool
        , ev_time                  :: !Time
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
    , (screenSaverNotify    , "ScreenSaverNotify")
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
    rrData     <- xrrQueryExtension display
    let rrHasExtension = isJust rrData
    let rrEventBase    = fromIntegral $ fst $ fromMaybe (0, 0) rrData
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
            keycode     <- (#{peek XKeyEvent, keycode   } p) :: IO CUInt
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
                        , ev_keycode       = fromIntegral keycode
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
          -- SelectionClearEvent:
          -------------------------
          | type_ == selectionClear -> do
            window <- #{peek XSelectionClearEvent, window    } p
            atom   <- #{peek XSelectionClearEvent, selection } p
            time   <- #{peek XSelectionClearEvent, time      } p
            return $ SelectionClear
                        { ev_event_type    = type_
                        , ev_serial        = serial
                        , ev_send_event    = send_event
                        , ev_event_display = display
                        , ev_window        = window
                        , ev_selection     = atom
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
                                 return $ map fromIntegral (a::[CLong])
                        _  -> error "X11.Extras.clientMessage: illegal value"
            return $ ClientMessageEvent
                        { ev_event_type    = type_
                        , ev_serial        = serial
                        , ev_send_event    = send_event
                        , ev_event_display = display
                        , ev_window        = window
                        , ev_message_type  = message_type
                        , ev_data          = dat
                        }

          -------------------------
          -- RRScreenChangeNotify
          -------------------------
          | rrHasExtension &&
            type_ == rrEventBase + rrScreenChangeNotify -> do
            window           <- #{peek XRRScreenChangeNotifyEvent, window           } p
            root             <- #{peek XRRScreenChangeNotifyEvent, root             } p
            timestamp        <- #{peek XRRScreenChangeNotifyEvent, timestamp        } p
            config_timestamp <- #{peek XRRScreenChangeNotifyEvent, config_timestamp } p
            size_index       <- #{peek XRRScreenChangeNotifyEvent, config_timestamp } p
            subpixel_order   <- #{peek XRRScreenChangeNotifyEvent, subpixel_order   } p
            rotation         <- #{peek XRRScreenChangeNotifyEvent, rotation         } p
            width            <- #{peek XRRScreenChangeNotifyEvent, width            } p
            height           <- #{peek XRRScreenChangeNotifyEvent, height           } p
            mwidth           <- #{peek XRRScreenChangeNotifyEvent, mwidth           } p
            mheight          <- #{peek XRRScreenChangeNotifyEvent, mheight          } p
            return $ RRScreenChangeNotifyEvent
                        { ev_event_type       = type_
                        , ev_serial           = serial
                        , ev_send_event       = send_event
                        , ev_event_display    = display
                        , ev_window           = window
                        , ev_root             = root
                        , ev_timestamp        = timestamp
                        , ev_config_timestamp = config_timestamp
                        , ev_size_index       = size_index
                        , ev_subpixel_order   = subpixel_order
                        , ev_rotation         = rotation
                        , ev_width            = width
                        , ev_height           = height
                        , ev_mwidth           = mwidth
                        , ev_mheight          = mheight
                        }

          -------------------------
          -- RRNotify
          -------------------------
          | rrHasExtension &&
            type_ == rrEventBase + rrNotify -> do
            window   <- #{peek XRRNotifyEvent, window  } p
            subtype  <- #{peek XRRNotifyEvent, subtype } p
            let subtype_ = fromIntegral subtype_
            case () of
                _ | subtype_ == rrNotifyCrtcChange -> do
                    crtc           <- #{peek XRRCrtcChangeNotifyEvent, crtc     } p
                    mode           <- #{peek XRRCrtcChangeNotifyEvent, mode     } p
                    rotation       <- #{peek XRRCrtcChangeNotifyEvent, rotation } p
                    x              <- #{peek XRRCrtcChangeNotifyEvent, x        } p
                    y              <- #{peek XRRCrtcChangeNotifyEvent, y        } p
                    width          <- #{peek XRRCrtcChangeNotifyEvent, width    } p
                    height         <- #{peek XRRCrtcChangeNotifyEvent, height   } p
                    return $ RRCrtcChangeNotifyEvent
                             { ev_event_type    = type_
                             , ev_serial        = serial
                             , ev_send_event    = send_event
                             , ev_event_display = display
                             , ev_window        = window
                             , ev_subtype       = subtype
                             , ev_crtc          = crtc
                             , ev_rr_mode       = mode
                             , ev_rotation      = rotation
                             , ev_x             = x
                             , ev_y             = y
                             , ev_rr_width      = width
                             , ev_rr_height     = height
                             }

                  | subtype_ == rrNotifyOutputChange -> do
                    output         <- #{peek XRROutputChangeNotifyEvent, output         } p
                    crtc           <- #{peek XRROutputChangeNotifyEvent, crtc           } p
                    mode           <- #{peek XRROutputChangeNotifyEvent, mode           } p
                    rotation       <- #{peek XRROutputChangeNotifyEvent, rotation       } p
                    connection     <- #{peek XRROutputChangeNotifyEvent, connection     } p
                    subpixel_order <- #{peek XRROutputChangeNotifyEvent, subpixel_order } p
                    return $ RROutputChangeNotifyEvent
                             { ev_event_type     = type_
                             , ev_serial         = serial
                             , ev_send_event     = send_event
                             , ev_event_display  = display
                             , ev_window         = window
                             , ev_subtype        = subtype
                             , ev_output         = output
                             , ev_crtc           = crtc
                             , ev_rr_mode        = mode
                             , ev_rotation       = rotation
                             , ev_connection     = connection
                             , ev_subpixel_order = subpixel_order
                             }

                  | subtype_ == rrNotifyOutputProperty -> do
                    output         <- #{peek XRROutputPropertyNotifyEvent, output    } p
                    property       <- #{peek XRROutputPropertyNotifyEvent, property  } p
                    timestamp      <- #{peek XRROutputPropertyNotifyEvent, timestamp } p
                    state          <- #{peek XRROutputPropertyNotifyEvent, state     } p
                    return $ RROutputPropertyNotifyEvent
                             { ev_event_type    = type_
                             , ev_serial        = serial
                             , ev_send_event    = send_event
                             , ev_event_display = display
                             , ev_window        = window
                             , ev_subtype       = subtype
                             , ev_output        = output
                             , ev_property      = property
                             , ev_timestamp     = timestamp
                             , ev_rr_state      = state
                             }

                  -- We don't handle this event specifically, so return the generic
                  -- RRNotifyEvent.
                  | otherwise -> do
                    return $ RRNotifyEvent
                                { ev_event_type    = type_
                                , ev_serial        = serial
                                , ev_send_event    = send_event
                                , ev_event_display = display
                                , ev_window        = window
                                , ev_subtype       = subtype
                                }

          -----------------
          -- ScreenSaverNotifyEvent:
          -----------------
          | type_ == screenSaverNotify -> do
            return (ScreenSaverNotifyEvent type_ serial send_event display)
                `ap` (#{peek XScreenSaverNotifyEvent, window     } p )
                `ap` (#{peek XScreenSaverNotifyEvent, root       } p )
                `ap` (#{peek XScreenSaverNotifyEvent, state      } p )
                `ap` (#{peek XScreenSaverNotifyEvent, kind       } p )
                `ap` (#{peek XScreenSaverNotifyEvent, forced     } p )
                `ap` (#{peek XScreenSaverNotifyEvent, time       } p )

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
    _ <- with c (xConfigureWindow d w m)
    return ()

foreign import ccall unsafe "XlibExtras.h XQueryTree"
    xQueryTree :: Display -> Window -> Ptr Window -> Ptr Window -> Ptr (Ptr Window) -> Ptr CInt -> IO Status

queryTree :: Display -> Window -> IO (Window, Window, [Window])
queryTree d w =
    alloca $ \root_return ->
    alloca $ \parent_return ->
    alloca $ \children_return ->
    alloca $ \nchildren_return -> do
        _ <- throwIfZero "queryTree" $ xQueryTree d w root_return parent_return children_return nchildren_return
        p <- peek children_return
        n <- fmap fromIntegral $ peek nchildren_return
        ws <- peekArray n p
        _ <- xFree p
        liftM3 (,,) (peek root_return) (peek parent_return) (return ws)

-- TODO: this data type is incomplete wrt. the C struct
data WindowAttributes = WindowAttributes
            { wa_x, wa_y, wa_width, wa_height, wa_border_width :: CInt
            , wa_colormap :: Colormap
            , wa_map_installed :: Bool
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
                `ap` (#{peek XWindowAttributes, colormap         } p)
                `ap` (#{peek XWindowAttributes, map_installed    } p)
                `ap` (#{peek XWindowAttributes, map_state        } p)
                `ap` (#{peek XWindowAttributes, override_redirect} p)
    poke p wa = do
        #{poke XWindowAttributes, x                } p $ wa_x wa
        #{poke XWindowAttributes, y                } p $ wa_y wa
        #{poke XWindowAttributes, width            } p $ wa_width wa
        #{poke XWindowAttributes, height           } p $ wa_height wa
        #{poke XWindowAttributes, border_width     } p $ wa_border_width wa
        #{poke XWindowAttributes, colormap         } p $ wa_colormap wa
        #{poke XWindowAttributes, map_installed    } p $ wa_map_installed wa
        #{poke XWindowAttributes, map_state        } p $ wa_map_state wa
        #{poke XWindowAttributes, override_redirect} p $ wa_override_redirect wa

foreign import ccall unsafe "XlibExtras.h XGetWindowAttributes"
    xGetWindowAttributes :: Display -> Window -> Ptr (WindowAttributes) -> IO Status

getWindowAttributes :: Display -> Window -> IO WindowAttributes
getWindowAttributes d w = alloca $ \p -> do
    _ <- throwIfZero "getWindowAttributes" $ xGetWindowAttributes d w p
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
        _ <- throwIf (0==) (const "getTextProperty") $ xGetTextProperty d w textp a
        peek textp

foreign import ccall unsafe "XlibExtras.h XwcTextPropertyToTextList"
    xwcTextPropertyToTextList :: Display -> Ptr TextProperty -> Ptr (Ptr CWString) -> Ptr CInt -> IO CInt

wcTextPropertyToTextList :: Display -> TextProperty -> IO [String]
wcTextPropertyToTextList d prop =
    alloca    $ \listp  ->
    alloca    $ \countp ->
    with prop $ \propp  -> do
        _ <- throwIf (success>) (const "wcTextPropertyToTextList") $
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
        _ <- xwcTextExtents fs textp (fromIntegral len) inkp logicalp
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
    _ <- xFetchName d w p
    cstr <- peek p
    if cstr == nullPtr
        then return Nothing
        else do
            str <- peekCString cstr
            _ <- xFree cstr
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
-- stored in the WM_PROTOCOLS property on the specified window.
-- These atoms describe window manager protocols in
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
                    _ <- xFree atom_ptr
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
    setClientMessageEvent' p window message_type format [fromIntegral l_0_, fromIntegral l_1_]

-- slightly less hacky way to set up an XClientMessageEvent
setClientMessageEvent' :: XEventPtr -> Window -> Atom -> CInt -> [CInt] -> IO ()
setClientMessageEvent' p window message_type format dat = do
    #{poke XClientMessageEvent, window}         p window
    #{poke XClientMessageEvent, message_type}   p message_type
    #{poke XClientMessageEvent, format}         p format
    case format of
        8  -> do let datap = #{ptr XClientMessageEvent, data} p :: Ptr Word8
                 pokeArray datap $ take 20 $ map fromIntegral dat ++ repeat 0
        16 -> do let datap = #{ptr XClientMessageEvent, data} p :: Ptr Word16
                 pokeArray datap $ take 10 $ map fromIntegral dat ++ repeat 0
        32 -> do let datap = #{ptr XClientMessageEvent, data} p :: Ptr CLong
                 pokeArray datap $ take 5  $ map fromIntegral dat ++ repeat 0
        _  -> error "X11.Extras.setClientMessageEvent': illegal format"

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

setKeyEvent :: XEventPtr -> Window -> Window -> Window -> KeyMask -> KeyCode -> Bool -> IO ()
setKeyEvent p win root subwin state keycode sameScreen = do
    #{poke XKeyEvent, window          } p win
    #{poke XKeyEvent, root            } p root
    #{poke XKeyEvent, subwindow       } p subwin
    #{poke XKeyEvent, time            } p currentTime
    #{poke XKeyEvent, x               } p (1 :: CInt)
    #{poke XKeyEvent, y               } p (1 :: CInt)
    #{poke XKeyEvent, x_root          } p (1 :: CInt)
    #{poke XKeyEvent, y_root          } p (1 :: CInt)
    #{poke XKeyEvent, state           } p state
    #{poke XKeyEvent, keycode         } p keycode
    #{poke XKeyEvent, same_screen     } p sameScreen
    return ()

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
    _ <- xRefreshKeyboardMapping p
    return ()
refreshKeyboardMapping _ = return ()

foreign import ccall unsafe "XlibExtras.h XRefreshKeyboardMapping"
    xRefreshKeyboardMapping :: Ptr () -> IO CInt

-- Properties

anyPropertyType :: Atom
anyPropertyType = #{const AnyPropertyType}

foreign import ccall unsafe "XlibExtras.h XChangeProperty"
    xChangeProperty :: Display -> Window -> Atom -> Atom -> CInt -> CInt -> Ptr CUChar -> CInt -> IO Status

foreign import ccall unsafe "XlibExtras.h XDeleteProperty"
    xDeleteProperty :: Display -> Window -> Atom -> IO Status

foreign import ccall unsafe "XlibExtras.h XGetWindowProperty"
    xGetWindowProperty :: Display -> Window -> Atom -> CLong -> CLong -> Bool -> Atom -> Ptr Atom -> Ptr CInt -> Ptr CULong -> Ptr CULong -> Ptr (Ptr CUChar) -> IO Status

rawGetWindowProperty :: Storable a => Int -> Display -> Atom -> Window -> IO (Maybe [a])
rawGetWindowProperty bits d atom w =
    alloca $ \actual_type_return ->
    alloca $ \actual_format_return ->
    alloca $ \nitems_return ->
    alloca $ \bytes_after_return ->
    alloca $ \prop_return -> do
        ret <- xGetWindowProperty d w atom 0 0xFFFFFFFF False anyPropertyType
                           actual_type_return
                           actual_format_return
                           nitems_return
                           bytes_after_return
                           prop_return

        if ret /= 0
            then return Nothing
            else do
                prop_ptr      <- peek prop_return
                actual_format <- fromIntegral `fmap` peek actual_format_return
                nitems        <- fromIntegral `fmap` peek nitems_return
                getprop prop_ptr nitems actual_format
  where
    getprop prop_ptr nitems actual_format
        | actual_format == 0    = return Nothing -- Property not found
        | actual_format /= bits = xFree prop_ptr >> return Nothing
        | otherwise = do
            retval <- peekArray nitems (castPtr prop_ptr)
            _ <- xFree prop_ptr
            return $ Just retval

getWindowProperty8 :: Display -> Atom -> Window -> IO (Maybe [CChar])
getWindowProperty8 = rawGetWindowProperty 8

getWindowProperty16 :: Display -> Atom -> Window -> IO (Maybe [CShort])
getWindowProperty16 = rawGetWindowProperty 16

getWindowProperty32 :: Display -> Atom -> Window -> IO (Maybe [CLong])
getWindowProperty32 = rawGetWindowProperty 32

-- this assumes bytes are 8 bits.  I hope X isn't more portable than that :(

changeProperty8 :: Display -> Window -> Atom -> Atom -> CInt -> [CChar] -> IO ()
changeProperty8 dpy w prop typ mode dat =
    withArrayLen dat $ \ len ptr -> do
        _ <- xChangeProperty dpy w prop typ 8 mode (castPtr ptr) (fromIntegral len)
        return ()

changeProperty16 :: Display -> Window -> Atom -> Atom -> CInt -> [CShort] -> IO ()
changeProperty16 dpy w prop typ mode dat =
    withArrayLen dat $ \ len ptr -> do
        _ <- xChangeProperty dpy w prop typ 16 mode (castPtr ptr) (fromIntegral len)
        return ()

changeProperty32 :: Display -> Window -> Atom -> Atom -> CInt -> [CLong] -> IO ()
changeProperty32 dpy w prop typ mode dat =
    withArrayLen dat $ \ len ptr -> do
        _ <- xChangeProperty dpy w prop typ 32 mode (castPtr ptr) (fromIntegral len)
        return ()

propModeReplace, propModePrepend, propModeAppend :: CInt
propModeReplace = #{const PropModeReplace}
propModePrepend = #{const PropModePrepend}
propModeAppend = #{const PropModeAppend}

deleteProperty :: Display -> Window -> Atom -> IO ()
deleteProperty dpy w prop = do
    _ <- xDeleteProperty dpy w prop
    return ()

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
        #{poke XSizeHints, height_inc  } p h
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
          status <- xGetWMNormalHints d w sh supplied_return
          case status of
            0 -> return (SizeHints Nothing Nothing Nothing Nothing Nothing Nothing)
            _ -> peek sh


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
            _ <- xFree res_name_p
            _ <- xFree res_class_p
            return res
        else return $ ClassHint "" ""

foreign import ccall unsafe "XlibExtras.h XGetClassHint"
    xGetClassHint :: Display -> Window -> Ptr ClassHint -> IO Status

------------------------------------------------------------------------
-- WM Hints

-- These are the documented values for a window's "WM State", set, for example,
-- in wmh_initial_state, below. Note, you may need to play games with
-- fromIntegral and/or fromEnum.
withdrawnState,normalState, iconicState :: Int
withdrawnState = #{const WithdrawnState}
normalState    = #{const NormalState}
iconicState    = #{const IconicState}

-- The following values are the documented bit positions on XWMHints's flags field.
-- Use testBit, setBit, and clearBit to manipulate the field.
inputHintBit,stateHintBit,iconPixmapHintBit,iconWindowHintBit,iconPositionHintBit,iconMaskHintBit,windowGroupHintBit,urgencyHintBit :: Int
inputHintBit        = 0
stateHintBit        = 1
iconPixmapHintBit   = 2
iconWindowHintBit   = 3
iconPositionHintBit = 4
iconMaskHintBit     = 5
windowGroupHintBit  = 6
urgencyHintBit      = 8

-- The following bitmask tests for the presence of all bits except for the
-- urgencyHintBit.
allHintsBitmask :: CLong
allHintsBitmask    = #{const AllHints}

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
getWMHints dpy w = do
    p <- xGetWMHints dpy w
    if p == nullPtr
        then return $ WMHints 0 False 0 0 0 0 0 0 0
        else do x <- peek p; _ <- xFree p; return x

foreign import ccall unsafe "XlibExtras.h XAllocWMHints"
    xAllocWMHints :: IO (Ptr WMHints)

foreign import ccall unsafe "XlibExtras.h XSetWMHints"
    xSetWMHints :: Display -> Window -> Ptr WMHints -> IO Status

setWMHints :: Display -> Window -> WMHints -> IO Status
setWMHints dpy w wmh = do
    p_wmh <- xAllocWMHints
    poke p_wmh wmh
    res <- xSetWMHints dpy w p_wmh
    _ <- xFree p_wmh
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

-------------------------------------------------------------------------------
-- Selections
--
foreign import ccall unsafe "HsXlib.h XSetSelectionOwner"
    xSetSelectionOwner :: Display -> Atom -> Window -> Time -> IO ()

foreign import ccall unsafe "HsXlib.h XGetSelectionOwner"
    xGetSelectionOwner :: Display -> Atom -> IO Window

foreign import ccall unsafe "HsXlib.h XConvertSelection"
    xConvertSelection :: Display -> Atom -> Atom -> Atom -> Window -> Time -> IO ()

-------------------------------------------------------------------------------
-- Error handling
--
type XErrorEventPtr = Ptr ()
type CXErrorHandler = Display -> XErrorEventPtr -> IO CInt
type XErrorHandler = Display -> XErrorEventPtr -> IO ()

data ErrorEvent = ErrorEvent {
    ev_type :: !CInt,
    ev_display :: Display,
    ev_serialnum :: !CULong,
    ev_error_code :: !CUChar,
    ev_request_code :: !CUChar,
    ev_minor_code :: !CUChar,
    ev_resourceid :: !XID
}

foreign import ccall safe "wrapper"
    mkXErrorHandler :: CXErrorHandler -> IO (FunPtr CXErrorHandler)
foreign import ccall safe "dynamic"
    getXErrorHandler :: FunPtr CXErrorHandler -> CXErrorHandler
foreign import ccall safe "HsXlib.h XSetErrorHandler"
    _xSetErrorHandler :: FunPtr CXErrorHandler -> IO (FunPtr CXErrorHandler)

-- |A binding to XSetErrorHandler.
--  NOTE:  This is pretty experimental because of safe vs. unsafe calls.  I
--  changed sync to a safe call, but there *might* be other calls that cause a
--  problem
setErrorHandler :: XErrorHandler -> IO ()
setErrorHandler new_handler = do
    _handler <- mkXErrorHandler (\d -> \e -> new_handler d e >> return 0)
    _ <- _xSetErrorHandler _handler
    return ()

-- |Retrieves error event data from a pointer to an XErrorEvent and
--  puts it into an ErrorEvent.
getErrorEvent :: XErrorEventPtr -> IO ErrorEvent
getErrorEvent ev_ptr = do
    _type <- #{peek XErrorEvent, type } ev_ptr
    serial <- #{peek XErrorEvent, serial} ev_ptr
    dsp <- fmap Display (#{peek XErrorEvent, display} ev_ptr)
    error_code <- #{peek XErrorEvent, error_code} ev_ptr
    request_code <- #{peek XErrorEvent, request_code} ev_ptr
    minor_code <- #{peek XErrorEvent, minor_code} ev_ptr
    resourceid <- #{peek XErrorEvent, resourceid} ev_ptr
    return $ ErrorEvent {
        ev_type = _type,
        ev_display = dsp,
        ev_serialnum = serial,
        ev_error_code = error_code,
        ev_request_code = request_code,
        ev_minor_code = minor_code,
        ev_resourceid = resourceid
    }

-- |A binding to XMapRaised.
foreign import ccall unsafe "HsXlib.h XMapRaised"
    mapRaised :: Display -> Window -> IO CInt

foreign import ccall unsafe "HsXlib.h XGetCommand"
    xGetCommand :: Display -> Window -> Ptr (Ptr CWString) -> Ptr CInt -> IO Status

getCommand :: Display -> Window -> IO [String]
getCommand d w =
  alloca $
  \argvp ->
  alloca $
  \argcp ->
  do
    _ <- throwIf (success >) (\status -> "xGetCommand returned status: " ++ show status) $ xGetCommand d w argvp argcp
    argc <- peek argcp
    argv <- peek argvp
    texts <- flip mapM [0 .. fromIntegral $ pred argc] $ \i -> peekElemOff argv i >>= peekCWString
    wcFreeStringList argv
    return texts

foreign import ccall unsafe "HsXlib.h XGetModifierMapping"
    xGetModifierMapping :: Display -> IO (Ptr ())

foreign import ccall unsafe "HsXlib.h XFreeModifiermap"
    xFreeModifiermap :: Ptr () -> IO (Ptr CInt)

getModifierMapping :: Display -> IO [(Modifier, [KeyCode])]
getModifierMapping d = do
    p <- xGetModifierMapping d
    m' <- #{peek XModifierKeymap, max_keypermod} p :: IO CInt
    let m = fromIntegral m'
    pks <- #{peek XModifierKeymap, modifiermap} p :: IO (Ptr KeyCode)
    ks <- peekArray (m * 8) pks
    _ <- xFreeModifiermap p
    return . zip masks . map fst . tail . iterate (splitAt m . snd) $ ([], ks)
 where
    masks = [shiftMapIndex .. mod5MapIndex]
