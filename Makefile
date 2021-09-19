all:
	fasm test.asm
	qemu-system-i386 -drive format=raw,file=test.bin,if=ide,index=0,media=disk
