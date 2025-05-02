print:
	pusha
	
	; keep this in mind:
	; while (string[i] != 0) { print string[i]; i + + }
	
	; the comparison for string end (null byte)
start:
	mov al, [bx]                 ; 'bx' is the base address for the string
	cmp al, 0
	je done
	
	; the part where we print with the BIOS help
	mov ah, 0x0e
	int 0x10                     ; 'al' already contains the char
	
	; increment pointer and do next loop
	add bx, 1
	jmp start
	
done:
	popa
	ret
	
print_nl:
	pusha
	
	mov ah, 0x0e
	mov al, 0x0a                 ; newline char
	int 0x10
	mov al, 0x0d                 ; carriage return
	int 0x10
	
	popa
	ret
	[bits 32]                    ; using 32 - bit protected mode
	
print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY
	
print_string_pm_loop:
	mov al, [ebx]                ; [ebx] is the address of our character
	mov ah, WHITE_TEXT
	
	cmp al, 0                    ; check if end of string
	je print_string_pm_done
	
	mov [edx], ax                ; store character + attribute in video memory
	add ebx, 1                   ; next char
	add edx, 2                   ; next video memory position
	
	jmp print_string_pm_loop
	
print_string_pm_done:
	popa
	ret
