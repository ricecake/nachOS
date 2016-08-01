#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>

#include <kernel/tty.h>
#include <kernel/gdt.h>
#include <kernel/ldt.h>

void kernel_early(void) {
	terminal_initialize();
}

uint64_t descriptors[5];
gdt_ptr_t   gdt_ptr;

void kernel_main(void) {
	gdt_ptr.limit = (sizeof(uint64_t) * 5) - 1;
	gdt_ptr.base  = descriptors;

	create_descriptor(&descriptors[0], 0, 0, 0);
	create_descriptor(&descriptors[1], 0, 0x000FFFFF, 0x9A);
	create_descriptor(&descriptors[2], 0, 0x000FFFFF, 0x92);
	create_descriptor(&descriptors[3], 0, 0x000FFFFF, 0xFA);
	create_descriptor(&descriptors[4], 0, 0x000FFFFF, 0xF2);

	load_gdt(&gdt_ptr);
	printf("Hello, World!  I am a cheesy Operating System! '%z' done", descriptors[0]);
}
