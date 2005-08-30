{-# OPTIONS_GHC -fglasgow-exts #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Font
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of FFI declarations for interfacing with Xlib Fonts.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Font(

        Glyph,
        queryFont,
        fontFromGC,
        loadQueryFont,
        freeFont,
	FontStruct,
        fontFromFontStruct,
        ascentFromFontStruct,
        descentFromFontStruct,
        CharStruct,
        textExtents,
        textWidth,

        ) where

#include "HsXlib.h"

import Graphics.X11.Types
import Graphics.X11.Xlib.Types

import Foreign
import Foreign.C

#if __GLASGOW_HASKELL__
import Data.Generics
#endif

----------------------------------------------------------------
-- Fonts
----------------------------------------------------------------

-- A glyph (or Char2b) is a 16 bit character identification.
-- The top 8 bits are zero in many fonts.
type Glyph = Word16

-- | pointer to an X11 @XFontStruct@ structure
newtype FontStruct = FontStruct (Ptr FontStruct)
#if __GLASGOW_HASKELL__
	deriving (Eq, Ord, Show, Typeable, Data)
#else
	deriving (Eq, Ord, Show)
#endif

-- Disnae exist: %fun LoadFont       :: Display -> String -> IO Font
-- Disnae exist: %fun UnloadFont     :: Display -> Font -> IO ()

-- Argument can be a Font or a GContext.
-- But, if it's a GContext, the fontStruct will use the GContext as the
-- FontID - which will cause most things to break so it's probably
-- safer using XGetGCValues to get a genuine font ID

-- | interface to the X11 library function @XQueryFont()@.
foreign import ccall unsafe "HsXlib.h XQueryFont"
	queryFont     :: Display -> Font -> IO FontStruct

-- Note that this _WILL NOT WORK_ unless you have explicitly set the font.
-- I'm slowly but surely coming to the conclusion that Xlib is a pile of
-- steaming shit.

-- | interface to the X11 library function @XGetGCValues()@.
fontFromGC :: Display -> GC -> IO Font
fontFromGC display gc =
	allocaBytes #{size XGCValues} $ \ values -> do
	throwIfZero "fontFromGC" $
		xGetGCValues display gc #{const GCFont} values
	#{peek XGCValues,font} values
foreign import ccall unsafe "HsXlib.h XGetGCValues"
	xGetGCValues :: Display -> GC -> ValueMask -> Ptr GCValues -> IO Int

type ValueMask = #{type unsigned long}

-- | interface to the X11 library function @XLoadQueryFont()@.
loadQueryFont :: Display -> String -> IO FontStruct
loadQueryFont display name =
	withCString name $ \ c_name -> do
	fs <- throwIfNull "loadQueryFont" $ xLoadQueryFont display c_name
	return (FontStruct fs)
foreign import ccall unsafe "HsXlib.h XLoadQueryFont"
	xLoadQueryFont :: Display -> CString -> IO (Ptr FontStruct)

-- | interface to the X11 library function @XFreeFont()@.
foreign import ccall unsafe "HsXlib.h XFreeFont"
	freeFont      :: Display -> FontStruct -> IO ()
-- %fun XSetFontPath  :: Display -> ListString  -> IO () using XSetFontPath(arg1,arg2,arg2_size)

fontFromFontStruct :: FontStruct -> Font
fontFromFontStruct (FontStruct fs) = unsafePerformIO $
	#{peek XFontStruct,fid} fs

ascentFromFontStruct :: FontStruct -> Int32
ascentFromFontStruct (FontStruct fs) = unsafePerformIO $
	#{peek XFontStruct,ascent} fs

descentFromFontStruct :: FontStruct -> Int32
descentFromFontStruct (FontStruct fs) = unsafePerformIO $
	#{peek XFontStruct,descent} fs

-- %prim XGetFontPath :: Display -> IO ListString
--Int r_size;
--String* r = XGetFontPath(arg1,&r_size);
-- %update(r);
--XFreeFontPath(r);
--return;

-- %prim XListFonts :: Display -> String -> Int -> IO ListString
--Int r_size;
--String *r = XListFonts(arg1,arg2,arg3,&r_size);
-- %update(r);
--XFreeFontNames(r);
--return;

-- XListFontsWithInfo omitted (no support for FontStruct yet)

-- XQueryTextExtents omitted (no support for CharStruct yet)
-- XQueryTextExtents16 omitted (no support for CharStruct yet)

-- We marshall this across right away because it's usually one-off info
type CharStruct =
	( Int            -- lbearing (origin to left edge of raster)
	, Int            -- rbearing (origin to right edge of raster)
	, Int            -- width    (advance to next char's origin)
	, Int            -- ascent   (baseline to top edge of raster)
	, Int            -- descent  (baseline to bottom edge of raster)
	-- attributes omitted
	)

peekCharStruct :: Ptr CharStruct -> IO CharStruct
peekCharStruct p = do
	lbearing <- #{peek XCharStruct,lbearing} p
	rbearing <- #{peek XCharStruct,rbearing} p
	width    <- #{peek XCharStruct,width} p
	ascent   <- #{peek XCharStruct,ascent} p
	descent  <- #{peek XCharStruct,descent} p
	return (fromIntegral (lbearing::CShort),
		fromIntegral (rbearing::CShort),
		fromIntegral (width::CShort),
		fromIntegral (ascent::CShort),
		fromIntegral (descent::CShort))

-- No need to put this in the IO monad - this info is essentially constant

-- | interface to the X11 library function @XTextExtents()@.
textExtents :: FontStruct -> String -> (FontDirection, Int32, Int32, CharStruct)
textExtents font_struct string = unsafePerformIO $
	withCStringLen string $ \ (c_string, nchars) ->
	alloca $ \ direction_return ->
	alloca $ \ font_ascent_return ->
	alloca $ \ font_descent_return ->
	allocaBytes #{size XCharStruct} $ \ overall_return -> do
	xTextExtents font_struct c_string nchars direction_return
		font_ascent_return font_descent_return overall_return
	direction <- peek direction_return
	ascent <- peek font_ascent_return
	descent <- peek font_descent_return
	cs <- peekCharStruct overall_return
	return (direction, ascent, descent, cs)
foreign import ccall unsafe "HsXlib.h XTextExtents"
	xTextExtents :: FontStruct -> CString -> Int ->
		Ptr FontDirection -> Ptr Int32 -> Ptr Int32 ->
		Ptr CharStruct -> IO Int

-- No need to put ths in the IO monad - this info is essentially constant

-- | interface to the X11 library function @XTextWidth()@.
textWidth :: FontStruct -> String -> Int32
textWidth font_struct string = unsafePerformIO $
	withCStringLen string $ \ (c_string, len) ->
	xTextWidth font_struct c_string len
foreign import ccall unsafe "HsXlib.h XTextWidth"
	xTextWidth :: FontStruct -> CString -> Int -> IO Int32

-- XTextExtents16 omitted
-- XTextWidth16 omitted

-- XGetFontProperty omitted
-- XFreeFontInfo omitted
-- XFreeFontNames omitted

-- XCreateFontSet omitted (no documentation available)
-- XFreeFontSet omitted (no documentation available)
-- XFontsOfFontSet omitted (no documentation available)
-- XBaseFontNameListOfFontSet omitted (no documentation available)
-- XLocaleOfFontSet omitted (no documentation available)
-- XExtentsOfFontSet omitted (no documentation available)

-- XContextDependentDrawing omitted
-- XDirectionalDependentDrawing omitted
-- XContextualDrawing omitted

-- XmbTextEscapement omitted
-- XwcTextEscapement omitted
-- XmbTextExtents omitted
-- XwcTextExtents omitted
-- XmbTextPerCharExtents omitted
-- XwcTextPerCharExtents omitted
-- XmbDrawText omitted
-- XwcDrawText omitted
-- XmbDrawString omitted
-- XwcDrawString omitted
-- XmbDrawImageString omitted
-- XwcDrawImageString omitted

-- XOpenIM omitted
-- XCloseIM omitted
-- XGetIMValues omitted
-- XSetIMValues omitted
-- DisplayOfIM omitted
-- XLocaleOfIM omitted

-- XCreateIC omitted
-- XDestroyIC omitted
-- XSetICFocus omitted
-- XUnsetICFocus omitted
-- XwcResetIC omitted
-- XmbResetIC omitted
-- XSetICValues omitted
-- XGetICValues omitted
-- XIMOfIC omitted

-- XRegisterIMInstantiateCallback omitted
-- XUnregisterIMInstantiateCallback omitted

-- XInternalConnectionNumbers omitted
-- XProcessInternalConnection omitted
-- XAddConnectionWatch omitted
-- XRemoveConnectionWatch omitted

-- XmbLookupString omitted
-- XwcLookupString omitted

----------------------------------------------------------------
-- End
----------------------------------------------------------------
