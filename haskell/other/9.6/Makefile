GHC=ghc
GHCFLAGS=
RM=rm
STRIP=strip

.PHONY: all

all: build/main build/main-static

build:
	mkdir build

build/main: src/Main.hs build
	$(GHC) $(GHCFLAGS) src/Main.hs -o build/main
	$(STRIP) build/main

build/main-static: src/Main.hs build
	$(GHC) $(GHCFLAGS) -static src/Main.hs -o build/main-static
	$(STRIP) build/main-static

clean:
	$(RM) -rf src/*.{o,hi} build