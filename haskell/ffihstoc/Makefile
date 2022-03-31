CC = gcc
CFLAGS = -Wall -Werror
GHC = ghc
GHCFLAGS = -Wall -Werror

.PHONY: all

all: build build/main

build:
	mkdir build

build/lib.o: src/lib.c
	$(CC) $(CFLAGS) -c src/lib.c -o build/lib.o

build/main: src/main.hs build/lib.o
	$(GHC) $(GHCFLAGS) build/lib.o src/main.hs -o build/main

clean:
	$(RM) -r build src/*.o src/*.hi
