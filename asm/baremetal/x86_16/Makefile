NASM = nasm
NASMFLAGS =
EXECUTABLES = build/cli.img build/vesa.img
RM = rm

.PHONY: all

all: build $(EXECUTABLES)

build:
	mkdir build

build/%.img: src/%.asm
	$(NASM) $(NASMFLAGS) $< -o $@

clean:
	$(RM) -rf build