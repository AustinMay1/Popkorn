default: run

.PHONY: default build run clean
	
build/header.o: header.asm
	mkdir -p build
	nasm -f elf64 header.asm -o build/header.o

build/boot.o: boot.asm
	mkdir -p build
	nasm -f elf64 boot.asm -o build/boot.o

build/kernel.bin: build/header.o build/boot.o linker.ld
	ld -n -o build/kernel.bin -T linker.ld build/header.o build/boot.o

build/popkorn.iso: build/kernel.bin grub.cfg
	mkdir -p build/isofiles/boot/grub
	cp grub.cfg build/isofiles/boot/grub
	cp build/kernel.bin build/isofiles/boot/
	grub-mkrescue -o build/popkorn.iso build/isofiles

run: build/popkorn.iso
	qemu-system-x86_64 -cdrom build/popkorn.iso

build: build/popkorn.iso

clean:
	rm -rf build
