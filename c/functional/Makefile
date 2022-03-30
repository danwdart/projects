CC = gcc
CFLAGS =

.PHONY: all

all: build build/functional

build:
	mkdir build

build/functional:
	$(CC) $(CFLAGS) src/functional.c -o build/functional

clean:
	$(RM) -r build