-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Atom
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of type declarations for interfacing with X11 Atoms.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Atom(
        internAtom,
        getAtomName,
        getAtomNames,

        pRIMARY,
        sECONDARY,
        aRC,
        aTOM,
        bITMAP,
        cARDINAL,
        cOLORMAP,
        cURSOR,
        cUT_BUFFER0,
        cUT_BUFFER1,
        cUT_BUFFER2,
        cUT_BUFFER3,
        cUT_BUFFER4,
        cUT_BUFFER5,
        cUT_BUFFER6,
        cUT_BUFFER7,
        dRAWABLE,
        fONT,
        iNTEGER,
        pIXMAP,
        pOINT,
        rECTANGLE,
        rESOURCE_MANAGER,
        rGB_COLOR_MAP,
        rGB_BEST_MAP,
        rGB_BLUE_MAP,
        rGB_DEFAULT_MAP,
        rGB_GRAY_MAP,
        rGB_GREEN_MAP,
        rGB_RED_MAP,
        sTRING,
        vISUALID,
        wINDOW,
        wM_COMMAND,
        wM_HINTS,
        wM_CLIENT_MACHINE,
        wM_ICON_NAME,
        wM_ICON_SIZE,
        wM_NAME,
        wM_NORMAL_HINTS,
        wM_SIZE_HINTS,
        wM_ZOOM_HINTS,
        mIN_SPACE,
        nORM_SPACE,
        mAX_SPACE,
        eND_SPACE,
        sUPERSCRIPT_X,
        sUPERSCRIPT_Y,
        sUBSCRIPT_X,
        sUBSCRIPT_Y,
        uNDERLINE_POSITION,
        uNDERLINE_THICKNESS,
        sTRIKEOUT_ASCENT,
        sTRIKEOUT_DESCENT,
        iTALIC_ANGLE,
        x_HEIGHT,
        qUAD_WIDTH,
        wEIGHT,
        pOINT_SIZE,
        rESOLUTION,
        cOPYRIGHT,
        nOTICE,
        fONT_NAME,
        fAMILY_NAME,
        fULL_NAME,
        cAP_HEIGHT,
        wM_CLASS,
        wM_TRANSIENT_FOR,
        lAST_PREDEFINED,

        ) where

import Graphics.X11.Types
import Graphics.X11.Xlib.Internal
import Graphics.X11.Xlib.Types

import Foreign hiding ( void )
import Foreign.C.Types
import Foreign.C.String

#include "HsXlib.h"

----------------------------------------------------------------
-- Atoms
----------------------------------------------------------------

-- AC, 1/9/2000: Added definition for XInternAtom

-- | interface to the X11 library function @XInternAtom()@.
internAtom :: Display -> String -> Bool -> IO Atom
internAtom display atom_name only_if_exists =
        withCString atom_name $ \ c_atom_name ->
        xInternAtom display c_atom_name only_if_exists
foreign import ccall unsafe "XInternAtom"
        xInternAtom :: Display -> CString -> Bool -> IO Atom

-- jrk, 22.11.2012: getAtomName{,s}

getAtomName :: Display -> Atom -> IO (Maybe String)
getAtomName dpy atom = do
    p <- cXGetAtomName dpy atom
    if p == nullPtr
        then return Nothing
        else do
            res <- peekCString p
            _ <- xFree p
            return $ Just res

foreign import ccall "XGetAtomName"
    cXGetAtomName :: Display -> Atom -> IO (Ptr CChar)

getAtomNames :: Display -> [Atom] -> IO [String]
getAtomNames dpy atoms = withPool $ \pool -> do
    atomsp <- (pooledMallocArray pool $ length atoms) :: IO (Ptr Atom)
    ccharp <- (pooledMallocArray pool $ length atoms) :: IO (Ptr (Ptr CChar))

    pokeArray atomsp atoms
    _ <- cXGetAtomNames dpy atomsp (fromIntegral $ length atoms :: CInt) ccharp

    res <- peekArray (length atoms) ccharp >>= mapM peekCString
    peekArray (length atoms) ccharp >>= mapM_ xFree

    return res

foreign import ccall "XGetAtomNames"
    cXGetAtomNames :: Display -> Ptr Atom -> CInt -> Ptr (Ptr CChar) -> IO Status

-- XConvertSelection omitted
-- XListProperties omitted
-- XChangeProperty omitted
-- XDeleteProperty omitted

#{enum Atom,
 , pRIMARY              = XA_PRIMARY
 , sECONDARY            = XA_SECONDARY
 , aRC                  = XA_ARC
 , aTOM                 = XA_ATOM
 , bITMAP               = XA_BITMAP
 , cARDINAL             = XA_CARDINAL
 , cOLORMAP             = XA_COLORMAP
 , cURSOR               = XA_CURSOR
 , cUT_BUFFER0          = XA_CUT_BUFFER0
 , cUT_BUFFER1          = XA_CUT_BUFFER1
 , cUT_BUFFER2          = XA_CUT_BUFFER2
 , cUT_BUFFER3          = XA_CUT_BUFFER3
 , cUT_BUFFER4          = XA_CUT_BUFFER4
 , cUT_BUFFER5          = XA_CUT_BUFFER5
 , cUT_BUFFER6          = XA_CUT_BUFFER6
 , cUT_BUFFER7          = XA_CUT_BUFFER7
 , dRAWABLE             = XA_DRAWABLE
 , fONT                 = XA_FONT
 , iNTEGER              = XA_INTEGER
 , pIXMAP               = XA_PIXMAP
 , pOINT                = XA_POINT
 , rECTANGLE            = XA_RECTANGLE
 , rESOURCE_MANAGER     = XA_RESOURCE_MANAGER
 , rGB_COLOR_MAP        = XA_RGB_COLOR_MAP
 , rGB_BEST_MAP         = XA_RGB_BEST_MAP
 , rGB_BLUE_MAP         = XA_RGB_BLUE_MAP
 , rGB_DEFAULT_MAP      = XA_RGB_DEFAULT_MAP
 , rGB_GRAY_MAP         = XA_RGB_GRAY_MAP
 , rGB_GREEN_MAP        = XA_RGB_GREEN_MAP
 , rGB_RED_MAP          = XA_RGB_RED_MAP
 , sTRING               = XA_STRING
 , vISUALID             = XA_VISUALID
 , wINDOW               = XA_WINDOW
 , wM_COMMAND           = XA_WM_COMMAND
 , wM_HINTS             = XA_WM_HINTS
 , wM_CLIENT_MACHINE    = XA_WM_CLIENT_MACHINE
 , wM_ICON_NAME         = XA_WM_ICON_NAME
 , wM_ICON_SIZE         = XA_WM_ICON_SIZE
 , wM_NAME              = XA_WM_NAME
 , wM_NORMAL_HINTS      = XA_WM_NORMAL_HINTS
 , wM_SIZE_HINTS        = XA_WM_SIZE_HINTS
 , wM_ZOOM_HINTS        = XA_WM_ZOOM_HINTS
 , mIN_SPACE            = XA_MIN_SPACE
 , nORM_SPACE           = XA_NORM_SPACE
 , mAX_SPACE            = XA_MAX_SPACE
 , eND_SPACE            = XA_END_SPACE
 , sUPERSCRIPT_X        = XA_SUPERSCRIPT_X
 , sUPERSCRIPT_Y        = XA_SUPERSCRIPT_Y
 , sUBSCRIPT_X          = XA_SUBSCRIPT_X
 , sUBSCRIPT_Y          = XA_SUBSCRIPT_Y
 , uNDERLINE_POSITION   = XA_UNDERLINE_POSITION
 , uNDERLINE_THICKNESS  = XA_UNDERLINE_THICKNESS
 , sTRIKEOUT_ASCENT     = XA_STRIKEOUT_ASCENT
 , sTRIKEOUT_DESCENT    = XA_STRIKEOUT_DESCENT
 , iTALIC_ANGLE         = XA_ITALIC_ANGLE
 , x_HEIGHT             = XA_X_HEIGHT
 , qUAD_WIDTH           = XA_QUAD_WIDTH
 , wEIGHT               = XA_WEIGHT
 , pOINT_SIZE           = XA_POINT_SIZE
 , rESOLUTION           = XA_RESOLUTION
 , cOPYRIGHT            = XA_COPYRIGHT
 , nOTICE               = XA_NOTICE
 , fONT_NAME            = XA_FONT_NAME
 , fAMILY_NAME          = XA_FAMILY_NAME
 , fULL_NAME            = XA_FULL_NAME
 , cAP_HEIGHT           = XA_CAP_HEIGHT
 , wM_CLASS             = XA_WM_CLASS
 , wM_TRANSIENT_FOR     = XA_WM_TRANSIENT_FOR
 , lAST_PREDEFINED      = XA_LAST_PREDEFINED
 }

----------------------------------------------------------------
-- End
----------------------------------------------------------------
