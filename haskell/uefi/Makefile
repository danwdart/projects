all: efi/boot/bootx64.efi

main.hs:
	c2hs \
		--cppopts=-I/usr/include/efi \
		--cppopts=-I/usr/include/efi/x86_64 \
		--cppopts=-lefi \
		main.chs \
		-omain.hs
	# hsc2hs -I/usr/include/efi -I/usr/include/efi/x86_64 main.hsc

efimain.o: 
	gcc efimain.c                            \
      -c                                 \
	  -nostdlib \
	  -shared \
	  -fno-stack-protector               \
      -fshort-wchar                      \
      -mno-red-zone                      \
	  -I/usr/include/efi        \
	  -I/usr/include/efi/x86_64 \
	  -I/home/dwd/.stack/programs/x86_64-linux/ghc-tinfo6-8.8.3/lib/ghc-8.8.3/include \
	  -lefi \
	  -DEFI_FUNCTION_WRAPPER \
	  -o efimain.o

main.o: main.hs
	ghc -c \
	 -optc-fno-stack-protector \
	 -optc-fshort-wchar \
	 -optc-mno-red-zone \
	 -optc-I/usr/include/efi        \
	 -optc-I/usr/include/efi/x86_64 \
	 -optc-lefi \
	 -optc-DEFI_FUNCTION_WRAPPER \
	main.hs

efimain.so: efimain.o main.o
	ld efimain.o \
     /usr/lib/crt0-efi-x86_64.o \
	 -nostdlib \
	 -shared \
	 -znocombreloc \
	 -Bsymbolic \
	 -T /usr/lib/elf_x86_64_efi.lds \
	 -L /usr/lib \
	 -L /usr/include/efi \
	 -L /usr/lib/x86_64-linux-gnu \
	 -l:libffi.a \
	 -l:libgmp.a \
	 -l:libc.a \
	 -l:libgnuefi.a \
	 -l:libefi.a \
     -o efimain.so

efi/boot/bootx64.efi: efimain.so
	mkdir -p efi/boot
	objcopy -j .text                \
		-j .sdata               \
		-j .data                \
		-j .dynamic             \
		-j .dynsym              \
		-j .rel                 \
		-j .rela                \
		-j .reloc               \
		--target=efi-app-x86_64 \
		efimain.so                 \
		efi/boot/bootx64.efi

clean:
	rm -rf efi main_stub.h main.chs.h main.chi efimain.so efimain.o main.hi main.hs main.o

emu: efi/boot/bootx64.efi
	qemu-system-x86_64 -cpu host -enable-kvm -serial stdio -M q35 -m 1024 -vga std  -pflash OVMF_CODE.fd -pflash OVMF_VARS.fd -drive file=fat:rw:${PWD}
