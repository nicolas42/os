#-----------------------------------------
# MakeFile should be in <OS>/build/ folder
#-----------------------------------------
# Make variables
CC = clang
CFLAGS = -std=c17 -m32 -march=i386 -ffreestanding -fno-builtin -nostdinc -Oz -fno-stack-protector	
C_FILES = kernel editor calculator
ASM_FILES = bootSect 2ndstage fileTable testfont termu16n termu18n
SRCDIR = ../src/
BINDIR = ../bin/
TMPFILES = bootSect 2ndstage termu16n fileTable kernel calculator editor termu18n testfont
BINFILES = $(TMPFILES:%=$(BINDIR)%.bin)

# Make final OS.bin binary - padding out to full 1.44MB "floppy" bochs img
OS: $(ASM_FILES) $(C_FILES)
	@cat $(BINFILES) > $(BINDIR)temp.bin
	@dd if=/dev/zero of=$(BINDIR)OS.bin bs=512 count=2880 status=none
	@dd if=$(BINDIR)temp.bin of=$(BINDIR)OS.bin conv=notrunc status=none
	@rm $(BINDIR)*[!OS].bin

# Assemble assembly source files into binary files
$(ASM_FILES):
	@fasm $(SRCDIR)$@.asm $(BINDIR)$@.bin 1>/dev/null
	@size=$$(wc -c < $(BINDIR)$@.bin);\
	size=$${size##*( )};\
	echo "$@" "$$size ($$(printf '0x%02X' $$(expr $$size / 512)) sectors)" 

# Compile C source files into binary files, and pad out their size to next 512 byte sector size
$(C_FILES):
	@$(CC) -c $(CFLAGS) -o $@.o $(SRCDIR)$@.c
	@ld -m elf_i386 -T$@.ld $@.o -z notext --oformat binary -o $@.bin
	@rm -f $@.o
	@size=$$(wc -c < $@.bin);\
	size=$${size##*( )};\
	newsize=$$(expr $$size - $$(expr $$size % 512) + 512);\
	echo "$@" "$$size ($$(printf '0x%02X' $$(expr $$size / 512)) sectors) ->" "$$newsize ($$(printf '0x%02X' $$(expr $$newsize / 512)) sectors)";\
	dd if=/dev/zero of=$@.bin bs=1 seek=$$size count=$$(expr $$newsize - $$size) status=none
	@mv $@.bin $(BINDIR)

# Launch OS through qemu 
run:
	qemu-system-i386 -drive format=raw,file=$(BINDIR)OS.bin,if=ide,index=0,media=disk 

# Launch OS through bochs
bochs:
	bochs -qf $(BINDIR).bochsrc

clean:
	rm -f $(BINDIR)*.bin
