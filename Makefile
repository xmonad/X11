# -----------------------------------------------------------------------------
# $Id: Makefile,v 1.7 2003/05/22 11:14:30 reid Exp $

TOP = .
include $(TOP)/mk/boilerplate.mk

# -----------------------------------------------------------------------------

SUBDIRS = cbits

ALL_DIRS = \
	Graphics/X11 \
	Graphics/X11/Xlib

PACKAGE = X11
PACKAGE_DEPS = base lang

SRC_CC_OPTS += -Wall -Iinclude -I.

SRC_HC_OPTS += -Wall -cpp -fglasgow-exts
SRC_HC_OPTS += -fffi -package greencard

SRC_HADDOCK_OPTS += -t "X11 Libraries (${PACKAGE} package)"

# yeuch, have to get X_CFLAGS & X_LIBS in through CPP to package.conf.in
comma = ,
PACKAGE_CPP_OPTS += -DX_CFLAGS='$(patsubst %,$(comma)"%",$(X_CFLAGS))'
PACKAGE_CPP_OPTS += -DX_LIBS='$(patsubst %,$(comma)"%",$(X_LIBS))'

# -----------------------------------------------------------------------------

include $(TOP)/mk/target.mk
