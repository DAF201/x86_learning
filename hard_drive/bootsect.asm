[org 0x7C00]
[bits 16]

mov bp, 0x9000
mov sp, bp

call disk_load

call switch_to_pm

%include "disk.asm"
%include "gdt.asm"
%include "pm.asm"
%include "printer.asm"
%include "static.asm"

[bits 32]
pm_start:
    mov ebx, PM_START_MSG
    call print_string_pm
    jmp KERNEL_OFFSET
    jmp $

boot_sector:
    times 510 - ($ - $$) db 0
    dw 0xaa55
