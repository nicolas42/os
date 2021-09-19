https://www.youtube.com/watch?v=5FnrtmJXsdM&list=PLT7NbkyNWaqajsw8Xh7SP9KJwjfpP8TNX&index=1

filename="${1%.*}"
fasm a.asm
qemu-system-i386 -drive format=raw,file=a.bin,if=ide,index=0,media=disk

