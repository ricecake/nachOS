BUILDDIR = build
DATADIR  = $(BUILDDIR)/data
TOOLDIR  = $(BUILDDIR)/tools
DIRS    := $(DATADIR) $(TOOLDIR)

GCCVERSION     = 6.1.0
BINUTILVERSION = 2.26.1

.PHONY : tools build_dirs binutils gcc

tools: binutils gcc

build_dirs:
	mkdir -p $(DIRS)

binutils: $(DATADIR)/binutils-$(BINUTILVERSION)

gcc: $(DATADIR)/gcc-$(GCCVERSION)

$(DATADIR)/binutils-$(BINUTILVERSION): build_dirs $(DATADIR)/binutils.tar.bz2
	tar -C $(DATADIR) -xf $(DATADIR)/binutils.tar.bz2

$(DATADIR)/binutils.tar.bz2: build_dirs
	wget  -O $(DATADIR)/binutils.tar.bz2 http://ftp.gnu.org/gnu/binutils/binutils-$(BINUTILVERSION).tar.bz2

$(DATADIR)/gcc-$(GCCVERSION): build_dirs $(DATADIR)/gcc.tar.bz2
	tar -C $(DATADIR) -xf $(DATADIR)/gcc.tar.bz2

$(DATADIR)/gcc.tar.bz2: build_dirs
	wget  -O $(DATADIR)/gcc.tar.bz2      http://ftp.gnu.org/gnu/gcc/gcc-$(GCCVERSION)/gcc-$(GCCVERSION).tar.bz2
