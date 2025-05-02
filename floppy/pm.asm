	[bits 16]
switch_to_pm:
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
	call pm_start
