-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.ExtraTypes.AP
-- Copyright   :  (c) Apollo 1987, HP 1989
-- License     :  X11 (see below) due to X headers
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  unstable
-- Portability :  unportable
--
--
-- This file is generated based on X.org includes.  It contains
-- the keysyms for AP.
-----------------------------------------------------------------------------

-- Generated from /usr/include/X11/ap_keysym.h
--

-- Copyright 1987 by Apollo Computer Inc., Chelmsford, Massachusetts.
-- Copyright 1989 by Hewlett-Packard Company.
--
--                         All Rights Reserved
--
-- Permission to use, duplicate, change, and distribute this software and
-- its documentation for any purpose and without fee is granted, provided
-- that the above copyright notice appear in such copy and that this
-- copyright notice appear in all supporting documentation, and that the
-- names of Apollo Computer Inc., the Hewlett-Packard Company, or the X
-- Consortium not be used in advertising or publicity pertaining to
-- distribution of the software without written prior permission.
--
-- HEWLETT-PACKARD MAKES NO WARRANTY OF ANY KIND WITH REGARD
-- TO THIS SOFWARE, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE.  Hewlett-Packard shall not be liable for errors
-- contained herein or direct, indirect, special, incidental or
-- consequential damages in connection with the furnishing,
-- performance, or use of this material.
--
-- This software is not subject to any license of the American
-- Telephone and Telegraph Company or of the Regents of the
-- University of California.

module Graphics.X11.ExtraTypes.AP
        (

#ifdef apXK_LineDel
         apXK_LineDel,
#else
         -- Skipping apXK_LineDel because your X doesn't define it
#endif
#ifdef apXK_CharDel
         apXK_CharDel,
#else
         -- Skipping apXK_CharDel because your X doesn't define it
#endif
#ifdef apXK_Copy
         apXK_Copy,
#else
         -- Skipping apXK_Copy because your X doesn't define it
#endif
#ifdef apXK_Cut
         apXK_Cut,
#else
         -- Skipping apXK_Cut because your X doesn't define it
#endif
#ifdef apXK_Paste
         apXK_Paste,
#else
         -- Skipping apXK_Paste because your X doesn't define it
#endif
#ifdef apXK_Move
         apXK_Move,
#else
         -- Skipping apXK_Move because your X doesn't define it
#endif
#ifdef apXK_Grow
         apXK_Grow,
#else
         -- Skipping apXK_Grow because your X doesn't define it
#endif
#ifdef apXK_Cmd
         apXK_Cmd,
#else
         -- Skipping apXK_Cmd because your X doesn't define it
#endif
#ifdef apXK_Shell
         apXK_Shell,
#else
         -- Skipping apXK_Shell because your X doesn't define it
#endif
#ifdef apXK_LeftBar
         apXK_LeftBar,
#else
         -- Skipping apXK_LeftBar because your X doesn't define it
#endif
#ifdef apXK_RightBar
         apXK_RightBar,
#else
         -- Skipping apXK_RightBar because your X doesn't define it
#endif
#ifdef apXK_LeftBox
         apXK_LeftBox,
#else
         -- Skipping apXK_LeftBox because your X doesn't define it
#endif
#ifdef apXK_RightBox
         apXK_RightBox,
#else
         -- Skipping apXK_RightBox because your X doesn't define it
#endif
#ifdef apXK_UpBox
         apXK_UpBox,
#else
         -- Skipping apXK_UpBox because your X doesn't define it
#endif
#ifdef apXK_DownBox
         apXK_DownBox,
#else
         -- Skipping apXK_DownBox because your X doesn't define it
#endif
#ifdef apXK_Pop
         apXK_Pop,
#else
         -- Skipping apXK_Pop because your X doesn't define it
#endif
#ifdef apXK_Read
         apXK_Read,
#else
         -- Skipping apXK_Read because your X doesn't define it
#endif
#ifdef apXK_Edit
         apXK_Edit,
#else
         -- Skipping apXK_Edit because your X doesn't define it
#endif
#ifdef apXK_Save
         apXK_Save,
#else
         -- Skipping apXK_Save because your X doesn't define it
#endif
#ifdef apXK_Exit
         apXK_Exit,
#else
         -- Skipping apXK_Exit because your X doesn't define it
#endif
#ifdef apXK_Repeat
         apXK_Repeat,
#else
         -- Skipping apXK_Repeat because your X doesn't define it
#endif
#ifdef apXK_KP_parenleft
         apXK_KP_parenleft,
#else
         -- Skipping apXK_KP_parenleft because your X doesn't define it
#endif
#ifdef apXK_KP_parenright
         apXK_KP_parenright,
#else
         -- Skipping apXK_KP_parenright because your X doesn't define it
#endif
        ) where

import Graphics.X11.Types

#include "HsAllKeysyms.h"

#ifdef apXK_LineDel
apXK_LineDel          :: KeySym
apXK_LineDel          = #const apXK_LineDel
#endif
#ifdef apXK_CharDel
apXK_CharDel          :: KeySym
apXK_CharDel          = #const apXK_CharDel
#endif
#ifdef apXK_Copy
apXK_Copy             :: KeySym
apXK_Copy             = #const apXK_Copy
#endif
#ifdef apXK_Cut
apXK_Cut              :: KeySym
apXK_Cut              = #const apXK_Cut
#endif
#ifdef apXK_Paste
apXK_Paste            :: KeySym
apXK_Paste            = #const apXK_Paste
#endif
#ifdef apXK_Move
apXK_Move             :: KeySym
apXK_Move             = #const apXK_Move
#endif
#ifdef apXK_Grow
apXK_Grow             :: KeySym
apXK_Grow             = #const apXK_Grow
#endif
#ifdef apXK_Cmd
apXK_Cmd              :: KeySym
apXK_Cmd              = #const apXK_Cmd
#endif
#ifdef apXK_Shell
apXK_Shell            :: KeySym
apXK_Shell            = #const apXK_Shell
#endif
#ifdef apXK_LeftBar
apXK_LeftBar          :: KeySym
apXK_LeftBar          = #const apXK_LeftBar
#endif
#ifdef apXK_RightBar
apXK_RightBar         :: KeySym
apXK_RightBar         = #const apXK_RightBar
#endif
#ifdef apXK_LeftBox
apXK_LeftBox          :: KeySym
apXK_LeftBox          = #const apXK_LeftBox
#endif
#ifdef apXK_RightBox
apXK_RightBox         :: KeySym
apXK_RightBox         = #const apXK_RightBox
#endif
#ifdef apXK_UpBox
apXK_UpBox            :: KeySym
apXK_UpBox            = #const apXK_UpBox
#endif
#ifdef apXK_DownBox
apXK_DownBox          :: KeySym
apXK_DownBox          = #const apXK_DownBox
#endif
#ifdef apXK_Pop
apXK_Pop              :: KeySym
apXK_Pop              = #const apXK_Pop
#endif
#ifdef apXK_Read
apXK_Read             :: KeySym
apXK_Read             = #const apXK_Read
#endif
#ifdef apXK_Edit
apXK_Edit             :: KeySym
apXK_Edit             = #const apXK_Edit
#endif
#ifdef apXK_Save
apXK_Save             :: KeySym
apXK_Save             = #const apXK_Save
#endif
#ifdef apXK_Exit
apXK_Exit             :: KeySym
apXK_Exit             = #const apXK_Exit
#endif
#ifdef apXK_Repeat
apXK_Repeat           :: KeySym
apXK_Repeat           = #const apXK_Repeat
#endif
#ifdef apXK_KP_parenleft
apXK_KP_parenleft     :: KeySym
apXK_KP_parenleft     = #const apXK_KP_parenleft
#endif
#ifdef apXK_KP_parenright
apXK_KP_parenright    :: KeySym
apXK_KP_parenright    = #const apXK_KP_parenright
#endif
