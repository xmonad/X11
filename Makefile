# -----------------------------------------------------------------------------
# $Id: Makefile,v 1.18 2004/11/26 16:22:09 simonmar Exp $

TOP = ..
include $(TOP)/mk/boilerplate.mk
-include config.mk

# -----------------------------------------------------------------------------

ifeq "$(X11_BUILD_PACKAGE)" "yes"

SUBDIRS = cbits doc include

ALL_DIRS = \
	Graphics/X11 \
	Graphics/X11/Xlib

PACKAGE = X11
VERSION = 1.0
PACKAGE_DEPS = base

SRC_CC_OPTS += -Iinclude $(X_CFLAGS)

SRC_HC_OPTS += -cpp -fffi
SRC_HC_OPTS += -Iinclude $(X_CFLAGS)
SRC_HSC2HS_OPTS += -Iinclude $(X_CFLAGS)

SRC_HADDOCK_OPTS += -t "X11 Libraries ($(PACKAGE) package)"

endif

# -----------------------------------------------------------------------------

include $(TOP)/mk/target.mk
