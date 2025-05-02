dap:
    db 0x10               ; size of DAP
    db 0x00               ; reserved
    dw 1                  ; number of sectors to read
    dw 0x1000             ; offset
    dw 0x0000             ; segment => 0x0010:0000 = 0x1000
    dq 1                  ; LBA start sector

disk_load:
    pusha
    push ds

    xor ax, ax
    mov ds, ax            ; DS=0 so DS:SI = 0:dap is valid
    mov si, dap
    mov ah, 0x42
    ; DL is assumed to be already set by BIOS
    int 0x13
    jc disk_error

    pop ds
    popa
    ret

disk_error:
    mov bx, DISK_ERROR
    call print_string_pm
    hlt
    jmp $
