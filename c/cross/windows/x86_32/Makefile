CC = i686-w64-mingw32-gcc
CFLAGS = -lm
EXECUTABLES = build/one.exe build/two.exe build/three.exe build/four.exe build/five.exe build/six.exe build/hacker.exe build/spinner.exe build/windows.exe

.PHONY: all

all: build $(EXECUTABLES)

build:
	mkdir build

build/%.exe: build src/%.c
	$(CC) $(CFLAGS) $< -o $@

clean:
	$(RM) -r build