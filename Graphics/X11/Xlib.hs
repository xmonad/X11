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
-- The library aims to provide a direct translation of the X
-- binding into Haskell so the most important documentation you
-- should read is /The Xlib Programming Manual/, available online at
-- <http://tronche.com/gui/x/xlib/>.  Let me say that again because
-- it is very important.  Get hold of this documentation and read it:
-- it tells you almost everything you need to know to use this library.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib 
	( -- * Conventions
	  -- $conventions

	  -- * Types
	  module Graphics.X11.Types,
          -- module Graphics.X11.Xlib.Types,
	  Display, Screen, Visual, GC, SetWindowAttributes,
	  Point(..), Rectangle(..), Arc(..), Segment(..), Color(..),
	  Pixel, Position, Dimension, Angle, ScreenNumber, Buffer,

	  -- * X11 library functions
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

{- $conventions

In translating the library, we had to change names to conform with
Haskell's lexical syntax: function names and names of constants must start
with a lowercase letter; type names must start with an uppercase letter.
The case of the remaining letters is unchanged.

In addition, we chose to take advantage of Haskell's module system to
allow us to drop common prefixes (@X@, @XA_@, etc.) attached to X11
identifiers.

We named enumeration types so that function types would be easier
to understand.  For example, we added 'Status', 'WindowClass', etc.
Note that the types are synonyms for 'Int' so no extra typesafety was
obtained.

We consistently raise exceptions when a function returns an error code.
In practice, this only affects the following functions because most Xlib
functions do not return error codes: 'allocColor', 'allocNamedColor',
'fetchBuffer', 'fetchBytes', 'fontFromGC', 'getGeometry', 'getIconName',
'iconifyWindow', 'loadQueryFont', 'lookupColor', 'openDisplay',
'parseColor', 'queryBestCursor', 'queryBestSize', 'queryBestStipple',
'queryBestTile', 'rotateBuffers', 'selectInput', 'storeBuffer',
'storeBytes', 'withdrawWindow'.

-}

----------------------------------------------------------------
-- End
----------------------------------------------------------------
