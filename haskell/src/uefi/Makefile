all: efimain.efi

main.hs:
	hsc2hs -I/usr/include/efi -I/usr/include/efi/x86_64 main.hsc

efimain.o:
	gcc efimain.c                             \
      -c                                 \
      -fno-stack-protector               \
      -fpic                              \
      -fshort-wchar                      \
      -mno-red-zone                      \
	  -I/root/.stack/programs/x86_64-linux/ghc-8.6.5/lib/ghc-8.6.5/include \
      -I/usr/include/efi        \
      -I/usr/include/efi/x86_64 \
      -DEFI_FUNCTION_WRAPPER             \
      -o efimain.o

main.o: main.hs
	ghc -c -optc-fno-stack-protector \
	 -optc-fpic \
	 -optc-fshort-wchar \
	 -optc-mno-red-zone \
	 -optc-I/usr/include/efi \
	 -optc-I/usr/include/efi/x86_64 \
	 -optc-DEFI_FUNCTION_WRAPPER \
	main.hs

efimain.so: efimain.o main.o
	ld efimain.o main.o -fPIC                       \
     /usr/lib/crt0-efi-x86_64.o     \
     -nostdlib                      \
     -znocombreloc                  \
     -T /usr/lib/elf_x86_64_efi.lds \
     -shared                        \
     -Bsymbolic                     \
     -L /usr/include/efi               \
	 -L /usr/lib \
     -l:libgnuefi.a                 \
     -l:libefi.a                    \
     -o efimain.so

efimain.efi: efimain.so
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
		efimain.efi

clean:
	rm efimain.efi main_stub.h efimain.so efimain.o main.hi main.hs main.o