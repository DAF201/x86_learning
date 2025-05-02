disk_load:
	pusha
	push dx
	mov ah, 0x02                 ; read
	mov al, dh                   ; read dh sectors (which is 2 here)
	mov cl, 0x02                 ; read starts from 02 sector
	mov ch, 0x00                 ; cylinter 0
	mov dh, 0x00                 ; header 0
	int 0x13
	
	jc disk_error                ; if error, jump to disk_error
	
	pop dx
	cmp al, dh                   ; check number of sectors read
	jne s_err                    ; if not equal, jump to s_error
	popa
	
	ret
	
disk_error:
	mov bx, DISK_ERROR
	call print_string_pm
	hlt
	jmp $
	
	
s_err:
	mov bx, SECTORS_ERROR
	call print_string_pm
	hlt
	jmp $
