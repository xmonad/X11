# -----------------------------------------------------------------------------
# $Id: Makefile,v 1.1 2003/04/03 23:44:01 reid Exp $

TOP = ..
include $(TOP)/mk/boilerplate.mk

# -----------------------------------------------------------------------------

# SUBDIRS = include

ALL_DIRS = \
	Graphics/X11

PACKAGE = X11
PACKAGE_DEPS = base

SRC_HC_OPTS += -Wall -fffi -cpp -fglasgow-exts
GC_OPTS += --target=ffi 

SRC_HADDOCK_OPTS += -t "X11 Libraries (X11 package)"

# yeuch, have to get X11_CFLAGS & X11_LIBS in through CPP to X11.conf.in
comma = ,
PACKAGE_CPP_OPTS += -DX11_CFLAGS='$(patsubst %,$(comma)"%",$(X11_CFLAGS))'
PACKAGE_CPP_OPTS += -DX11_LIBS='$(patsubst %,$(comma)"%",$(X11_LIBS))'

# -----------------------------------------------------------------------------

include $(TOP)/mk/target.mk
