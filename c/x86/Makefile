CC = gcc
CFLAGS = -g -fno-stack-protector -z execstack

.PHONY: all

all: build build/whatdoesthisdo

build:
	mkdir build

build/whatdoesthisdo:
	$(CC) $(CFLAGS) src/whatdoesthisdo.c -o build/whatdoesthisdo

clean:
	$(RM) -r build