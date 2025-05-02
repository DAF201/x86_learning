	KERNEL_OFFSET equ 0x1000
	VIDEO_MEMORY equ 0xb8000
	WHITE_TEXT equ 0x0f
	BOOT_DRIVE db 0
	DISK_ERROR db "Disk read error", 0
	SECTORS_ERROR db "Sector read error", 0
	PM_START_MSG db "system entered 32 bits mode", 0
	RL_START_MSG db "started in 16 - bit real mode", 0
