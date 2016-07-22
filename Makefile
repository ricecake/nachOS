SHELL := /bin/bash

BUILDDIR = build
DATADIR  = $(BUILDDIR)/data
TOOLDIR  = $(BUILDDIR)/tools
DIRS    := $(DATADIR) $(TOOLDIR)

GCCVERSION     = 6.1.0
BINUTILVERSION = 2.26.1

.PHONY : tools build_dirs

tools: build_dirs $(TOOLDIR)/binutils $(TOOLDIR)/gcc

build_dirs:
	mkdir -p $(DIRS)

$(TOOLDIR)/binutils: $(DATADIR)/binutils-$(BINUTILVERSION)
	pushd $(DATADIR)/binutils-$(BINUTILVERSION) && \
	./configure && \
	make && \
	popd
	ln -s $(DATADIR)/binutils-$(BINUTILVERSION) $(TOOLDIR)/binutils

$(TOOLDIR)/gcc: $(DATADIR)/gcc-$(GCCVERSION)
	ln -s $(DATADIR)/gcc-$(GCCVERSION) $(TOOLDIR)/gcc

$(DATADIR)/binutils-$(BINUTILVERSION): $(DATADIR)/binutils.tar.bz2
	tar -C $(DATADIR) -xf $(DATADIR)/binutils.tar.bz2

$(DATADIR)/binutils.tar.bz2:
	wget  -O $(DATADIR)/binutils.tar.bz2 http://ftp.gnu.org/gnu/binutils/binutils-$(BINUTILVERSION).tar.bz2

$(DATADIR)/gcc-$(GCCVERSION): $(DATADIR)/gcc.tar.bz2
	tar -C $(DATADIR) -xf $(DATADIR)/gcc.tar.bz2

$(DATADIR)/gcc.tar.bz2:
	wget  -O $(DATADIR)/gcc.tar.bz2      http://ftp.gnu.org/gnu/gcc/gcc-$(GCCVERSION)/gcc-$(GCCVERSION).tar.bz2
