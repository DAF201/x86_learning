export PATH="$HOME/opt/cross/bin:$PATH"
nasm kernel_entry.asm -f elf -o kernel_entry.o
i686-elf-gcc -ffreestanding -c kernel.c -o kernel.o
i686-elf-ld -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary
nasm bootsect.asm -f bin -o bootsect.bin
dd if=/dev/zero of=hdd.img bs=512 count=20480 
dd if=bootsect.bin of=hdd.img bs=512 count=1 conv=notrunc  
dd if=kernel.bin of=hdd.img bs=512 seek=1 conv=notrunc 
