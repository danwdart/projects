CC = gcc
CFLAGS = -Wall -Werror -ldl
GHC = ghc
GHCVER = 9.2.2
GHCFLAGS = -Wall -Werror -shared -dynamic -lHSrts-ghc$(GHCVER) # -dynamic as this ghc can't -fPIC, and include rts

.PHONY: all

all: build build/libHSLib.so build/main

build:
	mkdir build
	
build/libHSLib.so: src/Lib.hs
	$(GHC) $(GHCFLAGS) src/Lib.hs -o build/libHSLib.so

build/main: src/main.c
	$(CC) $(CFLAGS) src/main.c -o build/main

clean:
	$(RM) -r build src/*.o src/*_stub.h src/*.hi