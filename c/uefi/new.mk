# https://wiki.osdev.org/GNU-EFI
CC = gcc
CFLAGS = -Wall -Werror -fno-stack-protector -fpic -ffreestanding -fno-stack-check -fshort-wchar -mno-red-zone -maccumulate-outgoing-args
EFIDIR = /nix/store/90cvbs0s6mg5c6xmfqbl5gz463si9vzn-gnu-efi-3.0.11
HEADERPATH = ${EFIDIR}/include/efi
HEADERS = -I ${HEADERPATH} -I ${HEADERPATH}/x86_64
LIBDIR = ${EFIDIR}/lib
LD = ld
LDFLAGS = -T ${LIBDIR}/elf_x86_64_efi.lds -shared -Bsymbolic -L ${LIBDIR} -l:libgnuefi.a -l:libefi.a

DISKIMG = build/disk.img
PARTIMG = build/part.img
PARTEDCMD = parted ${DISKIMG} -s -a minimal
DISKSECTS = 204800
PARTSECTS = 202720

all: build/efimain.efi

build:
	mkdir build

build/efimain.o: build
	${CC} src/efimain.c -c ${CFLAGS} ${HEADERS} -o build/efimain.o

build/efimain.so: build/efimain.o
	ld build/efimain.o ${LIBDIR}/crt0-efi-x86_64.o ${LDFLAGS} -o build/efimain.so

build/efimain.efi: build/efimain.so
	objcopy -j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel -j .rela -j .rel.* -j .rela.* -j .reloc --target=efi-app-x86_64 --subsystem=10 build/efimain.so build/efimain.efi
	strip build/efimain.efi

clean:
	rm -rf build

${PARTIMG}: build/efimain.efi
	dd if=/dev/zero of=${PARTIMG} bs=512 count=${PARTSECTS}
	mkfs.vfat -F32 ${PARTIMG} # mformat -i ${PARTIMG} -h 32 -t 32 -n 64 -c 1
	mmd -i ${PARTIMG} ::/EFI
	mmd -i ${PARTIMG} ::/EFI/BOOT
	mcopy -i ${PARTIMG} build/efimain.efi ::/EFI/BOOT/BOOTX64.EFI

${DISKIMG}: ${PARTIMG}
	dd if=/dev/zero of=build/disk.img bs=512 count=${DISKSECTS}
	sgdisk -o -n1 -t1:ef00 ${DISKIMG}
	dd if=${PARTIMG} of=${DISKIMG} bs=512 seek=2048 count=${PARTSECTS} conv=notrunc

qemuefi: ${DISKIMG}
	qemu-system-x86_64 -enable-kvm -cpu qemu64 -pflash OVMF_CODE.fd -pflash OVMF_VARS.fd -drive file=${DISKIMG},format=raw
