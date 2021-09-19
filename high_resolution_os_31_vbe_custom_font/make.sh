#!/bin/sh
for file in *.asm; do fasm $file; done

# concatenate binary files - order matters!!!
files="bootSect.bin 2ndstage.bin testfont.bin kernel.bin fileTable.bin calculator.bin editor.bin"
cat $files > temp.bin;

# pad to 1.44MB floppy size - works with other sizes too
dd if=/dev/zero of=OS.bin bs=512 count=10000;
dd if=temp.bin of=OS.bin conv=notrunc; # do not truncate the output file

# run
qemu-system-i386 -drive format=raw,file=OS.bin,if=ide,index=0,media=disk

# cleanup
rm $files
# rm OS.bin temp.bin


