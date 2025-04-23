disk_load:
	pusha                        ; save registers
	push dx                      ; the bios call will change it
	mov ah, 0x02                 ; BIOS read
	mov al, dh                   ; dh saved the number of sectors to read as param
	mov cl, 0x02                 ; start read from sector 02(01 is bootloader, 00 not exist)
	mov dh, 0x00                 ; head number 0
	
	int 0x13                     ; bios interrupt to read
	jc disk_error                ; if error
	
	pop dx                       ;
	cmp al, dh                   ; compare target with actual read sectors
	jne sectors_error            ; if not read exact sectors
	
	popa                         ;read success
	ret                          ;return
	
disk_error:
	mov bx, DISK_ERROR_MSG
	call print
	call print_newline
	mov dh, ah                   ; ah = error code, dl = disk drive that dropped the error
	call print_hex               ; check out the code at http: / / stanislavs.org / helppc / int_13 - 1.html
	hlt
	jmp disk_error
	
	
	
sectors_error:
	mov bx, SECTORS_ERROR_MSG
	call print
	call print_newline
	hlt
	jmp sectors_error
	
	%include "printer.asm"
	
DISK_ERROR_MSG: db "Disk read error", 0
SECTORS_ERROR_MSG: db "Sectors read error", 0
