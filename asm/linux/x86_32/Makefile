NASM = nasm
NASMFLAGS = -felf32
LD = ld
LDFLAGS = -melf_i386
EXECUTABLES = build/cpuid build/fork build/hello build/runflat build/wrangle
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
	$(NASM) $(NASMFLAGS) $< -o $@

clean:
	$(RM) -rf build obj
