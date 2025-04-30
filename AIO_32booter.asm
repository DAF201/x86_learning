	[org 0x7C00]
	[bits 16]
	mov bp, 0x8000               ; stack at 8000
	mov sp, bp
	pusha
	push dx
	mov bx, 0x9000               ; loat to 0x9000
	mov ah, 0x02                 ; read
	mov al, 2                    ; read 16 sectors (8 Mb)
	mov cl, 0x02                 ; read starts from 02 sector
	mov ch, 0x00                 ; cylinter 0
	mov dh, 0x00                 ; header 0
	int 0x13
	jc disk_error
	pop dx
	cmp al, 2
	jne s_err
	popa
	jmp pm_start
disk_error:
	mov bx, DISK_ERROR
	call print_bios
	hlt
	jmp $
s_err:
	mov bx, SECTORS_ERROR
	call print_bios
	hlt
	jmp $
pm_start:
	cli                          ; disable interrupt
	lgdt [gdt_descriptor]        ; load gdt
	mov eax, cr0
	or eax, 0x1                  ; set the cr0 to 32 bits mode
	mov cr0, eax
jmp CODE_SEG:init_pm
	[bits 32]
init_pm:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ebp, 0x90000             ; set the stack in 32 bits mode
	mov esp, ebp
	call begin_pm
	[bits 32]
begin_pm:
	mov ebx, PM_START_MSG
	call print_pm                ; Note that this will be written at the top left corner
	jmp $
gdt_start:                    ; don't remove the labels, they're needed to compute sizes and jumps
	; the GDT starts with a null 8 - byte
	dd 0x0                       ; 4 byte
	dd 0x0                       ; 4 byte
	; GDT for code segment. base = 0x00000000, length = 0xfffff
	; for flags, refer to os - dev.pdf document, page 36
gdt_code:
	dw 0xffff                    ; segment length, bits 0 - 15
	dw 0x0                       ; segment base, bits 0 - 15
	db 0x0                       ; segment base, bits 16 - 23
	db 10011010b                 ; flags (8 bits)
	db 11001111b                 ; flags (4 bits) + segment length, bits 16 - 19
	db 0x0                       ; segment base, bits 24 - 31
	; GDT for data segment. base and length identical to code segment
	; some flags changed, again, refer to os - dev.pdf
gdt_data:
	dw 0xffff
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0
gdt_end:
	; GDT descriptor
gdt_descriptor:
	dw gdt_end - gdt_start - 1   ; size (16 bit), always one less of its true size
	dd gdt_start                 ; address (32 bit)
	; define some constants for later use
	CODE_SEG equ gdt_code - gdt_start
	DATA_SEG equ gdt_data - gdt_start
	; for real mode print
	[bits 16]
print_bios:
	pusha
print_bios_start:
	mov al, [bx]                 ; bx stored corrent index of character to print
	cmp al, 0x00                 ; if 0, then that is the end of string
	je print_bios_print_finish
	mov ah, 0x0e
	int 0x10
	add bx, 1                    ; to next char index
	jmp print_bios_start         ; to print next char
print_bios_print_finish:
	popa
	ret
	;print a new line
print_bios_nl:
	pusha
	mov ah, 0x0e
	mov al, 0x0a
	int 0x10
	mov al, 0x0d
	int 0x10
	popa
	ret
	;for print in 32 bits mode
	[bits 32]
	VIDEO_MEMORY equ 0xb8000
	WHITE_TEXT equ 0x0f
print_pm:
	pusha
	mov edx, VIDEO_MEMORY
print_pm_start:
	mov al, [ebx]
	mov ah, WHITE_TEXT
	cmp al, 0x00
	je print_pm_print_finish
	mov [edx], ax
	add ebx, 1
	add edx, 2
	jmp print_pm_start
print_pm_print_finish:
	popa
	ret
DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Sector read error", 0
PM_START_MSG: db "system entered 32 bits mode", 0
boot_sector:
	times 510 - ($ - $$) db 0
	dw 0xaa55
disk_data:
	times 256 dw 0xdada          ; sector 2 = 512 bytes
	times 256 dw 0xface          ; sector 3 = 512 bytes
