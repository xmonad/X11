-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Internal
-- Copyright   :  (c) Daniel Wagner, 2013
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- Functions used often elsewhere in the X11 bindings.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Internal (xFree, xFreePtr) where

import Foreign
import Foreign.C.Types

foreign import ccall unsafe "XFree" xFree :: Ptr a -> IO CInt
foreign import ccall unsafe "&XFree" xFreePtr :: FinalizerPtr a
