-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Types
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of type declarations for interfacing with X11.
--
-----------------------------------------------------------------------------

module Graphics.X11.Types
	(

	XID,
	Mask,
	Atom,
	VisualID,
	Time,
	Window,
	Drawable,
	Font,
	Pixmap,
	Cursor,
	Colormap,
	GContext,
	KeyCode,

	-- * Enumeration types
	-- | These types were introduced to make function types clearer.
	-- Note that the types are synonyms for 'Int', so no extra
	-- typesafety was obtained.

	-- ** Key symbols
	KeySym,

	xK_VoidSymbol,
	xK_BackSpace,
	xK_Tab,
	xK_Linefeed,
	xK_Clear,
	xK_Return,
	xK_Pause,
	xK_Scroll_Lock,
	xK_Sys_Req,
	xK_Escape,
	xK_Delete,
	xK_Multi_key,
	xK_Home,
	xK_Left,
	xK_Up,
	xK_Right,
	xK_Down,
	xK_Prior,
	xK_Page_Up,
	xK_Next,
	xK_Page_Down,
	xK_End,
	xK_Begin,
	xK_Select,
	xK_Print,
	xK_Execute,
	xK_Insert,
	xK_Undo,
	xK_Redo,
	xK_Menu,
	xK_Find,
	xK_Cancel,
	xK_Help,
	xK_Break,
	xK_Mode_switch,
	xK_script_switch,
	xK_Num_Lock,
	xK_KP_Space,
	xK_KP_Tab,
	xK_KP_Enter,
	xK_KP_F1,
	xK_KP_F2,
	xK_KP_F3,
	xK_KP_F4,
	xK_KP_Home,
	xK_KP_Left,
	xK_KP_Up,
	xK_KP_Right,
	xK_KP_Down,
	xK_KP_Prior,
	xK_KP_Page_Up,
	xK_KP_Next,
	xK_KP_Page_Down,
	xK_KP_End,
	xK_KP_Begin,
	xK_KP_Insert,
	xK_KP_Delete,
	xK_KP_Equal,
	xK_KP_Multiply,
	xK_KP_Add,
	xK_KP_Separator,
	xK_KP_Subtract,
	xK_KP_Decimal,
	xK_KP_Divide,
	xK_KP_0,
	xK_KP_1,
	xK_KP_2,
	xK_KP_3,
	xK_KP_4,
	xK_KP_5,
	xK_KP_6,
	xK_KP_7,
	xK_KP_8,
	xK_KP_9,
	xK_F1,
	xK_F2,
	xK_F3,
	xK_F4,
	xK_F5,
	xK_F6,
	xK_F7,
	xK_F8,
	xK_F9,
	xK_F10,
	xK_F11,
	xK_L1,
	xK_F12,
	xK_L2,
	xK_F13,
	xK_L3,
	xK_F14,
	xK_L4,
	xK_F15,
	xK_L5,
	xK_F16,
	xK_L6,
	xK_F17,
	xK_L7,
	xK_F18,
	xK_L8,
	xK_F19,
	xK_L9,
	xK_F20,
	xK_L10,
	xK_F21,
	xK_R1,
	xK_F22,
	xK_R2,
	xK_F23,
	xK_R3,
	xK_F24,
	xK_R4,
	xK_F25,
	xK_R5,
	xK_F26,
	xK_R6,
	xK_F27,
	xK_R7,
	xK_F28,
	xK_R8,
	xK_F29,
	xK_R9,
	xK_F30,
	xK_R10,
	xK_F31,
	xK_R11,
	xK_F32,
	xK_R12,
	xK_F33,
	xK_R13,
	xK_F34,
	xK_R14,
	xK_F35,
	xK_R15,
	xK_Shift_L,
	xK_Shift_R,
	xK_Control_L,
	xK_Control_R,
	xK_Caps_Lock,
	xK_Shift_Lock,
	xK_Meta_L,
	xK_Meta_R,
	xK_Alt_L,
	xK_Alt_R,
	xK_Super_L,
	xK_Super_R,
	xK_Hyper_L,
	xK_Hyper_R,
	xK_space,
	xK_exclam,
	xK_quotedbl,
	xK_numbersign,
	xK_dollar,
	xK_percent,
	xK_ampersand,
	xK_apostrophe,
	xK_quoteright,
	xK_parenleft,
	xK_parenright,
	xK_asterisk,
	xK_plus,
	xK_comma,
	xK_minus,
	xK_period,
	xK_slash,
	xK_0,
	xK_1,
	xK_2,
	xK_3,
	xK_4,
	xK_5,
	xK_6,
	xK_7,
	xK_8,
	xK_9,
	xK_colon,
	xK_semicolon,
	xK_less,
	xK_equal,
	xK_greater,
	xK_question,
	xK_at,
	xK_A,
	xK_B,
	xK_C,
	xK_D,
	xK_E,
	xK_F,
	xK_G,
	xK_H,
	xK_I,
	xK_J,
	xK_K,
	xK_L,
	xK_M,
	xK_N,
	xK_O,
	xK_P,
	xK_Q,
	xK_R,
	xK_S,
	xK_T,
	xK_U,
	xK_V,
	xK_W,
	xK_X,
	xK_Y,
	xK_Z,
	xK_bracketleft,
	xK_backslash,
	xK_bracketright,
	xK_asciicircum,
	xK_underscore,
	xK_grave,
	xK_quoteleft,
	xK_a,
	xK_b,
	xK_c,
	xK_d,
	xK_e,
	xK_f,
	xK_g,
	xK_h,
	xK_i,
	xK_j,
	xK_k,
	xK_l,
	xK_m,
	xK_n,
	xK_o,
	xK_p,
	xK_q,
	xK_r,
	xK_s,
	xK_t,
	xK_u,
	xK_v,
	xK_w,
	xK_x,
	xK_y,
	xK_z,
	xK_braceleft,
	xK_bar,
	xK_braceright,
	xK_asciitilde,
	xK_nobreakspace,
	xK_exclamdown,
	xK_cent,
	xK_sterling,
	xK_currency,
	xK_yen,
	xK_brokenbar,
	xK_section,
	xK_diaeresis,
	xK_copyright,
	xK_ordfeminine,
	xK_guillemotleft,
	xK_notsign,
	xK_hyphen,
	xK_registered,
	xK_macron,
	xK_degree,
	xK_plusminus,
	xK_twosuperior,
	xK_threesuperior,
	xK_acute,
	xK_mu,
	xK_paragraph,
	xK_periodcentered,
	xK_cedilla,
	xK_onesuperior,
	xK_masculine,
	xK_guillemotright,
	xK_onequarter,
	xK_onehalf,
	xK_threequarters,
	xK_questiondown,
	xK_Agrave,
	xK_Aacute,
	xK_Acircumflex,
	xK_Atilde,
	xK_Adiaeresis,
	xK_Aring,
	xK_AE,
	xK_Ccedilla,
	xK_Egrave,
	xK_Eacute,
	xK_Ecircumflex,
	xK_Ediaeresis,
	xK_Igrave,
	xK_Iacute,
	xK_Icircumflex,
	xK_Idiaeresis,
	xK_ETH,
	xK_Eth,
	xK_Ntilde,
	xK_Ograve,
	xK_Oacute,
	xK_Ocircumflex,
	xK_Otilde,
	xK_Odiaeresis,
	xK_multiply,
	xK_Ooblique,
	xK_Ugrave,
	xK_Uacute,
	xK_Ucircumflex,
	xK_Udiaeresis,
	xK_Yacute,
	xK_THORN,
	xK_Thorn,
	xK_ssharp,
	xK_agrave,
	xK_aacute,
	xK_acircumflex,
	xK_atilde,
	xK_adiaeresis,
	xK_aring,
	xK_ae,
	xK_ccedilla,
	xK_egrave,
	xK_eacute,
	xK_ecircumflex,
	xK_ediaeresis,
	xK_igrave,
	xK_iacute,
	xK_icircumflex,
	xK_idiaeresis,
	xK_eth,
	xK_ntilde,
	xK_ograve,
	xK_oacute,
	xK_ocircumflex,
	xK_otilde,
	xK_odiaeresis,
	xK_division,
	xK_oslash,
	xK_ugrave,
	xK_uacute,
	xK_ucircumflex,
	xK_udiaeresis,
	xK_yacute,
	xK_thorn,
	xK_ydiaeresis,

	-- ** Event masks
	EventMask,
	noEventMask,
	keyPressMask,
	keyReleaseMask,
	buttonPressMask,
	buttonReleaseMask,
	enterWindowMask,
	leaveWindowMask,
	pointerMotionMask,
	pointerMotionHintMask,
	button1MotionMask,
	button2MotionMask,
	button3MotionMask,
	button4MotionMask,
	button5MotionMask,
	buttonMotionMask,
	keymapStateMask,
	exposureMask,
	visibilityChangeMask,
	structureNotifyMask,
	resizeRedirectMask,
	substructureNotifyMask,
	substructureRedirectMask,
	focusChangeMask,
	propertyChangeMask,
	colormapChangeMask,
	ownerGrabButtonMask,

	-- ** Event types
	EventType,
	keyPress,
	keyRelease,
	buttonPress,
	buttonRelease,
	motionNotify,
	enterNotify,
	leaveNotify,
	focusIn,
	focusOut,
	keymapNotify,
	expose,
	graphicsExpose,
	noExpose,
	visibilityNotify,
	createNotify,
	destroyNotify,
	unmapNotify,
	mapNotify,
	mapRequest,
	reparentNotify,
	configureNotify,
	configureRequest,
	gravityNotify,
	resizeRequest,
	circulateNotify,
	circulateRequest,
	propertyNotify,
	selectionClear,
	selectionRequest,
	selectionNotify,
	colormapNotify,
	clientMessage,
	mappingNotify,
	lASTEvent,

	-- ** Modifiers
	Modifier,
	shiftMapIndex,
	lockMapIndex,
	controlMapIndex,
	mod1MapIndex,
	mod2MapIndex,
	mod3MapIndex,
	mod4MapIndex,
	mod5MapIndex,
	anyModifier,

	-- ** Key masks
	KeyMask,
	shiftMask,
	lockMask,
	controlMask,
	mod1Mask,
	mod2Mask,
	mod3Mask,
	mod4Mask,
	mod5Mask,

	-- ** Button masks
	ButtonMask,
	button1Mask,
	button2Mask,
	button3Mask,
	button4Mask,
	button5Mask,

	-- ** Buttons
	Button,
	button1,
	button2,
	button3,
	button4,
	button5,

	-- ** Notify modes
	NotifyMode,
	notifyNormal,
	notifyGrab,
	notifyUngrab,
	notifyWhileGrabbed,
	notifyHint,

	-- ** Notify details
	NotifyDetail,
	notifyAncestor,
	notifyVirtual,
	notifyInferior,
	notifyNonlinear,
	notifyNonlinearVirtual,
	notifyPointer,
	notifyPointerRoot,
	notifyDetailNone,

	-- ** Visibility
	Visibility,
	visibilityUnobscured,
	visibilityPartiallyObscured,
	visibilityFullyObscured,

	-- ** Place of window
	Place,
	placeOnTop,
	placeOnBottom,

	-- ** Protocols
	Protocol,
	familyInternet,
	familyDECnet,
	familyChaos,

	-- ** Property notification
	PropertyNotification,
	propertyNewValue,
	propertyDelete,

	-- ** Colormap notification
	ColormapNotification,
	colormapUninstalled,
	colormapInstalled,

	-- ** Grab modes
	GrabMode,
	grabModeSync,
	grabModeAsync,

	-- ** Grab status
	GrabStatus,
	grabSuccess,
	alreadyGrabbed,
	grabInvalidTime,
	grabNotViewable,
	grabFrozen,

	-- ** Allow events
	AllowEvents,
	asyncPointer,
	syncPointer,
	replayPointer,
	asyncKeyboard,
	syncKeyboard,
	replayKeyboard,
	asyncBoth,
	syncBoth,

	-- ** Focus modes
	FocusMode,
	revertToNone,
	revertToPointerRoot,
	revertToParent,

	-- ** Error codes
	ErrorCode,
	success,
	badRequest,
	badValue,
	badWindow,
	badPixmap,
	badAtom,
	badCursor,
	badFont,
	badMatch,
	badDrawable,
	badAccess,
	badAlloc,
	badColor,
	badGC,
	badIDChoice,
	badName,
	badLength,
	badImplementation,
	firstExtensionError,
	lastExtensionError,

	-- ** Return status
	Status,
	throwIfZero,

	-- ** WindowClass
	WindowClass,
	copyFromParent,
	inputOutput,
	inputOnly,

	-- ** Attribute masks
	AttributeMask,
	cWBackPixmap,
	cWBackPixel,
	cWBorderPixmap,
	cWBorderPixel,
	cWBitGravity,
	cWWinGravity,
	cWBackingStore,
	cWBackingPlanes,
	cWBackingPixel,
	cWOverrideRedirect,
	cWSaveUnder,
	cWEventMask,
	cWDontPropagate,
	cWColormap,
	cWCursor,

	-- ** Close down modes
	CloseDownMode,
	destroyAll,
	retainPermanent,
	retainTemporary,

	-- ** QueryBestSize classes
	QueryBestSizeClass,
	cursorShape,
	tileShape,
	stippleShape,

	-- ** Graphics functions
	GXFunction,
	gXclear,
	gXand,
	gXandReverse,
	gXcopy,
	gXandInverted,
	gXnoop,
	gXxor,
	gXor,
	gXnor,
	gXequiv,
	gXinvert,
	gXorReverse,
	gXcopyInverted,
	gXorInverted,
	gXnand,
	gXset,

	-- ** Line styles
	LineStyle,
	lineSolid,
	lineOnOffDash,
	lineDoubleDash,

	-- ** Cap styles
	CapStyle,
	capNotLast,
	capButt,
	capRound,
	capProjecting,

	-- ** Join styles
	JoinStyle,
	joinMiter,
	joinRound,
	joinBevel,

	-- ** Fill styles
	FillStyle,
	fillSolid,
	fillTiled,
	fillStippled,
	fillOpaqueStippled,

	-- ** Fill rules
	FillRule,
	evenOddRule,
	windingRule,

	-- ** Subwindow modes
	SubWindowMode,
	clipByChildren,
	includeInferiors,

	-- ** Coordinate modes
	CoordinateMode,
	coordModeOrigin,
	coordModePrevious,

	-- ** Polygon shapes
	PolygonShape,
	complex,
	nonconvex,
	convex,

	-- ** Arc modes
	ArcMode,
	arcChord,
	arcPieSlice,

	-- ** GC masks
	GCMask,
	gCFunction,
	gCPlaneMask,
	gCForeground,
	gCBackground,
	gCLineWidth,
	gCLineStyle,
	gCCapStyle,
	gCJoinStyle,
	gCFillStyle,
	gCFillRule,
	gCTile,
	gCStipple,
	gCTileStipXOrigin,
	gCTileStipYOrigin,
	gCFont,
	gCSubwindowMode,
	gCGraphicsExposures,
	gCClipXOrigin,
	gCClipYOrigin,
	gCClipMask,
	gCDashOffset,
	gCDashList,
	gCArcMode,
	gCLastBit,

	-- ** Circulation direction
	CirculationDirection,
	raiseLowest,
	lowerHighest,

	-- ** Byte order
	ByteOrder,
	lSBFirst,
	mSBFirst,

	-- ** ColormapAlloc
	ColormapAlloc,
	allocNone,
	allocAll,

	-- ** Mapping requests
	MappingRequest,
	mappingModifier,
	mappingKeyboard,
	mappingPointer,

	-- ** ChangeSaveSetMode
	ChangeSaveSetMode,
	setModeInsert,
	setModeDelete,

	-- ** Bit gravity
	BitGravity,
	forgetGravity,
	northWestGravity,
	northGravity,
	northEastGravity,
	westGravity,
	centerGravity,
	eastGravity,
	southWestGravity,
	southGravity,
	southEastGravity,
	staticGravity,

	-- ** Window gravity
	WindowGravity,
	unmapGravity,

	-- ** Backing store
	BackingStore,
	notUseful,
	whenMapped,
	always,
	doRed,
	doGreen,
	doBlue,

	-- ** Font direction
	FontDirection,
	fontLeftToRight,
	fontRightToLeft,

	) where

import Data.Int
import Data.Word
import Foreign.Marshal.Error

#include "HsXlib.h"

-- ToDo: use newtype
type XID      = #{type XID}
type Mask     = #{type Mask}
type Atom     = #{type Atom}
type VisualID = #{type VisualID}
type Time     = #{type Time}

-- end platform dependency

type Window   = XID
type Drawable = XID
type Font     = XID
type Pixmap   = XID
type Cursor   = XID
type Colormap = XID
type GContext = XID

type KeyCode  = Char

type KeySym   = XID

#{enum KeySym,
 , xK_VoidSymbol	= XK_VoidSymbol
 }

-- TTY Functions, cleverly chosen to map to ascii, for convenience of
-- programming, but could have been arbitrary (at the cost of lookup
-- tables in client code.

#{enum KeySym,
 , xK_BackSpace		= XK_BackSpace
 , xK_Tab		= XK_Tab
 , xK_Linefeed		= XK_Linefeed
 , xK_Clear		= XK_Clear
 , xK_Return		= XK_Return
 , xK_Pause		= XK_Pause
 , xK_Scroll_Lock	= XK_Scroll_Lock
 , xK_Sys_Req		= XK_Sys_Req
 , xK_Escape		= XK_Escape
 , xK_Delete		= XK_Delete
 }

-- International & multi-key character composition
#{enum KeySym,
 , xK_Multi_key		= XK_Multi_key
 }
-- xK_Codeinput		= XK_Codeinput		-- Not defined for SunOS.
-- xK_SingleCandidate	= XK_SingleCandidate	-- Not defined for SunOS.
-- xK_MultipleCandidate	= XK_MultipleCandidate	-- Not defined for SunOS.
-- xK_PreviousCandidate	= XK_PreviousCandidate	-- Not defined for SunOS.

-- Cursor control & motion
#{enum KeySym,
 , xK_Home		= XK_Home
 , xK_Left		= XK_Left
 , xK_Up		= XK_Up
 , xK_Right		= XK_Right
 , xK_Down		= XK_Down
 , xK_Prior		= XK_Prior
 , xK_Page_Up		= XK_Page_Up
 , xK_Next		= XK_Next
 , xK_Page_Down		= XK_Page_Down
 , xK_End		= XK_End
 , xK_Begin		= XK_Begin

 , xK_Select		= XK_Select
 , xK_Print		= XK_Print
 , xK_Execute		= XK_Execute
 , xK_Insert		= XK_Insert
 , xK_Undo		= XK_Undo
 , xK_Redo		= XK_Redo
 , xK_Menu		= XK_Menu
 , xK_Find		= XK_Find
 , xK_Cancel		= XK_Cancel
 , xK_Help		= XK_Help
 , xK_Break		= XK_Break
 , xK_Mode_switch	= XK_Mode_switch
 , xK_script_switch	= XK_script_switch
 , xK_Num_Lock		= XK_Num_Lock
 }

-- Keypad Functions, keypad numbers cleverly chosen to map to ascii
#{enum KeySym,
 , xK_KP_Space		= XK_KP_Space
 , xK_KP_Tab		= XK_KP_Tab
 , xK_KP_Enter		= XK_KP_Enter
 , xK_KP_F1		= XK_KP_F1
 , xK_KP_F2		= XK_KP_F2
 , xK_KP_F3		= XK_KP_F3
 , xK_KP_F4		= XK_KP_F4
 , xK_KP_Home		= XK_KP_Home
 , xK_KP_Left		= XK_KP_Left
 , xK_KP_Up		= XK_KP_Up
 , xK_KP_Right		= XK_KP_Right
 , xK_KP_Down		= XK_KP_Down
 , xK_KP_Prior		= XK_KP_Prior
 , xK_KP_Page_Up	= XK_KP_Page_Up
 , xK_KP_Next		= XK_KP_Next
 , xK_KP_Page_Down	= XK_KP_Page_Down
 , xK_KP_End		= XK_KP_End
 , xK_KP_Begin		= XK_KP_Begin
 , xK_KP_Insert		= XK_KP_Insert
 , xK_KP_Delete		= XK_KP_Delete
 , xK_KP_Equal		= XK_KP_Equal
 , xK_KP_Multiply	= XK_KP_Multiply
 , xK_KP_Add		= XK_KP_Add
 , xK_KP_Separator	= XK_KP_Separator
 , xK_KP_Subtract	= XK_KP_Subtract
 , xK_KP_Decimal	= XK_KP_Decimal
 , xK_KP_Divide		= XK_KP_Divide

 , xK_KP_0		= XK_KP_0
 , xK_KP_1		= XK_KP_1
 , xK_KP_2		= XK_KP_2
 , xK_KP_3		= XK_KP_3
 , xK_KP_4		= XK_KP_4
 , xK_KP_5		= XK_KP_5
 , xK_KP_6		= XK_KP_6
 , xK_KP_7		= XK_KP_7
 , xK_KP_8		= XK_KP_8
 , xK_KP_9		= XK_KP_9

 , xK_F1		= XK_F1
 , xK_F2		= XK_F2
 , xK_F3		= XK_F3
 , xK_F4		= XK_F4
 , xK_F5		= XK_F5
 , xK_F6		= XK_F6
 , xK_F7		= XK_F7
 , xK_F8		= XK_F8
 , xK_F9		= XK_F9
 , xK_F10		= XK_F10
 , xK_F11		= XK_F11
 , xK_L1		= XK_L1
 , xK_F12		= XK_F12
 , xK_L2		= XK_L2
 , xK_F13		= XK_F13
 , xK_L3		= XK_L3
 , xK_F14		= XK_F14
 , xK_L4		= XK_L4
 , xK_F15		= XK_F15
 , xK_L5		= XK_L5
 , xK_F16		= XK_F16
 , xK_L6		= XK_L6
 , xK_F17		= XK_F17
 , xK_L7		= XK_L7
 , xK_F18		= XK_F18
 , xK_L8		= XK_L8
 , xK_F19		= XK_F19
 , xK_L9		= XK_L9
 , xK_F20		= XK_F20
 , xK_L10		= XK_L10
 , xK_F21		= XK_F21
 , xK_R1		= XK_R1
 , xK_F22		= XK_F22
 , xK_R2		= XK_R2
 , xK_F23		= XK_F23
 , xK_R3		= XK_R3
 , xK_F24		= XK_F24
 , xK_R4		= XK_R4
 , xK_F25		= XK_F25
 , xK_R5		= XK_R5
 , xK_F26		= XK_F26
 , xK_R6		= XK_R6
 , xK_F27		= XK_F27
 , xK_R7		= XK_R7
 , xK_F28		= XK_F28
 , xK_R8		= XK_R8
 , xK_F29		= XK_F29
 , xK_R9		= XK_R9
 , xK_F30		= XK_F30
 , xK_R10		= XK_R10
 , xK_F31		= XK_F31
 , xK_R11		= XK_R11
 , xK_F32		= XK_F32
 , xK_R12		= XK_R12
 , xK_F33		= XK_F33
 , xK_R13		= XK_R13
 , xK_F34		= XK_F34
 , xK_R14		= XK_R14
 , xK_F35		= XK_F35
 , xK_R15		= XK_R15
 }

#{enum KeySym,
 , xK_Shift_L		= XK_Shift_L
 , xK_Shift_R		= XK_Shift_R
 , xK_Control_L		= XK_Control_L
 , xK_Control_R		= XK_Control_R
 , xK_Caps_Lock		= XK_Caps_Lock
 , xK_Shift_Lock	= XK_Shift_Lock

 , xK_Meta_L		= XK_Meta_L
 , xK_Meta_R		= XK_Meta_R
 , xK_Alt_L		= XK_Alt_L
 , xK_Alt_R		= XK_Alt_R
 , xK_Super_L		= XK_Super_L
 , xK_Super_R		= XK_Super_R
 , xK_Hyper_L		= XK_Hyper_L
 , xK_Hyper_R		= XK_Hyper_R
 }

#{enum KeySym,
 , xK_space		= XK_space
 , xK_exclam		= XK_exclam
 , xK_quotedbl		= XK_quotedbl
 , xK_numbersign	= XK_numbersign
 , xK_dollar		= XK_dollar
 , xK_percent		= XK_percent
 , xK_ampersand		= XK_ampersand
 , xK_apostrophe	= XK_apostrophe
 , xK_quoteright	= XK_quoteright
 , xK_parenleft		= XK_parenleft
 , xK_parenright	= XK_parenright
 , xK_asterisk		= XK_asterisk
 , xK_plus		= XK_plus
 , xK_comma		= XK_comma
 , xK_minus		= XK_minus
 , xK_period		= XK_period
 , xK_slash		= XK_slash
 , xK_0			= XK_0
 , xK_1			= XK_1
 , xK_2			= XK_2
 , xK_3			= XK_3
 , xK_4			= XK_4
 , xK_5			= XK_5
 , xK_6			= XK_6
 , xK_7			= XK_7
 , xK_8			= XK_8
 , xK_9			= XK_9
 , xK_colon		= XK_colon
 , xK_semicolon		= XK_semicolon
 , xK_less		= XK_less
 , xK_equal		= XK_equal
 , xK_greater		= XK_greater
 , xK_question		= XK_question
 , xK_at		= XK_at
 , xK_A			= XK_A
 , xK_B			= XK_B
 , xK_C			= XK_C
 , xK_D			= XK_D
 , xK_E			= XK_E
 , xK_F			= XK_F
 , xK_G			= XK_G
 , xK_H			= XK_H
 , xK_I			= XK_I
 , xK_J			= XK_J
 , xK_K			= XK_K
 , xK_L			= XK_L
 , xK_M			= XK_M
 , xK_N			= XK_N
 , xK_O			= XK_O
 , xK_P			= XK_P
 , xK_Q			= XK_Q
 , xK_R			= XK_R
 , xK_S			= XK_S
 , xK_T			= XK_T
 , xK_U			= XK_U
 , xK_V			= XK_V
 , xK_W			= XK_W
 , xK_X			= XK_X
 , xK_Y			= XK_Y
 , xK_Z			= XK_Z
 , xK_bracketleft	= XK_bracketleft
 , xK_backslash		= XK_backslash
 , xK_bracketright	= XK_bracketright
 , xK_asciicircum	= XK_asciicircum
 , xK_underscore	= XK_underscore
 , xK_grave		= XK_grave
 , xK_quoteleft		= XK_quoteleft
 , xK_a			= XK_a
 , xK_b			= XK_b
 , xK_c			= XK_c
 , xK_d			= XK_d
 , xK_e			= XK_e
 , xK_f			= XK_f
 , xK_g			= XK_g
 , xK_h			= XK_h
 , xK_i			= XK_i
 , xK_j			= XK_j
 , xK_k			= XK_k
 , xK_l			= XK_l
 , xK_m			= XK_m
 , xK_n			= XK_n
 , xK_o			= XK_o
 , xK_p			= XK_p
 , xK_q			= XK_q
 , xK_r			= XK_r
 , xK_s			= XK_s
 , xK_t			= XK_t
 , xK_u			= XK_u
 , xK_v			= XK_v
 , xK_w			= XK_w
 , xK_x			= XK_x
 , xK_y			= XK_y
 , xK_z			= XK_z
 , xK_braceleft		= XK_braceleft
 , xK_bar		= XK_bar
 , xK_braceright	= XK_braceright
 , xK_asciitilde	= XK_asciitilde
 }

#{enum KeySym,
 , xK_nobreakspace	= XK_nobreakspace
 , xK_exclamdown	= XK_exclamdown
 , xK_cent		= XK_cent
 , xK_sterling		= XK_sterling
 , xK_currency		= XK_currency
 , xK_yen		= XK_yen
 , xK_brokenbar		= XK_brokenbar
 , xK_section		= XK_section
 , xK_diaeresis		= XK_diaeresis
 , xK_copyright		= XK_copyright
 , xK_ordfeminine	= XK_ordfeminine
 , xK_guillemotleft	= XK_guillemotleft
 , xK_notsign		= XK_notsign
 , xK_hyphen		= XK_hyphen
 , xK_registered	= XK_registered
 , xK_macron		= XK_macron
 , xK_degree		= XK_degree
 , xK_plusminus		= XK_plusminus
 , xK_twosuperior	= XK_twosuperior
 , xK_threesuperior	= XK_threesuperior
 , xK_acute		= XK_acute
 , xK_mu		= XK_mu
 , xK_paragraph		= XK_paragraph
 , xK_periodcentered	= XK_periodcentered
 , xK_cedilla		= XK_cedilla
 , xK_onesuperior	= XK_onesuperior
 , xK_masculine		= XK_masculine
 , xK_guillemotright	= XK_guillemotright
 , xK_onequarter	= XK_onequarter
 , xK_onehalf		= XK_onehalf
 , xK_threequarters	= XK_threequarters
 , xK_questiondown	= XK_questiondown
 , xK_Agrave		= XK_Agrave
 , xK_Aacute		= XK_Aacute
 , xK_Acircumflex	= XK_Acircumflex
 , xK_Atilde		= XK_Atilde
 , xK_Adiaeresis	= XK_Adiaeresis
 , xK_Aring		= XK_Aring
 , xK_AE		= XK_AE
 , xK_Ccedilla		= XK_Ccedilla
 , xK_Egrave		= XK_Egrave
 , xK_Eacute		= XK_Eacute
 , xK_Ecircumflex	= XK_Ecircumflex
 , xK_Ediaeresis	= XK_Ediaeresis
 , xK_Igrave		= XK_Igrave
 , xK_Iacute		= XK_Iacute
 , xK_Icircumflex	= XK_Icircumflex
 , xK_Idiaeresis	= XK_Idiaeresis
 , xK_ETH		= XK_ETH
 , xK_Eth		= XK_Eth
 , xK_Ntilde		= XK_Ntilde
 , xK_Ograve		= XK_Ograve
 , xK_Oacute		= XK_Oacute
 , xK_Ocircumflex	= XK_Ocircumflex
 , xK_Otilde		= XK_Otilde
 , xK_Odiaeresis	= XK_Odiaeresis
 , xK_multiply		= XK_multiply
 , xK_Ooblique		= XK_Ooblique
 , xK_Ugrave		= XK_Ugrave
 , xK_Uacute		= XK_Uacute
 , xK_Ucircumflex	= XK_Ucircumflex
 , xK_Udiaeresis	= XK_Udiaeresis
 , xK_Yacute		= XK_Yacute
 , xK_THORN		= XK_THORN
 , xK_Thorn		= XK_Thorn
 , xK_ssharp		= XK_ssharp
 , xK_agrave		= XK_agrave
 , xK_aacute		= XK_aacute
 , xK_acircumflex	= XK_acircumflex
 , xK_atilde		= XK_atilde
 , xK_adiaeresis	= XK_adiaeresis
 , xK_aring		= XK_aring
 , xK_ae		= XK_ae
 , xK_ccedilla		= XK_ccedilla
 , xK_egrave		= XK_egrave
 , xK_eacute		= XK_eacute
 , xK_ecircumflex	= XK_ecircumflex
 , xK_ediaeresis	= XK_ediaeresis
 , xK_igrave		= XK_igrave
 , xK_iacute		= XK_iacute
 , xK_icircumflex	= XK_icircumflex
 , xK_idiaeresis	= XK_idiaeresis
 , xK_eth		= XK_eth
 , xK_ntilde		= XK_ntilde
 , xK_ograve		= XK_ograve
 , xK_oacute		= XK_oacute
 , xK_ocircumflex	= XK_ocircumflex
 , xK_otilde		= XK_otilde
 , xK_odiaeresis	= XK_odiaeresis
 , xK_division		= XK_division
 , xK_oslash		= XK_oslash
 , xK_ugrave		= XK_ugrave
 , xK_uacute		= XK_uacute
 , xK_ucircumflex	= XK_ucircumflex
 , xK_udiaeresis	= XK_udiaeresis
 , xK_yacute		= XK_yacute
 , xK_thorn		= XK_thorn
 , xK_ydiaeresis	= XK_ydiaeresis
 }

type EventMask			= Mask
#{enum EventMask,
 , noEventMask			= NoEventMask
 , keyPressMask			= KeyPressMask
 , keyReleaseMask		= KeyReleaseMask
 , buttonPressMask		= ButtonPressMask
 , buttonReleaseMask		= ButtonReleaseMask
 , enterWindowMask		= EnterWindowMask
 , leaveWindowMask		= LeaveWindowMask
 , pointerMotionMask		= PointerMotionMask
 , pointerMotionHintMask	= PointerMotionHintMask
 , button1MotionMask		= Button1MotionMask
 , button2MotionMask		= Button2MotionMask
 , button3MotionMask		= Button3MotionMask
 , button4MotionMask		= Button4MotionMask
 , button5MotionMask		= Button5MotionMask
 , buttonMotionMask		= ButtonMotionMask
 , keymapStateMask		= KeymapStateMask
 , exposureMask			= ExposureMask
 , visibilityChangeMask		= VisibilityChangeMask
 , structureNotifyMask		= StructureNotifyMask
 , resizeRedirectMask		= ResizeRedirectMask
 , substructureNotifyMask	= SubstructureNotifyMask
 , substructureRedirectMask	= SubstructureRedirectMask
 , focusChangeMask		= FocusChangeMask
 , propertyChangeMask		= PropertyChangeMask
 , colormapChangeMask		= ColormapChangeMask
 , ownerGrabButtonMask		= OwnerGrabButtonMask
 }

type EventType		= Word32
#{enum EventType,
 , keyPress		= KeyPress
 , keyRelease		= KeyRelease
 , buttonPress		= ButtonPress
 , buttonRelease	= ButtonRelease
 , motionNotify		= MotionNotify
 , enterNotify		= EnterNotify
 , leaveNotify		= LeaveNotify
 , focusIn		= FocusIn
 , focusOut		= FocusOut
 , keymapNotify		= KeymapNotify
 , expose		= Expose
 , graphicsExpose	= GraphicsExpose
 , noExpose		= NoExpose
 , visibilityNotify	= VisibilityNotify
 , createNotify		= CreateNotify
 , destroyNotify	= DestroyNotify
 , unmapNotify		= UnmapNotify
 , mapNotify		= MapNotify
 , mapRequest		= MapRequest
 , reparentNotify	= ReparentNotify
 , configureNotify	= ConfigureNotify
 , configureRequest	= ConfigureRequest
 , gravityNotify	= GravityNotify
 , resizeRequest	= ResizeRequest
 , circulateNotify	= CirculateNotify
 , circulateRequest	= CirculateRequest
 , propertyNotify	= PropertyNotify
 , selectionClear	= SelectionClear
 , selectionRequest	= SelectionRequest
 , selectionNotify	= SelectionNotify
 , colormapNotify	= ColormapNotify
 , clientMessage	= ClientMessage
 , mappingNotify	= MappingNotify
 , lASTEvent		= LASTEvent
 }

type Modifier		= Mask
#{enum Modifier,
 , shiftMapIndex	= ShiftMapIndex
 , lockMapIndex		= LockMapIndex
 , controlMapIndex	= ControlMapIndex
 , mod1MapIndex		= Mod1MapIndex
 , mod2MapIndex		= Mod2MapIndex
 , mod3MapIndex		= Mod3MapIndex
 , mod4MapIndex		= Mod4MapIndex
 , mod5MapIndex		= Mod5MapIndex
 , anyModifier		= AnyModifier
 }

type KeyMask		= Modifier
#{enum KeyMask,
 , shiftMask		= ShiftMask
 , lockMask		= LockMask
 , controlMask		= ControlMask
 , mod1Mask		= Mod1Mask
 , mod2Mask		= Mod2Mask
 , mod3Mask		= Mod3Mask
 , mod4Mask		= Mod4Mask
 , mod5Mask		= Mod5Mask
 }

type ButtonMask		= Modifier
#{enum ButtonMask,
 , button1Mask		= Button1Mask
 , button2Mask		= Button2Mask
 , button3Mask		= Button3Mask
 , button4Mask		= Button4Mask
 , button5Mask		= Button5Mask
 }

type Button		= Word32
#{enum Button,
 , button1		= Button1
 , button2		= Button2
 , button3		= Button3
 , button4		= Button4
 , button5		= Button5
 }

type NotifyMode		= Int
-- NotifyNormal and NotifyHint are used as detail in XMotionEvents
#{enum NotifyMode,
 , notifyNormal		= NotifyNormal
 , notifyGrab		= NotifyGrab
 , notifyUngrab		= NotifyUngrab
 , notifyWhileGrabbed	= NotifyWhileGrabbed
 , notifyHint		= NotifyHint
 }

type NotifyDetail	= Int
#{enum NotifyDetail,
 , notifyAncestor	= NotifyAncestor
 , notifyVirtual	= NotifyVirtual
 , notifyInferior	= NotifyInferior
 , notifyNonlinear	= NotifyNonlinear
 , notifyNonlinearVirtual = NotifyNonlinearVirtual
 , notifyPointer	= NotifyPointer
 , notifyPointerRoot	= NotifyPointerRoot
 , notifyDetailNone	= NotifyDetailNone
 }

type Visibility = Int
#{enum Visibility,
 , visibilityUnobscured		= VisibilityUnobscured
 , visibilityPartiallyObscured	= VisibilityPartiallyObscured
 , visibilityFullyObscured	= VisibilityFullyObscured
 }

-- | Place of window relative to siblings
-- (used in Circulation requests or events)
type Place = Int
#{enum Place,
 , placeOnTop		= PlaceOnTop
 , placeOnBottom	= PlaceOnBottom
 }

type Protocol		= Int
#{enum Protocol,
 , familyInternet	= FamilyInternet
 , familyDECnet		= FamilyDECnet
 , familyChaos		= FamilyChaos
 }

type PropertyNotification = Int
#{enum PropertyNotification,
 , propertyNewValue	= PropertyNewValue
 , propertyDelete	= PropertyDelete
 }

type ColormapNotification = Int
#{enum ColormapNotification,
 , colormapUninstalled	= ColormapUninstalled
 , colormapInstalled	= ColormapInstalled
 }

-- Grab{Pointer,Button,Keyboard,Key} Modes
type GrabMode		= Int
#{enum GrabMode,
 , grabModeSync		= GrabModeSync
 , grabModeAsync	= GrabModeAsync
 }

-- Grab{Pointer,Keyboard} reply status

type GrabStatus		= Int
#{enum GrabStatus,
 , grabSuccess		= GrabSuccess
 , alreadyGrabbed	= AlreadyGrabbed
 , grabInvalidTime	= GrabInvalidTime
 , grabNotViewable	= GrabNotViewable
 , grabFrozen		= GrabFrozen
 }

-- AllowEvents modes
type AllowEvents	= Int
#{enum AllowEvents,
 , asyncPointer		= AsyncPointer
 , syncPointer		= SyncPointer
 , replayPointer	= ReplayPointer
 , asyncKeyboard	= AsyncKeyboard
 , syncKeyboard		= SyncKeyboard
 , replayKeyboard	= ReplayKeyboard
 , asyncBoth		= AsyncBoth
 , syncBoth		= SyncBoth
 }

-- {Set,Get}InputFocus Modes
type FocusMode		= Int
#{enum FocusMode,
 , revertToNone		= RevertToNone
 , revertToPointerRoot	= RevertToPointerRoot
 , revertToParent	= RevertToParent
 }

-- Error codes
type ErrorCode		= Int
#{enum ErrorCode,
 , success		= Success
 , badRequest		= BadRequest
 , badValue		= BadValue
 , badWindow		= BadWindow
 , badPixmap		= BadPixmap
 , badAtom		= BadAtom
 , badCursor		= BadCursor
 , badFont		= BadFont
 , badMatch		= BadMatch
 , badDrawable		= BadDrawable
 , badAccess		= BadAccess
 , badAlloc		= BadAlloc
 , badColor		= BadColor
 , badGC		= BadGC
 , badIDChoice		= BadIDChoice
 , badName		= BadName
 , badLength		= BadLength
 , badImplementation	= BadImplementation
 , firstExtensionError	= FirstExtensionError
 , lastExtensionError	= LastExtensionError
 }

type Status		= Int

-- |Xlib functions with return values of type @Status@ return zero on
-- failure and nonzero on success.
throwIfZero :: String -> IO Status -> IO ()
throwIfZero fn_name = throwIf_ (== 0) (const ("Error in function " ++ fn_name))

type WindowClass	= Int
#{enum WindowClass,
 , copyFromParent	= CopyFromParent
 , inputOutput		= InputOutput
 , inputOnly		= InputOnly
 }

-- Window attributes mask
type AttributeMask	= Mask
#{enum AttributeMask,
 , cWBackPixmap		= CWBackPixmap
 , cWBackPixel		= CWBackPixel
 , cWBorderPixmap	= CWBorderPixmap
 , cWBorderPixel	= CWBorderPixel
 , cWBitGravity		= CWBitGravity
 , cWWinGravity		= CWWinGravity
 , cWBackingStore	= CWBackingStore
 , cWBackingPlanes	= CWBackingPlanes
 , cWBackingPixel	= CWBackingPixel
 , cWOverrideRedirect	= CWOverrideRedirect
 , cWSaveUnder		= CWSaveUnder
 , cWEventMask		= CWEventMask
 , cWDontPropagate	= CWDontPropagate
 , cWColormap		= CWColormap
 , cWCursor		= CWCursor
 }

-- Used in ChangeCloseDownMode
type CloseDownMode	= Int
#{enum CloseDownMode,
 , destroyAll		= DestroyAll
 , retainPermanent	= RetainPermanent
 , retainTemporary	= RetainTemporary
 }

----------------------------------------------------------------
-- CURSOR STUFF
----------------------------------------------------------------

type QueryBestSizeClass = Int
#{enum QueryBestSizeClass,
 , cursorShape		= CursorShape
 , tileShape		= TileShape
 , stippleShape		= StippleShape
 }

----------------------------------------------------------------
-- GRAPHICS DEFINITIONS
----------------------------------------------------------------

-- graphics functions, as in GC.alu

type   GXFunction	= Int
#{enum GXFunction,
 , gXclear		= GXclear
 , gXand		= GXand
 , gXandReverse		= GXandReverse
 , gXcopy		= GXcopy
 , gXandInverted	= GXandInverted
 , gXnoop		= GXnoop
 , gXxor		= GXxor
 , gXor			= GXor
 , gXnor		= GXnor
 , gXequiv		= GXequiv
 , gXinvert		= GXinvert
 , gXorReverse		= GXorReverse
 , gXcopyInverted	= GXcopyInverted
 , gXorInverted		= GXorInverted
 , gXnand		= GXnand
 , gXset		= GXset
 }

type   LineStyle	= Int
#{enum LineStyle,
 , lineSolid		= LineSolid
 , lineOnOffDash	= LineOnOffDash
 , lineDoubleDash	= LineDoubleDash
 }

type   CapStyle		= Int
#{enum CapStyle,
 , capNotLast		= CapNotLast
 , capButt		= CapButt
 , capRound		= CapRound
 , capProjecting	= CapProjecting
 }

type   JoinStyle	= Int
#{enum JoinStyle,
 , joinMiter		= JoinMiter
 , joinRound		= JoinRound
 , joinBevel		= JoinBevel
 }

type   FillStyle	= Int
#{enum FillStyle,
 , fillSolid		= FillSolid
 , fillTiled		= FillTiled
 , fillStippled		= FillStippled
 , fillOpaqueStippled	= FillOpaqueStippled
 }

type   FillRule		= Int
#{enum FillRule,
 , evenOddRule		= EvenOddRule
 , windingRule		= WindingRule
 }

type   SubWindowMode	= Int
#{enum SubWindowMode,
 , clipByChildren	= ClipByChildren
 , includeInferiors	= IncludeInferiors
 }

-- -- SetClipRectangles ordering
-- type   Ordering        = Int
-- {enum Ordering,
-- , unsorted		= Unsorted
-- , ySorted		= YSorted
-- , yXSorted		= YXSorted
-- , yXBanded		= YXBanded
-- }

-- CoordinateMode for drawing routines
type   CoordinateMode	= Int
#{enum CoordinateMode,
 , coordModeOrigin	= CoordModeOrigin
 , coordModePrevious	= CoordModePrevious
 }

type   PolygonShape	= Int
#{enum PolygonShape,
 , complex		= Complex
 , nonconvex		= Nonconvex
 , convex		= Convex
 }

-- Arc modes for PolyFillArc
type   ArcMode		= Int
#{enum ArcMode,
 , arcChord		= ArcChord
 , arcPieSlice		= ArcPieSlice
 }

-- GC components: masks used in CreateGC, CopyGC, ChangeGC, OR'ed into
-- GC.stateChanges

type   GCMask		= Int
#{enum GCMask,
 , gCFunction		= GCFunction
 , gCPlaneMask		= GCPlaneMask
 , gCForeground		= GCForeground
 , gCBackground		= GCBackground
 , gCLineWidth		= GCLineWidth
 , gCLineStyle		= GCLineStyle
 , gCCapStyle		= GCCapStyle
 , gCJoinStyle		= GCJoinStyle
 , gCFillStyle		= GCFillStyle
 , gCFillRule		= GCFillRule
 , gCTile		= GCTile
 , gCStipple		= GCStipple
 , gCTileStipXOrigin	= GCTileStipXOrigin
 , gCTileStipYOrigin	= GCTileStipYOrigin
 , gCFont		= GCFont
 , gCSubwindowMode	= GCSubwindowMode
 , gCGraphicsExposures	= GCGraphicsExposures
 , gCClipXOrigin	= GCClipXOrigin
 , gCClipYOrigin	= GCClipYOrigin
 , gCClipMask		= GCClipMask
 , gCDashOffset		= GCDashOffset
 , gCDashList		= GCDashList
 , gCArcMode		= GCArcMode
 , gCLastBit		= GCLastBit
 }

type   CirculationDirection = Int
#{enum CirculationDirection,
 , raiseLowest		= RaiseLowest
 , lowerHighest		= LowerHighest
 }

-- used in imageByteOrder and bitmapBitOrder
type   ByteOrder	= Int
#{enum ByteOrder,
 , lSBFirst		= LSBFirst
 , mSBFirst		= MSBFirst
 }

type   ColormapAlloc	= Int
#{enum ColormapAlloc,
 , allocNone		= AllocNone
 , allocAll		= AllocAll
 }

type   MappingRequest   = Int
#{enum MappingRequest,
 , mappingModifier	= MappingModifier
 , mappingKeyboard	= MappingKeyboard
 , mappingPointer	= MappingPointer
 }

type   ChangeSaveSetMode = Int
#{enum ChangeSaveSetMode,
 , setModeInsert	= SetModeInsert
 , setModeDelete	= SetModeDelete
 }

type   BitGravity	= Int
#{enum BitGravity,
 , forgetGravity	= ForgetGravity
 , northWestGravity	= NorthWestGravity
 , northGravity		= NorthGravity
 , northEastGravity	= NorthEastGravity
 , westGravity		= WestGravity
 , centerGravity	= CenterGravity
 , eastGravity		= EastGravity
 , southWestGravity	= SouthWestGravity
 , southGravity		= SouthGravity
 , southEastGravity	= SouthEastGravity
 , staticGravity	= StaticGravity
 }

-- All the BitGravity's plus ...
type   WindowGravity   = Int
#{enum WindowGravity,
 , unmapGravity		= UnmapGravity
 }

-- Used in CreateWindow for backing-store hint
type   BackingStore	= Int
#{enum BackingStore,
 , notUseful		= NotUseful
 , whenMapped		= WhenMapped
 , always		= Always
 }

#{enum Word8,
 , doRed		= DoRed
 , doGreen		= DoGreen
 , doBlue		= DoBlue
 }

type   FontDirection    = Int
#{enum FontDirection,
 , fontLeftToRight	= FontLeftToRight
 , fontRightToLeft	= FontRightToLeft
 }
