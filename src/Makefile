export SYSTEM_HEADER_PROJECTS=libc kernel
export PROJECTS=libc kernel

export HOST=i686-elf

export PREFIX=/usr
export EXEC_PREFIX=$(PREFIX)
export BOOTDIR=/boot
export LIBDIR=$(EXEC_PREFIX)/lib
export INCLUDEDIR=$(PREFIX)/include

export CFLAGS=-O3 -g
export CPPFLAGS=

export AR=${HOST}-ar
export AS=${HOST}-as
export CC=${HOST}-gcc --sysroot=$(PWD)/$(BUILDDIR)/sysroot -isystem=$(INCLUDEDIR)

export DESTDIR=$(PWD)/$(BUILDDIR)/sysroot

compile:
	for target in $(SYSTEM_HEADER_PROJECTS); do \
		$(MAKE) -C $$target install-headers; \
	done
	for target in $(PROJECTS); do \
		$(MAKE) -C $$target install; \
	done

libc:
	$(MAKE) -C libc

kernel:
	$(MAKE) -C kernel

.PHONY: kernel libc compile
