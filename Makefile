# -----------------------------------------------------------------------------
# $Id: Makefile,v 1.11 2003/05/29 14:44:31 reid Exp $

TOP = .
include $(TOP)/mk/boilerplate.mk

# -----------------------------------------------------------------------------

SUBDIRS = cbits doc

ALL_DIRS = \
	Graphics/X11 \
	Graphics/X11/Xlib

PACKAGE = HSX11
PACKAGE_DEPS = haskell98 HSgreencard

SRC_CC_OPTS += -Wall -Iinclude -I.

SRC_HC_OPTS += -Wall -cpp -fglasgow-exts -fffi
SRC_HC_OPTS += -Iinclude
SRC_HC_OPTS += -package haskell98 -package HSgreencard

SRC_HADDOCK_OPTS += -t "X11 Libraries (${PACKAGE} package)"

# yeuch, have to get X_CFLAGS & X_LIBS in through CPP to package.conf.in
comma = ,
PACKAGE_CPP_OPTS += -DX_CFLAGS='$(patsubst %,$(comma)"%",$(X_CFLAGS))'
PACKAGE_CPP_OPTS += -DX_LIBS='$(patsubst %,$(comma)"%",$(X_LIBS))'
PACKAGE_CPP_OPTS += -DPACKAGE=\"${PACKAGE}\"
PACKAGE_CPP_OPTS += -DPACKAGE_DEPS='$(patsubst %,"%"$(comma),$(PACKAGE_DEPS)) "haskell98"'
PACKAGE_CPP_OPTS += -DLIBRARY=\"HS$(PACKAGE)\"

# -----------------------------------------------------------------------------

include $(TOP)/mk/target.mk
