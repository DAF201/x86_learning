	gdt_start                    ;start address of GDT
	dq 0x0000000000000000        ;allocate of spcace 8bytes(64 bits)
	
gdt_code:
	dw 0xffff                    ;limit lower 16 bytes, how much space can the segment use, if G flag=1, segment size will be times by 4k, else this value
	dw 0x0000                    ;the lower 16 bits of the segment base address
	db 0x00                      ;the mid 8 bits pf segment base address
	db 11001010b                 ;access flags, such as type, S, PDL, P
	db 11001111b                 ;limit high 4 bytes, D / B, G flag, 
	db 0x00                      ;high 8bits of the segment base address
	
gdt_data:                     ;same as above, but for program data and it can read and write
	dw 0xffff
	dw 0x0000
	db 0x00
	db 10010010b
	db 11001111b
	db 0x00
	
gdt_end:
	
gdt_descriptor:
	dw gdt_end - gdt_start - 1   ;get the size of GDT
	dd gdt_start                 ;get the starting address og GDT
