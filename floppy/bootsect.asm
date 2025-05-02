	[org 0x7C00]
	[bits 16]
	
	mov [BOOT_DRIVE], dl         ;store the boot type 0x00: Floppy 0x80: hard Drive (important, otherwise you will not be able to load kernel)
	
	mov bp, 0x9000               ; set the stack in 16 bits
	mov sp, bp
	
	mov bx, KERNEL_OFFSET        ; load our kernel at 0x1000
	mov dh, 2                    ; read 2 sectors
	mov dl, [BOOT_DRIVE]         ; media type
	call disk_load               ; load kernel to memory at 0x1000
	call switch_to_pm            ; switch to protected mode
	
	%include "disk.asm"
	%include "gdt.asm"
	%include "pm.asm"
	%include "printer.asm"
	%include "static.asm"
	
	[bits 32]
pm_start:
	mov ebx, PM_START_MSG
	call print_string_pm
	call KERNEL_OFFSET           ;jump to kernel
	jmp $
	
boot_sector:
	times 510 - ($ - $$) db 0
	dw 0xaa55
