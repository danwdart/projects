NASM = nasm
NASMFLAGS = -felf64
LD = ld
LDFLAGS =
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
	$(NASM) $(NASMFLAGS) $< -o $@

clean:
	$(RM) -rf build obj
