# -----------------------------------------------------------------------------
# $Id: Makefile,v 1.5 2003/04/27 21:49:48 reid Exp $

TOP = ..
include $(TOP)/mk/boilerplate.mk

# -----------------------------------------------------------------------------

SUBDIRS = cbits

ALL_DIRS = \
	Graphics/X11 \
	Graphics/X11/Xlib

PACKAGE = X11
PACKAGE_DEPS = base

SRC_CC_OPTS += -Wall -Iinclude -I.
SRC_CC_OPTS += -I$(GHC_INCLUDE_DIR) -I$(GHC_RUNTIME_DIR)

SRC_HC_OPTS += -Wall -fffi -cpp -fglasgow-exts
GC_OPTS += --target=ffi 

SRC_HADDOCK_OPTS += -t "X11 Libraries (X11 package)"

# yeuch, have to get X_CFLAGS & X_LIBS in through CPP to X11.conf.in
comma = ,
PACKAGE_CPP_OPTS += -DX_CFLAGS='$(patsubst %,$(comma)"%",$(X_CFLAGS))'
PACKAGE_CPP_OPTS += -DX_LIBS='$(patsubst %,$(comma)"%",$(X_LIBS))'

# -----------------------------------------------------------------------------

STUBOBJS += \
   $(patsubst %.gc,  %_stub_ffi.o, $(GC_SRCS))

# -----------------------------------------------------------------------------

include $(TOP)/mk/target.mk
