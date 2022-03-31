CC = gcc
CFLAGS = -Wall -Werror -I$(shell ghc --print-libdir)/include
GHC = ghc
GHCFLAGS = -Wall -Werror -no-hs-main

.PHONY: all

all: build build/main

build:
	mkdir build

build/main: build/Lib.o build/main.o
	$(GHC) $(GHCFLAGS) build/Lib.o build/main.o -o build/main

build/main.o: src/main.c
	$(CC) $(CFLAGS) src/main.c -c -o build/main.o

build/Lib.o: src/Lib.hs
	$(GHC) $(GHCFLAGS) -c -o build/Lib.o src/Lib.hs 

clean:
	$(RM) -r src/*stub.h src/*.o src/*.hi build