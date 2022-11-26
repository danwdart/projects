CC = gcc
CFLAGS = -lm -L./lib
LD = ld
LDFLAGS = # -lc -emain # ????
LIBS = lib/heap.o lib/linkedlist.o
PLAIN_EXECUTABLES = build/one build/two build/three build/four build/five build/six build/hacker build/spinner
LIB_EXECUTABLES = build/heap build/ll

.PHONY: all

all: build $(PLAIN_EXECUTABLES) $(LIB_EXECUTABLES)

build:
	mkdir build

build/%: src/%.c
	$(CC) $(CFLAGS) $< -o $@

build/ll: lib/libll.c src/ll.c
	$(CC) $(CFLAGS) lib/libll.c src/ll.c -o $@

build/heap: lib/libheap.c src/heap.c
	$(CC) $(CFLAGS) lib/libheap.c src/heap.c -o $@

clean:
	$(RM) -r build src/*.o lib/*.o