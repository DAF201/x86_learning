[org 0x7C00]                ;begin program, tells the compiler the program will be loaded at 7C00

mov si, message             ;assign the si(text register) with text message
call print                  ;call the print function, will return to the next instruction after finished(after executing the ret instruction)

jmp $                       ;dead loop?

print:                      ;print function defination
    
.next:
    lodsb                   ;load string bytes from si to AL(arithmetic register load bits), incrase SI(source index, the begining pointer of the string)               
    or al, al               ;compare al and al, which always return al, and it will set the zero flag of al which jz needs           
    jz .done                ;if AL is 0, jump to .done label
    mov ah, 0x0e            ;else set ah to 0x0e(15), which is the high byte of the AX, will be used in next instruction
    int 0x10                ;call bios interrupt to do something, the instruction was stored in the ah(0x0e, which is print in text mode)
    jmp .next               ;go back to .next label to print next character

.done:                      ;end of the function
    ret                     ;function return, pop all the values stored in stack

message db "Hello, OS!", 0  ;string message to print

times 510 - ($ - $$) db 0   ;fill with 0 until 510
dw 0xaa55                   ;write 0xaa55 to 511 and 512

                            ;1: the BIOS will try to find a bootloader(512bytes, ends with aa55)
                            ;2: the bootloader being loaded to 0x7C00
                            ;3: jump to 7C00 and start executing
