# $Id: target.mk,v 1.1 2003/05/22 11:14:32 reid Exp $

TOP:=$(TOP)/..

# This is a standalone library.  That is, it is not (and cannot be)
# built as part of the ghc build process but is built later after you have
# installed GHC.
STANDALONE_PACKAGE = YES

# All the libs in here are "hierarchical", this flag tell the
# installation machinery to make sure that when installing interface
# files we maintain the directory structure.
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

include $(TOP)/mk/target.mk

TOP:=$(LIBRARY_TOP)/..
