#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>

#include <kernel/tty.h>
#include <kernel/gdt.h>

void kernel_early(void) {
	terminal_initialize();
}

void kernel_main(void) {
	uint64_t desc = create_descriptor(0, 0, 0);
	printf("Hello, World!  I am a cheesy Operating System! '%z' done", desc);
}
