CC = gcc
CFLAGS =
EXECUTABLES = build/functional build/imperative

.PHONY: all

all: build $(EXECUTABLES)

build:
	mkdir build

build/%: src/%.c
	$(CC) $(CFLAGS) $< -o $@
clean:
	$(RM) -r build