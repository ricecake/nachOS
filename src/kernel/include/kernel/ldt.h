#ifndef _KERNEL_LDT_H
#define _KERNEL_LDT_H

#include <kernel/gdt.h>

extern void load_gdt(gdt_ptr_t* gdt);

#endif
