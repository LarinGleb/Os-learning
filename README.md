# Os-learning
This is repo for save temp files. 

## Dependencies
```
$ sudo apt install nasm build-essential manpages-dev
```
You also need to install [qemu](https://github.com/qemu/qemu).
## Compile
Firstly, create a *.o file from boot.asm:
```
$ nasm -f elf32 boot.asm -o boot.o
```
Secondly, link the created *.o file with vga.cpp:
```
$ g++ -m32 vga.cpp boot.o -o kernel.bin -nostdlib -ffreestanding -std=c++11 -mno-red-zone -fno-exceptions -nostdlib -fno-rtti -Wall -Wextra -Werror -T linker.ld -fno-pie
```

Thirdly, run the virtual machine. For example, there are a code for qemu:
 ```
 qemu-system-x86_64 -fda kernel.bin
```
## Documentation and helpfull links

[NASM syntax](https://www.nasm.us/doc/)
[g++ flags](https://linux.die.net/man/1/g++)
[Global Data Table](https://wiki.osdev.org/GDT)  and [A-20 open gate](https://wiki.osdev.org/A20_Line)
[Enter safety mode](https://stackoverflow.com/questions/28645439/how-do-i-enter-32-bit-protected-mode-in-nasm-assembly)
[VGA text buffer](https://en.wikipedia.org/wiki/VGA_text_mode)

## Special thanks

[I'm learning by this cycle of articales](http://3zanders.co.uk/2017/10/16/writing-a-bootloader2/) 
