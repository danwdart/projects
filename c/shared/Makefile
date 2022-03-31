CC = gcc
CFLAGS =
CFLAGS_build/dlopen = -rdynamic -ldl
CFLAGS_build/shared.so = -fPIC
LDFLAGS =
EXECUTABLES = build/dlopen
SHARED_LIBRARIES = build/preload.so build/shared.so

.PHONY: all

all: build $(EXECUTABLES) $(SHARED_LIBRARIES)

build:
	mkdir build

build/%: src/%.c
	$(CC) $(CFLAGS) $(CFLAGS_$@) $< -o $@

build/%.so: src/%.c
	$(CC) $(CFLAGS) $(CFLAGS_$@) -shared $< -o $@

clean:
	$(RM) -r build