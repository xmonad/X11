-- Screen capture (screenshot)
-- Captures 1600x900 and writes a 24-bit ascii PPM image on stdout.
module Main where

import qualified Graphics.X11.Types as X
import qualified Graphics.X11.Xlib.Image as X
import qualified Graphics.X11.Xlib.Display as X
import qualified Graphics.X11.Xlib.Screen as X

import Foreign.C.Types
import Data.Bits

main :: IO ()
main = do
    let (w,h) = (1600,900)
    disp <- X.openDisplay ":0"
    let scr = X.defaultScreenOfDisplay disp
    root <- X.rootWindow disp (X.screenNumberOfScreen scr)
    img <- X.getImage disp root 0 0 w h (-1) X.xyPixmap

    let int :: CUInt -> CInt; int = fromIntegral . toInteger

    let rgb :: CULong -> String
        rgb v = unwords [ show (0xff .&. (v `shiftR` s)) | s <- [16,8,0] ]

    let ppm = unlines [ unwords [ rgb (X.getPixel img x y)
                                | x <- [0..int (w-1)] ]
                      | y <- [0..int (h-1)] ]

    putStrLn (unlines ["P3",show w,show h,"255",ppm])
    X.destroyImage img

