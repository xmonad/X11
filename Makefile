# -----------------------------------------------------------------------------
# $Id: Makefile,v 1.16 2004/03/07 01:04:23 ross Exp $

TOP = ..
include $(TOP)/mk/boilerplate.mk

# -----------------------------------------------------------------------------

SUBDIRS = cbits doc include

ALL_DIRS = \
	Graphics/X11 \
	Graphics/X11/Xlib

PACKAGE = X11
PACKAGE_DEPS = base

SRC_CC_OPTS += -Iinclude $(X_CFLAGS)

SRC_HC_OPTS += -cpp -fffi
SRC_HC_OPTS += -Iinclude $(X_CFLAGS)
SRC_HSC2HS_OPTS += -Iinclude $(X_CFLAGS)

SRC_HADDOCK_OPTS += -t "X11 Libraries ($(PACKAGE) package)"

# yeuch, have to get X_CFLAGS & X_LIBS in through CPP to package.conf.in
comma = ,
PACKAGE_CPP_OPTS += -DX_CFLAGS='$(patsubst %,$(comma)"%", $(X_CFLAGS))'
PACKAGE_CPP_OPTS += -DX_LIBS='$(patsubst %,  $(comma)"%", $(X_LIBS))'

# -----------------------------------------------------------------------------

include $(TOP)/mk/target.mk
