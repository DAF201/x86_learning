	[org 0x7c00]
	
stack_init:
	mov bp, 0x8000               ; set stack base to 0x8000
	mov sp, bp                   ; set stack pointer
	
disk_init:
	mov bx, 0x9000               ;load to 0x9000
	mov dh, 3                    ;read 32kb(each sector is 512bytes)
	call disk_load               ;load the disk
	
test_read:
	mov dx, [0x9000]             ; retrieve the first loaded word, 0xdada
	call print_hex
	
	call print_newline
	
	mov dx, [0x9000 + 512]       ; first word from second loaded sector, 0xface
	call print_hex
	
	jmp $
	
	%include "disk_loader.asm"
	
bootloader_format:
	; Magic number
	times 510 - ($ - $$) db 0
	dw 0xaa55
	
test_data:
	; boot sector = sector 1 of cyl 0 of head 0 of hdd 0
	; from now on = sector 2 ...
	times 256 dw 0xdada          ; sector 2 = 512 bytes
	times 256 dw 0xface          ; sector 3 = 512 bytes
	times 126 * 512 db 0         ; fill the 128 sectors
