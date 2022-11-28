CC = gcc
CFLAGS = -Wall -Werror

CFLAGS_dlctohs = -DDYNAMIC_LIBRARY -ldl
CFLAGS_dlctohs_withhelper = -DDYNAMIC_LIBRARY -ldl -DHELPER_MODULE

CFLAGS_dlhstoc_library = -shared -Wl,-shared -fPIC

CFLAGS_ffictohs_object = -I$(shell ghc --print-libdir)/rts/include
CFLAGS_ffictohs_static_object = -I$(shell ghc --print-libdir)/rts/include

CFLAGS_ffihstoc_object =
CFLAGS_ffihstoc_static_object =

GHC = ghc
GHCFLAGS = -Wall -Werror -no-keep-o-files -no-keep-hi-files # confusion about main otherwise

GHCFLAGS_dlctohs_library = -shared -optl-shared -dynamic -flink-rts # dynamic not ideal
GHCFLAGS_dlctohs_library_withhelper = -shared -optl-shared -dynamic -flink-rts -DMODULE=libHSDemo_withhelper # dynamic not ideal

GHCFLAGS_dlhstoc = -DDYNAMIC_LIBRARY

GHCFLAGS_ffictohs = -no-hs-main
GHCFLAGS_ffictohs_object = -no-hs-main
GHCFLAGS_ffictohs_static = -no-hs-main -optl-static -static
GHCFLAGS_ffictohs_static_object = -no-hs-main -static
GHCFLAGS_ffictohs_static_fromlibrary = -no-hs-main -static -optl-static -Llib -lHSDemo

GHCFLAGS_ffihstoc =
GHCFLAGS_ffihstoc_static = -optl-static -static
GHCFLAGS_ffihstoc_static_fromlibrary = -static -optl-static -Llib -ldemo

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


lib/libHSDemo.so: lib src/LibDemo.hs
	$(GHC) $(GHCFLAGS) $(GHCFLAGS_dlctohs_library) src/LibDemo.hs -o lib/libHSDemo.so

lib/libHSDemo_withhelper.so: lib src/hswrapper.c src/LibDemo.hs
	$(GHC) $(GHCFLAGS) $(GHCFLAGS_dlctohs_library_withhelper) src/LibDemo.hs src/hswrapper.c -o lib/libHSDemo_withhelper.so

lib/libHSDemo.a: lib obj/LibDemo_static.o
	ar -rc lib/libHSDemo.a obj/LibDemo_static.o

lib/libdemo.so: lib src/libdemo.c
	$(CC) $(CFLAGS) $(CFLAGS_dlhstoc_library) src/libdemo.c -o lib/libdemo.so

lib/libdemo.a: lib obj/libdemo_static.o
	ar -rc lib/libdemo.a obj/libdemo_static.o


obj/ffictohs.o: obj src/main.c
	$(CC) $(CFLAGS) $(CFLAGS_ffictohs_object) src/main.c -c -o obj/ffictohs.o

obj/ffictohs_static.o: obj src/main.c
	$(CC) $(CFLAGS) $(CFLAGS_ffictohs_static_object) src/main.c -c -o obj/ffictohs_static.o

obj/LibDemo.o: obj src/LibDemo.hs
	$(GHC) $(GHCFLAGS) $(GHCFLAGS_ffictohs_object) -c -o obj/LibDemo.o src/LibDemo.hs

obj/LibDemo_static.o: obj src/LibDemo.hs
	$(GHC) $(GHCFLAGS) $(GHCFLAGS_ffictohs_static_object) -c -o obj/LibDemo_static.o src/LibDemo.hs

obj/libdemo.o: obj src/libdemo.c
	$(CC) $(CFLAGS) $(CFLAGS_ffihstoc_object) -c src/libdemo.c -o obj/libdemo.o

obj/libdemo_static.o: obj src/libdemo.c
	$(CC) $(CFLAGS) $(CFLAGS_ffihstoc_static_object) -c src/libdemo.c -o obj/libdemo_static.o


build/dlctohs: src/main.c
	$(CC) $(CFLAGS) $(CFLAGS_dlctohs) src/main.c -o build/dlctohs

build/dlctohs_withhelper: src/main.c
	$(CC) $(CFLAGS) $(CFLAGS_dlctohs_withhelper) src/main.c -o build/dlctohs_withhelper

build/dlhstoc: src/Main.hs
	$(GHC) $(GHCFLAGS) $(GHCFLAGS_dlhstoc) src/Main.hs -o build/dlhstoc

build/ffictohs: obj/LibDemo.o obj/ffictohs.o
	$(GHC) $(GHCFLAGS) $(GHCFLAGS_ffictohs) obj/LibDemo.o obj/ffictohs.o -o build/ffictohs

build/ffictohs_static: obj/LibDemo_static.o obj/ffictohs_static.o
	$(GHC) $(GHCFLAGS) $(GHCFLAGS_ffictohs_static) obj/LibDemo_static.o obj/ffictohs_static.o -o build/ffictohs_static

build/ffictohs_static_fromlibrary: src/main.c
	$(GHC) $(GHCFLAGS) $(GHCFLAGS_ffictohs_static_fromlibrary) src/main.c -o build/ffictohs_static_fromlibrary

build/ffihstoc: src/Main.hs obj/libdemo.o
	$(GHC) $(GHCFLAGS) $(GHCFLAGS_ffihstoc) obj/libdemo.o src/Main.hs -o build/ffihstoc

build/ffihstoc_static: src/Main.hs obj/libdemo_static.o
	$(GHC) $(GHCFLAGS) $(GHCFLAGS_ffihstoc_static) obj/libdemo_static.o src/Main.hs -o build/ffihstoc_static

build/ffihstoc_static_fromlibrary: src/Main.hs
	$(GHC) $(GHCFLAGS) $(GHCFLAGS_ffihstoc_static_fromlibrary) src/Main.hs -o build/ffihstoc_static_fromlibrary


clean:
	$(RM) -r build obj lib src/*.o src/*_stub.h src/*.hi