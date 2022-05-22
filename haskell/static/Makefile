GHC = ghc
GHCFLAGS = -static -optl-static

.PHONY: all

all: build build/tesths

build:
	mkdir build

build/tesths: src/test.hs
	$(GHC) $(GHCFLAGS) src/test.hs -o build/tesths
	strip build/tesths

clean:
	$(RM) -r build