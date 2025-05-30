GHC=javascript-unknown-ghcjs-ghc
GHCFLAGS=
RM=rm
CLOSURE=closure-compiler
CLOSUREFLAGS=--compilation_level SIMPLE

.PHONY: all

all: build/main.min.js build/main-static.min.js

build:
	mkdir build

build/main.js: src/Main.hs build
	$(GHC) $(GHCFLAGS) src/Main.hs -o build/main.js

build/main.min.js: build/main.js
	$(CLOSURE) $(CLOSUREFLAGS) --js build/main --js_output_file build/main.min.js

build/main-static.js: src/Main.hs build
	$(GHC) $(GHCFLAGS) -static src/Main.hs -o build/main-static.js

build/main-static.min.js: build/main-static.js
	$(CLOSURE) $(CLOSUREFLAGS) --js build/main-static --js_output_file build/main-static.min.js

clean:
	$(RM) -rf src/*.{o,hi} build