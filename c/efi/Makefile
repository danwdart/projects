CC = gcc
CFLAGS = -fno-stack-protector -fpic -fshort-wchar -mno-red-zone -DEFI_FUNCTION_WRAPPER
HEADERPATH = /usr/include/efi
HEADERS = -I ${HEADERPATH} -I ${HEADERPATH}/x86_64
LIBDIR = /usr/lib
LD = ld
LDFLAGS = -nostdlib -znocombreloc -T ${LIBDIR}/elf_x86_64_efi.lds -shared -Bsymbolic -L ${LIBDIR} -l:libgnuefi.a -l:libefi.a

all: efimain.efi strip

efimain.o:
	${CC} efimain.c -c ${CFLAGS} ${HEADERS} -o efimain.o

efimain.so: efimain.o
	ld efimain.o ${LIBDIR}/crt0-efi-x86_64.o ${LDFLAGS} -o efimain.so

efimain.efi: efimain.so
	objcopy -j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel -j .rela -j .reloc --target=efi-app-x86_64 efimain.so efimain.efi

clean:
	rm -rf *.o *.so *.efi

strip:
	strip efimain.efi
