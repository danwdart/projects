AS = riscv64-unknown-linux-gnu-as
ASFLAGS =
LD = riscv64-unknown-linux-gnu-ld
LDFLAGS = -nostdlib -static
EXECUTABLES = build/hello
RM = rm

.PHONY: all

all: build obj $(EXECUTABLES)

build:
	mkdir build

obj:
	mkdir obj

build/%: obj/%.o
	$(LD) $(LDFLAGS) $< -o $@

obj/%.o: src/%.asm
	$(AS) $(ASFLAGS) $< -o $@

clean:
	$(RM) -rf build obj
