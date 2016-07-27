SHELL := /bin/bash

current_dir := $(shell pwd)

NPROCS:=$(shell grep -c ^processor /proc/cpuinfo)

BUILDDIR := build
DATADIR  := $(BUILDDIR)/data
TOOLDIR  := $(BUILDDIR)/tools
DIRS     := $(DATADIR) $(TOOLDIR)

GCCVERSION     := 6.1.0
BINUTILVERSION := 2.26.1

PREFIX := $(current_dir)/$(TOOLDIR)
TARGET := i686-elf
PATH   := $(PREFIX)/bin:$(PATH)"

CC := i686-elf-gcc
AS := i686-elf-as
AR := i686-elf-ar

OBJ_LINK_LIST := src/boot.o src/kernel.o

.PHONY : tools build_dirs kernel image

image: kernel
	mkdir -p $(BUILDDIR)/isodir/boot/grub
	cp src/grub.cfg $(BUILDDIR)/isodir/boot/grub/grub.cfg
	cp src/nachos.bin $(BUILDDIR)/isodir/boot/nachos.bin
	grub-mkrescue -o build/nachos.iso $(BUILDDIR)/isodir

kernel: tools src/nachos.bin

tools: build_dirs $(BUILDDIR)/binutils $(BUILDDIR)/gcc

build_dirs:
	mkdir -p $(DIRS)

src/kernel.o: src/kernel.c
	$(CC) -c $< -o $@ -std=gnu11 -ffreestanding -O3 -Wall -Wextra

src/boot.o: src/boot.s
	$(CC) -c $< -o $@ -ffreestanding -O3 -Wall -Wextra

src/nachos.bin: $(OBJ_LINK_LIST)
	$(CC) -T src/linker.ld -o $@ -ffreestanding -O3 -nostdlib $(OBJ_LINK_LIST) -lgcc

$(BUILDDIR)/binutils: $(DATADIR)/binutils-$(BINUTILVERSION)
	mkdir -p $(DATADIR)/binutils

	cd $(DATADIR)/binutils && \
		../binutils-$(BINUTILVERSION)/configure --target=$(TARGET) --prefix="$(PREFIX)" --with-sysroot --disable-nls --disable-werror && \
		make -j -l$(NPROCS) && \
		make -j -l$(NPROCS) install

	ln -s ../$(DATADIR)/binutils $(BUILDDIR)/binutils

$(BUILDDIR)/gcc: $(DATADIR)/gcc-$(GCCVERSION)
	mkdir -p $(DATADIR)/gcc

	cd $(DATADIR)/gcc-$(GCCVERSION) && \
		./contrib/download_prerequisites

	cd $(DATADIR)/gcc && \
		../gcc-$(GCCVERSION)/configure --target=$(TARGET) --prefix="$(PREFIX)" --disable-nls --enable-languages=c,c++ --without-headers && \
		make -j -l$(NPROCS) all-gcc && \
		make -j -l$(NPROCS) all-target-libgcc && \
		make -j -l$(NPROCS) install-gcc && \
		make -j -l$(NPROCS) install-target-libgcc

	ln -s ../$(DATADIR)/gcc $(BUILDDIR)/gcc

$(DATADIR)/binutils-$(BINUTILVERSION): $(DATADIR)/binutils.tar.bz2
	tar -C $(DATADIR) -xf $(DATADIR)/binutils.tar.bz2

$(DATADIR)/binutils.tar.bz2:
	wget  -O $(DATADIR)/binutils.tar.bz2 http://ftp.gnu.org/gnu/binutils/binutils-$(BINUTILVERSION).tar.bz2

$(DATADIR)/gcc-$(GCCVERSION): $(DATADIR)/gcc.tar.bz2
	tar -C $(DATADIR) -xf $(DATADIR)/gcc.tar.bz2

$(DATADIR)/gcc.tar.bz2:
	wget  -O $(DATADIR)/gcc.tar.bz2      http://ftp.gnu.org/gnu/gcc/gcc-$(GCCVERSION)/gcc-$(GCCVERSION).tar.bz2
