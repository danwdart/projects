CC = gcc
CFLAGS = -static
GHC = ghc
GHCFLAGS = -static -optl-static

.PHONY: all

all: build build/testc build/tesths

build:
	mkdir build

build/testc: src/test.c
	$(CC) $(CFLAGS) src/test.c -o build/testc
	strip build/testc

build/tesths: src/test.hs
	$(GHC) $(GHCFLAGS) src/test.hs -o build/tesths
	strip build/tesths

clean:
	$(RM) -r build