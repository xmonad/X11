# -----------------------------------------------------------------------------

TOP = ..
include $(TOP)/mk/boilerplate.mk
-include config.mk

ifneq "$(findstring clean, $(MAKECMDGOALS))" ""
# if we're cleaning, then config.mk might have been cleaned already
X11_BUILD_PACKAGE=yes
PACKAGE=X11
endif

# -----------------------------------------------------------------------------

ifeq "$(X11_BUILD_PACKAGE)" "yes"

SUBDIRS = cbits doc include

ALL_DIRS = \
	Graphics/X11 \
	Graphics/X11/Xlib

PACKAGE_DEPS = base

SRC_CC_OPTS += -Iinclude $(X_CFLAGS)

SRC_HC_OPTS += -cpp -fffi
SRC_HC_OPTS += -Iinclude $(X_CFLAGS)
SRC_HSC2HS_OPTS += -Iinclude $(X_CFLAGS)

PACKAGE_CPP_OPTS += -DMAINTAINER=$(MAINTAINER)

SRC_HADDOCK_OPTS += -t "X11 Libraries ($(PACKAGE) package)"

endif

EXCLUDED_SRCS += Setup.hs

# -----------------------------------------------------------------------------

DIST_CLEAN_FILES += X11.buildinfo config.cache config.status config.mk

extraclean::
	$(RM) -rf autom4te.cache

include $(TOP)/mk/target.mk
