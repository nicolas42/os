# usage: sh make.sh <filename.asm>

cat ${0}
filename="${1%.*}"
echo ${filename}
fasm ${filename}.asm
qemu-system-i386 -drive format=raw,file=${filename}.bin,if=ide,index=0,media=disk

