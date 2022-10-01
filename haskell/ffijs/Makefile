GHC = ghcjs
GHCFLAGS = -Wall -Werror -no-keep-o-files -no-keep-hi-files -DGHCJS_NODE # confusion about main otherwise
GHCFLAGS_LIB = ${GHCFLAGS} -no-hs-main

.PHONY: all

all: build/ffihstojs

build/ffihstojs: build
	${GHC} ${GHCFLAGS} src/Main.hs src/libdemo.js -o build/ffihstojs

build:
	mkdir build

obj:
	mkdir obj

lib:
	mkdir lib

clean:
	$(RM) -r build obj lib src/*.js_o src/*.js_hi