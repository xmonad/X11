-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib
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

module Graphics.X11.Xlib 
	( module Graphics.X11.Types,
          free,

          module Graphics.X11.Xlib.Types,
          module Graphics.X11.Xlib.Event,
          module Graphics.X11.Xlib.Display,
          module Graphics.X11.Xlib.Screen,
          module Graphics.X11.Xlib.Window,
          module Graphics.X11.Xlib.Context,
          module Graphics.X11.Xlib.Color,
          module Graphics.X11.Xlib.Font,
          module Graphics.X11.Xlib.Atom,
          module Graphics.X11.Xlib.Region,
          module Graphics.X11.Xlib.Misc,
          
	) where

import Graphics.X11.Types
import Graphics.X11.Xlib.Types
import Graphics.X11.Xlib.Event
import Graphics.X11.Xlib.Display
import Graphics.X11.Xlib.Screen
import Graphics.X11.Xlib.Window
import Graphics.X11.Xlib.Context
import Graphics.X11.Xlib.Color
import Graphics.X11.Xlib.Font
import Graphics.X11.Xlib.Atom
import Graphics.X11.Xlib.Region
import Graphics.X11.Xlib.Misc

import Foreign.Marshal.Alloc( free )

----------------------------------------------------------------
-- End
----------------------------------------------------------------
