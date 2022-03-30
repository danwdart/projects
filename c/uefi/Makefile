CC = gcc
CFLAGS = -fno-stack-protector -fpic -fshort-wchar -mno-red-zone -DEFI_FUNCTION_WRAPPER
HEADERPATH = /usr/include/efi # TODO: where is this on nixos?
HEADERS = -I ${HEADERPATH} -I ${HEADERPATH}/x86_64
LIBDIR = /usr/lib
LD = ld
LDFLAGS = -nostdlib -znocombreloc -T ${LIBDIR}/elf_x86_64_efi.lds -shared -Bsymbolic -L ${LIBDIR} -l:libgnuefi.a -l:libefi.a

DISKIMG = build/disk.img
PARTIMG = build/part.img
PARTEDCMD = parted ${DISKIMG} -s -a minimal
DISKSECTS = 204800
PARTSECTS = 202720

all: build/efimain.efi strip

build/efimain.o:
	mkdir build
	${CC} src/efimain.c -c ${CFLAGS} ${HEADERS} -o build/efimain.o

build/efimain.so: build/efimain.o
	ld build/efimain.o ${LIBDIR}/crt0-efi-x86_64.o ${LDFLAGS} -o build/efimain.so

build/efimain.efi: build/efimain.so
	objcopy -j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel -j .rela -j .reloc --target=efi-app-x86_64 build/efimain.so build/efimain.efi

clean:
	rm -rf build

strip:
	strip build/efimain.efi

bootimg: disk partdisk part copyfilestopart parttodisk

disk:
	dd if=/dev/zero of=build/disk.img bs=512 count=${DISKSECTS}

partdisk:
	echo -e "o\ny\nn\n\n\n\nef00\nw\ny\n" | gdisk build/disk.img
	# ${PARTEDCMD} mklabel gpt
	# ${PARTEDCMD} mkpart EFI FAT16 2048s # 93716s
	# ${PARTEDCMD} toggle 1 boot

part:
	dd if=/dev/zero of=${PARTIMG} bs=512 count=${PARTSECTS}
	mkfs.vfat -F32 ${PARTIMG} # mformat -i ${PARTIMG} -h 32 -t 32 -n 64 -c 1

copyfilestopart:
	mmd -i ${PARTIMG} ::/EFI
	mmd -i ${PARTIMG} ::/EFI/BOOT
	mcopy -i ${PARTIMG} build/efimain.efi ::/EFI/BOOT/BOOTX64.EFI

parttodisk:
	dd if=${PARTIMG} of=${DISKIMG} bs=512 seek=2048 count=${PARTSECTS} conv=notrunc

qemuefi:
	qemu-system-x86_64 -cpu qemu64 -pflash OVMF_CODE.fd -pflash OVMF_VARS.fd -drive file=${DISKIMG},format=raw
