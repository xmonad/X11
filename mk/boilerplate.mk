# Begin by slurping in the boilerplate from one level up.
# Remember, TOP is the top level of the innermost level
# (FPTOOLS_TOP is the fptools top)

# We need to set TOP to be the TOP that the next level up expects!
# The TOP variable is reset after the inclusion of the fptools
# boilerplate, so we stash TOP away first:
LIBRARY_TOP := $(TOP)
TOP:=$(TOP)/fptools

HIERARCHICAL_LIB = YES

# Some of the libraries rely on GreenCard.  When you compile the GreenCard
# generated code, you have to use -I/usr/lib/ghc-<version>/include so that
# the C compiler can find HsFFI.h.  The easy way of doing this is to use ghc
# as your C compiler.
UseGhcForCc = YES

# NOT YET: Haddock needs to understand about .raw-hs files
#
# Set our source links to point to the CVS repository on the web.
# SRC_HADDOCK_OPTS += -s http://cvs.haskell.org/cgi-bin/cvsweb.cgi/fptools/libaries/$(PACKAGE)

# Pull in the fptools boilerplate
include $(TOP)/mk/boilerplate.mk

# Reset TOP
TOP:=$(LIBRARY_TOP)

# -----------------------------------------------------------------
# Everything after this point
# augments or overrides previously set variables.

-include $(TOP)/mk/paths.mk
-include $(TOP)/mk/opts.mk
-include $(TOP)/mk/suffix.mk
-include $(TOP)/mk/version.mk
