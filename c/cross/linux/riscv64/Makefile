CC = riscv64-unknown-linux-gnu-gcc
CFLAGS = -lm
EXECUTABLES = build/one build/two build/three build/four build/five build/six build/hacker build/spinner

.PHONY: all

all: build $(EXECUTABLES)

build:
	mkdir build

build/%: src/%.c
	$(CC) $(CFLAGS) $< -o $@

clean:
	$(RM) -r build