# Makefile is located in QuesOS/bin/
#-----------------------------------

# Create the OS.bin file (use 'Make OS')
OS: bootSect.bin fileTable.bin kernel.bin
	cat bootSect.bin fileTable.bin kernel.bin > OS.bin

# Create bootsector binary file (use 'Make bootSect.bin')
bootSect.bin:
	fasm ../src/asm/bootSect.asm
	mv ../src/asm/bootSect.bin ./
	
# Create file table binary file (use 'Make fileTable.bin')
fileTable.bin:
	fasm ../src/asm/fileTable.asm
	mv ../src/asm/fileTable.bin ./

# Create kernel binary file (use 'Make kernel.bin')
kernel.bin:
	fasm ../src/asm/kernel.asm
	mv ../src/asm/kernel.bin ./

# Clean up binary files (use 'Make clean')
clean:
	rm *.bin
