all: efimain.efi

main.hs:
	c2hs --cppopts=-I/usr/include/efi --cppopts=-I/usr/include/efi/x86_64 --cppopts=-lefi main.chs -omain.hs
	# hsc2hs -I/usr/include/efi -I/usr/include/efi/x86_64 main.hsc

efimain.o:
	gcc efimain.c                             \
      -c                                 \
	  -fno-stack-protector               \
	  -fpie \
	  -fpic \
      -fshort-wchar                      \
      -mno-red-zone                      \
      -I/usr/include/efi        \
      -I/usr/include/efi/x86_64 \
	  -lefi \
      -DEFI_FUNCTION_WRAPPER             \
      -o efimain.o

main.o: main.hs
	ghc -c -no-hs-main \
	 -optc-pie \
	 -optc-fpic \
	 -optc-fno-stack-protector \
	 -optc-fshort-wchar \
	 -optc-mno-red-zone \
	 -optc-I/usr/include/efi \
	 -optc-I/usr/include/efi/x86_64 \
	 -optc-DEFI_FUNCTION_WRAPPER \
	main.hs

efimain.so: main.o efimain.o 
	ld main.o efimain.o                     \
     /usr/lib/crt0-efi-x86_64.o     \
     -nostdlib                      \
	 -fpie \
	 -fpic \
	 -shared \
     -znocombreloc                  \
	 -Bsymbolic \
     -T /usr/lib/elf_x86_64_efi.lds \
	 -L /usr/lib \
     -L /usr/include/efi               \
	 -L /home/dwd/.stack/programs/x86_64-linux/ghc-tinfo6-8.6.5/lib/ghc-8.6.5/rts/ \
	 -L /home/dwd/.stack/programs/x86_64-linux/ghc-tinfo6-8.6.5/lib/ghc-8.6.5/base-4.12.0.0/ \
     -l:libgnuefi.a                 \
     -l:libefi.a                    \
	 -l:libHSrts_l.a \
	 -l:libHSbase-4.12.0.0_p.a \
     -o efimain.so

efimain.efi: efimain.so
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

emu:
	qemu-system-x86_64 -cpu host -enable-kvm -serial stdio -M q35 -m 1024 -vga std  -pflash OVMF_CODE.fd -pflash OVMF_VARS.fd -drive file=fat:rw:${PWD}
