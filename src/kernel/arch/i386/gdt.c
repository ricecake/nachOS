// Used for creating GDT segment descriptors in 64-bit integer form.

#include <stdio.h>
#include <stdint.h>
#include <kernel/gdt.h>

void gdt_set_gate(gdt_entry_t* entry, uint32_t base, uint32_t limit, uint8_t access, uint8_t gran) {
	entry->base_low    = (base & 0xFFFF);
	entry->base_middle = (base >> 16) & 0xFF;
	entry->base_high   = (base >> 24) & 0xFF;

	entry->limit_low   = (limit & 0xFFFF);
	entry->granularity = (limit >> 16) & 0x0F;

	entry->granularity |= gran & 0xF0;
	entry->access      = access;
}
