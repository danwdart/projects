CC = emcc
CFLAGS =

.PHONY: all

all: build build/index.html

build:
	mkdir build

build/index.html:
	$(CC) $(CFLAGS) src/index.c -o build/index.html

clean:
	$(RM) -r build