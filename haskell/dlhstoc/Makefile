CC = gcc
CFLAGS = -shared -fPIC -Wall -Werror
GHC = ghc
GHCFLAGS = -Wall -Werror

.PHONY: all

all: build build/lib.so build/main

build:
	mkdir build

build/lib.so: src/lib.c
	$(CC) $(CFLAGS) src/lib.c -o build/lib.so

build/main: src/main.hs
	$(GHC) $(GHCFLAGS) src/main.hs -o build/main

clean:
	$(RM) -r build
