all: fat/efi/boot/bootx64.efi

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
	  -fPIC \
	  -fno-stack-protector               \
      -fshort-wchar                      \
      -mno-red-zone                      \
	  -I/usr/include/efi        \
	  -I/usr/include/efi/x86_64 \
	  -I/home/dwd/.ghcup/ghc/8.10.1/lib/ghc-8.10.1/include \
	  -lefi \
	  -DEFI_FUNCTION_WRAPPER \
	  -o efimain.o

main.o: main.hs
	ghc -c \
	 -dynamic \
     -optc-shared \
	 -optc-fno-stack-protector \
	 -optc-fshort-wchar \
	 -optc-fPIC \
	 -optc-mno-red-zone \
	 -optc-I/usr/include/efi        \
	 -optc-I/usr/include/efi/x86_64 \
	 -optc-lefi \
	 -optc-DEFI_FUNCTION_WRAPPER \
	main.hs

efimain.so: efimain.o main.o
	ghc efimain.o main.o \
     /usr/lib/crt0-efi-x86_64.o \
	 -dynamic \
	 -optl-nostdlib \
	 -shared \
	 -optl-shared \
	 -optl-fPIC \
	 -optl-znocombreloc \
	 -optl-Bsymbolic \
	 -optl-T/usr/lib/elf_x86_64_efi.lds \
	 -optl-L/usr/lib \
	 -optl-L/usr/include/efi \
	 -optl-L/usr/lib/x86_64-linux-gnu \
	 -optl-L/home/dwd/.ghcup/ghc/8.10.1/lib/ghc-8.10.1/rts \
	 -optl-L/home/dwd/.ghcup/ghc/8.10.1/lib/ghc-8.10.1/base-4.14.0.0 \
	 -optl-L/home/dwd/.ghcup/ghc/8.10.1/lib/ghc-8.10.1/integer-gmp-1.0.3.0 \
     -optl-L/home/dwd/.ghcup/ghc/8.10.1/lib/ghc-8.10.1/ghc-prim-0.6.1 \
	 -l:libgnuefi.a \
	 -l:libefi.a \
	 -l:libHSbase-4.14.0.0.a \
	 -l:libHSinteger-gmp-1.0.3.0.a \
	 -l:libHSghc-prim-0.6.1.a \
     -l:libgmp.a \
     -o efimain.so

fat/efi/boot/bootx64.efi: efimain.so
	mkdir -p fat/efi/boot
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
		fat/efi/boot/bootx64.efi

clean:
	rm -rf fat main_stub.h main.chs.h main.chi efimain.so efimain.o main.hi main.hs main.o

emu: fat/efi/boot/bootx64.efi
	qemu-system-x86_64 -cpu host -enable-kvm -serial stdio -M q35 -m 1024 -vga std  -pflash OVMF_CODE.fd -pflash OVMF_VARS.fd -drive file=fat:rw:${PWD}/fat
