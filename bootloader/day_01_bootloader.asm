	[org 0x7C00]                 ;begin program, tells the compiler the program will be loaded at 7C00
	
stack_init:
	mov ax, 0x9FFF               ; Set the stack segment (base of the stack)
	mov ss, ax
	mov sp, 0xFFFF               ; Set the stack pointer (top of the stack)
	
disk_load_init:
	mov ax, 0x8000               ; disk data starts at 0x8000
	mov es, ax                   ; set where to load the data (for disk reading call)
	
	mov ch, 0                    ; cylinder 0
	mov dh, 0                    ; disk head 0
	mov cl, 2                    ; disk sector 2 (because there's no sector 0)
	
	mov si, 0                    ; disk load fail counter
	mov di, 0                    ; sectors loaded counter (instead of cx)
	
disk_load_attempt:
	mov cl, [sector_num]         ; load updated sector number into CL
	mov ah, 0x02                 ; AH=0x02 is the syscall for read disk
	mov al, 1                    ; load 1 sector at once
	mov bx, 0                    ; buffer offset in segment
	mov dl, 0x80                 ; load from the HDD or SSD
	int 0x13                     ; BIOS disk read
	
	jnc next_section             ; if success, go to the next section
	
	add si, 1                    ; failed, add 1 to fail counter
	cmp si, 5                    ; compare si with 5, if 5 failed just exit
	jae error                    ; failed 5 times, go to error
	
disk_load_reset:
	mov ah, 0x00                 ; failed, try reset drive
	mov dl, 0x80                 ; select driver 0
	int 0x13                     ; system call
	jmp disk_load_attempt        ; retry read
	
next_section:
	add byte [sector_num], 1     ; move to next disk sector
	inc di                       ; increment successfully loaded count
	cmp di, 128                  ; read 128 sectors?
	je done                      ; done reading
	
	mov ax, es                   ;add 512 bytes to ES (512 / 16 = 32 = 0x20)
	add ax, 0x20
	mov es, ax
	
	mov si, 0                    ; reset fail counter
	jmp disk_load_attempt
	
done:
	jmp $                        ; infinite loop (placeholder for next step)
	
error:
	hlt                          ; stop the system
	jmp error                    ; infinite halt
	
sector_num: db 2              ; initial sector number (start from sector 2)
	
	times 510 - ($ - $$) db 0    ; fill with 0 until byte 510
	dw 0xAA55                    ; boot signature
	
	;1: BIOS will look for bootloader with AA55
	;2: BIOS loads it to 0x7C00
	;3: Execution starts from 0x7C00
