--------------------------------------------------------------------
-- |
-- Module    : Graphics.X11.Xinerama
-- Copyright : (c) Haskell.org, 2007
-- License   : BSD3
--
-- Maintainer: Don Stewart <dons@galois.com>
-- Stability : provisional
-- Portability: portable
--
--------------------------------------------------------------------
--
-- Interface to Xinerama API
--

module Graphics.X11.Xinerama (
   XineramaScreenInfo(..),
   xineramaIsActive,
   xineramaQueryExtension,
   xineramaQueryVersion,
   xineramaQueryScreens,
   compiledWithXinerama,
   getScreenInfo
 ) where

#include <X11_extras_config.h>

import Foreign
import Foreign.C.Types
import Graphics.X11.Xlib
import Graphics.X11.Xlib.Extras (WindowAttributes(..), getWindowAttributes)
import Graphics.X11.Xlib.Internal
import Control.Monad

-- | Representation of the XineramaScreenInfo struct
data XineramaScreenInfo = XineramaScreenInfo
                          { xsi_screen_number :: !CInt,
                            xsi_x_org         :: !CShort,
                            xsi_y_org         :: !CShort,
                            xsi_width         :: !CShort,
                            xsi_height        :: !CShort }
                            deriving (Show)

-- | Wrapper around xineramaQueryScreens that fakes a single screen when
-- Xinerama is not active. This is the preferred interface to
-- Graphics.X11.Xinerama.
getScreenInfo :: Display -> IO [Rectangle]
getScreenInfo dpy = do
    mxs <- xineramaQueryScreens dpy
    case mxs of
        Just xs -> return . map xsiToRect $ xs
        Nothing -> do
            wa <- getWindowAttributes dpy (defaultRootWindow dpy)
            return $ [Rectangle
                        { rect_x      = fromIntegral $ wa_x wa
                        , rect_y      = fromIntegral $ wa_y wa
                        , rect_width  = fromIntegral $ wa_width wa
                        , rect_height = fromIntegral $ wa_height wa }]
 where
    xsiToRect xsi = Rectangle
                    { rect_x        = fromIntegral $ xsi_x_org xsi
                    , rect_y        = fromIntegral $ xsi_y_org xsi
                    , rect_width    = fromIntegral $ xsi_width xsi
                    , rect_height   = fromIntegral $ xsi_height xsi
                    }

#ifdef HAVE_X11_EXTENSIONS_XINERAMA_H
-- We have Xinerama, so the library will actually work
compiledWithXinerama :: Bool
compiledWithXinerama = True

#include <X11/extensions/Xinerama.h>

instance Storable XineramaScreenInfo where
  sizeOf _ = #{size XineramaScreenInfo}
  -- FIXME: Is this right?
  alignment _ = alignment (undefined :: CInt)

  poke p xsi = do
    #{poke XineramaScreenInfo, screen_number } p $ xsi_screen_number xsi
    #{poke XineramaScreenInfo, x_org         } p $ xsi_x_org xsi
    #{poke XineramaScreenInfo, y_org         } p $ xsi_y_org xsi
    #{poke XineramaScreenInfo, width         } p $ xsi_width xsi
    #{poke XineramaScreenInfo, height        } p $ xsi_height xsi

  peek p = return XineramaScreenInfo
              `ap` (#{peek XineramaScreenInfo, screen_number} p)
              `ap` (#{peek XineramaScreenInfo, x_org} p)
              `ap` (#{peek XineramaScreenInfo, y_org} p)
              `ap` (#{peek XineramaScreenInfo, width} p)
              `ap` (#{peek XineramaScreenInfo, height} p)

foreign import ccall "XineramaIsActive"
  xineramaIsActive :: Display -> IO Bool

xineramaQueryExtension :: Display -> IO (Maybe (CInt, CInt))
xineramaQueryExtension dpy = wrapPtr2 (cXineramaQueryExtension dpy) go
  where go False _ _                = Nothing
        go True eventbase errorbase = Just (fromIntegral eventbase, fromIntegral errorbase)

xineramaQueryVersion :: Display -> IO (Maybe (CInt, CInt))
xineramaQueryVersion dpy = wrapPtr2 (cXineramaQueryVersion dpy) go
  where go False _ _        = Nothing
        go True major minor = Just (fromIntegral major, fromIntegral minor)

xineramaQueryScreens :: Display -> IO (Maybe [XineramaScreenInfo])
xineramaQueryScreens dpy = 
  withPool $ \pool -> do intp <- pooledMalloc pool
                         p <- cXineramaQueryScreens dpy intp
                         if p == nullPtr 
                            then return Nothing
                            else do nscreens <- peek intp
                                    screens <- peekArray (fromIntegral nscreens) p
                                    _ <- xFree p
                                    return (Just screens)

foreign import ccall "XineramaQueryExtension"
  cXineramaQueryExtension :: Display -> Ptr CInt -> Ptr CInt -> IO Bool

foreign import ccall "XineramaQueryVersion"
  cXineramaQueryVersion :: Display -> Ptr CInt -> Ptr CInt -> IO Bool

foreign import ccall "XineramaQueryScreens"
  cXineramaQueryScreens :: Display -> Ptr CInt -> IO (Ptr XineramaScreenInfo)

wrapPtr2 :: (Storable a, Storable b) => (Ptr a -> Ptr b -> IO c) -> (c -> a -> b -> d) -> IO d
wrapPtr2 cfun f =
  withPool $ \pool -> do aptr <- pooledMalloc pool
                         bptr <- pooledMalloc pool
                         ret <- cfun aptr bptr
                         a <- peek aptr
                         b <- peek bptr
                         return (f ret a b)

#else

-- No Xinerama, but if we fake a non-active Xinerama interface, "getScreenInfo"
-- will continue to work fine in the single-screen case.
compiledWithXinerama :: Bool
compiledWithXinerama = False

xineramaIsActive :: Display -> IO Bool
xineramaIsActive _ = return False

xineramaQueryExtension :: Display -> IO (Maybe (CInt, CInt))
xineramaQueryExtension _  = return Nothing

xineramaQueryVersion :: Display -> IO (Maybe (CInt, CInt))
xineramaQueryVersion _ = return Nothing

xineramaQueryScreens :: Display -> IO (Maybe [XineramaScreenInfo])
xineramaQueryScreens _ = return Nothing

#endif
