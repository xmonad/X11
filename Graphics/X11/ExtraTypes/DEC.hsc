-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.ExtraTypes.DEC
-- Copyright   :  (c) Open Group 1988,1998, DEC 1988
-- License     :  X11 (see below) due to X headers
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  unstable
-- Portability :  unportable
--
--
-- This file is generated based on X.org includes.  It contains
-- the keysyms for DEC.
-----------------------------------------------------------------------------

-- Generated from /usr/include/X11/DECkeysym.h
--

--
-- Copyright 1988, 1998  The Open Group
--
-- Permission to use, copy, modify, distribute, and sell this software and its
-- documentation for any purpose is hereby granted without fee, provided that
-- the above copyright notice appear in all copies and that both that
-- copyright notice and this permission notice appear in supporting
-- documentation.
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
-- OPEN GROUP BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
-- AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
-- CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--
-- Except as contained in this notice, the name of The Open Group shall not be
-- used in advertising or otherwise to promote the sale, use or other dealings
-- in this Software without prior written authorization from The Open Group.
--
--
-- Copyright 1988 by Digital Equipment Corporation, Maynard, Massachusetts.
--
--                         All Rights Reserved
--
-- Permission to use, copy, modify, and distribute this software and its
-- documentation for any purpose and without fee is hereby granted,
-- provided that the above copyright notice appear in all copies and that
-- both that copyright notice and this permission notice appear in
-- supporting documentation, and that the name of Digital not be
-- used in advertising or publicity pertaining to distribution of the
-- software without specific, written prior permission.
--
-- DIGITAL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
-- ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL
-- DIGITAL BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
-- ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
-- WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
-- ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
-- SOFTWARE.
--

module Graphics.X11.ExtraTypes.DEC
        (

#ifdef DXK_ring_accent
         dXK_ring_accent,
#else
         -- Skipping dXK_ring_accent because your X doesn't define it
#endif
#ifdef DXK_circumflex_accent
         dXK_circumflex_accent,
#else
         -- Skipping dXK_circumflex_accent because your X doesn't define it
#endif
#ifdef DXK_cedilla_accent
         dXK_cedilla_accent,
#else
         -- Skipping dXK_cedilla_accent because your X doesn't define it
#endif
#ifdef DXK_acute_accent
         dXK_acute_accent,
#else
         -- Skipping dXK_acute_accent because your X doesn't define it
#endif
#ifdef DXK_grave_accent
         dXK_grave_accent,
#else
         -- Skipping dXK_grave_accent because your X doesn't define it
#endif
#ifdef DXK_tilde
         dXK_tilde,
#else
         -- Skipping dXK_tilde because your X doesn't define it
#endif
#ifdef DXK_diaeresis
         dXK_diaeresis,
#else
         -- Skipping dXK_diaeresis because your X doesn't define it
#endif
#ifdef DXK_Remove
         dXK_Remove,              --  Remove
#else
         -- Skipping dXK_Remove because your X doesn't define it
#endif
        ) where

import Graphics.X11.Types

#include "HsAllKeysyms.h"

#ifdef DXK_ring_accent
dXK_ring_accent          :: KeySym
dXK_ring_accent          = #const DXK_ring_accent
#endif
#ifdef DXK_circumflex_accent
dXK_circumflex_accent    :: KeySym
dXK_circumflex_accent    = #const DXK_circumflex_accent
#endif
#ifdef DXK_cedilla_accent
dXK_cedilla_accent       :: KeySym
dXK_cedilla_accent       = #const DXK_cedilla_accent
#endif
#ifdef DXK_acute_accent
dXK_acute_accent         :: KeySym
dXK_acute_accent         = #const DXK_acute_accent
#endif
#ifdef DXK_grave_accent
dXK_grave_accent         :: KeySym
dXK_grave_accent         = #const DXK_grave_accent
#endif
#ifdef DXK_tilde
dXK_tilde                :: KeySym
dXK_tilde                = #const DXK_tilde
#endif
#ifdef DXK_diaeresis
dXK_diaeresis            :: KeySym
dXK_diaeresis            = #const DXK_diaeresis
#endif
#ifdef DXK_Remove
dXK_Remove               :: KeySym
dXK_Remove               = #const DXK_Remove
#endif
