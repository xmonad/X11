# -----------------------------------------------------------------------------
# $Id: Makefile,v 1.9 2003/05/23 10:06:24 simonmar Exp $

TOP = .
include $(TOP)/mk/boilerplate.mk

# -----------------------------------------------------------------------------

SUBDIRS = cbits doc

ALL_DIRS = \
	Graphics/X11 \
	Graphics/X11/Xlib

PACKAGE = X11
PACKAGE_DEPS = base lang

SRC_CC_OPTS += -Wall -Iinclude -I.

SRC_HC_OPTS += -Wall -cpp -fglasgow-exts -fffi
SRC_HC_OPTS += -Iinclude
SRC_HC_OPTS += -package greencard

SRC_HADDOCK_OPTS += -t "X11 Libraries (${PACKAGE} package)"

# yeuch, have to get X_CFLAGS & X_LIBS in through CPP to package.conf.in
comma = ,
PACKAGE_CPP_OPTS += -DX_CFLAGS='$(patsubst %,$(comma)"%",$(X_CFLAGS))'
PACKAGE_CPP_OPTS += -DX_LIBS='$(patsubst %,$(comma)"%",$(X_LIBS))'

# -----------------------------------------------------------------------------

include $(TOP)/mk/target.mk
