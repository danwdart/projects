CC = gcc
CFLAGS = -Wall -Werror

GHC = ghc
GHCFLAGS = -Wall -Werror -no-keep-o-files -no-keep-hi-files # confusion about main otherwise

.PHONY: all dynamic_libs dynamic static_libs static clean

all: dynamic static

dynamic_libs: lib lib/libHSDemo.so lib/libHSDemo_withhelper.so lib/libdemo.so

dynamic: dynamic_libs build build/dlctohs build/dlctohs_withhelper build/dlhstoc build/ffictohs build/ffihstoc

static_libs: lib lib/libHSDemo.a lib/libdemo.a

static: static_libs build build/ffihstoc_static build/ffictohs_static build/ffihstoc_static_fromlibrary build/ffictohs_static_fromlibrary


build:
	mkdir build

obj:
	mkdir obj

lib:
	mkdir lib

lib/libHSDemo.a: lib obj/LibDemo_static.o
	ar -rc lib/libHSDemo.a obj/LibDemo_static.o

lib/libdemo.so: lib src/libdemo.c
	$(CC) $(CFLAGS) -shared -Wl,-shared -fPIC src/libdemo.c -o lib/libdemo.so

lib/libdemo.a: lib obj/libdemo_static.o
	ar -rc lib/libdemo.a obj/libdemo_static.o
	
obj/LibDemo_static.o: obj src/LibDemo.hs
	$(GHC) $(GHCFLAGS) -no-hs-main -static -c -o obj/LibDemo_static.o src/LibDemo.h
	
obj/libdemo_static.o: obj src/libdemo.c
	$(CC) $(CFLAGS) -c src/libdemo.c -o obj/libdemo_static.o

build/dlctohs: src/main.c
	$(CC) $(CFLAGS) -DDYNAMIC_LIBRARY -ldl src/main.c -o build/dlctohs

build/dlctohs_withhelper: src/main.c
	$(CC) $(CFLAGS) -DDYNAMIC_LIBRARY -ldl -DHELPER_MODULE src/main.c -o build/dlctohs_withhelper

build/ffictohs:
	$(GHC) $(GHCFLAGS) -no-hs-main -c -o obj/LibDemo.o src/LibDemo.hs
    $(CC) $(CFLAGS) -I$(shell ghc --print-libdir)/rts/include src/main.c -c -o obj/ffictohs.o
	$(GHC) $(GHCFLAGS) -no-hs-main obj/LibDemo.o obj/ffictohs.o -o build/ffictohs

build/ffictohs_static: obj/LibDemo_static.o obj/ffictohs_static.o
	$(CC) $(CFLAGS) -I$(shell ghc --print-libdir)/rts/include src/main.c -c -o obj/ffictohs_static.o
	$(GHC) $(GHCFLAGS) -no-hs-main -optl-static -static obj/LibDemo_static.o obj/ffictohs_static.o -o build/ffictohs_static

build/ffictohs_static_fromlibrary: src/main.c
	$(GHC) $(GHCFLAGS) -no-hs-main -static -optl-static -Llib -lHSDemo src/main.c -o build/ffictohs_static_fromlibrary

build/ffihstoc: src/Main.hs obj/libdemo.o
	$(CC) $(CFLAGS) -c src/libdemo.c -o obj/libdemo.o
	$(GHC) $(GHCFLAGS) $(GHCFLAGS_ffihstoc) obj/libdemo.o src/Main.hs -o build/ffihstoc

build/ffihstoc_static: src/Main.hs obj/libdemo_static.o
	$(GHC) $(GHCFLAGS) -optl-static -static obj/libdemo_static.o src/Main.hs -o build/ffihstoc_static

build/ffihstoc_static_fromlibrary: src/Main.hs
	$(GHC) $(GHCFLAGS) -static -optl-static -Llib -ldemo src/Main.hs -o build/ffihstoc_static_fromlibrary

clean:
	$(RM) -r build obj lib src/*.o src/*_stub.h src/*.hi