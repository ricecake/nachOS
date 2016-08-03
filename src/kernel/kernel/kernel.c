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

gdt_entry_t gdt_entries[5];
gdt_ptr_t   gdt_ptr;

void kernel_main(void) {
	gdt_ptr.limit = (sizeof(gdt_entry_t) * 5) - 1;
	gdt_ptr.base  = gdt_entries;

	gdt_set_gate(&gdt_entries[0], 0, 0, 0, 0);                // Null segment
	gdt_set_gate(&gdt_entries[1], 0, 0xFFFFFFFF, 0x9A, 0xCF); // Code segment
	gdt_set_gate(&gdt_entries[2], 0, 0xFFFFFFFF, 0x92, 0xCF); // Data segment
	gdt_set_gate(&gdt_entries[3], 0, 0xFFFFFFFF, 0xFA, 0xCF); // User mode code segment
	gdt_set_gate(&gdt_entries[4], 0, 0xFFFFFFFF, 0xF2, 0xCF); // User mode data segment

	load_gdt(&gdt_ptr);
	printf("Hello, World!  I am a cheesy Operating System! '%z' done", descriptors[0]);
}
