CC = gcc
CFLAGS = -static

.PHONY: all

all: build build/testc

build:
	mkdir build

build/testc: src/test.c
	$(CC) $(CFLAGS) src/test.c -o build/testc
	strip build/testc

clean:
	$(RM) -r build