-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Cursor
-- Copyright   :  (C) Collabora Ltd  2009
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of cursor types defined by \/usr/include/X11/cursorfont.h.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Cursor(

        xC_X_cursor,
        xC_arrow,
        xC_based_arrow_down,
        xC_based_arrow_up,
        xC_boat,
        xC_bogosity,
        xC_bottom_left_corner,
        xC_bottom_right_corner,
        xC_bottom_side,
        xC_bottom_tee,
        xC_box_spiral,
        xC_center_ptr,
        xC_circle,
        xC_clock,
        xC_coffee_mug,
        xC_cross,
        xC_cross_reverse,
        xC_crosshair,
        xC_diamond_cross,
        xC_dot,
        xC_dotbox,
        xC_double_arrow,
        xC_draft_large,
        xC_draft_small,
        xC_draped_box,
        xC_exchange,
        xC_fleur,
        xC_gobbler,
        xC_gumby,
        xC_hand1,
        xC_hand2,
        xC_heart,
        xC_icon,
        xC_iron_cross,
        xC_left_ptr,
        xC_left_side,
        xC_left_tee,
        xC_leftbutton,
        xC_ll_angle,
        xC_lr_angle,
        xC_man,
        xC_mouse,
        xC_pencil,
        xC_pirate,
        xC_plus,
        xC_question_arrow,
        xC_right_ptr,
        xC_right_side,
        xC_right_tee,
        xC_rightbutton,
        xC_rtl_logo,
        xC_sailboat,
        xC_sb_down_arrow,
        xC_sb_h_double_arrow,
        xC_sb_left_arrow,
        xC_sb_right_arrow,
        xC_sb_up_arrow,
        xC_sb_v_double_arrow,
        xC_shuttle,
        xC_sizing,
        xC_spider,
        xC_spraycan,
        xC_star,
        xC_target,
        xC_tcross,
        xC_top_left_arrow,
        xC_top_left_corner,
        xC_top_right_corner,
        xC_top_side,
        xC_top_tee,
        xC_trek,
        xC_ul_angle,
        xC_umbrella,
        xC_ur_angle,
        xC_watch,
        xC_xterm,

        ) where

import Graphics.X11.Xlib.Font

----------------------------------------------------------------
-- Cursors
----------------------------------------------------------------

#include "HsXlib.h"

xC_X_cursor             :: Glyph
xC_X_cursor             = #const XC_X_cursor

xC_arrow                :: Glyph
xC_arrow                = #const XC_arrow

xC_based_arrow_down     :: Glyph
xC_based_arrow_down     = #const XC_based_arrow_down

xC_based_arrow_up       :: Glyph
xC_based_arrow_up       = #const XC_based_arrow_up

xC_boat                 :: Glyph
xC_boat                 = #const XC_boat

xC_bogosity             :: Glyph
xC_bogosity             = #const XC_bogosity

xC_bottom_left_corner   :: Glyph
xC_bottom_left_corner   = #const XC_bottom_left_corner

xC_bottom_right_corner  :: Glyph
xC_bottom_right_corner  = #const XC_bottom_right_corner

xC_bottom_side          :: Glyph
xC_bottom_side          = #const XC_bottom_side

xC_bottom_tee           :: Glyph
xC_bottom_tee           = #const XC_bottom_tee

xC_box_spiral           :: Glyph
xC_box_spiral           = #const XC_box_spiral

xC_center_ptr           :: Glyph
xC_center_ptr           = #const XC_center_ptr

xC_circle               :: Glyph
xC_circle               = #const XC_circle

xC_clock                :: Glyph
xC_clock                = #const XC_clock

xC_coffee_mug           :: Glyph
xC_coffee_mug           = #const XC_coffee_mug

xC_cross                :: Glyph
xC_cross                = #const XC_cross

xC_cross_reverse        :: Glyph
xC_cross_reverse        = #const XC_cross_reverse

xC_crosshair            :: Glyph
xC_crosshair            = #const XC_crosshair

xC_diamond_cross        :: Glyph
xC_diamond_cross        = #const XC_diamond_cross

xC_dot                  :: Glyph
xC_dot                  = #const XC_dot

xC_dotbox               :: Glyph
xC_dotbox               = #const XC_dotbox

xC_double_arrow         :: Glyph
xC_double_arrow         = #const XC_double_arrow

xC_draft_large          :: Glyph
xC_draft_large          = #const XC_draft_large

xC_draft_small          :: Glyph
xC_draft_small          = #const XC_draft_small

xC_draped_box           :: Glyph
xC_draped_box           = #const XC_draped_box

xC_exchange             :: Glyph
xC_exchange             = #const XC_exchange

xC_fleur                :: Glyph
xC_fleur                = #const XC_fleur

xC_gobbler              :: Glyph
xC_gobbler              = #const XC_gobbler

xC_gumby                :: Glyph
xC_gumby                = #const XC_gumby

xC_hand1                :: Glyph
xC_hand1                = #const XC_hand1

xC_hand2                :: Glyph
xC_hand2                = #const XC_hand2

xC_heart                :: Glyph
xC_heart                = #const XC_heart

xC_icon                 :: Glyph
xC_icon                 = #const XC_icon

xC_iron_cross           :: Glyph
xC_iron_cross           = #const XC_iron_cross

xC_left_ptr             :: Glyph
xC_left_ptr             = #const XC_left_ptr

xC_left_side            :: Glyph
xC_left_side            = #const XC_left_side

xC_left_tee             :: Glyph
xC_left_tee             = #const XC_left_tee

xC_leftbutton           :: Glyph
xC_leftbutton           = #const XC_leftbutton

xC_ll_angle             :: Glyph
xC_ll_angle             = #const XC_ll_angle

xC_lr_angle             :: Glyph
xC_lr_angle             = #const XC_lr_angle

xC_man                  :: Glyph
xC_man                  = #const XC_man

xC_middlebutton         :: Glyph
xC_middlebutton         = #const XC_middlebutton

xC_mouse                :: Glyph
xC_mouse                = #const XC_mouse

xC_pencil               :: Glyph
xC_pencil               = #const XC_pencil

xC_pirate               :: Glyph
xC_pirate               = #const XC_pirate

xC_plus                 :: Glyph
xC_plus                 = #const XC_plus

xC_question_arrow       :: Glyph
xC_question_arrow       = #const XC_question_arrow

xC_right_ptr            :: Glyph
xC_right_ptr            = #const XC_right_ptr

xC_right_side           :: Glyph
xC_right_side           = #const XC_right_side

xC_right_tee            :: Glyph
xC_right_tee            = #const XC_right_tee

xC_rightbutton          :: Glyph
xC_rightbutton          = #const XC_rightbutton

xC_rtl_logo             :: Glyph
xC_rtl_logo             = #const XC_rtl_logo

xC_sailboat             :: Glyph
xC_sailboat             = #const XC_sailboat

xC_sb_down_arrow        :: Glyph
xC_sb_down_arrow        = #const XC_sb_down_arrow

xC_sb_h_double_arrow    :: Glyph
xC_sb_h_double_arrow    = #const XC_sb_h_double_arrow

xC_sb_left_arrow        :: Glyph
xC_sb_left_arrow        = #const XC_sb_left_arrow

xC_sb_right_arrow       :: Glyph
xC_sb_right_arrow       = #const XC_sb_right_arrow

xC_sb_up_arrow          :: Glyph
xC_sb_up_arrow          = #const XC_sb_up_arrow

xC_sb_v_double_arrow    :: Glyph
xC_sb_v_double_arrow    = #const XC_sb_v_double_arrow

xC_shuttle              :: Glyph
xC_shuttle              = #const XC_shuttle

xC_sizing               :: Glyph
xC_sizing               = #const XC_sizing

xC_spider               :: Glyph
xC_spider               = #const XC_spider

xC_spraycan             :: Glyph
xC_spraycan             = #const XC_spraycan

xC_star                 :: Glyph
xC_star                 = #const XC_star

xC_target               :: Glyph
xC_target               = #const XC_target

xC_tcross               :: Glyph
xC_tcross               = #const XC_tcross

xC_top_left_arrow       :: Glyph
xC_top_left_arrow       = #const XC_top_left_arrow

xC_top_left_corner      :: Glyph
xC_top_left_corner      = #const XC_top_left_corner

xC_top_right_corner     :: Glyph
xC_top_right_corner     = #const XC_top_right_corner

xC_top_side             :: Glyph
xC_top_side             = #const XC_top_side

xC_top_tee              :: Glyph
xC_top_tee              = #const XC_top_tee

xC_trek                 :: Glyph
xC_trek                 = #const XC_trek

xC_ul_angle             :: Glyph
xC_ul_angle             = #const XC_ul_angle

xC_umbrella             :: Glyph
xC_umbrella             = #const XC_umbrella

xC_ur_angle             :: Glyph
xC_ur_angle             = #const XC_ur_angle

xC_watch                :: Glyph
xC_watch                = #const XC_watch

xC_xterm                :: Glyph
xC_xterm                = #const XC_xterm

----------------------------------------------------------------
-- End
----------------------------------------------------------------
